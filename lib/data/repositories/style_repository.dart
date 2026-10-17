import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/outfit_engine.dart';
import '../../domain/services/palette_engine.dart';
import 'body_record_repository.dart';

T _enum<T extends Enum>(List<T> values, String name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

enum StylePreference { classic, minimal, smartCasual, street, traditional, sporty }

/// How clothes should sit on the body.
enum FitPreference { slim, regular, relaxed, oversized, tailored }

enum BudgetLevel { value, midRange, premium }

/// How much coverage the user prefers; shapes every suggestion.
enum Modesty { relaxed, moderate, covered }

enum CulturalWear { indianEthnic, modest, western, fusion }

/// The user's colour and style profile ("Style DNA"), stored as app settings.
class StyleProfile {
  const StyleProfile({
    this.undertone,
    this.depth,
    this.styles = const {},
    this.fits = const {},
    this.budget,
    this.modesty,
    this.cultural = const {},
    this.occasions = const {},
  });

  final Undertone? undertone;
  final SkinDepth? depth;
  final Set<StylePreference> styles;
  final Set<FitPreference> fits;
  final BudgetLevel? budget;
  final Modesty? modesty;
  final Set<CulturalWear> cultural;

  /// Occasions the user dresses for most.
  final Set<Occasion> occasions;

  /// How much of the Style DNA is filled in (0–1), for gentle prompts.
  double get completeness =>
      [
        hasPalette,
        styles.isNotEmpty,
        fits.isNotEmpty,
        budget != null,
        modesty != null,
        cultural.isNotEmpty,
        occasions.isNotEmpty,
      ].where((b) => b).length /
      7;

  bool get hasPalette => undertone != null && depth != null;
  Palette? get palette =>
      hasPalette ? PaletteEngine.palette(undertone!, depth!) : null;
}

class SavedOutfit {
  const SavedOutfit({
    required this.id,
    required this.occasion,
    required this.items,
    required this.wornDays,
  });

  final String id;
  final Occasion occasion;
  final List<WardrobeItem> items;
  final List<int> wornDays;
}

/// An outfit planned for a day in the outfit calendar.
class OutfitPlan {
  const OutfitPlan({required this.id, required this.day, required this.outfitId, required this.occasion, this.note});
  final String id;
  final int day;
  final String outfitId;
  final Occasion occasion;
  final String? note;
}

/// Wardrobe, outfits and style profile. Photos stay in the encrypted DB.
class StyleRepository {
  StyleRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  int get _now => _clock().toUtc().millisecondsSinceEpoch;

  static const _kUndertone = 'style.undertone';
  static const _kDepth = 'style.depth';
  static const _kStyles = 'style.preferences';
  static const _kFits = 'style.fits';
  static const _kBudget = 'style.budget';
  static const _kModesty = 'style.modesty';
  static const _kCultural = 'style.cultural';
  static const _kOccasions = 'style.occasions';

  static Set<T> _set<T extends Enum>(List<T> values, String? csv) => {
        for (final n in (csv ?? '').split(','))
          if (n.isNotEmpty && values.any((v) => v.name == n)) values.byName(n),
      };

  // ---------- profile ----------

  Stream<StyleProfile> watchProfile() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key
          .isIn([_kUndertone, _kDepth, _kStyles, _kFits, _kBudget, _kModesty, _kCultural, _kOccasions]));
    return q.watch().map((rows) {
      final m = {for (final r in rows) r.key: r.value};
      return StyleProfile(
        undertone: m[_kUndertone] == null
            ? null
            : _enum(Undertone.values, m[_kUndertone]!, Undertone.neutral),
        depth: m[_kDepth] == null
            ? null
            : _enum(SkinDepth.values, m[_kDepth]!, SkinDepth.medium),
        styles: {
          for (final n in (m[_kStyles] ?? '').split(','))
            if (n.isNotEmpty)
              _enum(StylePreference.values, n, StylePreference.classic),
        },
        fits: _set(FitPreference.values, m[_kFits]),
        budget: m[_kBudget] == null ? null : _enum(BudgetLevel.values, m[_kBudget]!, BudgetLevel.midRange),
        modesty: m[_kModesty] == null ? null : _enum(Modesty.values, m[_kModesty]!, Modesty.moderate),
        cultural: _set(CulturalWear.values, m[_kCultural]),
        occasions: _set(Occasion.values, m[_kOccasions]),
      );
    });
  }

  Future<void> _put(String key, String value) =>
      _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
          AppSettingsEntriesCompanion.insert(
              key: key, value: value, updatedAt: _now));

  Future<void> setPalette(Undertone u, SkinDepth d) async {
    await _db.transaction(() async {
      await _put(_kUndertone, u.name);
      await _put(_kDepth, d.name);
    });
  }

  Future<void> setStyles(Set<StylePreference> s) =>
      _put(_kStyles, s.map((e) => e.name).join(','));

  /// Saves the rest of the Style DNA in one go.
  Future<void> setDna({
    required Set<FitPreference> fits,
    BudgetLevel? budget,
    Modesty? modesty,
    required Set<CulturalWear> cultural,
    required Set<Occasion> occasions,
  }) =>
      _db.transaction(() async {
        await _put(_kFits, fits.map((e) => e.name).join(','));
        await _put(_kCultural, cultural.map((e) => e.name).join(','));
        await _put(_kOccasions, occasions.map((e) => e.name).join(','));
        if (budget != null) await _put(_kBudget, budget.name);
        if (modesty != null) await _put(_kModesty, modesty.name);
      });

  // ---------- wardrobe ----------

  WardrobeItem _toItem(WardrobeRow r) => WardrobeItem(
        id: r.id,
        name: r.name,
        category: _enum(GarmentCategory.values, r.category, GarmentCategory.top),
        colorHex: r.colorHex,
        pattern: _enum(GarmentPattern.values, r.pattern, GarmentPattern.solid),
        formality: r.formality.clamp(1, 5),
        occasions: {
          for (final n in r.occasions.split(','))
            if (n.isNotEmpty) _enum(Occasion.values, n, Occasion.casual),
        },
        favorite: r.favorite,
        price: r.price,
      );

  Stream<List<WardrobeItem>> watchWardrobe() {
    final q = _db.select(_db.wardrobeItems)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_toItem).toList());
  }

  /// Photos by item id (loaded separately so lists stay light).
  Stream<Map<String, Uint8List>> watchPhotos() {
    final q = _db.selectOnly(_db.wardrobeItems)
      ..addColumns([_db.wardrobeItems.id, _db.wardrobeItems.photo])
      ..where(_db.wardrobeItems.photo.isNotNull());
    return q.watch().map((rows) => {
          for (final r in rows)
            r.read(_db.wardrobeItems.id)!: r.read(_db.wardrobeItems.photo)!,
        });
  }

  static void _validate(String name, String hex, int formality) {
    if (name.trim().isEmpty) throw ArgumentError('Name is required');
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(hex)) {
      throw ArgumentError.value(hex, 'colorHex');
    }
    if (formality < 1 || formality > 5) throw ArgumentError.value(formality);
  }

  Future<String> addItem({
    required String name,
    required GarmentCategory category,
    required String colorHex,
    GarmentPattern pattern = GarmentPattern.solid,
    int formality = 3,
    Set<Occasion> occasions = const {},
    Uint8List? photo,
    double? price,
  }) async {
    _validate(name, colorHex, formality);
    final id = _uuid.v4();
    await _db.into(_db.wardrobeItems).insert(WardrobeItemsCompanion.insert(
          id: id,
          name: name.trim(),
          category: category.name,
          colorHex: colorHex.toUpperCase(),
          pattern: pattern.name,
          formality: formality,
          occasions: Value(occasions.map((o) => o.name).join(',')),
          photo: Value(photo),
          price: Value(price),
          createdAt: _now,
          updatedAt: _now,
        ));
    return id;
  }

  Future<void> setPrice(String id, double? price) =>
      (_db.update(_db.wardrobeItems)..where((t) => t.id.equals(id))).write(
          WardrobeItemsCompanion(price: Value(price), updatedAt: Value(_now)));

  Future<void> setFavorite(String id, bool on) =>
      (_db.update(_db.wardrobeItems)..where((t) => t.id.equals(id))).write(
          WardrobeItemsCompanion(favorite: Value(on), updatedAt: Value(_now)));

  /// Deletes the item; outfits containing it lose it (cascade).
  Future<void> deleteItem(String id) => _db.transaction(() async {
        await (_db.delete(_db.wardrobeItems)..where((t) => t.id.equals(id)))
            .go();
        // Outfits left with fewer than two pieces are no longer outfits.
        final counts = await _db.customSelect(
            'SELECT o.id AS id, COUNT(oi.item_id) AS n FROM outfit o '
            'LEFT JOIN outfit_item oi ON oi.outfit_id = o.id GROUP BY o.id',
            readsFrom: {_db.outfits, _db.outfitItems}).get();
        for (final c in counts) {
          if (c.read<int>('n') < 2) {
            await (_db.delete(_db.outfits)
                  ..where((t) => t.id.equals(c.read<String>('id'))))
                .go();
          }
        }
      });

  // ---------- outfits ----------

  Future<String> saveOutfit(Occasion occasion, List<String> itemIds) async {
    if (itemIds.length < 2) throw ArgumentError('An outfit needs two items');
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.outfits).insert(OutfitsCompanion.insert(
          id: id, occasion: occasion.name, createdAt: _now));
      for (final i in itemIds) {
        await _db.into(_db.outfitItems)
            .insert(OutfitItemsCompanion.insert(outfitId: id, itemId: i));
      }
    });
    return id;
  }

  Future<void> deleteOutfit(String id) =>
      (_db.delete(_db.outfits)..where((t) => t.id.equals(id))).go();

  Future<void> markWorn(String outfitId) =>
      _db.into(_db.outfitWears).insertOnConflictUpdate(
          OutfitWearsCompanion.insert(
              outfitId: outfitId, day: Days.key(_clock())));

  Stream<List<SavedOutfit>> watchOutfits() {
    // Re-emit when outfits, their items, wear days or garments change —
    // not only the outfit table.
    final trigger = _db.customSelect('SELECT COUNT(*) AS n FROM outfit',
        readsFrom: {
          _db.outfits,
          _db.outfitItems,
          _db.outfitWears,
          _db.wardrobeItems,
        }).watch();
    return trigger.asyncMap((_) async {
      final rows = await (_db.select(_db.outfits)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
      if (rows.isEmpty) return const <SavedOutfit>[];
      final links = await _db.select(_db.outfitItems).get();
      final items = {
        for (final r in await _db.select(_db.wardrobeItems).get())
          r.id: _toItem(r),
      };
      final wears = await _db.select(_db.outfitWears).get();
      return [
        for (final o in rows)
          SavedOutfit(
            id: o.id,
            occasion: _enum(Occasion.values, o.occasion, Occasion.casual),
            items: [
              for (final l in links)
                if (l.outfitId == o.id && items[l.itemId] != null) items[l.itemId]!,
            ],
            wornDays: [
              for (final w in wears)
                if (w.outfitId == o.id) w.day,
            ]..sort(),
          ),
      ];
    });
  }

  // ---------- outfit calendar ----------

  /// Plans [outfitId] for [day] (yyyymmdd). One plan per day and occasion.
  Future<String> planOutfit(int day, String outfitId, Occasion occasion, {String? note}) async {
    final id = '$day:${occasion.name}';
    final n = note?.trim();
    await _db.into(_db.outfitPlans).insertOnConflictUpdate(OutfitPlansCompanion.insert(
        id: id,
        day: day,
        outfitId: outfitId,
        occasion: occasion.name,
        note: Value(n == null || n.isEmpty ? null : n),
        createdAt: _now));
    return id;
  }

  Future<void> removePlan(String id) => (_db.delete(_db.outfitPlans)..where((t) => t.id.equals(id))).go();

  /// Plans from [fromDay] to [toDay] inclusive, by day.
  Stream<List<OutfitPlan>> watchPlans(int fromDay, int toDay) {
    final q = _db.select(_db.outfitPlans)
      ..where((t) => t.day.isBetweenValues(fromDay, toDay))
      ..orderBy([(t) => OrderingTerm.asc(t.day)]);
    return q.watch().map((rows) => [
          for (final r in rows)
            OutfitPlan(
                id: r.id,
                day: r.day,
                outfitId: r.outfitId,
                occasion: _enum(Occasion.values, r.occasion, Occasion.casual),
                note: r.note),
        ]);
  }

  /// Records that an outfit was worn on a given day.
  Future<void> markWornOn(String outfitId, int day) => _db
      .into(_db.outfitWears)
      .insertOnConflictUpdate(OutfitWearsCompanion.insert(outfitId: outfitId, day: day));

  /// Item ids worn within the last [days] days (for variety).
  Future<Set<String>> recentlyWornItems({int days = 7}) async {
    final since = Days.key(_clock().subtract(Duration(days: days)));
    final rows = await _db.customSelect(
        'SELECT DISTINCT oi.item_id AS id FROM outfit_wear w '
        'JOIN outfit_item oi ON oi.outfit_id = w.outfit_id WHERE w.day >= ?',
        variables: [Variable.withInt(since)],
        readsFrom: {_db.outfitWears, _db.outfitItems}).get();
    return {for (final r in rows) r.read<String>('id')};
  }
}
