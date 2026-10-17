import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/style_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/grooming.dart';
import '../../domain/services/face_engine.dart';
import '../../domain/services/glasses_fit.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/outfit_engine.dart';
import '../../domain/services/wardrobe_stats.dart';
import '../face/face_providers.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import 'style_providers.dart';

/// The most recent face-shape result, if the user has analysed their face.
final latestFaceShapeProvider = Provider<FaceShape?>((ref) {
  final h = ref.watch(faceHistoryProvider).value;
  return h == null || h.isEmpty ? null : h.first.result.shape;
});

final glassesCatalogProvider = FutureProvider<List<GlassesFrame>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/glasses.json', cache: false);
  return [for (final f in jsonDecode(raw) as List) GlassesFrame.fromJson(f as Map<String, dynamic>)];
});

/// Outfit plans for an inclusive day range (yyyymmdd).
final outfitPlansProvider = StreamProvider.family<List<OutfitPlan>, (int, int)>(
    (ref, r) => ref.watch(styleRepositoryProvider).watchPlans(r.$1, r.$2));

/// Who clothes are styled for, from the profile.
final styleFitProvider = Provider<StyleFit?>((ref) => ref.watch(profileProvider).value?.effectiveStyleFit);

final wardrobeStatsProvider = Provider<WardrobeStats?>((ref) {
  final wardrobe = ref.watch(wardrobeProvider).value;
  final outfits = ref.watch(savedOutfitsProvider).value;
  if (wardrobe == null || outfits == null) return null;
  final dna = ref.watch(styleProfileProvider).value ?? const StyleProfile();
  final region = ref.watch(profileProvider).value?.region;
  return WardrobeStats.compute(
    wardrobe: wardrobe,
    outfits: [for (final o in outfits) (itemIds: [for (final i in o.items) i.id], wornDays: o.wornDays)],
    occasions: dna.occasions,
    ethnicWear: dna.cultural.contains(CulturalWear.indianEthnic),
    hotClimate: region?.hotClimate ?? true,
  );
});

/// Hairstyle and beard ideas for the user's face shape and style fit.
final groomingPicksProvider = Provider<({String? hair, String? beard})>((ref) {
  final shape = ref.watch(latestFaceShapeProvider);
  final content = ref.watch(groomingContentProvider).value;
  if (shape == null || content == null) return (hair: null, beard: null);
  final fit = ref.watch(styleFitProvider) ?? StyleFit.all;
  final guide = content.shapes[shape];
  bool suits(String id) => content.items[id]?.suits(fit) ?? false;

  String? first(StyleKind k) => guide?.items[k]?.where(suits).firstOrNull;
  return (hair: first(StyleKind.hair), beard: first(StyleKind.beard));
});

/// Today's planned outfit items, if any.
final plannedTodayProvider = Provider<List<WardrobeItem>?>((ref) {
  final today = Days.key(ref.watch(clockProvider)());
  final plans = ref.watch(outfitPlansProvider((today, today))).value ?? const [];
  if (plans.isEmpty) return null;
  final outfits = ref.watch(savedOutfitsProvider).value ?? const [];
  return outfits.where((o) => o.id == plans.first.outfitId).firstOrNull?.items;
});

/// Money in the user's region's currency.
NumberFormat moneyFormat(Region? region, String locale) {
  final code = switch (region) {
    Region.indiaNorth || Region.indiaSouth || Region.indiaEast || Region.indiaWest => 'INR',
    Region.europe => 'EUR',
    Region.northAmerica => 'USD',
    Region.middleEast => 'AED',
    Region.oceania => 'AUD',
    _ => null,
  };
  return code == null
      ? NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0)
      : NumberFormat.simpleCurrency(locale: locale, name: code, decimalDigits: 0);
}
