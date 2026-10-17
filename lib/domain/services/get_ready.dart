import '../../data/repositories/style_repository.dart';
import 'outfit_engine.dart';

/// What the user is getting ready for.
enum ReadyEvent { interview, presentation, office, date, wedding, festival, party, casual, gym, travel }

enum ReadySection { outfit, grooming, presentation, finalChecks }

/// One line of the checklist. [id] picks the text; [route] (optional)
/// opens the screen that helps with it.
class ReadyItem {
  const ReadyItem(this.section, this.id, {this.route, this.outfit, this.styleId});

  final ReadySection section;
  final String id;
  final String? route;

  /// The outfit to wear, for outfit lines.
  final List<WardrobeItem>? outfit;

  /// A hairstyle or beard style id from the grooming content.
  final String? styleId;
}

/// Inputs gathered from the user's records.
class ReadyContext {
  const ReadyContext({
    this.wardrobe = const [],
    this.plannedToday,
    this.profile = const StyleProfile(),
    this.menswear = false,
    this.womenswear = false,
    this.hairStyleId,
    this.beardStyleId,
    this.hotClimate = true,
    this.recentlyWorn = const {},
  });

  final List<WardrobeItem> wardrobe;

  /// Items of an outfit already planned for today, if any.
  final List<WardrobeItem>? plannedToday;
  final StyleProfile profile;
  final bool menswear;
  final bool womenswear;

  /// From face-shape suggestions, when a face analysis exists.
  final String? hairStyleId;
  final String? beardStyleId;
  final bool hotClimate;
  final Set<String> recentlyWorn;
}

abstract final class GetReady {
  static Occasion occasionOf(ReadyEvent e) => switch (e) {
        ReadyEvent.interview || ReadyEvent.presentation || ReadyEvent.office => Occasion.work,
        ReadyEvent.wedding || ReadyEvent.festival => Occasion.festive,
        ReadyEvent.gym => Occasion.sport,
        _ => Occasion.casual,
      };

  /// How dressed-up the event is, 1–5.
  static int formalityOf(ReadyEvent e) => switch (e) {
        ReadyEvent.wedding => 5,
        ReadyEvent.interview || ReadyEvent.presentation || ReadyEvent.festival => 4,
        ReadyEvent.office || ReadyEvent.date || ReadyEvent.party => 3,
        ReadyEvent.casual || ReadyEvent.travel => 2,
        ReadyEvent.gym => 1,
      };

  static bool _speaking(ReadyEvent e) =>
      e == ReadyEvent.interview || e == ReadyEvent.presentation || e == ReadyEvent.date;

  static List<ReadyItem> checklist(ReadyEvent e, ReadyContext c) {
    final occasion = occasionOf(e);
    final formal = formalityOf(e);
    final out = <ReadyItem>[];

    // ---- outfit
    if (c.plannedToday != null && c.plannedToday!.isNotEmpty) {
      out.add(ReadyItem(ReadySection.outfit, 'planned', outfit: c.plannedToday));
    } else {
      final ideas = OutfitEngine.suggest(
          wardrobe: c.wardrobe, occasion: occasion, palette: c.profile.palette, recentlyWorn: c.recentlyWorn, limit: 1);
      if (ideas.isNotEmpty) {
        out.add(ReadyItem(ReadySection.outfit, 'suggested', outfit: ideas.first.items, route: '/style/wardrobe/outfits'));
      } else {
        final ethnic = c.profile.cultural.contains(CulturalWear.indianEthnic) &&
            (e == ReadyEvent.wedding || e == ReadyEvent.festival);
        out.add(ReadyItem(ReadySection.outfit, ethnic ? 'guide_ethnic' : 'guide_${e.name}', route: '/style/wardrobe'));
      }
    }
    if (c.profile.modesty == Modesty.covered) out.add(const ReadyItem(ReadySection.outfit, 'modest'));
    final fit = c.profile.fits.isEmpty ? null : c.profile.fits.first;
    if (fit != null && formal >= 3) out.add(ReadyItem(ReadySection.outfit, 'fit_${fit.name}'));
    if (c.profile.hasPalette && e != ReadyEvent.gym) {
      out.add(const ReadyItem(ReadySection.outfit, 'colours', route: '/style/colours'));
    }
    if (formal >= 3) out.add(const ReadyItem(ReadySection.outfit, 'press'));
    if (formal >= 3) out.add(const ReadyItem(ReadySection.outfit, 'shoes'));
    if (!c.hotClimate && e != ReadyEvent.gym) out.add(const ReadyItem(ReadySection.outfit, 'layer'));

    // ---- grooming
    if (e != ReadyEvent.gym) {
      out.add(c.hairStyleId != null
          ? ReadyItem(ReadySection.grooming, 'hair_style', styleId: c.hairStyleId, route: '/analyze/face')
          : const ReadyItem(ReadySection.grooming, 'hair_tidy', route: '/analyze/face'));
      if (c.menswear) {
        out.add(c.beardStyleId != null
            ? ReadyItem(ReadySection.grooming, 'beard_style', styleId: c.beardStyleId, route: '/analyze/face/try-on')
            : const ReadyItem(ReadySection.grooming, 'beard_tidy'));
      }
      out.add(const ReadyItem(ReadySection.grooming, 'skin'));
      if (const {ReadyEvent.wedding, ReadyEvent.festival, ReadyEvent.casual, ReadyEvent.travel}.contains(e)) {
        out.add(const ReadyItem(ReadySection.grooming, 'sunscreen'));
      }
      if (formal >= 3) out.add(const ReadyItem(ReadySection.grooming, 'nails'));
      if (formal >= 3 && e != ReadyEvent.wedding) out.add(const ReadyItem(ReadySection.grooming, 'scent_light'));
    } else {
      out.add(const ReadyItem(ReadySection.grooming, 'gym_hair'));
    }

    // ---- presentation: posture, breath, voice
    if (_speaking(e) || e == ReadyEvent.office || e == ReadyEvent.wedding) {
      out.add(const ReadyItem(ReadySection.presentation, 'posture', route: '/analyze/posture'));
      out.add(const ReadyItem(ReadySection.presentation, 'breath'));
    }
    if (_speaking(e)) {
      out.add(const ReadyItem(ReadySection.presentation, 'face_warmup', route: '/growth/search?q=face'));
      out.add(const ReadyItem(ReadySection.presentation, 'voice'));
      out.add(const ReadyItem(ReadySection.presentation, 'eye_contact'));
    }
    if (e == ReadyEvent.interview || e == ReadyEvent.presentation) {
      out.add(const ReadyItem(ReadySection.presentation, 'three_points'));
    }

    // ---- final checks
    if (e == ReadyEvent.interview || e == ReadyEvent.presentation) {
      out.add(const ReadyItem(ReadySection.finalChecks, 'documents'));
    }
    if (e == ReadyEvent.travel) out.add(const ReadyItem(ReadySection.finalChecks, 'travel_docs'));
    if (e == ReadyEvent.gym) out.add(const ReadyItem(ReadySection.finalChecks, 'gym_kit'));
    if (e == ReadyEvent.wedding || e == ReadyEvent.festival) out.add(const ReadyItem(ReadySection.finalChecks, 'gift'));
    if (const {ReadyEvent.gym, ReadyEvent.travel, ReadyEvent.festival, ReadyEvent.wedding}.contains(e) || c.hotClimate) {
      out.add(const ReadyItem(ReadySection.finalChecks, 'water'));
    }
    out.add(const ReadyItem(ReadySection.finalChecks, 'phone'));
    if (formal >= 3) out.add(const ReadyItem(ReadySection.finalChecks, 'early'));
    return out;
  }
}
