import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/body.dart';
import 'body_record_repository.dart';

class ProfileRepository {
  ProfileRepository(this._db, {Clock? clock}) : _clock = clock ?? DateTime.now;

  static const _id = 'me';

  final AppDatabase _db;
  final Clock _clock;

  int get _now => _clock().toUtc().millisecondsSinceEpoch;

  Stream<Profile> watchProfile() {
    final query = _db.select(_db.userProfiles)..where((t) => t.id.equals(_id));
    return query.watchSingleOrNull().map(_toProfile);
  }

  Future<Profile> load() async {
    final query = _db.select(_db.userProfiles)..where((t) => t.id.equals(_id));
    return _toProfile(await query.getSingleOrNull());
  }

  Future<void> save(Profile p) async {
    final now = _now;
    await _db.into(_db.userProfiles).insert(
          UserProfilesCompanion.insert(
            id: _id,
            displayName: Value(_blankToNull(p.displayName)),
            ageRange: Value(p.ageRange?.name),
            activityLevel: Value(p.activityLevel?.name),
            primaryHeightId: Value(p.primaryHeightId),
            goalWeightMinKg: Value(p.goalWeightMinKg),
            goalWeightMaxKg: Value(p.goalWeightMaxKg),
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => UserProfilesCompanion(
              displayName: Value(_blankToNull(p.displayName)),
              ageRange: Value(p.ageRange?.name),
              activityLevel: Value(p.activityLevel?.name),
              primaryHeightId: Value(p.primaryHeightId),
              goalWeightMinKg: Value(p.goalWeightMinKg),
              goalWeightMaxKg: Value(p.goalWeightMaxKg),
              updatedAt: Value(now),
            ),
          ),
        );
  }

  Stream<Set<GoalType>> watchGoals() {
    final query = _db.select(_db.goals)..where((t) => t.active.equals(true));
    return query.watch().map((rows) => {
          for (final r in rows)
            for (final g in GoalType.values)
              if (g.name == r.type) g,
        });
  }

  Future<void> setGoals(Set<GoalType> active) async {
    final now = _now;
    await _db.transaction(() async {
      for (final g in GoalType.values) {
        await _db.into(_db.goals).insert(
              GoalsCompanion.insert(
                type: g.name,
                active: active.contains(g),
                createdAt: now,
                updatedAt: now,
              ),
              onConflict: DoUpdate((old) => GoalsCompanion(
                    active: Value(active.contains(g)),
                    updatedAt: Value(now),
                  )),
            );
      }
    });
  }

  /// Deletes a height record and clears the primary pin if it pointed there.
  Future<void> deleteHeight(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.heightRecords)..where((t) => t.id.equals(id)))
          .go();
      await (_db.update(_db.userProfiles)
            ..where((t) => t.primaryHeightId.equals(id)))
          .write(UserProfilesCompanion(
        primaryHeightId: const Value(null),
        updatedAt: Value(_now),
      ));
    });
  }

  static String? _blankToNull(String? s) =>
      (s == null || s.trim().isEmpty) ? null : s.trim();

  static Profile _toProfile(ProfileRow? row) {
    if (row == null) return const Profile();
    T? parse<T extends Enum>(List<T> values, String? name) {
      for (final v in values) {
        if (v.name == name) return v;
      }
      return null;
    }

    return Profile(
      displayName: row.displayName,
      ageRange: parse(AgeRange.values, row.ageRange),
      activityLevel: parse(ActivityLevel.values, row.activityLevel),
      primaryHeightId: row.primaryHeightId,
      goalWeightMinKg: row.goalWeightMinKg,
      goalWeightMaxKg: row.goalWeightMaxKg,
    );
  }
}
