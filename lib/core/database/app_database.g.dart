// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsEntriesTable extends AppSettingsEntries
    with TableInfo<$AppSettingsEntriesTable, SettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsEntriesTable createAlias(String alias) {
    return $AppSettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingEntry extends DataClass implements Insertable<SettingEntry> {
  final String key;
  final String value;
  final int updatedAt;
  const SettingEntry({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsEntriesCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SettingEntry copyWith({String? key, String? value, int? updatedAt}) =>
      SettingEntry(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SettingEntry copyWithCompanion(AppSettingsEntriesCompanion data) {
    return SettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntry &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsEntriesCompanion extends UpdateCompanion<SettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsEntriesCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<SettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatureFlagsTable extends FeatureFlags
    with TableInfo<$FeatureFlagsTable, FeatureFlagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, enabled, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_flag';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureFlagEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureFlagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureFlagEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FeatureFlagsTable createAlias(String alias) {
    return $FeatureFlagsTable(attachedDatabase, alias);
  }
}

class FeatureFlagEntry extends DataClass
    implements Insertable<FeatureFlagEntry> {
  final String id;
  final bool enabled;
  final int updatedAt;
  const FeatureFlagEntry({
    required this.id,
    required this.enabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['enabled'] = Variable<bool>(enabled);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  FeatureFlagsCompanion toCompanion(bool nullToAbsent) {
    return FeatureFlagsCompanion(
      id: Value(id),
      enabled: Value(enabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeatureFlagEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureFlagEntry(
      id: serializer.fromJson<String>(json['id']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'enabled': serializer.toJson<bool>(enabled),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  FeatureFlagEntry copyWith({String? id, bool? enabled, int? updatedAt}) =>
      FeatureFlagEntry(
        id: id ?? this.id,
        enabled: enabled ?? this.enabled,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FeatureFlagEntry copyWithCompanion(FeatureFlagsCompanion data) {
    return FeatureFlagEntry(
      id: data.id.present ? data.id.value : this.id,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlagEntry(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureFlagEntry &&
          other.id == this.id &&
          other.enabled == this.enabled &&
          other.updatedAt == this.updatedAt);
}

class FeatureFlagsCompanion extends UpdateCompanion<FeatureFlagEntry> {
  final Value<String> id;
  final Value<bool> enabled;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const FeatureFlagsCompanion({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatureFlagsCompanion.insert({
    required String id,
    required bool enabled,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       enabled = Value(enabled),
       updatedAt = Value(updatedAt);
  static Insertable<FeatureFlagEntry> custom({
    Expression<String>? id,
    Expression<bool>? enabled,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enabled != null) 'enabled': enabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatureFlagsCompanion copyWith({
    Value<String>? id,
    Value<bool>? enabled,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return FeatureFlagsCompanion(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlagsCompanion(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageRangeMeta = const VerificationMeta(
    'ageRange',
  );
  @override
  late final GeneratedColumn<String> ageRange = GeneratedColumn<String>(
    'age_range',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryHeightIdMeta = const VerificationMeta(
    'primaryHeightId',
  );
  @override
  late final GeneratedColumn<String> primaryHeightId = GeneratedColumn<String>(
    'primary_height_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalWeightMinKgMeta = const VerificationMeta(
    'goalWeightMinKg',
  );
  @override
  late final GeneratedColumn<double> goalWeightMinKg = GeneratedColumn<double>(
    'goal_weight_min_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalWeightMaxKgMeta = const VerificationMeta(
    'goalWeightMaxKg',
  );
  @override
  late final GeneratedColumn<double> goalWeightMaxKg = GeneratedColumn<double>(
    'goal_weight_max_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    ageRange,
    activityLevel,
    primaryHeightId,
    goalWeightMinKg,
    goalWeightMaxKg,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('age_range')) {
      context.handle(
        _ageRangeMeta,
        ageRange.isAcceptableOrUnknown(data['age_range']!, _ageRangeMeta),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('primary_height_id')) {
      context.handle(
        _primaryHeightIdMeta,
        primaryHeightId.isAcceptableOrUnknown(
          data['primary_height_id']!,
          _primaryHeightIdMeta,
        ),
      );
    }
    if (data.containsKey('goal_weight_min_kg')) {
      context.handle(
        _goalWeightMinKgMeta,
        goalWeightMinKg.isAcceptableOrUnknown(
          data['goal_weight_min_kg']!,
          _goalWeightMinKgMeta,
        ),
      );
    }
    if (data.containsKey('goal_weight_max_kg')) {
      context.handle(
        _goalWeightMaxKgMeta,
        goalWeightMaxKg.isAcceptableOrUnknown(
          data['goal_weight_max_kg']!,
          _goalWeightMaxKgMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      ageRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_range'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      ),
      primaryHeightId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_height_id'],
      ),
      goalWeightMinKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_weight_min_kg'],
      ),
      goalWeightMaxKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_weight_max_kg'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String? displayName;
  final String? ageRange;
  final String? activityLevel;
  final String? primaryHeightId;
  final double? goalWeightMinKg;
  final double? goalWeightMaxKg;
  final int createdAt;
  final int updatedAt;
  const ProfileRow({
    required this.id,
    this.displayName,
    this.ageRange,
    this.activityLevel,
    this.primaryHeightId,
    this.goalWeightMinKg,
    this.goalWeightMaxKg,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || ageRange != null) {
      map['age_range'] = Variable<String>(ageRange);
    }
    if (!nullToAbsent || activityLevel != null) {
      map['activity_level'] = Variable<String>(activityLevel);
    }
    if (!nullToAbsent || primaryHeightId != null) {
      map['primary_height_id'] = Variable<String>(primaryHeightId);
    }
    if (!nullToAbsent || goalWeightMinKg != null) {
      map['goal_weight_min_kg'] = Variable<double>(goalWeightMinKg);
    }
    if (!nullToAbsent || goalWeightMaxKg != null) {
      map['goal_weight_max_kg'] = Variable<double>(goalWeightMaxKg);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      ageRange: ageRange == null && nullToAbsent
          ? const Value.absent()
          : Value(ageRange),
      activityLevel: activityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(activityLevel),
      primaryHeightId: primaryHeightId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryHeightId),
      goalWeightMinKg: goalWeightMinKg == null && nullToAbsent
          ? const Value.absent()
          : Value(goalWeightMinKg),
      goalWeightMaxKg: goalWeightMaxKg == null && nullToAbsent
          ? const Value.absent()
          : Value(goalWeightMaxKg),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      ageRange: serializer.fromJson<String?>(json['ageRange']),
      activityLevel: serializer.fromJson<String?>(json['activityLevel']),
      primaryHeightId: serializer.fromJson<String?>(json['primaryHeightId']),
      goalWeightMinKg: serializer.fromJson<double?>(json['goalWeightMinKg']),
      goalWeightMaxKg: serializer.fromJson<double?>(json['goalWeightMaxKg']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'ageRange': serializer.toJson<String?>(ageRange),
      'activityLevel': serializer.toJson<String?>(activityLevel),
      'primaryHeightId': serializer.toJson<String?>(primaryHeightId),
      'goalWeightMinKg': serializer.toJson<double?>(goalWeightMinKg),
      'goalWeightMaxKg': serializer.toJson<double?>(goalWeightMaxKg),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    Value<String?> ageRange = const Value.absent(),
    Value<String?> activityLevel = const Value.absent(),
    Value<String?> primaryHeightId = const Value.absent(),
    Value<double?> goalWeightMinKg = const Value.absent(),
    Value<double?> goalWeightMaxKg = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    ageRange: ageRange.present ? ageRange.value : this.ageRange,
    activityLevel: activityLevel.present
        ? activityLevel.value
        : this.activityLevel,
    primaryHeightId: primaryHeightId.present
        ? primaryHeightId.value
        : this.primaryHeightId,
    goalWeightMinKg: goalWeightMinKg.present
        ? goalWeightMinKg.value
        : this.goalWeightMinKg,
    goalWeightMaxKg: goalWeightMaxKg.present
        ? goalWeightMaxKg.value
        : this.goalWeightMaxKg,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(UserProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      ageRange: data.ageRange.present ? data.ageRange.value : this.ageRange,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      primaryHeightId: data.primaryHeightId.present
          ? data.primaryHeightId.value
          : this.primaryHeightId,
      goalWeightMinKg: data.goalWeightMinKg.present
          ? data.goalWeightMinKg.value
          : this.goalWeightMinKg,
      goalWeightMaxKg: data.goalWeightMaxKg.present
          ? data.goalWeightMaxKg.value
          : this.goalWeightMaxKg,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('ageRange: $ageRange, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('primaryHeightId: $primaryHeightId, ')
          ..write('goalWeightMinKg: $goalWeightMinKg, ')
          ..write('goalWeightMaxKg: $goalWeightMaxKg, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    ageRange,
    activityLevel,
    primaryHeightId,
    goalWeightMinKg,
    goalWeightMaxKg,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.ageRange == this.ageRange &&
          other.activityLevel == this.activityLevel &&
          other.primaryHeightId == this.primaryHeightId &&
          other.goalWeightMinKg == this.goalWeightMinKg &&
          other.goalWeightMaxKg == this.goalWeightMaxKg &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<String?> ageRange;
  final Value<String?> activityLevel;
  final Value<String?> primaryHeightId;
  final Value<double?> goalWeightMinKg;
  final Value<double?> goalWeightMaxKg;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.ageRange = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.primaryHeightId = const Value.absent(),
    this.goalWeightMinKg = const Value.absent(),
    this.goalWeightMaxKg = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.ageRange = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.primaryHeightId = const Value.absent(),
    this.goalWeightMinKg = const Value.absent(),
    this.goalWeightMaxKg = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? ageRange,
    Expression<String>? activityLevel,
    Expression<String>? primaryHeightId,
    Expression<double>? goalWeightMinKg,
    Expression<double>? goalWeightMaxKg,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (ageRange != null) 'age_range': ageRange,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (primaryHeightId != null) 'primary_height_id': primaryHeightId,
      if (goalWeightMinKg != null) 'goal_weight_min_kg': goalWeightMinKg,
      if (goalWeightMaxKg != null) 'goal_weight_max_kg': goalWeightMaxKg,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<String?>? ageRange,
    Value<String?>? activityLevel,
    Value<String?>? primaryHeightId,
    Value<double?>? goalWeightMinKg,
    Value<double?>? goalWeightMaxKg,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      ageRange: ageRange ?? this.ageRange,
      activityLevel: activityLevel ?? this.activityLevel,
      primaryHeightId: primaryHeightId ?? this.primaryHeightId,
      goalWeightMinKg: goalWeightMinKg ?? this.goalWeightMinKg,
      goalWeightMaxKg: goalWeightMaxKg ?? this.goalWeightMaxKg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (ageRange.present) {
      map['age_range'] = Variable<String>(ageRange.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (primaryHeightId.present) {
      map['primary_height_id'] = Variable<String>(primaryHeightId.value);
    }
    if (goalWeightMinKg.present) {
      map['goal_weight_min_kg'] = Variable<double>(goalWeightMinKg.value);
    }
    if (goalWeightMaxKg.present) {
      map['goal_weight_max_kg'] = Variable<double>(goalWeightMaxKg.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('ageRange: $ageRange, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('primaryHeightId: $primaryHeightId, ')
          ..write('goalWeightMinKg: $goalWeightMinKg, ')
          ..write('goalWeightMaxKg: $goalWeightMaxKg, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [type, active, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String type;
  final bool active;
  final int createdAt;
  final int updatedAt;
  const GoalRow({
    required this.type,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      type: Value(type),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      type: serializer.fromJson<String>(json['type']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  GoalRow copyWith({
    String? type,
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) => GoalRow(
    type: type ?? this.type,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      type: data.type.present ? data.type.value : this.type,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('type: $type, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(type, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.type == this.type &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> type;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.type = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String type,
    required bool active,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : type = Value(type),
       active = Value(active),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalRow> custom({
    Expression<String>? type,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? type,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      type: type ?? this.type,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('type: $type, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HeightRecordsTable extends HeightRecords
    with TableInfo<$HeightRecordsTable, HeightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowerBoundMeta = const VerificationMeta(
    'lowerBound',
  );
  @override
  late final GeneratedColumn<double> lowerBound = GeneratedColumn<double>(
    'lower_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _upperBoundMeta = const VerificationMeta(
    'upperBound',
  );
  @override
  late final GeneratedColumn<double> upperBound = GeneratedColumn<double>(
    'upper_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'height_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('lower_bound')) {
      context.handle(
        _lowerBoundMeta,
        lowerBound.isAcceptableOrUnknown(data['lower_bound']!, _lowerBoundMeta),
      );
    }
    if (data.containsKey('upper_bound')) {
      context.handle(
        _upperBoundMeta,
        upperBound.isAcceptableOrUnknown(data['upper_bound']!, _upperBoundMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      lowerBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lower_bound'],
      ),
      upperBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}upper_bound'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HeightRecordsTable createAlias(String alias) {
    return $HeightRecordsTable(attachedDatabase, alias);
  }
}

class HeightRow extends DataClass implements Insertable<HeightRow> {
  final String id;
  final double value;
  final String unit;
  final String source;
  final String? method;
  final String? confidence;
  final double? lowerBound;
  final double? upperBound;
  final int recordedAt;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const HeightRow({
    required this.id,
    required this.value,
    required this.unit,
    required this.source,
    this.method,
    this.confidence,
    this.lowerBound,
    this.upperBound,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    if (!nullToAbsent || lowerBound != null) {
      map['lower_bound'] = Variable<double>(lowerBound);
    }
    if (!nullToAbsent || upperBound != null) {
      map['upper_bound'] = Variable<double>(upperBound);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  HeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return HeightRecordsCompanion(
      id: Value(id),
      value: Value(value),
      unit: Value(unit),
      source: Value(source),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      lowerBound: lowerBound == null && nullToAbsent
          ? const Value.absent()
          : Value(lowerBound),
      upperBound: upperBound == null && nullToAbsent
          ? const Value.absent()
          : Value(upperBound),
      recordedAt: Value(recordedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HeightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeightRow(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      source: serializer.fromJson<String>(json['source']),
      method: serializer.fromJson<String?>(json['method']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      lowerBound: serializer.fromJson<double?>(json['lowerBound']),
      upperBound: serializer.fromJson<double?>(json['upperBound']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'source': serializer.toJson<String>(source),
      'method': serializer.toJson<String?>(method),
      'confidence': serializer.toJson<String?>(confidence),
      'lowerBound': serializer.toJson<double?>(lowerBound),
      'upperBound': serializer.toJson<double?>(upperBound),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  HeightRow copyWith({
    String? id,
    double? value,
    String? unit,
    String? source,
    Value<String?> method = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    Value<double?> lowerBound = const Value.absent(),
    Value<double?> upperBound = const Value.absent(),
    int? recordedAt,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => HeightRow(
    id: id ?? this.id,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    source: source ?? this.source,
    method: method.present ? method.value : this.method,
    confidence: confidence.present ? confidence.value : this.confidence,
    lowerBound: lowerBound.present ? lowerBound.value : this.lowerBound,
    upperBound: upperBound.present ? upperBound.value : this.upperBound,
    recordedAt: recordedAt ?? this.recordedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HeightRow copyWithCompanion(HeightRecordsCompanion data) {
    return HeightRow(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      source: data.source.present ? data.source.value : this.source,
      method: data.method.present ? data.method.value : this.method,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      lowerBound: data.lowerBound.present
          ? data.lowerBound.value
          : this.lowerBound,
      upperBound: data.upperBound.present
          ? data.upperBound.value
          : this.upperBound,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeightRow(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeightRow &&
          other.id == this.id &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.source == this.source &&
          other.method == this.method &&
          other.confidence == this.confidence &&
          other.lowerBound == this.lowerBound &&
          other.upperBound == this.upperBound &&
          other.recordedAt == this.recordedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HeightRecordsCompanion extends UpdateCompanion<HeightRow> {
  final Value<String> id;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> source;
  final Value<String?> method;
  final Value<String?> confidence;
  final Value<double?> lowerBound;
  final Value<double?> upperBound;
  final Value<int> recordedAt;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const HeightRecordsCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.source = const Value.absent(),
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HeightRecordsCompanion.insert({
    required String id,
    required double value,
    required String unit,
    required String source,
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    required int recordedAt,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       value = Value(value),
       unit = Value(unit),
       source = Value(source),
       recordedAt = Value(recordedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HeightRow> custom({
    Expression<String>? id,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? source,
    Expression<String>? method,
    Expression<String>? confidence,
    Expression<double>? lowerBound,
    Expression<double>? upperBound,
    Expression<int>? recordedAt,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (source != null) 'source': source,
      if (method != null) 'method': method,
      if (confidence != null) 'confidence': confidence,
      if (lowerBound != null) 'lower_bound': lowerBound,
      if (upperBound != null) 'upper_bound': upperBound,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HeightRecordsCompanion copyWith({
    Value<String>? id,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? source,
    Value<String?>? method,
    Value<String?>? confidence,
    Value<double?>? lowerBound,
    Value<double?>? upperBound,
    Value<int>? recordedAt,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return HeightRecordsCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source ?? this.source,
      method: method ?? this.method,
      confidence: confidence ?? this.confidence,
      lowerBound: lowerBound ?? this.lowerBound,
      upperBound: upperBound ?? this.upperBound,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (lowerBound.present) {
      map['lower_bound'] = Variable<double>(lowerBound.value);
    }
    if (upperBound.present) {
      map['upper_bound'] = Variable<double>(upperBound.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordsTable extends WeightRecords
    with TableInfo<$WeightRecordsTable, WeightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowerBoundMeta = const VerificationMeta(
    'lowerBound',
  );
  @override
  late final GeneratedColumn<double> lowerBound = GeneratedColumn<double>(
    'lower_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _upperBoundMeta = const VerificationMeta(
    'upperBound',
  );
  @override
  late final GeneratedColumn<double> upperBound = GeneratedColumn<double>(
    'upper_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('lower_bound')) {
      context.handle(
        _lowerBoundMeta,
        lowerBound.isAcceptableOrUnknown(data['lower_bound']!, _lowerBoundMeta),
      );
    }
    if (data.containsKey('upper_bound')) {
      context.handle(
        _upperBoundMeta,
        upperBound.isAcceptableOrUnknown(data['upper_bound']!, _upperBoundMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      lowerBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lower_bound'],
      ),
      upperBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}upper_bound'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeightRecordsTable createAlias(String alias) {
    return $WeightRecordsTable(attachedDatabase, alias);
  }
}

class WeightRow extends DataClass implements Insertable<WeightRow> {
  final String id;
  final double value;
  final String unit;
  final String source;
  final String? method;
  final String? confidence;
  final double? lowerBound;
  final double? upperBound;
  final int recordedAt;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const WeightRow({
    required this.id,
    required this.value,
    required this.unit,
    required this.source,
    this.method,
    this.confidence,
    this.lowerBound,
    this.upperBound,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    if (!nullToAbsent || lowerBound != null) {
      map['lower_bound'] = Variable<double>(lowerBound);
    }
    if (!nullToAbsent || upperBound != null) {
      map['upper_bound'] = Variable<double>(upperBound);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordsCompanion(
      id: Value(id),
      value: Value(value),
      unit: Value(unit),
      source: Value(source),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      lowerBound: lowerBound == null && nullToAbsent
          ? const Value.absent()
          : Value(lowerBound),
      upperBound: upperBound == null && nullToAbsent
          ? const Value.absent()
          : Value(upperBound),
      recordedAt: Value(recordedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRow(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      source: serializer.fromJson<String>(json['source']),
      method: serializer.fromJson<String?>(json['method']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      lowerBound: serializer.fromJson<double?>(json['lowerBound']),
      upperBound: serializer.fromJson<double?>(json['upperBound']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'source': serializer.toJson<String>(source),
      'method': serializer.toJson<String?>(method),
      'confidence': serializer.toJson<String?>(confidence),
      'lowerBound': serializer.toJson<double?>(lowerBound),
      'upperBound': serializer.toJson<double?>(upperBound),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WeightRow copyWith({
    String? id,
    double? value,
    String? unit,
    String? source,
    Value<String?> method = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    Value<double?> lowerBound = const Value.absent(),
    Value<double?> upperBound = const Value.absent(),
    int? recordedAt,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => WeightRow(
    id: id ?? this.id,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    source: source ?? this.source,
    method: method.present ? method.value : this.method,
    confidence: confidence.present ? confidence.value : this.confidence,
    lowerBound: lowerBound.present ? lowerBound.value : this.lowerBound,
    upperBound: upperBound.present ? upperBound.value : this.upperBound,
    recordedAt: recordedAt ?? this.recordedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WeightRow copyWithCompanion(WeightRecordsCompanion data) {
    return WeightRow(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      source: data.source.present ? data.source.value : this.source,
      method: data.method.present ? data.method.value : this.method,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      lowerBound: data.lowerBound.present
          ? data.lowerBound.value
          : this.lowerBound,
      upperBound: data.upperBound.present
          ? data.upperBound.value
          : this.upperBound,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRow(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRow &&
          other.id == this.id &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.source == this.source &&
          other.method == this.method &&
          other.confidence == this.confidence &&
          other.lowerBound == this.lowerBound &&
          other.upperBound == this.upperBound &&
          other.recordedAt == this.recordedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeightRecordsCompanion extends UpdateCompanion<WeightRow> {
  final Value<String> id;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> source;
  final Value<String?> method;
  final Value<String?> confidence;
  final Value<double?> lowerBound;
  final Value<double?> upperBound;
  final Value<int> recordedAt;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WeightRecordsCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.source = const Value.absent(),
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightRecordsCompanion.insert({
    required String id,
    required double value,
    required String unit,
    required String source,
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    required int recordedAt,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       value = Value(value),
       unit = Value(unit),
       source = Value(source),
       recordedAt = Value(recordedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WeightRow> custom({
    Expression<String>? id,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? source,
    Expression<String>? method,
    Expression<String>? confidence,
    Expression<double>? lowerBound,
    Expression<double>? upperBound,
    Expression<int>? recordedAt,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (source != null) 'source': source,
      if (method != null) 'method': method,
      if (confidence != null) 'confidence': confidence,
      if (lowerBound != null) 'lower_bound': lowerBound,
      if (upperBound != null) 'upper_bound': upperBound,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightRecordsCompanion copyWith({
    Value<String>? id,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? source,
    Value<String?>? method,
    Value<String?>? confidence,
    Value<double?>? lowerBound,
    Value<double?>? upperBound,
    Value<int>? recordedAt,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeightRecordsCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source ?? this.source,
      method: method ?? this.method,
      confidence: confidence ?? this.confidence,
      lowerBound: lowerBound ?? this.lowerBound,
      upperBound: upperBound ?? this.upperBound,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (lowerBound.present) {
      map['lower_bound'] = Variable<double>(lowerBound.value);
    }
    if (upperBound.present) {
      map['upper_bound'] = Variable<double>(upperBound.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyMeasurementsTable extends BodyMeasurements
    with TableInfo<$BodyMeasurementsTable, BodyMeasurementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowerBoundMeta = const VerificationMeta(
    'lowerBound',
  );
  @override
  late final GeneratedColumn<double> lowerBound = GeneratedColumn<double>(
    'lower_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _upperBoundMeta = const VerificationMeta(
    'upperBound',
  );
  @override
  late final GeneratedColumn<double> upperBound = GeneratedColumn<double>(
    'upper_bound',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customLabelMeta = const VerificationMeta(
    'customLabel',
  );
  @override
  late final GeneratedColumn<String> customLabel = GeneratedColumn<String>(
    'custom_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
    type,
    customLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_measurement';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMeasurementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('lower_bound')) {
      context.handle(
        _lowerBoundMeta,
        lowerBound.isAcceptableOrUnknown(data['lower_bound']!, _lowerBoundMeta),
      );
    }
    if (data.containsKey('upper_bound')) {
      context.handle(
        _upperBoundMeta,
        upperBound.isAcceptableOrUnknown(data['upper_bound']!, _upperBoundMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('custom_label')) {
      context.handle(
        _customLabelMeta,
        customLabel.isAcceptableOrUnknown(
          data['custom_label']!,
          _customLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMeasurementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMeasurementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      lowerBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lower_bound'],
      ),
      upperBound: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}upper_bound'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      customLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_label'],
      ),
    );
  }

  @override
  $BodyMeasurementsTable createAlias(String alias) {
    return $BodyMeasurementsTable(attachedDatabase, alias);
  }
}

class BodyMeasurementRow extends DataClass
    implements Insertable<BodyMeasurementRow> {
  final String id;
  final double value;
  final String unit;
  final String source;
  final String? method;
  final String? confidence;
  final double? lowerBound;
  final double? upperBound;
  final int recordedAt;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  final String type;
  final String? customLabel;
  const BodyMeasurementRow({
    required this.id,
    required this.value,
    required this.unit,
    required this.source,
    this.method,
    this.confidence,
    this.lowerBound,
    this.upperBound,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.customLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    if (!nullToAbsent || lowerBound != null) {
      map['lower_bound'] = Variable<double>(lowerBound);
    }
    if (!nullToAbsent || upperBound != null) {
      map['upper_bound'] = Variable<double>(upperBound);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || customLabel != null) {
      map['custom_label'] = Variable<String>(customLabel);
    }
    return map;
  }

  BodyMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return BodyMeasurementsCompanion(
      id: Value(id),
      value: Value(value),
      unit: Value(unit),
      source: Value(source),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      lowerBound: lowerBound == null && nullToAbsent
          ? const Value.absent()
          : Value(lowerBound),
      upperBound: upperBound == null && nullToAbsent
          ? const Value.absent()
          : Value(upperBound),
      recordedAt: Value(recordedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      type: Value(type),
      customLabel: customLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(customLabel),
    );
  }

  factory BodyMeasurementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMeasurementRow(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      source: serializer.fromJson<String>(json['source']),
      method: serializer.fromJson<String?>(json['method']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      lowerBound: serializer.fromJson<double?>(json['lowerBound']),
      upperBound: serializer.fromJson<double?>(json['upperBound']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      type: serializer.fromJson<String>(json['type']),
      customLabel: serializer.fromJson<String?>(json['customLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'source': serializer.toJson<String>(source),
      'method': serializer.toJson<String?>(method),
      'confidence': serializer.toJson<String?>(confidence),
      'lowerBound': serializer.toJson<double?>(lowerBound),
      'upperBound': serializer.toJson<double?>(upperBound),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'type': serializer.toJson<String>(type),
      'customLabel': serializer.toJson<String?>(customLabel),
    };
  }

  BodyMeasurementRow copyWith({
    String? id,
    double? value,
    String? unit,
    String? source,
    Value<String?> method = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    Value<double?> lowerBound = const Value.absent(),
    Value<double?> upperBound = const Value.absent(),
    int? recordedAt,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    String? type,
    Value<String?> customLabel = const Value.absent(),
  }) => BodyMeasurementRow(
    id: id ?? this.id,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    source: source ?? this.source,
    method: method.present ? method.value : this.method,
    confidence: confidence.present ? confidence.value : this.confidence,
    lowerBound: lowerBound.present ? lowerBound.value : this.lowerBound,
    upperBound: upperBound.present ? upperBound.value : this.upperBound,
    recordedAt: recordedAt ?? this.recordedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    type: type ?? this.type,
    customLabel: customLabel.present ? customLabel.value : this.customLabel,
  );
  BodyMeasurementRow copyWithCompanion(BodyMeasurementsCompanion data) {
    return BodyMeasurementRow(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      source: data.source.present ? data.source.value : this.source,
      method: data.method.present ? data.method.value : this.method,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      lowerBound: data.lowerBound.present
          ? data.lowerBound.value
          : this.lowerBound,
      upperBound: data.upperBound.present
          ? data.upperBound.value
          : this.upperBound,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      type: data.type.present ? data.type.value : this.type,
      customLabel: data.customLabel.present
          ? data.customLabel.value
          : this.customLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementRow(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('customLabel: $customLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    value,
    unit,
    source,
    method,
    confidence,
    lowerBound,
    upperBound,
    recordedAt,
    notes,
    createdAt,
    updatedAt,
    type,
    customLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMeasurementRow &&
          other.id == this.id &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.source == this.source &&
          other.method == this.method &&
          other.confidence == this.confidence &&
          other.lowerBound == this.lowerBound &&
          other.upperBound == this.upperBound &&
          other.recordedAt == this.recordedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.type == this.type &&
          other.customLabel == this.customLabel);
}

class BodyMeasurementsCompanion extends UpdateCompanion<BodyMeasurementRow> {
  final Value<String> id;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> source;
  final Value<String?> method;
  final Value<String?> confidence;
  final Value<double?> lowerBound;
  final Value<double?> upperBound;
  final Value<int> recordedAt;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> type;
  final Value<String?> customLabel;
  final Value<int> rowid;
  const BodyMeasurementsCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.source = const Value.absent(),
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.customLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyMeasurementsCompanion.insert({
    required String id,
    required double value,
    required String unit,
    required String source,
    this.method = const Value.absent(),
    this.confidence = const Value.absent(),
    this.lowerBound = const Value.absent(),
    this.upperBound = const Value.absent(),
    required int recordedAt,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    required String type,
    this.customLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       value = Value(value),
       unit = Value(unit),
       source = Value(source),
       recordedAt = Value(recordedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       type = Value(type);
  static Insertable<BodyMeasurementRow> custom({
    Expression<String>? id,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? source,
    Expression<String>? method,
    Expression<String>? confidence,
    Expression<double>? lowerBound,
    Expression<double>? upperBound,
    Expression<int>? recordedAt,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? type,
    Expression<String>? customLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (source != null) 'source': source,
      if (method != null) 'method': method,
      if (confidence != null) 'confidence': confidence,
      if (lowerBound != null) 'lower_bound': lowerBound,
      if (upperBound != null) 'upper_bound': upperBound,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (type != null) 'type': type,
      if (customLabel != null) 'custom_label': customLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyMeasurementsCompanion copyWith({
    Value<String>? id,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? source,
    Value<String?>? method,
    Value<String?>? confidence,
    Value<double?>? lowerBound,
    Value<double?>? upperBound,
    Value<int>? recordedAt,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? type,
    Value<String?>? customLabel,
    Value<int>? rowid,
  }) {
    return BodyMeasurementsCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source ?? this.source,
      method: method ?? this.method,
      confidence: confidence ?? this.confidence,
      lowerBound: lowerBound ?? this.lowerBound,
      upperBound: upperBound ?? this.upperBound,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      customLabel: customLabel ?? this.customLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (lowerBound.present) {
      map['lower_bound'] = Variable<double>(lowerBound.value);
    }
    if (upperBound.present) {
      map['upper_bound'] = Variable<double>(upperBound.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (customLabel.present) {
      map['custom_label'] = Variable<String>(customLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('confidence: $confidence, ')
          ..write('lowerBound: $lowerBound, ')
          ..write('upperBound: $upperBound, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('customLabel: $customLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsEntriesTable appSettingsEntries =
      $AppSettingsEntriesTable(this);
  late final $FeatureFlagsTable featureFlags = $FeatureFlagsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $HeightRecordsTable heightRecords = $HeightRecordsTable(this);
  late final $WeightRecordsTable weightRecords = $WeightRecordsTable(this);
  late final $BodyMeasurementsTable bodyMeasurements = $BodyMeasurementsTable(
    this,
  );
  late final Index idxHeightRecordedAt = Index(
    'idx_height_recorded_at',
    'CREATE INDEX idx_height_recorded_at ON height_record (recorded_at)',
  );
  late final Index idxWeightRecordedAt = Index(
    'idx_weight_recorded_at',
    'CREATE INDEX idx_weight_recorded_at ON weight_record (recorded_at)',
  );
  late final Index idxMeasurementTypeRecordedAt = Index(
    'idx_measurement_type_recorded_at',
    'CREATE INDEX idx_measurement_type_recorded_at ON body_measurement (type, recorded_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettingsEntries,
    featureFlags,
    userProfiles,
    goals,
    heightRecords,
    weightRecords,
    bodyMeasurements,
    idxHeightRecordedAt,
    idxWeightRecordedAt,
    idxMeasurementTypeRecordedAt,
  ];
}

typedef $$AppSettingsEntriesTableCreateCompanionBuilder =
    AppSettingsEntriesCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsEntriesTableUpdateCompanionBuilder =
    AppSettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsEntriesTable,
          SettingEntry,
          $$AppSettingsEntriesTableFilterComposer,
          $$AppSettingsEntriesTableOrderingComposer,
          $$AppSettingsEntriesTableAnnotationComposer,
          $$AppSettingsEntriesTableCreateCompanionBuilder,
          $$AppSettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingEntry,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsEntriesTable,
              SettingEntry
            >,
          ),
          SettingEntry,
          PrefetchHooks Function()
        > {
  $$AppSettingsEntriesTableTableManager(
    _$AppDatabase db,
    $AppSettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsEntriesCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsEntriesCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsEntriesTable, SettingEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsEntriesTable,
                    SettingEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsEntriesTable,
      SettingEntry,
      $$AppSettingsEntriesTableFilterComposer,
      $$AppSettingsEntriesTableOrderingComposer,
      $$AppSettingsEntriesTableAnnotationComposer,
      $$AppSettingsEntriesTableCreateCompanionBuilder,
      $$AppSettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingEntry,
        BaseReferences<_$AppDatabase, $AppSettingsEntriesTable, SettingEntry>,
      ),
      SettingEntry,
      PrefetchHooks Function()
    >;
typedef $$FeatureFlagsTableCreateCompanionBuilder =
    FeatureFlagsCompanion Function({
      required String id,
      required bool enabled,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$FeatureFlagsTableUpdateCompanionBuilder =
    FeatureFlagsCompanion Function({
      Value<String> id,
      Value<bool> enabled,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$FeatureFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeatureFlagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeatureFlagsTable,
          FeatureFlagEntry,
          $$FeatureFlagsTableFilterComposer,
          $$FeatureFlagsTableOrderingComposer,
          $$FeatureFlagsTableAnnotationComposer,
          $$FeatureFlagsTableCreateCompanionBuilder,
          $$FeatureFlagsTableUpdateCompanionBuilder,
          (
            FeatureFlagEntry,
            BaseReferences<_$AppDatabase, $FeatureFlagsTable, FeatureFlagEntry>,
          ),
          FeatureFlagEntry,
          PrefetchHooks Function()
        > {
  $$FeatureFlagsTableTableManager(_$AppDatabase db, $FeatureFlagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatureFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureFlagsCompanion(
                id: id,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required bool enabled,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FeatureFlagsCompanion.insert(
                id: id,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeatureFlagsTable, FeatureFlagEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FeatureFlagsTable,
                    FeatureFlagEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeatureFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeatureFlagsTable,
      FeatureFlagEntry,
      $$FeatureFlagsTableFilterComposer,
      $$FeatureFlagsTableOrderingComposer,
      $$FeatureFlagsTableAnnotationComposer,
      $$FeatureFlagsTableCreateCompanionBuilder,
      $$FeatureFlagsTableUpdateCompanionBuilder,
      (
        FeatureFlagEntry,
        BaseReferences<_$AppDatabase, $FeatureFlagsTable, FeatureFlagEntry>,
      ),
      FeatureFlagEntry,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String?> displayName,
      Value<String?> ageRange,
      Value<String?> activityLevel,
      Value<String?> primaryHeightId,
      Value<double?> goalWeightMinKg,
      Value<double?> goalWeightMaxKg,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String?> displayName,
      Value<String?> ageRange,
      Value<String?> activityLevel,
      Value<String?> primaryHeightId,
      Value<double?> goalWeightMinKg,
      Value<double?> goalWeightMaxKg,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageRange => $composableBuilder(
    column: $table.ageRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryHeightId => $composableBuilder(
    column: $table.primaryHeightId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalWeightMinKg => $composableBuilder(
    column: $table.goalWeightMinKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalWeightMaxKg => $composableBuilder(
    column: $table.goalWeightMaxKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageRange => $composableBuilder(
    column: $table.ageRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryHeightId => $composableBuilder(
    column: $table.primaryHeightId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalWeightMinKg => $composableBuilder(
    column: $table.goalWeightMinKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalWeightMaxKg => $composableBuilder(
    column: $table.goalWeightMaxKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ageRange =>
      $composableBuilder(column: $table.ageRange, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryHeightId => $composableBuilder(
    column: $table.primaryHeightId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get goalWeightMinKg => $composableBuilder(
    column: $table.goalWeightMinKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get goalWeightMaxKg => $composableBuilder(
    column: $table.goalWeightMaxKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          ProfileRow,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $UserProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> ageRange = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> primaryHeightId = const Value.absent(),
                Value<double?> goalWeightMinKg = const Value.absent(),
                Value<double?> goalWeightMaxKg = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                ageRange: ageRange,
                activityLevel: activityLevel,
                primaryHeightId: primaryHeightId,
                goalWeightMinKg: goalWeightMinKg,
                goalWeightMaxKg: goalWeightMaxKg,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> displayName = const Value.absent(),
                Value<String?> ageRange = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> primaryHeightId = const Value.absent(),
                Value<double?> goalWeightMinKg = const Value.absent(),
                Value<double?> goalWeightMaxKg = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                ageRange: ageRange,
                activityLevel: activityLevel,
                primaryHeightId: primaryHeightId,
                goalWeightMinKg: goalWeightMinKg,
                goalWeightMaxKg: goalWeightMaxKg,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $UserProfilesTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      ProfileRow,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        ProfileRow,
        BaseReferences<_$AppDatabase, $UserProfilesTable, ProfileRow>,
      ),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String type,
  required bool active,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> type,
  Value<bool> active,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
          GoalRow,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> type = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                type: type,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String type,
                required bool active,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                type: type,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, GoalRow>(table),
                  BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
      GoalRow,
      PrefetchHooks Function()
    >;
typedef $$HeightRecordsTableCreateCompanionBuilder =
    HeightRecordsCompanion Function({
      required String id,
      required double value,
      required String unit,
      required String source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      required int recordedAt,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$HeightRecordsTableUpdateCompanionBuilder =
    HeightRecordsCompanion Function({
      Value<String> id,
      Value<double> value,
      Value<String> unit,
      Value<String> source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      Value<int> recordedAt,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$HeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HeightRecordsTable> {
  $$HeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HeightRecordsTable> {
  $$HeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeightRecordsTable> {
  $$HeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => column,
  );

  GeneratedColumn<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HeightRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeightRecordsTable,
          HeightRow,
          $$HeightRecordsTableFilterComposer,
          $$HeightRecordsTableOrderingComposer,
          $$HeightRecordsTableAnnotationComposer,
          $$HeightRecordsTableCreateCompanionBuilder,
          $$HeightRecordsTableUpdateCompanionBuilder,
          (
            HeightRow,
            BaseReferences<_$AppDatabase, $HeightRecordsTable, HeightRow>,
          ),
          HeightRow,
          PrefetchHooks Function()
        > {
  $$HeightRecordsTableTableManager(_$AppDatabase db, $HeightRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeightRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeightRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeightRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HeightRecordsCompanion(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double value,
                required String unit,
                required String source,
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                required int recordedAt,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HeightRecordsCompanion.insert(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HeightRecordsTable, HeightRow>(table),
                  BaseReferences<_$AppDatabase, $HeightRecordsTable, HeightRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeightRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeightRecordsTable,
      HeightRow,
      $$HeightRecordsTableFilterComposer,
      $$HeightRecordsTableOrderingComposer,
      $$HeightRecordsTableAnnotationComposer,
      $$HeightRecordsTableCreateCompanionBuilder,
      $$HeightRecordsTableUpdateCompanionBuilder,
      (
        HeightRow,
        BaseReferences<_$AppDatabase, $HeightRecordsTable, HeightRow>,
      ),
      HeightRow,
      PrefetchHooks Function()
    >;
typedef $$WeightRecordsTableCreateCompanionBuilder =
    WeightRecordsCompanion Function({
      required String id,
      required double value,
      required String unit,
      required String source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      required int recordedAt,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$WeightRecordsTableUpdateCompanionBuilder =
    WeightRecordsCompanion Function({
      Value<String> id,
      Value<double> value,
      Value<String> unit,
      Value<String> source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      Value<int> recordedAt,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$WeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => column,
  );

  GeneratedColumn<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WeightRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightRecordsTable,
          WeightRow,
          $$WeightRecordsTableFilterComposer,
          $$WeightRecordsTableOrderingComposer,
          $$WeightRecordsTableAnnotationComposer,
          $$WeightRecordsTableCreateCompanionBuilder,
          $$WeightRecordsTableUpdateCompanionBuilder,
          (
            WeightRow,
            BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRow>,
          ),
          WeightRow,
          PrefetchHooks Function()
        > {
  $$WeightRecordsTableTableManager(_$AppDatabase db, $WeightRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsCompanion(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double value,
                required String unit,
                required String source,
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                required int recordedAt,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsCompanion.insert(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightRecordsTable, WeightRow>(table),
                  BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightRecordsTable,
      WeightRow,
      $$WeightRecordsTableFilterComposer,
      $$WeightRecordsTableOrderingComposer,
      $$WeightRecordsTableAnnotationComposer,
      $$WeightRecordsTableCreateCompanionBuilder,
      $$WeightRecordsTableUpdateCompanionBuilder,
      (
        WeightRow,
        BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRow>,
      ),
      WeightRow,
      PrefetchHooks Function()
    >;
typedef $$BodyMeasurementsTableCreateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      required String id,
      required double value,
      required String unit,
      required String source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      required int recordedAt,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      required String type,
      Value<String?> customLabel,
      Value<int> rowid,
    });
typedef $$BodyMeasurementsTableUpdateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<String> id,
      Value<double> value,
      Value<String> unit,
      Value<String> source,
      Value<String?> method,
      Value<String?> confidence,
      Value<double?> lowerBound,
      Value<double?> upperBound,
      Value<int> recordedAt,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> type,
      Value<String?> customLabel,
      Value<int> rowid,
    });

class $$BodyMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customLabel => $composableBuilder(
    column: $table.customLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customLabel => $composableBuilder(
    column: $table.customLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowerBound => $composableBuilder(
    column: $table.lowerBound,
    builder: (column) => column,
  );

  GeneratedColumn<double> get upperBound => $composableBuilder(
    column: $table.upperBound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get customLabel => $composableBuilder(
    column: $table.customLabel,
    builder: (column) => column,
  );
}

class $$BodyMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurementRow,
          $$BodyMeasurementsTableFilterComposer,
          $$BodyMeasurementsTableOrderingComposer,
          $$BodyMeasurementsTableAnnotationComposer,
          $$BodyMeasurementsTableCreateCompanionBuilder,
          $$BodyMeasurementsTableUpdateCompanionBuilder,
          (
            BodyMeasurementRow,
            BaseReferences<
              _$AppDatabase,
              $BodyMeasurementsTable,
              BodyMeasurementRow
            >,
          ),
          BodyMeasurementRow,
          PrefetchHooks Function()
        > {
  $$BodyMeasurementsTableTableManager(
    _$AppDatabase db,
    $BodyMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> customLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMeasurementsCompanion(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                customLabel: customLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double value,
                required String unit,
                required String source,
                Value<String?> method = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<double?> lowerBound = const Value.absent(),
                Value<double?> upperBound = const Value.absent(),
                required int recordedAt,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                required String type,
                Value<String?> customLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMeasurementsCompanion.insert(
                id: id,
                value: value,
                unit: unit,
                source: source,
                method: method,
                confidence: confidence,
                lowerBound: lowerBound,
                upperBound: upperBound,
                recordedAt: recordedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                customLabel: customLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyMeasurementsTable, BodyMeasurementRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyMeasurementsTable,
                    BodyMeasurementRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMeasurementsTable,
      BodyMeasurementRow,
      $$BodyMeasurementsTableFilterComposer,
      $$BodyMeasurementsTableOrderingComposer,
      $$BodyMeasurementsTableAnnotationComposer,
      $$BodyMeasurementsTableCreateCompanionBuilder,
      $$BodyMeasurementsTableUpdateCompanionBuilder,
      (
        BodyMeasurementRow,
        BaseReferences<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurementRow
        >,
      ),
      BodyMeasurementRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsEntriesTableTableManager get appSettingsEntries =>
      $$AppSettingsEntriesTableTableManager(_db, _db.appSettingsEntries);
  $$FeatureFlagsTableTableManager get featureFlags =>
      $$FeatureFlagsTableTableManager(_db, _db.featureFlags);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$HeightRecordsTableTableManager get heightRecords =>
      $$HeightRecordsTableTableManager(_db, _db.heightRecords);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db, _db.weightRecords);
  $$BodyMeasurementsTableTableManager get bodyMeasurements =>
      $$BodyMeasurementsTableTableManager(_db, _db.bodyMeasurements);
}
