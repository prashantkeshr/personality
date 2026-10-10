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
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dietPreferenceMeta = const VerificationMeta(
    'dietPreference',
  );
  @override
  late final GeneratedColumn<String> dietPreference = GeneratedColumn<String>(
    'diet_preference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _styleFitMeta = const VerificationMeta(
    'styleFit',
  );
  @override
  late final GeneratedColumn<String> styleFit = GeneratedColumn<String>(
    'style_fit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    gender,
    dietPreference,
    styleFit,
    region,
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
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('diet_preference')) {
      context.handle(
        _dietPreferenceMeta,
        dietPreference.isAcceptableOrUnknown(
          data['diet_preference']!,
          _dietPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('style_fit')) {
      context.handle(
        _styleFitMeta,
        styleFit.isAcceptableOrUnknown(data['style_fit']!, _styleFitMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
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
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      dietPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_preference'],
      ),
      styleFit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style_fit'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
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
  final String? gender;
  final String? dietPreference;
  final String? styleFit;
  final String? region;
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
    this.gender,
    this.dietPreference,
    this.styleFit,
    this.region,
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
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || dietPreference != null) {
      map['diet_preference'] = Variable<String>(dietPreference);
    }
    if (!nullToAbsent || styleFit != null) {
      map['style_fit'] = Variable<String>(styleFit);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
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
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      dietPreference: dietPreference == null && nullToAbsent
          ? const Value.absent()
          : Value(dietPreference),
      styleFit: styleFit == null && nullToAbsent
          ? const Value.absent()
          : Value(styleFit),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
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
      gender: serializer.fromJson<String?>(json['gender']),
      dietPreference: serializer.fromJson<String?>(json['dietPreference']),
      styleFit: serializer.fromJson<String?>(json['styleFit']),
      region: serializer.fromJson<String?>(json['region']),
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
      'gender': serializer.toJson<String?>(gender),
      'dietPreference': serializer.toJson<String?>(dietPreference),
      'styleFit': serializer.toJson<String?>(styleFit),
      'region': serializer.toJson<String?>(region),
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
    Value<String?> gender = const Value.absent(),
    Value<String?> dietPreference = const Value.absent(),
    Value<String?> styleFit = const Value.absent(),
    Value<String?> region = const Value.absent(),
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
    gender: gender.present ? gender.value : this.gender,
    dietPreference: dietPreference.present
        ? dietPreference.value
        : this.dietPreference,
    styleFit: styleFit.present ? styleFit.value : this.styleFit,
    region: region.present ? region.value : this.region,
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
      gender: data.gender.present ? data.gender.value : this.gender,
      dietPreference: data.dietPreference.present
          ? data.dietPreference.value
          : this.dietPreference,
      styleFit: data.styleFit.present ? data.styleFit.value : this.styleFit,
      region: data.region.present ? data.region.value : this.region,
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
          ..write('updatedAt: $updatedAt, ')
          ..write('gender: $gender, ')
          ..write('dietPreference: $dietPreference, ')
          ..write('styleFit: $styleFit, ')
          ..write('region: $region')
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
    gender,
    dietPreference,
    styleFit,
    region,
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
          other.updatedAt == this.updatedAt &&
          other.gender == this.gender &&
          other.dietPreference == this.dietPreference &&
          other.styleFit == this.styleFit &&
          other.region == this.region);
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
  final Value<String?> gender;
  final Value<String?> dietPreference;
  final Value<String?> styleFit;
  final Value<String?> region;
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
    this.gender = const Value.absent(),
    this.dietPreference = const Value.absent(),
    this.styleFit = const Value.absent(),
    this.region = const Value.absent(),
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
    this.gender = const Value.absent(),
    this.dietPreference = const Value.absent(),
    this.styleFit = const Value.absent(),
    this.region = const Value.absent(),
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
    Expression<String>? gender,
    Expression<String>? dietPreference,
    Expression<String>? styleFit,
    Expression<String>? region,
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
      if (gender != null) 'gender': gender,
      if (dietPreference != null) 'diet_preference': dietPreference,
      if (styleFit != null) 'style_fit': styleFit,
      if (region != null) 'region': region,
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
    Value<String?>? gender,
    Value<String?>? dietPreference,
    Value<String?>? styleFit,
    Value<String?>? region,
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
      gender: gender ?? this.gender,
      dietPreference: dietPreference ?? this.dietPreference,
      styleFit: styleFit ?? this.styleFit,
      region: region ?? this.region,
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
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (dietPreference.present) {
      map['diet_preference'] = Variable<String>(dietPreference.value);
    }
    if (styleFit.present) {
      map['style_fit'] = Variable<String>(styleFit.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
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
          ..write('gender: $gender, ')
          ..write('dietPreference: $dietPreference, ')
          ..write('styleFit: $styleFit, ')
          ..write('region: $region, ')
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

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'water_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterRow> instance, {
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
  WaterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterRow(
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
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterRow extends DataClass implements Insertable<WaterRow> {
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
  const WaterRow({
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

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
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

  factory WaterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterRow(
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

  WaterRow copyWith({
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
  }) => WaterRow(
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
  WaterRow copyWithCompanion(WaterLogsCompanion data) {
    return WaterRow(
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
    return (StringBuffer('WaterRow(')
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
      (other is WaterRow &&
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

class WaterLogsCompanion extends UpdateCompanion<WaterRow> {
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
  const WaterLogsCompanion({
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
  WaterLogsCompanion.insert({
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
  static Insertable<WaterRow> custom({
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

  WaterLogsCompanion copyWith({
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
    return WaterLogsCompanion(
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
    return (StringBuffer('WaterLogsCompanion(')
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

class $MealsTable extends Meals with TableInfo<$MealsTable, MealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodMeta = const VerificationMeta('food');
  @override
  late final GeneratedColumn<String> food = GeneratedColumn<String>(
    'food',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eatenAtMeta = const VerificationMeta(
    'eatenAt',
  );
  @override
  late final GeneratedColumn<int> eatenAt = GeneratedColumn<int>(
    'eaten_at',
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
    mealType,
    customName,
    food,
    quantity,
    calories,
    eatenAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('food')) {
      context.handle(
        _foodMeta,
        food.isAcceptableOrUnknown(data['food']!, _foodMeta),
      );
    } else if (isInserting) {
      context.missing(_foodMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('eaten_at')) {
      context.handle(
        _eatenAtMeta,
        eatenAt.isAcceptableOrUnknown(data['eaten_at']!, _eatenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_eatenAtMeta);
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
  MealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      food: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      ),
      eatenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eaten_at'],
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
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class MealRow extends DataClass implements Insertable<MealRow> {
  final String id;
  final String mealType;
  final String? customName;
  final String food;
  final String? quantity;
  final double? calories;
  final int eatenAt;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const MealRow({
    required this.id,
    required this.mealType,
    this.customName,
    required this.food,
    this.quantity,
    this.calories,
    required this.eatenAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['food'] = Variable<String>(food);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(quantity);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<double>(calories);
    }
    map['eaten_at'] = Variable<int>(eatenAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      mealType: Value(mealType),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      food: Value(food),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      eatenAt: Value(eatenAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealRow(
      id: serializer.fromJson<String>(json['id']),
      mealType: serializer.fromJson<String>(json['mealType']),
      customName: serializer.fromJson<String?>(json['customName']),
      food: serializer.fromJson<String>(json['food']),
      quantity: serializer.fromJson<String?>(json['quantity']),
      calories: serializer.fromJson<double?>(json['calories']),
      eatenAt: serializer.fromJson<int>(json['eatenAt']),
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
      'mealType': serializer.toJson<String>(mealType),
      'customName': serializer.toJson<String?>(customName),
      'food': serializer.toJson<String>(food),
      'quantity': serializer.toJson<String?>(quantity),
      'calories': serializer.toJson<double?>(calories),
      'eatenAt': serializer.toJson<int>(eatenAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MealRow copyWith({
    String? id,
    String? mealType,
    Value<String?> customName = const Value.absent(),
    String? food,
    Value<String?> quantity = const Value.absent(),
    Value<double?> calories = const Value.absent(),
    int? eatenAt,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => MealRow(
    id: id ?? this.id,
    mealType: mealType ?? this.mealType,
    customName: customName.present ? customName.value : this.customName,
    food: food ?? this.food,
    quantity: quantity.present ? quantity.value : this.quantity,
    calories: calories.present ? calories.value : this.calories,
    eatenAt: eatenAt ?? this.eatenAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MealRow copyWithCompanion(MealsCompanion data) {
    return MealRow(
      id: data.id.present ? data.id.value : this.id,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      food: data.food.present ? data.food.value : this.food,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      calories: data.calories.present ? data.calories.value : this.calories,
      eatenAt: data.eatenAt.present ? data.eatenAt.value : this.eatenAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealRow(')
          ..write('id: $id, ')
          ..write('mealType: $mealType, ')
          ..write('customName: $customName, ')
          ..write('food: $food, ')
          ..write('quantity: $quantity, ')
          ..write('calories: $calories, ')
          ..write('eatenAt: $eatenAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealType,
    customName,
    food,
    quantity,
    calories,
    eatenAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealRow &&
          other.id == this.id &&
          other.mealType == this.mealType &&
          other.customName == this.customName &&
          other.food == this.food &&
          other.quantity == this.quantity &&
          other.calories == this.calories &&
          other.eatenAt == this.eatenAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealsCompanion extends UpdateCompanion<MealRow> {
  final Value<String> id;
  final Value<String> mealType;
  final Value<String?> customName;
  final Value<String> food;
  final Value<String?> quantity;
  final Value<double?> calories;
  final Value<int> eatenAt;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.mealType = const Value.absent(),
    this.customName = const Value.absent(),
    this.food = const Value.absent(),
    this.quantity = const Value.absent(),
    this.calories = const Value.absent(),
    this.eatenAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String id,
    required String mealType,
    this.customName = const Value.absent(),
    required String food,
    this.quantity = const Value.absent(),
    this.calories = const Value.absent(),
    required int eatenAt,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mealType = Value(mealType),
       food = Value(food),
       eatenAt = Value(eatenAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MealRow> custom({
    Expression<String>? id,
    Expression<String>? mealType,
    Expression<String>? customName,
    Expression<String>? food,
    Expression<String>? quantity,
    Expression<double>? calories,
    Expression<int>? eatenAt,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealType != null) 'meal_type': mealType,
      if (customName != null) 'custom_name': customName,
      if (food != null) 'food': food,
      if (quantity != null) 'quantity': quantity,
      if (calories != null) 'calories': calories,
      if (eatenAt != null) 'eaten_at': eatenAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith({
    Value<String>? id,
    Value<String>? mealType,
    Value<String?>? customName,
    Value<String>? food,
    Value<String?>? quantity,
    Value<double?>? calories,
    Value<int>? eatenAt,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      customName: customName ?? this.customName,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      eatenAt: eatenAt ?? this.eatenAt,
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
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (food.present) {
      map['food'] = Variable<String>(food.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (eatenAt.present) {
      map['eaten_at'] = Variable<int>(eatenAt.value);
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
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('mealType: $mealType, ')
          ..write('customName: $customName, ')
          ..write('food: $food, ')
          ..write('quantity: $quantity, ')
          ..write('calories: $calories, ')
          ..write('eatenAt: $eatenAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleepLogsTable extends SleepLogs
    with TableInfo<$SleepLogsTable, SleepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedAtMeta = const VerificationMeta('bedAt');
  @override
  late final GeneratedColumn<int> bedAt = GeneratedColumn<int>(
    'bed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeAtMeta = const VerificationMeta('wakeAt');
  @override
  late final GeneratedColumn<int> wakeAt = GeneratedColumn<int>(
    'wake_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    bedAt,
    wakeAt,
    source,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bed_at')) {
      context.handle(
        _bedAtMeta,
        bedAt.isAcceptableOrUnknown(data['bed_at']!, _bedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_bedAtMeta);
    }
    if (data.containsKey('wake_at')) {
      context.handle(
        _wakeAtMeta,
        wakeAt.isAcceptableOrUnknown(data['wake_at']!, _wakeAtMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  SleepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_at'],
      )!,
      wakeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
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
  $SleepLogsTable createAlias(String alias) {
    return $SleepLogsTable(attachedDatabase, alias);
  }
}

class SleepRow extends DataClass implements Insertable<SleepRow> {
  final String id;
  final int bedAt;
  final int wakeAt;
  final String source;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const SleepRow({
    required this.id,
    required this.bedAt,
    required this.wakeAt,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bed_at'] = Variable<int>(bedAt);
    map['wake_at'] = Variable<int>(wakeAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SleepLogsCompanion toCompanion(bool nullToAbsent) {
    return SleepLogsCompanion(
      id: Value(id),
      bedAt: Value(bedAt),
      wakeAt: Value(wakeAt),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SleepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepRow(
      id: serializer.fromJson<String>(json['id']),
      bedAt: serializer.fromJson<int>(json['bedAt']),
      wakeAt: serializer.fromJson<int>(json['wakeAt']),
      source: serializer.fromJson<String>(json['source']),
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
      'bedAt': serializer.toJson<int>(bedAt),
      'wakeAt': serializer.toJson<int>(wakeAt),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SleepRow copyWith({
    String? id,
    int? bedAt,
    int? wakeAt,
    String? source,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => SleepRow(
    id: id ?? this.id,
    bedAt: bedAt ?? this.bedAt,
    wakeAt: wakeAt ?? this.wakeAt,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SleepRow copyWithCompanion(SleepLogsCompanion data) {
    return SleepRow(
      id: data.id.present ? data.id.value : this.id,
      bedAt: data.bedAt.present ? data.bedAt.value : this.bedAt,
      wakeAt: data.wakeAt.present ? data.wakeAt.value : this.wakeAt,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepRow(')
          ..write('id: $id, ')
          ..write('bedAt: $bedAt, ')
          ..write('wakeAt: $wakeAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bedAt, wakeAt, source, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepRow &&
          other.id == this.id &&
          other.bedAt == this.bedAt &&
          other.wakeAt == this.wakeAt &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SleepLogsCompanion extends UpdateCompanion<SleepRow> {
  final Value<String> id;
  final Value<int> bedAt;
  final Value<int> wakeAt;
  final Value<String> source;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SleepLogsCompanion({
    this.id = const Value.absent(),
    this.bedAt = const Value.absent(),
    this.wakeAt = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepLogsCompanion.insert({
    required String id,
    required int bedAt,
    required int wakeAt,
    required String source,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bedAt = Value(bedAt),
       wakeAt = Value(wakeAt),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SleepRow> custom({
    Expression<String>? id,
    Expression<int>? bedAt,
    Expression<int>? wakeAt,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bedAt != null) 'bed_at': bedAt,
      if (wakeAt != null) 'wake_at': wakeAt,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepLogsCompanion copyWith({
    Value<String>? id,
    Value<int>? bedAt,
    Value<int>? wakeAt,
    Value<String>? source,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SleepLogsCompanion(
      id: id ?? this.id,
      bedAt: bedAt ?? this.bedAt,
      wakeAt: wakeAt ?? this.wakeAt,
      source: source ?? this.source,
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
    if (bedAt.present) {
      map['bed_at'] = Variable<int>(bedAt.value);
    }
    if (wakeAt.present) {
      map['wake_at'] = Variable<int>(wakeAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
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
    return (StringBuffer('SleepLogsCompanion(')
          ..write('id: $id, ')
          ..write('bedAt: $bedAt, ')
          ..write('wakeAt: $wakeAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    kind,
    durationMinutes,
    steps,
    distanceKm,
    recordedAt,
    source,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
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
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
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
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  final String id;
  final String kind;
  final int? durationMinutes;
  final int? steps;
  final double? distanceKm;
  final int recordedAt;
  final String source;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const ActivityRow({
    required this.id,
    required this.kind,
    this.durationMinutes,
    this.steps,
    this.distanceKm,
    required this.recordedAt,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || distanceKm != null) {
      map['distance_km'] = Variable<double>(distanceKm);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      kind: Value(kind),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      distanceKm: distanceKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceKm),
      recordedAt: Value(recordedAt),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      steps: serializer.fromJson<int?>(json['steps']),
      distanceKm: serializer.fromJson<double?>(json['distanceKm']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      source: serializer.fromJson<String>(json['source']),
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
      'kind': serializer.toJson<String>(kind),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'steps': serializer.toJson<int?>(steps),
      'distanceKm': serializer.toJson<double?>(distanceKm),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ActivityRow copyWith({
    String? id,
    String? kind,
    Value<int?> durationMinutes = const Value.absent(),
    Value<int?> steps = const Value.absent(),
    Value<double?> distanceKm = const Value.absent(),
    int? recordedAt,
    String? source,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ActivityRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    steps: steps.present ? steps.value : this.steps,
    distanceKm: distanceKm.present ? distanceKm.value : this.distanceKm,
    recordedAt: recordedAt ?? this.recordedAt,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActivityRow copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      steps: data.steps.present ? data.steps.value : this.steps,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('steps: $steps, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    durationMinutes,
    steps,
    distanceKm,
    recordedAt,
    source,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.durationMinutes == this.durationMinutes &&
          other.steps == this.steps &&
          other.distanceKm == this.distanceKm &&
          other.recordedAt == this.recordedAt &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<int?> durationMinutes;
  final Value<int?> steps;
  final Value<double?> distanceKm;
  final Value<int> recordedAt;
  final Value<String> source;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.steps = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String kind,
    this.durationMinutes = const Value.absent(),
    this.steps = const Value.absent(),
    this.distanceKm = const Value.absent(),
    required int recordedAt,
    required String source,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       recordedAt = Value(recordedAt),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActivityRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<int>? durationMinutes,
    Expression<int>? steps,
    Expression<double>? distanceKm,
    Expression<int>? recordedAt,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (steps != null) 'steps': steps,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<int?>? durationMinutes,
    Value<int?>? steps,
    Value<double?>? distanceKm,
    Value<int>? recordedAt,
    Value<String>? source,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
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
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
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
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('steps: $steps, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseSessionsTable extends ExerciseSessions
    with TableInfo<$ExerciseSessionsTable, ExerciseSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<int> performedAt = GeneratedColumn<int>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    name,
    category,
    durationMinutes,
    sets,
    reps,
    performedAt,
    source,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  ExerciseSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}performed_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
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
  $ExerciseSessionsTable createAlias(String alias) {
    return $ExerciseSessionsTable(attachedDatabase, alias);
  }
}

class ExerciseSessionRow extends DataClass
    implements Insertable<ExerciseSessionRow> {
  final String id;
  final String name;
  final String category;
  final int durationMinutes;
  final int? sets;
  final int? reps;
  final int performedAt;
  final String source;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const ExerciseSessionRow({
    required this.id,
    required this.name,
    required this.category,
    required this.durationMinutes,
    this.sets,
    this.reps,
    required this.performedAt,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || sets != null) {
      map['sets'] = Variable<int>(sets);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    map['performed_at'] = Variable<int>(performedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExerciseSessionsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseSessionsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      durationMinutes: Value(durationMinutes),
      sets: sets == null && nullToAbsent ? const Value.absent() : Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      performedAt: Value(performedAt),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExerciseSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSessionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      sets: serializer.fromJson<int?>(json['sets']),
      reps: serializer.fromJson<int?>(json['reps']),
      performedAt: serializer.fromJson<int>(json['performedAt']),
      source: serializer.fromJson<String>(json['source']),
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
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'sets': serializer.toJson<int?>(sets),
      'reps': serializer.toJson<int?>(reps),
      'performedAt': serializer.toJson<int>(performedAt),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ExerciseSessionRow copyWith({
    String? id,
    String? name,
    String? category,
    int? durationMinutes,
    Value<int?> sets = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    int? performedAt,
    String? source,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ExerciseSessionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sets: sets.present ? sets.value : this.sets,
    reps: reps.present ? reps.value : this.reps,
    performedAt: performedAt ?? this.performedAt,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExerciseSessionRow copyWithCompanion(ExerciseSessionsCompanion data) {
    return ExerciseSessionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSessionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('performedAt: $performedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    durationMinutes,
    sets,
    reps,
    performedAt,
    source,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseSessionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.durationMinutes == this.durationMinutes &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.performedAt == this.performedAt &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExerciseSessionsCompanion extends UpdateCompanion<ExerciseSessionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> durationMinutes;
  final Value<int?> sets;
  final Value<int?> reps;
  final Value<int> performedAt;
  final Value<String> source;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExerciseSessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseSessionsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required int durationMinutes,
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    required int performedAt,
    required String source,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       durationMinutes = Value(durationMinutes),
       performedAt = Value(performedAt),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExerciseSessionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? durationMinutes,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<int>? performedAt,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (performedAt != null) 'performed_at': performedAt,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? durationMinutes,
    Value<int?>? sets,
    Value<int?>? reps,
    Value<int>? performedAt,
    Value<String>? source,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExerciseSessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      performedAt: performedAt ?? this.performedAt,
      source: source ?? this.source,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<int>(performedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
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
    return (StringBuffer('ExerciseSessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('performedAt: $performedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    name,
    weekdays,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
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
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
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
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final String id;
  final String name;
  final int weekdays;
  final bool archived;
  final int createdAt;
  final int updatedAt;
  const HabitRow({
    required this.id,
    required this.name,
    required this.weekdays,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['weekdays'] = Variable<int>(weekdays);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      weekdays: Value(weekdays),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'weekdays': serializer.toJson<int>(weekdays),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  HabitRow copyWith({
    String? id,
    String? name,
    int? weekdays,
    bool? archived,
    int? createdAt,
    int? updatedAt,
  }) => HabitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    weekdays: weekdays ?? this.weekdays,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weekdays: $weekdays, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, weekdays, archived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.weekdays == this.weekdays &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> weekdays;
  final Value<bool> archived;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    required int weekdays,
    this.archived = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       weekdays = Value(weekdays),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HabitRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? weekdays,
    Expression<bool>? archived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weekdays != null) 'weekdays': weekdays,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? weekdays,
    Value<bool>? archived,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weekdays: weekdays ?? this.weekdays,
      archived: archived ?? this.archived,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
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
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weekdays: $weekdays, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habit (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [habitId, day, status, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completion';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, day};
  @override
  HabitCompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletionRow(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $HabitCompletionsTable createAlias(String alias) {
    return $HabitCompletionsTable(attachedDatabase, alias);
  }
}

class HabitCompletionRow extends DataClass
    implements Insertable<HabitCompletionRow> {
  final String habitId;

  /// Local calendar day, yyyymmdd.
  final int day;
  final String status;
  final int recordedAt;
  const HabitCompletionRow({
    required this.habitId,
    required this.day,
    required this.status,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['day'] = Variable<int>(day);
    map['status'] = Variable<String>(status);
    map['recorded_at'] = Variable<int>(recordedAt);
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      habitId: Value(habitId),
      day: Value(day),
      status: Value(status),
      recordedAt: Value(recordedAt),
    );
  }

  factory HabitCompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletionRow(
      habitId: serializer.fromJson<String>(json['habitId']),
      day: serializer.fromJson<int>(json['day']),
      status: serializer.fromJson<String>(json['status']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'day': serializer.toJson<int>(day),
      'status': serializer.toJson<String>(status),
      'recordedAt': serializer.toJson<int>(recordedAt),
    };
  }

  HabitCompletionRow copyWith({
    String? habitId,
    int? day,
    String? status,
    int? recordedAt,
  }) => HabitCompletionRow(
    habitId: habitId ?? this.habitId,
    day: day ?? this.day,
    status: status ?? this.status,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  HabitCompletionRow copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletionRow(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      day: data.day.present ? data.day.value : this.day,
      status: data.status.present ? data.status.value : this.status,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionRow(')
          ..write('habitId: $habitId, ')
          ..write('day: $day, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, day, status, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletionRow &&
          other.habitId == this.habitId &&
          other.day == this.day &&
          other.status == this.status &&
          other.recordedAt == this.recordedAt);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletionRow> {
  final Value<String> habitId;
  final Value<int> day;
  final Value<String> status;
  final Value<int> recordedAt;
  final Value<int> rowid;
  const HabitCompletionsCompanion({
    this.habitId = const Value.absent(),
    this.day = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    required String habitId,
    required int day,
    required String status,
    required int recordedAt,
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       day = Value(day),
       status = Value(status),
       recordedAt = Value(recordedAt);
  static Insertable<HabitCompletionRow> custom({
    Expression<String>? habitId,
    Expression<int>? day,
    Expression<String>? status,
    Expression<int>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (day != null) 'day': day,
      if (status != null) 'status': status,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCompletionsCompanion copyWith({
    Value<String>? habitId,
    Value<int>? day,
    Value<String>? status,
    Value<int>? recordedAt,
    Value<int>? rowid,
  }) {
    return HabitCompletionsCompanion(
      habitId: habitId ?? this.habitId,
      day: day ?? this.day,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('day: $day, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines
    with TableInfo<$RoutinesTable, RoutineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    name,
    weekdays,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
  RoutineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
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
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class RoutineRow extends DataClass implements Insertable<RoutineRow> {
  final String id;
  final String name;
  final int weekdays;
  final bool active;
  final int createdAt;
  final int updatedAt;
  const RoutineRow({
    required this.id,
    required this.name,
    required this.weekdays,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['weekdays'] = Variable<int>(weekdays);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      weekdays: Value(weekdays),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'weekdays': serializer.toJson<int>(weekdays),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RoutineRow copyWith({
    String? id,
    String? name,
    int? weekdays,
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) => RoutineRow(
    id: id ?? this.id,
    name: name ?? this.name,
    weekdays: weekdays ?? this.weekdays,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineRow copyWithCompanion(RoutinesCompanion data) {
    return RoutineRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weekdays: $weekdays, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, weekdays, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.weekdays == this.weekdays &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinesCompanion extends UpdateCompanion<RoutineRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> weekdays;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    required int weekdays,
    this.active = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       weekdays = Value(weekdays),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? weekdays,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weekdays != null) 'weekdays': weekdays,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? weekdays,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weekdays: weekdays ?? this.weekdays,
      active: active ?? this.active,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
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
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weekdays: $weekdays, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineItemsTable extends RoutineItems
    with TableInfo<$RoutineItemsTable, RoutineItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta(
    'minuteOfDay',
  );
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderMeta = const VerificationMeta(
    'reminder',
  );
  @override
  late final GeneratedColumn<bool> reminder = GeneratedColumn<bool>(
    'reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    routineId,
    minuteOfDay,
    title,
    kind,
    reminder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
        _minuteOfDayMeta,
        minuteOfDay.isAcceptableOrUnknown(
          data['minute_of_day']!,
          _minuteOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minuteOfDayMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('reminder')) {
      context.handle(
        _reminderMeta,
        reminder.isAcceptableOrUnknown(data['reminder']!, _reminderMeta),
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
  RoutineItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      minuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute_of_day'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      reminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder'],
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
  $RoutineItemsTable createAlias(String alias) {
    return $RoutineItemsTable(attachedDatabase, alias);
  }
}

class RoutineItemRow extends DataClass implements Insertable<RoutineItemRow> {
  final String id;
  final String routineId;

  /// Local time, minutes after midnight.
  final int minuteOfDay;
  final String title;
  final String kind;
  final bool reminder;
  final int createdAt;
  final int updatedAt;
  const RoutineItemRow({
    required this.id,
    required this.routineId,
    required this.minuteOfDay,
    required this.title,
    required this.kind,
    required this.reminder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['minute_of_day'] = Variable<int>(minuteOfDay);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    map['reminder'] = Variable<bool>(reminder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RoutineItemsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      minuteOfDay: Value(minuteOfDay),
      title: Value(title),
      kind: Value(kind),
      reminder: Value(reminder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItemRow(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      minuteOfDay: serializer.fromJson<int>(json['minuteOfDay']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      reminder: serializer.fromJson<bool>(json['reminder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'minuteOfDay': serializer.toJson<int>(minuteOfDay),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'reminder': serializer.toJson<bool>(reminder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RoutineItemRow copyWith({
    String? id,
    String? routineId,
    int? minuteOfDay,
    String? title,
    String? kind,
    bool? reminder,
    int? createdAt,
    int? updatedAt,
  }) => RoutineItemRow(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    minuteOfDay: minuteOfDay ?? this.minuteOfDay,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    reminder: reminder ?? this.reminder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineItemRow copyWithCompanion(RoutineItemsCompanion data) {
    return RoutineItemRow(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      minuteOfDay: data.minuteOfDay.present
          ? data.minuteOfDay.value
          : this.minuteOfDay,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      reminder: data.reminder.present ? data.reminder.value : this.reminder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemRow(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('reminder: $reminder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    minuteOfDay,
    title,
    kind,
    reminder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItemRow &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.minuteOfDay == this.minuteOfDay &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.reminder == this.reminder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineItemsCompanion extends UpdateCompanion<RoutineItemRow> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<int> minuteOfDay;
  final Value<String> title;
  final Value<String> kind;
  final Value<bool> reminder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RoutineItemsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.reminder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineItemsCompanion.insert({
    required String id,
    required String routineId,
    required int minuteOfDay,
    required String title,
    required String kind,
    this.reminder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineId = Value(routineId),
       minuteOfDay = Value(minuteOfDay),
       title = Value(title),
       kind = Value(kind),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineItemRow> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<int>? minuteOfDay,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<bool>? reminder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (reminder != null) 'reminder': reminder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? routineId,
    Value<int>? minuteOfDay,
    Value<String>? title,
    Value<String>? kind,
    Value<bool>? reminder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineItemsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      reminder: reminder ?? this.reminder,
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
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (reminder.present) {
      map['reminder'] = Variable<bool>(reminder.value);
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
    return (StringBuffer('RoutineItemsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('reminder: $reminder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanRecordsTable extends PlanRecords
    with TableInfo<$PlanRecordsTable, PlanRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_item (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rescheduledMinuteMeta = const VerificationMeta(
    'rescheduledMinute',
  );
  @override
  late final GeneratedColumn<int> rescheduledMinute = GeneratedColumn<int>(
    'rescheduled_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    day,
    outcome,
    rescheduledMinute,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_completion';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('rescheduled_minute')) {
      context.handle(
        _rescheduledMinuteMeta,
        rescheduledMinute.isAcceptableOrUnknown(
          data['rescheduled_minute']!,
          _rescheduledMinuteMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, day};
  @override
  PlanRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanRecordRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      rescheduledMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rescheduled_minute'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $PlanRecordsTable createAlias(String alias) {
    return $PlanRecordsTable(attachedDatabase, alias);
  }
}

class PlanRecordRow extends DataClass implements Insertable<PlanRecordRow> {
  final String itemId;
  final int day;
  final String outcome;
  final int? rescheduledMinute;
  final int recordedAt;
  const PlanRecordRow({
    required this.itemId,
    required this.day,
    required this.outcome,
    this.rescheduledMinute,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['day'] = Variable<int>(day);
    map['outcome'] = Variable<String>(outcome);
    if (!nullToAbsent || rescheduledMinute != null) {
      map['rescheduled_minute'] = Variable<int>(rescheduledMinute);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    return map;
  }

  PlanRecordsCompanion toCompanion(bool nullToAbsent) {
    return PlanRecordsCompanion(
      itemId: Value(itemId),
      day: Value(day),
      outcome: Value(outcome),
      rescheduledMinute: rescheduledMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(rescheduledMinute),
      recordedAt: Value(recordedAt),
    );
  }

  factory PlanRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanRecordRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      day: serializer.fromJson<int>(json['day']),
      outcome: serializer.fromJson<String>(json['outcome']),
      rescheduledMinute: serializer.fromJson<int?>(json['rescheduledMinute']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'day': serializer.toJson<int>(day),
      'outcome': serializer.toJson<String>(outcome),
      'rescheduledMinute': serializer.toJson<int?>(rescheduledMinute),
      'recordedAt': serializer.toJson<int>(recordedAt),
    };
  }

  PlanRecordRow copyWith({
    String? itemId,
    int? day,
    String? outcome,
    Value<int?> rescheduledMinute = const Value.absent(),
    int? recordedAt,
  }) => PlanRecordRow(
    itemId: itemId ?? this.itemId,
    day: day ?? this.day,
    outcome: outcome ?? this.outcome,
    rescheduledMinute: rescheduledMinute.present
        ? rescheduledMinute.value
        : this.rescheduledMinute,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  PlanRecordRow copyWithCompanion(PlanRecordsCompanion data) {
    return PlanRecordRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      day: data.day.present ? data.day.value : this.day,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      rescheduledMinute: data.rescheduledMinute.present
          ? data.rescheduledMinute.value
          : this.rescheduledMinute,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanRecordRow(')
          ..write('itemId: $itemId, ')
          ..write('day: $day, ')
          ..write('outcome: $outcome, ')
          ..write('rescheduledMinute: $rescheduledMinute, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(itemId, day, outcome, rescheduledMinute, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanRecordRow &&
          other.itemId == this.itemId &&
          other.day == this.day &&
          other.outcome == this.outcome &&
          other.rescheduledMinute == this.rescheduledMinute &&
          other.recordedAt == this.recordedAt);
}

class PlanRecordsCompanion extends UpdateCompanion<PlanRecordRow> {
  final Value<String> itemId;
  final Value<int> day;
  final Value<String> outcome;
  final Value<int?> rescheduledMinute;
  final Value<int> recordedAt;
  final Value<int> rowid;
  const PlanRecordsCompanion({
    this.itemId = const Value.absent(),
    this.day = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rescheduledMinute = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanRecordsCompanion.insert({
    required String itemId,
    required int day,
    required String outcome,
    this.rescheduledMinute = const Value.absent(),
    required int recordedAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       day = Value(day),
       outcome = Value(outcome),
       recordedAt = Value(recordedAt);
  static Insertable<PlanRecordRow> custom({
    Expression<String>? itemId,
    Expression<int>? day,
    Expression<String>? outcome,
    Expression<int>? rescheduledMinute,
    Expression<int>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (day != null) 'day': day,
      if (outcome != null) 'outcome': outcome,
      if (rescheduledMinute != null) 'rescheduled_minute': rescheduledMinute,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanRecordsCompanion copyWith({
    Value<String>? itemId,
    Value<int>? day,
    Value<String>? outcome,
    Value<int?>? rescheduledMinute,
    Value<int>? recordedAt,
    Value<int>? rowid,
  }) {
    return PlanRecordsCompanion(
      itemId: itemId ?? this.itemId,
      day: day ?? this.day,
      outcome: outcome ?? this.outcome,
      rescheduledMinute: rescheduledMinute ?? this.rescheduledMinute,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (rescheduledMinute.present) {
      map['rescheduled_minute'] = Variable<int>(rescheduledMinute.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanRecordsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('day: $day, ')
          ..write('outcome: $outcome, ')
          ..write('rescheduledMinute: $rescheduledMinute, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostureSessionsTable extends PostureSessions
    with TableInfo<$PostureSessionsTable, PostureSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostureSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _viewMeta = const VerificationMeta('view');
  @override
  late final GeneratedColumn<String> view = GeneratedColumn<String>(
    'view',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _framesUsedMeta = const VerificationMeta(
    'framesUsed',
  );
  @override
  late final GeneratedColumn<int> framesUsed = GeneratedColumn<int>(
    'frames_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visibilityMeta = const VerificationMeta(
    'visibility',
  );
  @override
  late final GeneratedColumn<double> visibility = GeneratedColumn<double>(
    'visibility',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordedAt,
    view,
    framesUsed,
    confidence,
    visibility,
    source,
    method,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posture_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostureSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('view')) {
      context.handle(
        _viewMeta,
        view.isAcceptableOrUnknown(data['view']!, _viewMeta),
      );
    } else if (isInserting) {
      context.missing(_viewMeta);
    }
    if (data.containsKey('frames_used')) {
      context.handle(
        _framesUsedMeta,
        framesUsed.isAcceptableOrUnknown(data['frames_used']!, _framesUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_framesUsedMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('visibility')) {
      context.handle(
        _visibilityMeta,
        visibility.isAcceptableOrUnknown(data['visibility']!, _visibilityMeta),
      );
    } else if (isInserting) {
      context.missing(_visibilityMeta);
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
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostureSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostureSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      view: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}view'],
      )!,
      framesUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frames_used'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      visibility: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}visibility'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PostureSessionsTable createAlias(String alias) {
    return $PostureSessionsTable(attachedDatabase, alias);
  }
}

class PostureSessionRow extends DataClass
    implements Insertable<PostureSessionRow> {
  final String id;
  final int recordedAt;
  final String view;
  final int framesUsed;
  final String confidence;
  final double visibility;
  final String source;
  final String method;
  final int createdAt;
  const PostureSessionRow({
    required this.id,
    required this.recordedAt,
    required this.view,
    required this.framesUsed,
    required this.confidence,
    required this.visibility,
    required this.source,
    required this.method,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recorded_at'] = Variable<int>(recordedAt);
    map['view'] = Variable<String>(view);
    map['frames_used'] = Variable<int>(framesUsed);
    map['confidence'] = Variable<String>(confidence);
    map['visibility'] = Variable<double>(visibility);
    map['source'] = Variable<String>(source);
    map['method'] = Variable<String>(method);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  PostureSessionsCompanion toCompanion(bool nullToAbsent) {
    return PostureSessionsCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      view: Value(view),
      framesUsed: Value(framesUsed),
      confidence: Value(confidence),
      visibility: Value(visibility),
      source: Value(source),
      method: Value(method),
      createdAt: Value(createdAt),
    );
  }

  factory PostureSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostureSessionRow(
      id: serializer.fromJson<String>(json['id']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      view: serializer.fromJson<String>(json['view']),
      framesUsed: serializer.fromJson<int>(json['framesUsed']),
      confidence: serializer.fromJson<String>(json['confidence']),
      visibility: serializer.fromJson<double>(json['visibility']),
      source: serializer.fromJson<String>(json['source']),
      method: serializer.fromJson<String>(json['method']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'view': serializer.toJson<String>(view),
      'framesUsed': serializer.toJson<int>(framesUsed),
      'confidence': serializer.toJson<String>(confidence),
      'visibility': serializer.toJson<double>(visibility),
      'source': serializer.toJson<String>(source),
      'method': serializer.toJson<String>(method),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  PostureSessionRow copyWith({
    String? id,
    int? recordedAt,
    String? view,
    int? framesUsed,
    String? confidence,
    double? visibility,
    String? source,
    String? method,
    int? createdAt,
  }) => PostureSessionRow(
    id: id ?? this.id,
    recordedAt: recordedAt ?? this.recordedAt,
    view: view ?? this.view,
    framesUsed: framesUsed ?? this.framesUsed,
    confidence: confidence ?? this.confidence,
    visibility: visibility ?? this.visibility,
    source: source ?? this.source,
    method: method ?? this.method,
    createdAt: createdAt ?? this.createdAt,
  );
  PostureSessionRow copyWithCompanion(PostureSessionsCompanion data) {
    return PostureSessionRow(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      view: data.view.present ? data.view.value : this.view,
      framesUsed: data.framesUsed.present
          ? data.framesUsed.value
          : this.framesUsed,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      visibility: data.visibility.present
          ? data.visibility.value
          : this.visibility,
      source: data.source.present ? data.source.value : this.source,
      method: data.method.present ? data.method.value : this.method,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostureSessionRow(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('view: $view, ')
          ..write('framesUsed: $framesUsed, ')
          ..write('confidence: $confidence, ')
          ..write('visibility: $visibility, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordedAt,
    view,
    framesUsed,
    confidence,
    visibility,
    source,
    method,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostureSessionRow &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.view == this.view &&
          other.framesUsed == this.framesUsed &&
          other.confidence == this.confidence &&
          other.visibility == this.visibility &&
          other.source == this.source &&
          other.method == this.method &&
          other.createdAt == this.createdAt);
}

class PostureSessionsCompanion extends UpdateCompanion<PostureSessionRow> {
  final Value<String> id;
  final Value<int> recordedAt;
  final Value<String> view;
  final Value<int> framesUsed;
  final Value<String> confidence;
  final Value<double> visibility;
  final Value<String> source;
  final Value<String> method;
  final Value<int> createdAt;
  final Value<int> rowid;
  const PostureSessionsCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.view = const Value.absent(),
    this.framesUsed = const Value.absent(),
    this.confidence = const Value.absent(),
    this.visibility = const Value.absent(),
    this.source = const Value.absent(),
    this.method = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostureSessionsCompanion.insert({
    required String id,
    required int recordedAt,
    required String view,
    required int framesUsed,
    required String confidence,
    required double visibility,
    required String source,
    required String method,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordedAt = Value(recordedAt),
       view = Value(view),
       framesUsed = Value(framesUsed),
       confidence = Value(confidence),
       visibility = Value(visibility),
       source = Value(source),
       method = Value(method),
       createdAt = Value(createdAt);
  static Insertable<PostureSessionRow> custom({
    Expression<String>? id,
    Expression<int>? recordedAt,
    Expression<String>? view,
    Expression<int>? framesUsed,
    Expression<String>? confidence,
    Expression<double>? visibility,
    Expression<String>? source,
    Expression<String>? method,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (view != null) 'view': view,
      if (framesUsed != null) 'frames_used': framesUsed,
      if (confidence != null) 'confidence': confidence,
      if (visibility != null) 'visibility': visibility,
      if (source != null) 'source': source,
      if (method != null) 'method': method,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostureSessionsCompanion copyWith({
    Value<String>? id,
    Value<int>? recordedAt,
    Value<String>? view,
    Value<int>? framesUsed,
    Value<String>? confidence,
    Value<double>? visibility,
    Value<String>? source,
    Value<String>? method,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return PostureSessionsCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      view: view ?? this.view,
      framesUsed: framesUsed ?? this.framesUsed,
      confidence: confidence ?? this.confidence,
      visibility: visibility ?? this.visibility,
      source: source ?? this.source,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (view.present) {
      map['view'] = Variable<String>(view.value);
    }
    if (framesUsed.present) {
      map['frames_used'] = Variable<int>(framesUsed.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<double>(visibility.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostureSessionsCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('view: $view, ')
          ..write('framesUsed: $framesUsed, ')
          ..write('confidence: $confidence, ')
          ..write('visibility: $visibility, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostureMetricsTable extends PostureMetrics
    with TableInfo<$PostureMetricsTable, PostureMetricRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostureMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posture_session (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
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
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bandMeta = const VerificationMeta('band');
  @override
  late final GeneratedColumn<String> band = GeneratedColumn<String>(
    'band',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spreadMeta = const VerificationMeta('spread');
  @override
  late final GeneratedColumn<double> spread = GeneratedColumn<double>(
    'spread',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    metric,
    value,
    unit,
    direction,
    band,
    spread,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posture_metric';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostureMetricRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
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
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('band')) {
      context.handle(
        _bandMeta,
        band.isAcceptableOrUnknown(data['band']!, _bandMeta),
      );
    } else if (isInserting) {
      context.missing(_bandMeta);
    }
    if (data.containsKey('spread')) {
      context.handle(
        _spreadMeta,
        spread.isAcceptableOrUnknown(data['spread']!, _spreadMeta),
      );
    } else if (isInserting) {
      context.missing(_spreadMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, metric};
  @override
  PostureMetricRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostureMetricRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      band: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}band'],
      )!,
      spread: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spread'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
    );
  }

  @override
  $PostureMetricsTable createAlias(String alias) {
    return $PostureMetricsTable(attachedDatabase, alias);
  }
}

class PostureMetricRow extends DataClass
    implements Insertable<PostureMetricRow> {
  final String sessionId;
  final String metric;
  final double value;
  final String unit;
  final String direction;
  final String band;
  final double spread;
  final String confidence;
  const PostureMetricRow({
    required this.sessionId,
    required this.metric,
    required this.value,
    required this.unit,
    required this.direction,
    required this.band,
    required this.spread,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['direction'] = Variable<String>(direction);
    map['band'] = Variable<String>(band);
    map['spread'] = Variable<double>(spread);
    map['confidence'] = Variable<String>(confidence);
    return map;
  }

  PostureMetricsCompanion toCompanion(bool nullToAbsent) {
    return PostureMetricsCompanion(
      sessionId: Value(sessionId),
      metric: Value(metric),
      value: Value(value),
      unit: Value(unit),
      direction: Value(direction),
      band: Value(band),
      spread: Value(spread),
      confidence: Value(confidence),
    );
  }

  factory PostureMetricRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostureMetricRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      direction: serializer.fromJson<String>(json['direction']),
      band: serializer.fromJson<String>(json['band']),
      spread: serializer.fromJson<double>(json['spread']),
      confidence: serializer.fromJson<String>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'direction': serializer.toJson<String>(direction),
      'band': serializer.toJson<String>(band),
      'spread': serializer.toJson<double>(spread),
      'confidence': serializer.toJson<String>(confidence),
    };
  }

  PostureMetricRow copyWith({
    String? sessionId,
    String? metric,
    double? value,
    String? unit,
    String? direction,
    String? band,
    double? spread,
    String? confidence,
  }) => PostureMetricRow(
    sessionId: sessionId ?? this.sessionId,
    metric: metric ?? this.metric,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    direction: direction ?? this.direction,
    band: band ?? this.band,
    spread: spread ?? this.spread,
    confidence: confidence ?? this.confidence,
  );
  PostureMetricRow copyWithCompanion(PostureMetricsCompanion data) {
    return PostureMetricRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      direction: data.direction.present ? data.direction.value : this.direction,
      band: data.band.present ? data.band.value : this.band,
      spread: data.spread.present ? data.spread.value : this.spread,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostureMetricRow(')
          ..write('sessionId: $sessionId, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('direction: $direction, ')
          ..write('band: $band, ')
          ..write('spread: $spread, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    metric,
    value,
    unit,
    direction,
    band,
    spread,
    confidence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostureMetricRow &&
          other.sessionId == this.sessionId &&
          other.metric == this.metric &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.direction == this.direction &&
          other.band == this.band &&
          other.spread == this.spread &&
          other.confidence == this.confidence);
}

class PostureMetricsCompanion extends UpdateCompanion<PostureMetricRow> {
  final Value<String> sessionId;
  final Value<String> metric;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> direction;
  final Value<String> band;
  final Value<double> spread;
  final Value<String> confidence;
  final Value<int> rowid;
  const PostureMetricsCompanion({
    this.sessionId = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.direction = const Value.absent(),
    this.band = const Value.absent(),
    this.spread = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostureMetricsCompanion.insert({
    required String sessionId,
    required String metric,
    required double value,
    required String unit,
    required String direction,
    required String band,
    required double spread,
    required String confidence,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       metric = Value(metric),
       value = Value(value),
       unit = Value(unit),
       direction = Value(direction),
       band = Value(band),
       spread = Value(spread),
       confidence = Value(confidence);
  static Insertable<PostureMetricRow> custom({
    Expression<String>? sessionId,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? direction,
    Expression<String>? band,
    Expression<double>? spread,
    Expression<String>? confidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (direction != null) 'direction': direction,
      if (band != null) 'band': band,
      if (spread != null) 'spread': spread,
      if (confidence != null) 'confidence': confidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostureMetricsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? metric,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? direction,
    Value<String>? band,
    Value<double>? spread,
    Value<String>? confidence,
    Value<int>? rowid,
  }) {
    return PostureMetricsCompanion(
      sessionId: sessionId ?? this.sessionId,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      direction: direction ?? this.direction,
      band: band ?? this.band,
      spread: spread ?? this.spread,
      confidence: confidence ?? this.confidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (band.present) {
      map['band'] = Variable<String>(band.value);
    }
    if (spread.present) {
      map['spread'] = Variable<double>(spread.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostureMetricsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('direction: $direction, ')
          ..write('band: $band, ')
          ..write('spread: $spread, ')
          ..write('confidence: $confidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FaceAnalysesTable extends FaceAnalyses
    with TableInfo<$FaceAnalysesTable, FaceAnalysisRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaceAnalysesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
    'shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alsoLikeMeta = const VerificationMeta(
    'alsoLike',
  );
  @override
  late final GeneratedColumn<String> alsoLike = GeneratedColumn<String>(
    'also_like',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _framesUsedMeta = const VerificationMeta(
    'framesUsed',
  );
  @override
  late final GeneratedColumn<int> framesUsed = GeneratedColumn<int>(
    'frames_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordedAt,
    shape,
    alsoLike,
    confidence,
    framesUsed,
    source,
    method,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'face_analysis';
  @override
  VerificationContext validateIntegrity(
    Insertable<FaceAnalysisRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('shape')) {
      context.handle(
        _shapeMeta,
        shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta),
      );
    } else if (isInserting) {
      context.missing(_shapeMeta);
    }
    if (data.containsKey('also_like')) {
      context.handle(
        _alsoLikeMeta,
        alsoLike.isAcceptableOrUnknown(data['also_like']!, _alsoLikeMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('frames_used')) {
      context.handle(
        _framesUsedMeta,
        framesUsed.isAcceptableOrUnknown(data['frames_used']!, _framesUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_framesUsedMeta);
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
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FaceAnalysisRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaceAnalysisRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      shape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape'],
      )!,
      alsoLike: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}also_like'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      framesUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frames_used'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FaceAnalysesTable createAlias(String alias) {
    return $FaceAnalysesTable(attachedDatabase, alias);
  }
}

class FaceAnalysisRow extends DataClass implements Insertable<FaceAnalysisRow> {
  final String id;
  final int recordedAt;
  final String shape;
  final String? alsoLike;
  final String confidence;
  final int framesUsed;
  final String source;
  final String method;
  final int createdAt;
  const FaceAnalysisRow({
    required this.id,
    required this.recordedAt,
    required this.shape,
    this.alsoLike,
    required this.confidence,
    required this.framesUsed,
    required this.source,
    required this.method,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recorded_at'] = Variable<int>(recordedAt);
    map['shape'] = Variable<String>(shape);
    if (!nullToAbsent || alsoLike != null) {
      map['also_like'] = Variable<String>(alsoLike);
    }
    map['confidence'] = Variable<String>(confidence);
    map['frames_used'] = Variable<int>(framesUsed);
    map['source'] = Variable<String>(source);
    map['method'] = Variable<String>(method);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  FaceAnalysesCompanion toCompanion(bool nullToAbsent) {
    return FaceAnalysesCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      shape: Value(shape),
      alsoLike: alsoLike == null && nullToAbsent
          ? const Value.absent()
          : Value(alsoLike),
      confidence: Value(confidence),
      framesUsed: Value(framesUsed),
      source: Value(source),
      method: Value(method),
      createdAt: Value(createdAt),
    );
  }

  factory FaceAnalysisRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaceAnalysisRow(
      id: serializer.fromJson<String>(json['id']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      shape: serializer.fromJson<String>(json['shape']),
      alsoLike: serializer.fromJson<String?>(json['alsoLike']),
      confidence: serializer.fromJson<String>(json['confidence']),
      framesUsed: serializer.fromJson<int>(json['framesUsed']),
      source: serializer.fromJson<String>(json['source']),
      method: serializer.fromJson<String>(json['method']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'shape': serializer.toJson<String>(shape),
      'alsoLike': serializer.toJson<String?>(alsoLike),
      'confidence': serializer.toJson<String>(confidence),
      'framesUsed': serializer.toJson<int>(framesUsed),
      'source': serializer.toJson<String>(source),
      'method': serializer.toJson<String>(method),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  FaceAnalysisRow copyWith({
    String? id,
    int? recordedAt,
    String? shape,
    Value<String?> alsoLike = const Value.absent(),
    String? confidence,
    int? framesUsed,
    String? source,
    String? method,
    int? createdAt,
  }) => FaceAnalysisRow(
    id: id ?? this.id,
    recordedAt: recordedAt ?? this.recordedAt,
    shape: shape ?? this.shape,
    alsoLike: alsoLike.present ? alsoLike.value : this.alsoLike,
    confidence: confidence ?? this.confidence,
    framesUsed: framesUsed ?? this.framesUsed,
    source: source ?? this.source,
    method: method ?? this.method,
    createdAt: createdAt ?? this.createdAt,
  );
  FaceAnalysisRow copyWithCompanion(FaceAnalysesCompanion data) {
    return FaceAnalysisRow(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      shape: data.shape.present ? data.shape.value : this.shape,
      alsoLike: data.alsoLike.present ? data.alsoLike.value : this.alsoLike,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      framesUsed: data.framesUsed.present
          ? data.framesUsed.value
          : this.framesUsed,
      source: data.source.present ? data.source.value : this.source,
      method: data.method.present ? data.method.value : this.method,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FaceAnalysisRow(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('shape: $shape, ')
          ..write('alsoLike: $alsoLike, ')
          ..write('confidence: $confidence, ')
          ..write('framesUsed: $framesUsed, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordedAt,
    shape,
    alsoLike,
    confidence,
    framesUsed,
    source,
    method,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceAnalysisRow &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.shape == this.shape &&
          other.alsoLike == this.alsoLike &&
          other.confidence == this.confidence &&
          other.framesUsed == this.framesUsed &&
          other.source == this.source &&
          other.method == this.method &&
          other.createdAt == this.createdAt);
}

class FaceAnalysesCompanion extends UpdateCompanion<FaceAnalysisRow> {
  final Value<String> id;
  final Value<int> recordedAt;
  final Value<String> shape;
  final Value<String?> alsoLike;
  final Value<String> confidence;
  final Value<int> framesUsed;
  final Value<String> source;
  final Value<String> method;
  final Value<int> createdAt;
  final Value<int> rowid;
  const FaceAnalysesCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.shape = const Value.absent(),
    this.alsoLike = const Value.absent(),
    this.confidence = const Value.absent(),
    this.framesUsed = const Value.absent(),
    this.source = const Value.absent(),
    this.method = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FaceAnalysesCompanion.insert({
    required String id,
    required int recordedAt,
    required String shape,
    this.alsoLike = const Value.absent(),
    required String confidence,
    required int framesUsed,
    required String source,
    required String method,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordedAt = Value(recordedAt),
       shape = Value(shape),
       confidence = Value(confidence),
       framesUsed = Value(framesUsed),
       source = Value(source),
       method = Value(method),
       createdAt = Value(createdAt);
  static Insertable<FaceAnalysisRow> custom({
    Expression<String>? id,
    Expression<int>? recordedAt,
    Expression<String>? shape,
    Expression<String>? alsoLike,
    Expression<String>? confidence,
    Expression<int>? framesUsed,
    Expression<String>? source,
    Expression<String>? method,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (shape != null) 'shape': shape,
      if (alsoLike != null) 'also_like': alsoLike,
      if (confidence != null) 'confidence': confidence,
      if (framesUsed != null) 'frames_used': framesUsed,
      if (source != null) 'source': source,
      if (method != null) 'method': method,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FaceAnalysesCompanion copyWith({
    Value<String>? id,
    Value<int>? recordedAt,
    Value<String>? shape,
    Value<String?>? alsoLike,
    Value<String>? confidence,
    Value<int>? framesUsed,
    Value<String>? source,
    Value<String>? method,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return FaceAnalysesCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      shape: shape ?? this.shape,
      alsoLike: alsoLike ?? this.alsoLike,
      confidence: confidence ?? this.confidence,
      framesUsed: framesUsed ?? this.framesUsed,
      source: source ?? this.source,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (shape.present) {
      map['shape'] = Variable<String>(shape.value);
    }
    if (alsoLike.present) {
      map['also_like'] = Variable<String>(alsoLike.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (framesUsed.present) {
      map['frames_used'] = Variable<int>(framesUsed.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaceAnalysesCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('shape: $shape, ')
          ..write('alsoLike: $alsoLike, ')
          ..write('confidence: $confidence, ')
          ..write('framesUsed: $framesUsed, ')
          ..write('source: $source, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FaceMetricsTable extends FaceMetrics
    with TableInfo<$FaceMetricsTable, FaceMetricRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaceMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES face_analysis (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
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
  @override
  List<GeneratedColumn> get $columns => [analysisId, metric, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'face_metric';
  @override
  VerificationContext validateIntegrity(
    Insertable<FaceMetricRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {analysisId, metric};
  @override
  FaceMetricRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaceMetricRow(
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $FaceMetricsTable createAlias(String alias) {
    return $FaceMetricsTable(attachedDatabase, alias);
  }
}

class FaceMetricRow extends DataClass implements Insertable<FaceMetricRow> {
  final String analysisId;
  final String metric;
  final double value;
  const FaceMetricRow({
    required this.analysisId,
    required this.metric,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['analysis_id'] = Variable<String>(analysisId);
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    return map;
  }

  FaceMetricsCompanion toCompanion(bool nullToAbsent) {
    return FaceMetricsCompanion(
      analysisId: Value(analysisId),
      metric: Value(metric),
      value: Value(value),
    );
  }

  factory FaceMetricRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaceMetricRow(
      analysisId: serializer.fromJson<String>(json['analysisId']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'analysisId': serializer.toJson<String>(analysisId),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
    };
  }

  FaceMetricRow copyWith({String? analysisId, String? metric, double? value}) =>
      FaceMetricRow(
        analysisId: analysisId ?? this.analysisId,
        metric: metric ?? this.metric,
        value: value ?? this.value,
      );
  FaceMetricRow copyWithCompanion(FaceMetricsCompanion data) {
    return FaceMetricRow(
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FaceMetricRow(')
          ..write('analysisId: $analysisId, ')
          ..write('metric: $metric, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(analysisId, metric, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceMetricRow &&
          other.analysisId == this.analysisId &&
          other.metric == this.metric &&
          other.value == this.value);
}

class FaceMetricsCompanion extends UpdateCompanion<FaceMetricRow> {
  final Value<String> analysisId;
  final Value<String> metric;
  final Value<double> value;
  final Value<int> rowid;
  const FaceMetricsCompanion({
    this.analysisId = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FaceMetricsCompanion.insert({
    required String analysisId,
    required String metric,
    required double value,
    this.rowid = const Value.absent(),
  }) : analysisId = Value(analysisId),
       metric = Value(metric),
       value = Value(value);
  static Insertable<FaceMetricRow> custom({
    Expression<String>? analysisId,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (analysisId != null) 'analysis_id': analysisId,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FaceMetricsCompanion copyWith({
    Value<String>? analysisId,
    Value<String>? metric,
    Value<double>? value,
    Value<int>? rowid,
  }) {
    return FaceMetricsCompanion(
      analysisId: analysisId ?? this.analysisId,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaceMetricsCompanion(')
          ..write('analysisId: $analysisId, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StyleFavoritesTable extends StyleFavorites
    with TableInfo<$StyleFavoritesTable, StyleFavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StyleFavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [itemId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hairstyle_favorite';
  @override
  VerificationContext validateIntegrity(
    Insertable<StyleFavoriteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  StyleFavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StyleFavoriteRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StyleFavoritesTable createAlias(String alias) {
    return $StyleFavoritesTable(attachedDatabase, alias);
  }
}

class StyleFavoriteRow extends DataClass
    implements Insertable<StyleFavoriteRow> {
  final String itemId;
  final int createdAt;
  const StyleFavoriteRow({required this.itemId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  StyleFavoritesCompanion toCompanion(bool nullToAbsent) {
    return StyleFavoritesCompanion(
      itemId: Value(itemId),
      createdAt: Value(createdAt),
    );
  }

  factory StyleFavoriteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StyleFavoriteRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  StyleFavoriteRow copyWith({String? itemId, int? createdAt}) =>
      StyleFavoriteRow(
        itemId: itemId ?? this.itemId,
        createdAt: createdAt ?? this.createdAt,
      );
  StyleFavoriteRow copyWithCompanion(StyleFavoritesCompanion data) {
    return StyleFavoriteRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StyleFavoriteRow(')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StyleFavoriteRow &&
          other.itemId == this.itemId &&
          other.createdAt == this.createdAt);
}

class StyleFavoritesCompanion extends UpdateCompanion<StyleFavoriteRow> {
  final Value<String> itemId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StyleFavoritesCompanion({
    this.itemId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StyleFavoritesCompanion.insert({
    required String itemId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       createdAt = Value(createdAt);
  static Insertable<StyleFavoriteRow> custom({
    Expression<String>? itemId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StyleFavoritesCompanion copyWith({
    Value<String>? itemId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StyleFavoritesCompanion(
      itemId: itemId ?? this.itemId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StyleFavoritesCompanion(')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, SnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<int> takenAt = GeneratedColumn<int>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jpegMeta = const VerificationMeta('jpeg');
  @override
  late final GeneratedColumn<Uint8List> jpeg = GeneratedColumn<Uint8List>(
    'jpeg',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
  static const VerificationMeta _leftEyeXMeta = const VerificationMeta(
    'leftEyeX',
  );
  @override
  late final GeneratedColumn<double> leftEyeX = GeneratedColumn<double>(
    'left_eye_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftEyeYMeta = const VerificationMeta(
    'leftEyeY',
  );
  @override
  late final GeneratedColumn<double> leftEyeY = GeneratedColumn<double>(
    'left_eye_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightEyeXMeta = const VerificationMeta(
    'rightEyeX',
  );
  @override
  late final GeneratedColumn<double> rightEyeX = GeneratedColumn<double>(
    'right_eye_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightEyeYMeta = const VerificationMeta(
    'rightEyeY',
  );
  @override
  late final GeneratedColumn<double> rightEyeY = GeneratedColumn<double>(
    'right_eye_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alignCheckedMeta = const VerificationMeta(
    'alignChecked',
  );
  @override
  late final GeneratedColumn<bool> alignChecked = GeneratedColumn<bool>(
    'align_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("align_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    takenAt,
    jpeg,
    width,
    height,
    note,
    createdAt,
    leftEyeX,
    leftEyeY,
    rightEyeX,
    rightEyeY,
    alignChecked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_snapshot';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('jpeg')) {
      context.handle(
        _jpegMeta,
        jpeg.isAcceptableOrUnknown(data['jpeg']!, _jpegMeta),
      );
    } else if (isInserting) {
      context.missing(_jpegMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
    if (data.containsKey('left_eye_x')) {
      context.handle(
        _leftEyeXMeta,
        leftEyeX.isAcceptableOrUnknown(data['left_eye_x']!, _leftEyeXMeta),
      );
    }
    if (data.containsKey('left_eye_y')) {
      context.handle(
        _leftEyeYMeta,
        leftEyeY.isAcceptableOrUnknown(data['left_eye_y']!, _leftEyeYMeta),
      );
    }
    if (data.containsKey('right_eye_x')) {
      context.handle(
        _rightEyeXMeta,
        rightEyeX.isAcceptableOrUnknown(data['right_eye_x']!, _rightEyeXMeta),
      );
    }
    if (data.containsKey('right_eye_y')) {
      context.handle(
        _rightEyeYMeta,
        rightEyeY.isAcceptableOrUnknown(data['right_eye_y']!, _rightEyeYMeta),
      );
    }
    if (data.containsKey('align_checked')) {
      context.handle(
        _alignCheckedMeta,
        alignChecked.isAcceptableOrUnknown(
          data['align_checked']!,
          _alignCheckedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnapshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken_at'],
      )!,
      jpeg: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}jpeg'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      leftEyeX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_eye_x'],
      ),
      leftEyeY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_eye_y'],
      ),
      rightEyeX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_eye_x'],
      ),
      rightEyeY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_eye_y'],
      ),
      alignChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}align_checked'],
      )!,
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }
}

class SnapshotRow extends DataClass implements Insertable<SnapshotRow> {
  final String id;

  /// face, bodyFront or bodySide.
  final String kind;
  final int takenAt;
  final Uint8List jpeg;
  final int width;
  final int height;
  final String? note;
  final int createdAt;

  /// Eye centres as fractions of width/height, for aligning the face
  /// time-lapse (v9). Null when not detected; [alignChecked] records that
  /// detection already ran so it is never repeated.
  final double? leftEyeX;
  final double? leftEyeY;
  final double? rightEyeX;
  final double? rightEyeY;
  final bool alignChecked;
  const SnapshotRow({
    required this.id,
    required this.kind,
    required this.takenAt,
    required this.jpeg,
    required this.width,
    required this.height,
    this.note,
    required this.createdAt,
    this.leftEyeX,
    this.leftEyeY,
    this.rightEyeX,
    this.rightEyeY,
    required this.alignChecked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['taken_at'] = Variable<int>(takenAt);
    map['jpeg'] = Variable<Uint8List>(jpeg);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || leftEyeX != null) {
      map['left_eye_x'] = Variable<double>(leftEyeX);
    }
    if (!nullToAbsent || leftEyeY != null) {
      map['left_eye_y'] = Variable<double>(leftEyeY);
    }
    if (!nullToAbsent || rightEyeX != null) {
      map['right_eye_x'] = Variable<double>(rightEyeX);
    }
    if (!nullToAbsent || rightEyeY != null) {
      map['right_eye_y'] = Variable<double>(rightEyeY);
    }
    map['align_checked'] = Variable<bool>(alignChecked);
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      kind: Value(kind),
      takenAt: Value(takenAt),
      jpeg: Value(jpeg),
      width: Value(width),
      height: Value(height),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      leftEyeX: leftEyeX == null && nullToAbsent
          ? const Value.absent()
          : Value(leftEyeX),
      leftEyeY: leftEyeY == null && nullToAbsent
          ? const Value.absent()
          : Value(leftEyeY),
      rightEyeX: rightEyeX == null && nullToAbsent
          ? const Value.absent()
          : Value(rightEyeX),
      rightEyeY: rightEyeY == null && nullToAbsent
          ? const Value.absent()
          : Value(rightEyeY),
      alignChecked: Value(alignChecked),
    );
  }

  factory SnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnapshotRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      takenAt: serializer.fromJson<int>(json['takenAt']),
      jpeg: serializer.fromJson<Uint8List>(json['jpeg']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      leftEyeX: serializer.fromJson<double?>(json['leftEyeX']),
      leftEyeY: serializer.fromJson<double?>(json['leftEyeY']),
      rightEyeX: serializer.fromJson<double?>(json['rightEyeX']),
      rightEyeY: serializer.fromJson<double?>(json['rightEyeY']),
      alignChecked: serializer.fromJson<bool>(json['alignChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'takenAt': serializer.toJson<int>(takenAt),
      'jpeg': serializer.toJson<Uint8List>(jpeg),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'leftEyeX': serializer.toJson<double?>(leftEyeX),
      'leftEyeY': serializer.toJson<double?>(leftEyeY),
      'rightEyeX': serializer.toJson<double?>(rightEyeX),
      'rightEyeY': serializer.toJson<double?>(rightEyeY),
      'alignChecked': serializer.toJson<bool>(alignChecked),
    };
  }

  SnapshotRow copyWith({
    String? id,
    String? kind,
    int? takenAt,
    Uint8List? jpeg,
    int? width,
    int? height,
    Value<String?> note = const Value.absent(),
    int? createdAt,
    Value<double?> leftEyeX = const Value.absent(),
    Value<double?> leftEyeY = const Value.absent(),
    Value<double?> rightEyeX = const Value.absent(),
    Value<double?> rightEyeY = const Value.absent(),
    bool? alignChecked,
  }) => SnapshotRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    takenAt: takenAt ?? this.takenAt,
    jpeg: jpeg ?? this.jpeg,
    width: width ?? this.width,
    height: height ?? this.height,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    leftEyeX: leftEyeX.present ? leftEyeX.value : this.leftEyeX,
    leftEyeY: leftEyeY.present ? leftEyeY.value : this.leftEyeY,
    rightEyeX: rightEyeX.present ? rightEyeX.value : this.rightEyeX,
    rightEyeY: rightEyeY.present ? rightEyeY.value : this.rightEyeY,
    alignChecked: alignChecked ?? this.alignChecked,
  );
  SnapshotRow copyWithCompanion(SnapshotsCompanion data) {
    return SnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      jpeg: data.jpeg.present ? data.jpeg.value : this.jpeg,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      leftEyeX: data.leftEyeX.present ? data.leftEyeX.value : this.leftEyeX,
      leftEyeY: data.leftEyeY.present ? data.leftEyeY.value : this.leftEyeY,
      rightEyeX: data.rightEyeX.present ? data.rightEyeX.value : this.rightEyeX,
      rightEyeY: data.rightEyeY.present ? data.rightEyeY.value : this.rightEyeY,
      alignChecked: data.alignChecked.present
          ? data.alignChecked.value
          : this.alignChecked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('takenAt: $takenAt, ')
          ..write('jpeg: $jpeg, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('leftEyeX: $leftEyeX, ')
          ..write('leftEyeY: $leftEyeY, ')
          ..write('rightEyeX: $rightEyeX, ')
          ..write('rightEyeY: $rightEyeY, ')
          ..write('alignChecked: $alignChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    takenAt,
    $driftBlobEquality.hash(jpeg),
    width,
    height,
    note,
    createdAt,
    leftEyeX,
    leftEyeY,
    rightEyeX,
    rightEyeY,
    alignChecked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnapshotRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.takenAt == this.takenAt &&
          $driftBlobEquality.equals(other.jpeg, this.jpeg) &&
          other.width == this.width &&
          other.height == this.height &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.leftEyeX == this.leftEyeX &&
          other.leftEyeY == this.leftEyeY &&
          other.rightEyeX == this.rightEyeX &&
          other.rightEyeY == this.rightEyeY &&
          other.alignChecked == this.alignChecked);
}

class SnapshotsCompanion extends UpdateCompanion<SnapshotRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<int> takenAt;
  final Value<Uint8List> jpeg;
  final Value<int> width;
  final Value<int> height;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<double?> leftEyeX;
  final Value<double?> leftEyeY;
  final Value<double?> rightEyeX;
  final Value<double?> rightEyeY;
  final Value<bool> alignChecked;
  final Value<int> rowid;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.jpeg = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.leftEyeX = const Value.absent(),
    this.leftEyeY = const Value.absent(),
    this.rightEyeX = const Value.absent(),
    this.rightEyeY = const Value.absent(),
    this.alignChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    required String id,
    required String kind,
    required int takenAt,
    required Uint8List jpeg,
    required int width,
    required int height,
    this.note = const Value.absent(),
    required int createdAt,
    this.leftEyeX = const Value.absent(),
    this.leftEyeY = const Value.absent(),
    this.rightEyeX = const Value.absent(),
    this.rightEyeY = const Value.absent(),
    this.alignChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       takenAt = Value(takenAt),
       jpeg = Value(jpeg),
       width = Value(width),
       height = Value(height),
       createdAt = Value(createdAt);
  static Insertable<SnapshotRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<int>? takenAt,
    Expression<Uint8List>? jpeg,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<double>? leftEyeX,
    Expression<double>? leftEyeY,
    Expression<double>? rightEyeX,
    Expression<double>? rightEyeY,
    Expression<bool>? alignChecked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (takenAt != null) 'taken_at': takenAt,
      if (jpeg != null) 'jpeg': jpeg,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (leftEyeX != null) 'left_eye_x': leftEyeX,
      if (leftEyeY != null) 'left_eye_y': leftEyeY,
      if (rightEyeX != null) 'right_eye_x': rightEyeX,
      if (rightEyeY != null) 'right_eye_y': rightEyeY,
      if (alignChecked != null) 'align_checked': alignChecked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<int>? takenAt,
    Value<Uint8List>? jpeg,
    Value<int>? width,
    Value<int>? height,
    Value<String?>? note,
    Value<int>? createdAt,
    Value<double?>? leftEyeX,
    Value<double?>? leftEyeY,
    Value<double?>? rightEyeX,
    Value<double?>? rightEyeY,
    Value<bool>? alignChecked,
    Value<int>? rowid,
  }) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      takenAt: takenAt ?? this.takenAt,
      jpeg: jpeg ?? this.jpeg,
      width: width ?? this.width,
      height: height ?? this.height,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      leftEyeX: leftEyeX ?? this.leftEyeX,
      leftEyeY: leftEyeY ?? this.leftEyeY,
      rightEyeX: rightEyeX ?? this.rightEyeX,
      rightEyeY: rightEyeY ?? this.rightEyeY,
      alignChecked: alignChecked ?? this.alignChecked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<int>(takenAt.value);
    }
    if (jpeg.present) {
      map['jpeg'] = Variable<Uint8List>(jpeg.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (leftEyeX.present) {
      map['left_eye_x'] = Variable<double>(leftEyeX.value);
    }
    if (leftEyeY.present) {
      map['left_eye_y'] = Variable<double>(leftEyeY.value);
    }
    if (rightEyeX.present) {
      map['right_eye_x'] = Variable<double>(rightEyeX.value);
    }
    if (rightEyeY.present) {
      map['right_eye_y'] = Variable<double>(rightEyeY.value);
    }
    if (alignChecked.present) {
      map['align_checked'] = Variable<bool>(alignChecked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('takenAt: $takenAt, ')
          ..write('jpeg: $jpeg, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('leftEyeX: $leftEyeX, ')
          ..write('leftEyeY: $leftEyeY, ')
          ..write('rightEyeX: $rightEyeX, ')
          ..write('rightEyeY: $rightEyeY, ')
          ..write('alignChecked: $alignChecked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WardrobeItemsTable extends WardrobeItems
    with TableInfo<$WardrobeItemsTable, WardrobeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WardrobeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formalityMeta = const VerificationMeta(
    'formality',
  );
  @override
  late final GeneratedColumn<int> formality = GeneratedColumn<int>(
    'formality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occasionsMeta = const VerificationMeta(
    'occasions',
  );
  @override
  late final GeneratedColumn<String> occasions = GeneratedColumn<String>(
    'occasions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
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
    name,
    category,
    colorHex,
    pattern,
    formality,
    occasions,
    favorite,
    photo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wardrobe_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<WardrobeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('formality')) {
      context.handle(
        _formalityMeta,
        formality.isAcceptableOrUnknown(data['formality']!, _formalityMeta),
      );
    } else if (isInserting) {
      context.missing(_formalityMeta);
    }
    if (data.containsKey('occasions')) {
      context.handle(
        _occasionsMeta,
        occasions.isAcceptableOrUnknown(data['occasions']!, _occasionsMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
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
  WardrobeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WardrobeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      formality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}formality'],
      )!,
      occasions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occasions'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}photo'],
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
  $WardrobeItemsTable createAlias(String alias) {
    return $WardrobeItemsTable(attachedDatabase, alias);
  }
}

class WardrobeRow extends DataClass implements Insertable<WardrobeRow> {
  final String id;
  final String name;
  final String category;
  final String colorHex;
  final String pattern;
  final int formality;

  /// Comma-separated occasion names; empty means any occasion.
  final String occasions;
  final bool favorite;
  final Uint8List? photo;
  final int createdAt;
  final int updatedAt;
  const WardrobeRow({
    required this.id,
    required this.name,
    required this.category,
    required this.colorHex,
    required this.pattern,
    required this.formality,
    required this.occasions,
    required this.favorite,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['color_hex'] = Variable<String>(colorHex);
    map['pattern'] = Variable<String>(pattern);
    map['formality'] = Variable<int>(formality);
    map['occasions'] = Variable<String>(occasions);
    map['favorite'] = Variable<bool>(favorite);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WardrobeItemsCompanion toCompanion(bool nullToAbsent) {
    return WardrobeItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      colorHex: Value(colorHex),
      pattern: Value(pattern),
      formality: Value(formality),
      occasions: Value(occasions),
      favorite: Value(favorite),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WardrobeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WardrobeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      pattern: serializer.fromJson<String>(json['pattern']),
      formality: serializer.fromJson<int>(json['formality']),
      occasions: serializer.fromJson<String>(json['occasions']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'colorHex': serializer.toJson<String>(colorHex),
      'pattern': serializer.toJson<String>(pattern),
      'formality': serializer.toJson<int>(formality),
      'occasions': serializer.toJson<String>(occasions),
      'favorite': serializer.toJson<bool>(favorite),
      'photo': serializer.toJson<Uint8List?>(photo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WardrobeRow copyWith({
    String? id,
    String? name,
    String? category,
    String? colorHex,
    String? pattern,
    int? formality,
    String? occasions,
    bool? favorite,
    Value<Uint8List?> photo = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => WardrobeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    colorHex: colorHex ?? this.colorHex,
    pattern: pattern ?? this.pattern,
    formality: formality ?? this.formality,
    occasions: occasions ?? this.occasions,
    favorite: favorite ?? this.favorite,
    photo: photo.present ? photo.value : this.photo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WardrobeRow copyWithCompanion(WardrobeItemsCompanion data) {
    return WardrobeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      formality: data.formality.present ? data.formality.value : this.formality,
      occasions: data.occasions.present ? data.occasions.value : this.occasions,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      photo: data.photo.present ? data.photo.value : this.photo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WardrobeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('colorHex: $colorHex, ')
          ..write('pattern: $pattern, ')
          ..write('formality: $formality, ')
          ..write('occasions: $occasions, ')
          ..write('favorite: $favorite, ')
          ..write('photo: $photo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    colorHex,
    pattern,
    formality,
    occasions,
    favorite,
    $driftBlobEquality.hash(photo),
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WardrobeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.colorHex == this.colorHex &&
          other.pattern == this.pattern &&
          other.formality == this.formality &&
          other.occasions == this.occasions &&
          other.favorite == this.favorite &&
          $driftBlobEquality.equals(other.photo, this.photo) &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WardrobeItemsCompanion extends UpdateCompanion<WardrobeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> colorHex;
  final Value<String> pattern;
  final Value<int> formality;
  final Value<String> occasions;
  final Value<bool> favorite;
  final Value<Uint8List?> photo;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WardrobeItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.pattern = const Value.absent(),
    this.formality = const Value.absent(),
    this.occasions = const Value.absent(),
    this.favorite = const Value.absent(),
    this.photo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WardrobeItemsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required String colorHex,
    required String pattern,
    required int formality,
    this.occasions = const Value.absent(),
    this.favorite = const Value.absent(),
    this.photo = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       colorHex = Value(colorHex),
       pattern = Value(pattern),
       formality = Value(formality),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WardrobeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? colorHex,
    Expression<String>? pattern,
    Expression<int>? formality,
    Expression<String>? occasions,
    Expression<bool>? favorite,
    Expression<Uint8List>? photo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (colorHex != null) 'color_hex': colorHex,
      if (pattern != null) 'pattern': pattern,
      if (formality != null) 'formality': formality,
      if (occasions != null) 'occasions': occasions,
      if (favorite != null) 'favorite': favorite,
      if (photo != null) 'photo': photo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WardrobeItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? colorHex,
    Value<String>? pattern,
    Value<int>? formality,
    Value<String>? occasions,
    Value<bool>? favorite,
    Value<Uint8List?>? photo,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WardrobeItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      colorHex: colorHex ?? this.colorHex,
      pattern: pattern ?? this.pattern,
      formality: formality ?? this.formality,
      occasions: occasions ?? this.occasions,
      favorite: favorite ?? this.favorite,
      photo: photo ?? this.photo,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (formality.present) {
      map['formality'] = Variable<int>(formality.value);
    }
    if (occasions.present) {
      map['occasions'] = Variable<String>(occasions.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
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
    return (StringBuffer('WardrobeItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('colorHex: $colorHex, ')
          ..write('pattern: $pattern, ')
          ..write('formality: $formality, ')
          ..write('occasions: $occasions, ')
          ..write('favorite: $favorite, ')
          ..write('photo: $photo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutfitsTable extends Outfits with TableInfo<$OutfitsTable, OutfitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutfitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occasionMeta = const VerificationMeta(
    'occasion',
  );
  @override
  late final GeneratedColumn<String> occasion = GeneratedColumn<String>(
    'occasion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [id, occasion, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outfit';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutfitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occasion')) {
      context.handle(
        _occasionMeta,
        occasion.isAcceptableOrUnknown(data['occasion']!, _occasionMeta),
      );
    } else if (isInserting) {
      context.missing(_occasionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutfitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutfitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occasion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occasion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutfitsTable createAlias(String alias) {
    return $OutfitsTable(attachedDatabase, alias);
  }
}

class OutfitRow extends DataClass implements Insertable<OutfitRow> {
  final String id;
  final String occasion;
  final int createdAt;
  const OutfitRow({
    required this.id,
    required this.occasion,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occasion'] = Variable<String>(occasion);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  OutfitsCompanion toCompanion(bool nullToAbsent) {
    return OutfitsCompanion(
      id: Value(id),
      occasion: Value(occasion),
      createdAt: Value(createdAt),
    );
  }

  factory OutfitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutfitRow(
      id: serializer.fromJson<String>(json['id']),
      occasion: serializer.fromJson<String>(json['occasion']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occasion': serializer.toJson<String>(occasion),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  OutfitRow copyWith({String? id, String? occasion, int? createdAt}) =>
      OutfitRow(
        id: id ?? this.id,
        occasion: occasion ?? this.occasion,
        createdAt: createdAt ?? this.createdAt,
      );
  OutfitRow copyWithCompanion(OutfitsCompanion data) {
    return OutfitRow(
      id: data.id.present ? data.id.value : this.id,
      occasion: data.occasion.present ? data.occasion.value : this.occasion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutfitRow(')
          ..write('id: $id, ')
          ..write('occasion: $occasion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, occasion, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutfitRow &&
          other.id == this.id &&
          other.occasion == this.occasion &&
          other.createdAt == this.createdAt);
}

class OutfitsCompanion extends UpdateCompanion<OutfitRow> {
  final Value<String> id;
  final Value<String> occasion;
  final Value<int> createdAt;
  final Value<int> rowid;
  const OutfitsCompanion({
    this.id = const Value.absent(),
    this.occasion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutfitsCompanion.insert({
    required String id,
    required String occasion,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occasion = Value(occasion),
       createdAt = Value(createdAt);
  static Insertable<OutfitRow> custom({
    Expression<String>? id,
    Expression<String>? occasion,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occasion != null) 'occasion': occasion,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutfitsCompanion copyWith({
    Value<String>? id,
    Value<String>? occasion,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return OutfitsCompanion(
      id: id ?? this.id,
      occasion: occasion ?? this.occasion,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occasion.present) {
      map['occasion'] = Variable<String>(occasion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutfitsCompanion(')
          ..write('id: $id, ')
          ..write('occasion: $occasion, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutfitItemsTable extends OutfitItems
    with TableInfo<$OutfitItemsTable, OutfitItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutfitItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _outfitIdMeta = const VerificationMeta(
    'outfitId',
  );
  @override
  late final GeneratedColumn<String> outfitId = GeneratedColumn<String>(
    'outfit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES outfit (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wardrobe_item (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [outfitId, itemId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outfit_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutfitItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('outfit_id')) {
      context.handle(
        _outfitIdMeta,
        outfitId.isAcceptableOrUnknown(data['outfit_id']!, _outfitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_outfitIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {outfitId, itemId};
  @override
  OutfitItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutfitItemRow(
      outfitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outfit_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
    );
  }

  @override
  $OutfitItemsTable createAlias(String alias) {
    return $OutfitItemsTable(attachedDatabase, alias);
  }
}

class OutfitItemRow extends DataClass implements Insertable<OutfitItemRow> {
  final String outfitId;
  final String itemId;
  const OutfitItemRow({required this.outfitId, required this.itemId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['outfit_id'] = Variable<String>(outfitId);
    map['item_id'] = Variable<String>(itemId);
    return map;
  }

  OutfitItemsCompanion toCompanion(bool nullToAbsent) {
    return OutfitItemsCompanion(
      outfitId: Value(outfitId),
      itemId: Value(itemId),
    );
  }

  factory OutfitItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutfitItemRow(
      outfitId: serializer.fromJson<String>(json['outfitId']),
      itemId: serializer.fromJson<String>(json['itemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'outfitId': serializer.toJson<String>(outfitId),
      'itemId': serializer.toJson<String>(itemId),
    };
  }

  OutfitItemRow copyWith({String? outfitId, String? itemId}) => OutfitItemRow(
    outfitId: outfitId ?? this.outfitId,
    itemId: itemId ?? this.itemId,
  );
  OutfitItemRow copyWithCompanion(OutfitItemsCompanion data) {
    return OutfitItemRow(
      outfitId: data.outfitId.present ? data.outfitId.value : this.outfitId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutfitItemRow(')
          ..write('outfitId: $outfitId, ')
          ..write('itemId: $itemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(outfitId, itemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutfitItemRow &&
          other.outfitId == this.outfitId &&
          other.itemId == this.itemId);
}

class OutfitItemsCompanion extends UpdateCompanion<OutfitItemRow> {
  final Value<String> outfitId;
  final Value<String> itemId;
  final Value<int> rowid;
  const OutfitItemsCompanion({
    this.outfitId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutfitItemsCompanion.insert({
    required String outfitId,
    required String itemId,
    this.rowid = const Value.absent(),
  }) : outfitId = Value(outfitId),
       itemId = Value(itemId);
  static Insertable<OutfitItemRow> custom({
    Expression<String>? outfitId,
    Expression<String>? itemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (outfitId != null) 'outfit_id': outfitId,
      if (itemId != null) 'item_id': itemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutfitItemsCompanion copyWith({
    Value<String>? outfitId,
    Value<String>? itemId,
    Value<int>? rowid,
  }) {
    return OutfitItemsCompanion(
      outfitId: outfitId ?? this.outfitId,
      itemId: itemId ?? this.itemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (outfitId.present) {
      map['outfit_id'] = Variable<String>(outfitId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutfitItemsCompanion(')
          ..write('outfitId: $outfitId, ')
          ..write('itemId: $itemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutfitWearsTable extends OutfitWears
    with TableInfo<$OutfitWearsTable, OutfitWearRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutfitWearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _outfitIdMeta = const VerificationMeta(
    'outfitId',
  );
  @override
  late final GeneratedColumn<String> outfitId = GeneratedColumn<String>(
    'outfit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES outfit (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [outfitId, day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outfit_wear';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutfitWearRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('outfit_id')) {
      context.handle(
        _outfitIdMeta,
        outfitId.isAcceptableOrUnknown(data['outfit_id']!, _outfitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_outfitIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {outfitId, day};
  @override
  OutfitWearRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutfitWearRow(
      outfitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outfit_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
    );
  }

  @override
  $OutfitWearsTable createAlias(String alias) {
    return $OutfitWearsTable(attachedDatabase, alias);
  }
}

class OutfitWearRow extends DataClass implements Insertable<OutfitWearRow> {
  final String outfitId;
  final int day;
  const OutfitWearRow({required this.outfitId, required this.day});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['outfit_id'] = Variable<String>(outfitId);
    map['day'] = Variable<int>(day);
    return map;
  }

  OutfitWearsCompanion toCompanion(bool nullToAbsent) {
    return OutfitWearsCompanion(outfitId: Value(outfitId), day: Value(day));
  }

  factory OutfitWearRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutfitWearRow(
      outfitId: serializer.fromJson<String>(json['outfitId']),
      day: serializer.fromJson<int>(json['day']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'outfitId': serializer.toJson<String>(outfitId),
      'day': serializer.toJson<int>(day),
    };
  }

  OutfitWearRow copyWith({String? outfitId, int? day}) =>
      OutfitWearRow(outfitId: outfitId ?? this.outfitId, day: day ?? this.day);
  OutfitWearRow copyWithCompanion(OutfitWearsCompanion data) {
    return OutfitWearRow(
      outfitId: data.outfitId.present ? data.outfitId.value : this.outfitId,
      day: data.day.present ? data.day.value : this.day,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutfitWearRow(')
          ..write('outfitId: $outfitId, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(outfitId, day);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutfitWearRow &&
          other.outfitId == this.outfitId &&
          other.day == this.day);
}

class OutfitWearsCompanion extends UpdateCompanion<OutfitWearRow> {
  final Value<String> outfitId;
  final Value<int> day;
  final Value<int> rowid;
  const OutfitWearsCompanion({
    this.outfitId = const Value.absent(),
    this.day = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutfitWearsCompanion.insert({
    required String outfitId,
    required int day,
    this.rowid = const Value.absent(),
  }) : outfitId = Value(outfitId),
       day = Value(day);
  static Insertable<OutfitWearRow> custom({
    Expression<String>? outfitId,
    Expression<int>? day,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (outfitId != null) 'outfit_id': outfitId,
      if (day != null) 'day': day,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutfitWearsCompanion copyWith({
    Value<String>? outfitId,
    Value<int>? day,
    Value<int>? rowid,
  }) {
    return OutfitWearsCompanion(
      outfitId: outfitId ?? this.outfitId,
      day: day ?? this.day,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (outfitId.present) {
      map['outfit_id'] = Variable<String>(outfitId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutfitWearsCompanion(')
          ..write('outfitId: $outfitId, ')
          ..write('day: $day, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyPlansTable extends BodyPlans
    with TableInfo<$BodyPlansTable, BodyPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paceMeta = const VerificationMeta('pace');
  @override
  late final GeneratedColumn<String> pace = GeneratedColumn<String>(
    'pace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietMeta = const VerificationMeta('diet');
  @override
  late final GeneratedColumn<String> diet = GeneratedColumn<String>(
    'diet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startWeightKgMeta = const VerificationMeta(
    'startWeightKg',
  );
  @override
  late final GeneratedColumn<double> startWeightKg = GeneratedColumn<double>(
    'start_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<int> proteinG = GeneratedColumn<int>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<int> carbsG = GeneratedColumn<int>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<int> fatG = GeneratedColumn<int>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterMlMeta = const VerificationMeta(
    'waterMl',
  );
  @override
  late final GeneratedColumn<int> waterMl = GeneratedColumn<int>(
    'water_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    pace,
    diet,
    startDay,
    startWeightKg,
    targetWeightKg,
    calories,
    proteinG,
    carbsG,
    fatG,
    waterMl,
    active,
    createdAt,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_plan';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('pace')) {
      context.handle(
        _paceMeta,
        pace.isAcceptableOrUnknown(data['pace']!, _paceMeta),
      );
    } else if (isInserting) {
      context.missing(_paceMeta);
    }
    if (data.containsKey('diet')) {
      context.handle(
        _dietMeta,
        diet.isAcceptableOrUnknown(data['diet']!, _dietMeta),
      );
    } else if (isInserting) {
      context.missing(_dietMeta);
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('start_weight_kg')) {
      context.handle(
        _startWeightKgMeta,
        startWeightKg.isAcceptableOrUnknown(
          data['start_weight_kg']!,
          _startWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startWeightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('water_ml')) {
      context.handle(
        _waterMlMeta,
        waterMl.isAcceptableOrUnknown(data['water_ml']!, _waterMlMeta),
      );
    } else if (isInserting) {
      context.missing(_waterMlMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      pace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pace'],
      )!,
      diet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet'],
      )!,
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day'],
      )!,
      startWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fat_g'],
      )!,
      waterMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_ml'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $BodyPlansTable createAlias(String alias) {
    return $BodyPlansTable(attachedDatabase, alias);
  }
}

class BodyPlanRow extends DataClass implements Insertable<BodyPlanRow> {
  final String id;

  /// loseFat, maintain, gainWeight or buildMuscle.
  final String kind;

  /// gentle, steady or brisk.
  final String pace;
  final String diet;
  final int startDay;
  final double startWeightKg;
  final double? targetWeightKg;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int waterMl;
  final bool active;
  final int createdAt;
  final int? endedAt;
  const BodyPlanRow({
    required this.id,
    required this.kind,
    required this.pace,
    required this.diet,
    required this.startDay,
    required this.startWeightKg,
    this.targetWeightKg,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
    required this.active,
    required this.createdAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['pace'] = Variable<String>(pace);
    map['diet'] = Variable<String>(diet);
    map['start_day'] = Variable<int>(startDay);
    map['start_weight_kg'] = Variable<double>(startWeightKg);
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    map['calories'] = Variable<int>(calories);
    map['protein_g'] = Variable<int>(proteinG);
    map['carbs_g'] = Variable<int>(carbsG);
    map['fat_g'] = Variable<int>(fatG);
    map['water_ml'] = Variable<int>(waterMl);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    return map;
  }

  BodyPlansCompanion toCompanion(bool nullToAbsent) {
    return BodyPlansCompanion(
      id: Value(id),
      kind: Value(kind),
      pace: Value(pace),
      diet: Value(diet),
      startDay: Value(startDay),
      startWeightKg: Value(startWeightKg),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      waterMl: Value(waterMl),
      active: Value(active),
      createdAt: Value(createdAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory BodyPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyPlanRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      pace: serializer.fromJson<String>(json['pace']),
      diet: serializer.fromJson<String>(json['diet']),
      startDay: serializer.fromJson<int>(json['startDay']),
      startWeightKg: serializer.fromJson<double>(json['startWeightKg']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      calories: serializer.fromJson<int>(json['calories']),
      proteinG: serializer.fromJson<int>(json['proteinG']),
      carbsG: serializer.fromJson<int>(json['carbsG']),
      fatG: serializer.fromJson<int>(json['fatG']),
      waterMl: serializer.fromJson<int>(json['waterMl']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'pace': serializer.toJson<String>(pace),
      'diet': serializer.toJson<String>(diet),
      'startDay': serializer.toJson<int>(startDay),
      'startWeightKg': serializer.toJson<double>(startWeightKg),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'calories': serializer.toJson<int>(calories),
      'proteinG': serializer.toJson<int>(proteinG),
      'carbsG': serializer.toJson<int>(carbsG),
      'fatG': serializer.toJson<int>(fatG),
      'waterMl': serializer.toJson<int>(waterMl),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'endedAt': serializer.toJson<int?>(endedAt),
    };
  }

  BodyPlanRow copyWith({
    String? id,
    String? kind,
    String? pace,
    String? diet,
    int? startDay,
    double? startWeightKg,
    Value<double?> targetWeightKg = const Value.absent(),
    int? calories,
    int? proteinG,
    int? carbsG,
    int? fatG,
    int? waterMl,
    bool? active,
    int? createdAt,
    Value<int?> endedAt = const Value.absent(),
  }) => BodyPlanRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    pace: pace ?? this.pace,
    diet: diet ?? this.diet,
    startDay: startDay ?? this.startDay,
    startWeightKg: startWeightKg ?? this.startWeightKg,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    waterMl: waterMl ?? this.waterMl,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  BodyPlanRow copyWithCompanion(BodyPlansCompanion data) {
    return BodyPlanRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      pace: data.pace.present ? data.pace.value : this.pace,
      diet: data.diet.present ? data.diet.value : this.diet,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      startWeightKg: data.startWeightKg.present
          ? data.startWeightKg.value
          : this.startWeightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      waterMl: data.waterMl.present ? data.waterMl.value : this.waterMl,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyPlanRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('pace: $pace, ')
          ..write('diet: $diet, ')
          ..write('startDay: $startDay, ')
          ..write('startWeightKg: $startWeightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('waterMl: $waterMl, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    pace,
    diet,
    startDay,
    startWeightKg,
    targetWeightKg,
    calories,
    proteinG,
    carbsG,
    fatG,
    waterMl,
    active,
    createdAt,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyPlanRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.pace == this.pace &&
          other.diet == this.diet &&
          other.startDay == this.startDay &&
          other.startWeightKg == this.startWeightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.waterMl == this.waterMl &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.endedAt == this.endedAt);
}

class BodyPlansCompanion extends UpdateCompanion<BodyPlanRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> pace;
  final Value<String> diet;
  final Value<int> startDay;
  final Value<double> startWeightKg;
  final Value<double?> targetWeightKg;
  final Value<int> calories;
  final Value<int> proteinG;
  final Value<int> carbsG;
  final Value<int> fatG;
  final Value<int> waterMl;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int?> endedAt;
  final Value<int> rowid;
  const BodyPlansCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.pace = const Value.absent(),
    this.diet = const Value.absent(),
    this.startDay = const Value.absent(),
    this.startWeightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.waterMl = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyPlansCompanion.insert({
    required String id,
    required String kind,
    required String pace,
    required String diet,
    required int startDay,
    required double startWeightKg,
    this.targetWeightKg = const Value.absent(),
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
    required int waterMl,
    this.active = const Value.absent(),
    required int createdAt,
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       pace = Value(pace),
       diet = Value(diet),
       startDay = Value(startDay),
       startWeightKg = Value(startWeightKg),
       calories = Value(calories),
       proteinG = Value(proteinG),
       carbsG = Value(carbsG),
       fatG = Value(fatG),
       waterMl = Value(waterMl),
       createdAt = Value(createdAt);
  static Insertable<BodyPlanRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? pace,
    Expression<String>? diet,
    Expression<int>? startDay,
    Expression<double>? startWeightKg,
    Expression<double>? targetWeightKg,
    Expression<int>? calories,
    Expression<int>? proteinG,
    Expression<int>? carbsG,
    Expression<int>? fatG,
    Expression<int>? waterMl,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (pace != null) 'pace': pace,
      if (diet != null) 'diet': diet,
      if (startDay != null) 'start_day': startDay,
      if (startWeightKg != null) 'start_weight_kg': startWeightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (waterMl != null) 'water_ml': waterMl,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? pace,
    Value<String>? diet,
    Value<int>? startDay,
    Value<double>? startWeightKg,
    Value<double?>? targetWeightKg,
    Value<int>? calories,
    Value<int>? proteinG,
    Value<int>? carbsG,
    Value<int>? fatG,
    Value<int>? waterMl,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int?>? endedAt,
    Value<int>? rowid,
  }) {
    return BodyPlansCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      pace: pace ?? this.pace,
      diet: diet ?? this.diet,
      startDay: startDay ?? this.startDay,
      startWeightKg: startWeightKg ?? this.startWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      waterMl: waterMl ?? this.waterMl,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (pace.present) {
      map['pace'] = Variable<String>(pace.value);
    }
    if (diet.present) {
      map['diet'] = Variable<String>(diet.value);
    }
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (startWeightKg.present) {
      map['start_weight_kg'] = Variable<double>(startWeightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<int>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<int>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<int>(fatG.value);
    }
    if (waterMl.present) {
      map['water_ml'] = Variable<int>(waterMl.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyPlansCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('pace: $pace, ')
          ..write('diet: $diet, ')
          ..write('startDay: $startDay, ')
          ..write('startWeightKg: $startWeightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('waterMl: $waterMl, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodLogsTable extends MoodLogs with TableInfo<$MoodLogsTable, MoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
    'energy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [day, mood, energy, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  MoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $MoodLogsTable createAlias(String alias) {
    return $MoodLogsTable(attachedDatabase, alias);
  }
}

class MoodRow extends DataClass implements Insertable<MoodRow> {
  final int day;
  final int mood;
  final int energy;
  final int recordedAt;
  const MoodRow({
    required this.day,
    required this.mood,
    required this.energy,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['mood'] = Variable<int>(mood);
    map['energy'] = Variable<int>(energy);
    map['recorded_at'] = Variable<int>(recordedAt);
    return map;
  }

  MoodLogsCompanion toCompanion(bool nullToAbsent) {
    return MoodLogsCompanion(
      day: Value(day),
      mood: Value(mood),
      energy: Value(energy),
      recordedAt: Value(recordedAt),
    );
  }

  factory MoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodRow(
      day: serializer.fromJson<int>(json['day']),
      mood: serializer.fromJson<int>(json['mood']),
      energy: serializer.fromJson<int>(json['energy']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'mood': serializer.toJson<int>(mood),
      'energy': serializer.toJson<int>(energy),
      'recordedAt': serializer.toJson<int>(recordedAt),
    };
  }

  MoodRow copyWith({int? day, int? mood, int? energy, int? recordedAt}) =>
      MoodRow(
        day: day ?? this.day,
        mood: mood ?? this.mood,
        energy: energy ?? this.energy,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  MoodRow copyWithCompanion(MoodLogsCompanion data) {
    return MoodRow(
      day: data.day.present ? data.day.value : this.day,
      mood: data.mood.present ? data.mood.value : this.mood,
      energy: data.energy.present ? data.energy.value : this.energy,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodRow(')
          ..write('day: $day, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, mood, energy, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodRow &&
          other.day == this.day &&
          other.mood == this.mood &&
          other.energy == this.energy &&
          other.recordedAt == this.recordedAt);
}

class MoodLogsCompanion extends UpdateCompanion<MoodRow> {
  final Value<int> day;
  final Value<int> mood;
  final Value<int> energy;
  final Value<int> recordedAt;
  const MoodLogsCompanion({
    this.day = const Value.absent(),
    this.mood = const Value.absent(),
    this.energy = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  MoodLogsCompanion.insert({
    this.day = const Value.absent(),
    required int mood,
    required int energy,
    required int recordedAt,
  }) : mood = Value(mood),
       energy = Value(energy),
       recordedAt = Value(recordedAt);
  static Insertable<MoodRow> custom({
    Expression<int>? day,
    Expression<int>? mood,
    Expression<int>? energy,
    Expression<int>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (mood != null) 'mood': mood,
      if (energy != null) 'energy': energy,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  MoodLogsCompanion copyWith({
    Value<int>? day,
    Value<int>? mood,
    Value<int>? energy,
    Value<int>? recordedAt,
  }) {
    return MoodLogsCompanion(
      day: day ?? this.day,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodLogsCompanion(')
          ..write('day: $day, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('recordedAt: $recordedAt')
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
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $SleepLogsTable sleepLogs = $SleepLogsTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $ExerciseSessionsTable exerciseSessions = $ExerciseSessionsTable(
    this,
  );
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(
    this,
  );
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineItemsTable routineItems = $RoutineItemsTable(this);
  late final $PlanRecordsTable planRecords = $PlanRecordsTable(this);
  late final $PostureSessionsTable postureSessions = $PostureSessionsTable(
    this,
  );
  late final $PostureMetricsTable postureMetrics = $PostureMetricsTable(this);
  late final $FaceAnalysesTable faceAnalyses = $FaceAnalysesTable(this);
  late final $FaceMetricsTable faceMetrics = $FaceMetricsTable(this);
  late final $StyleFavoritesTable styleFavorites = $StyleFavoritesTable(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  late final $WardrobeItemsTable wardrobeItems = $WardrobeItemsTable(this);
  late final $OutfitsTable outfits = $OutfitsTable(this);
  late final $OutfitItemsTable outfitItems = $OutfitItemsTable(this);
  late final $OutfitWearsTable outfitWears = $OutfitWearsTable(this);
  late final $BodyPlansTable bodyPlans = $BodyPlansTable(this);
  late final $MoodLogsTable moodLogs = $MoodLogsTable(this);
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
  late final Index idxWaterRecordedAt = Index(
    'idx_water_recorded_at',
    'CREATE INDEX idx_water_recorded_at ON water_log (recorded_at)',
  );
  late final Index idxMealEatenAt = Index(
    'idx_meal_eaten_at',
    'CREATE INDEX idx_meal_eaten_at ON meal (eaten_at)',
  );
  late final Index idxSleepWakeAt = Index(
    'idx_sleep_wake_at',
    'CREATE INDEX idx_sleep_wake_at ON sleep_log (wake_at)',
  );
  late final Index idxActivityRecordedAt = Index(
    'idx_activity_recorded_at',
    'CREATE INDEX idx_activity_recorded_at ON activity_log (recorded_at)',
  );
  late final Index idxExercisePerformedAt = Index(
    'idx_exercise_performed_at',
    'CREATE INDEX idx_exercise_performed_at ON exercise_session (performed_at)',
  );
  late final Index idxHabitCompletionDay = Index(
    'idx_habit_completion_day',
    'CREATE INDEX idx_habit_completion_day ON habit_completion (day)',
  );
  late final Index idxRoutineItemRoutine = Index(
    'idx_routine_item_routine',
    'CREATE INDEX idx_routine_item_routine ON routine_item (routine_id)',
  );
  late final Index idxPlanRecordDay = Index(
    'idx_plan_record_day',
    'CREATE INDEX idx_plan_record_day ON routine_completion (day)',
  );
  late final Index idxPostureSessionRecordedAt = Index(
    'idx_posture_session_recorded_at',
    'CREATE INDEX idx_posture_session_recorded_at ON posture_session (recorded_at)',
  );
  late final Index idxFaceAnalysisRecordedAt = Index(
    'idx_face_analysis_recorded_at',
    'CREATE INDEX idx_face_analysis_recorded_at ON face_analysis (recorded_at)',
  );
  late final Index idxSnapshotKindTaken = Index(
    'idx_snapshot_kind_taken',
    'CREATE INDEX idx_snapshot_kind_taken ON progress_snapshot (kind, taken_at)',
  );
  late final Index idxWardrobeCategory = Index(
    'idx_wardrobe_category',
    'CREATE INDEX idx_wardrobe_category ON wardrobe_item (category)',
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
    waterLogs,
    meals,
    sleepLogs,
    activityLogs,
    exerciseSessions,
    habits,
    habitCompletions,
    routines,
    routineItems,
    planRecords,
    postureSessions,
    postureMetrics,
    faceAnalyses,
    faceMetrics,
    styleFavorites,
    snapshots,
    wardrobeItems,
    outfits,
    outfitItems,
    outfitWears,
    bodyPlans,
    moodLogs,
    idxHeightRecordedAt,
    idxWeightRecordedAt,
    idxMeasurementTypeRecordedAt,
    idxWaterRecordedAt,
    idxMealEatenAt,
    idxSleepWakeAt,
    idxActivityRecordedAt,
    idxExercisePerformedAt,
    idxHabitCompletionDay,
    idxRoutineItemRoutine,
    idxPlanRecordDay,
    idxPostureSessionRecordedAt,
    idxFaceAnalysisRecordedAt,
    idxSnapshotKindTaken,
    idxWardrobeCategory,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habit',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_completion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_item', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_item',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_completion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'posture_session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('posture_metric', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'face_analysis',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('face_metric', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'outfit',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('outfit_item', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wardrobe_item',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('outfit_item', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'outfit',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('outfit_wear', kind: UpdateKind.delete)],
    ),
  ]);
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
      Value<String?> gender,
      Value<String?> dietPreference,
      Value<String?> styleFit,
      Value<String?> region,
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
      Value<String?> gender,
      Value<String?> dietPreference,
      Value<String?> styleFit,
      Value<String?> region,
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

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietPreference => $composableBuilder(
    column: $table.dietPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get styleFit => $composableBuilder(
    column: $table.styleFit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
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

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietPreference => $composableBuilder(
    column: $table.dietPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get styleFit => $composableBuilder(
    column: $table.styleFit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
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

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get dietPreference => $composableBuilder(
    column: $table.dietPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get styleFit =>
      $composableBuilder(column: $table.styleFit, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);
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
                Value<String?> gender = const Value.absent(),
                Value<String?> dietPreference = const Value.absent(),
                Value<String?> styleFit = const Value.absent(),
                Value<String?> region = const Value.absent(),
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
                gender: gender,
                dietPreference: dietPreference,
                styleFit: styleFit,
                region: region,
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
                Value<String?> gender = const Value.absent(),
                Value<String?> dietPreference = const Value.absent(),
                Value<String?> styleFit = const Value.absent(),
                Value<String?> region = const Value.absent(),
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
                gender: gender,
                dietPreference: dietPreference,
                styleFit: styleFit,
                region: region,
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
typedef $$WaterLogsTableCreateCompanionBuilder = WaterLogsCompanion Function({
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
typedef $$WaterLogsTableUpdateCompanionBuilder = WaterLogsCompanion Function({
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

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
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

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
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

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
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

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTable,
          WaterRow,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (WaterRow, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterRow>),
          WaterRow,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
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
              }) => WaterLogsCompanion(
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
              }) => WaterLogsCompanion.insert(
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
                  e.readTable<$WaterLogsTable, WaterRow>(table),
                  BaseReferences<_$AppDatabase, $WaterLogsTable, WaterRow>(
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

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTable,
      WaterRow,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (WaterRow, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterRow>),
      WaterRow,
      PrefetchHooks Function()
    >;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  required String id,
  required String mealType,
  Value<String?> customName,
  required String food,
  Value<String?> quantity,
  Value<double?> calories,
  required int eatenAt,
  Value<String?> notes,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<String> id,
  Value<String> mealType,
  Value<String?> customName,
  Value<String> food,
  Value<String?> quantity,
  Value<double?> calories,
  Value<int> eatenAt,
  Value<String?> notes,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
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

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
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

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
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

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
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

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get food =>
      $composableBuilder(column: $table.food, builder: (column) => column);

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get eatenAt =>
      $composableBuilder(column: $table.eatenAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          MealRow,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
          MealRow,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<String> food = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                Value<int> eatenAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                mealType: mealType,
                customName: customName,
                food: food,
                quantity: quantity,
                calories: calories,
                eatenAt: eatenAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mealType,
                Value<String?> customName = const Value.absent(),
                required String food,
                Value<String?> quantity = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                required int eatenAt,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                mealType: mealType,
                customName: customName,
                food: food,
                quantity: quantity,
                calories: calories,
                eatenAt: eatenAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealsTable, MealRow>(table),
                  BaseReferences<_$AppDatabase, $MealsTable, MealRow>(
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

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      MealRow,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
      MealRow,
      PrefetchHooks Function()
    >;
typedef $$SleepLogsTableCreateCompanionBuilder = SleepLogsCompanion Function({
  required String id,
  required int bedAt,
  required int wakeAt,
  required String source,
  Value<String?> notes,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SleepLogsTableUpdateCompanionBuilder = SleepLogsCompanion Function({
  Value<String> id,
  Value<int> bedAt,
  Value<int> wakeAt,
  Value<String> source,
  Value<String?> notes,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SleepLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableFilterComposer({
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

  ColumnFilters<int> get bedAt => $composableBuilder(
    column: $table.bedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeAt => $composableBuilder(
    column: $table.wakeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
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

class $$SleepLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableOrderingComposer({
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

  ColumnOrderings<int> get bedAt => $composableBuilder(
    column: $table.bedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeAt => $composableBuilder(
    column: $table.wakeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

class $$SleepLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bedAt =>
      $composableBuilder(column: $table.bedAt, builder: (column) => column);

  GeneratedColumn<int> get wakeAt =>
      $composableBuilder(column: $table.wakeAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SleepLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepLogsTable,
          SleepRow,
          $$SleepLogsTableFilterComposer,
          $$SleepLogsTableOrderingComposer,
          $$SleepLogsTableAnnotationComposer,
          $$SleepLogsTableCreateCompanionBuilder,
          $$SleepLogsTableUpdateCompanionBuilder,
          (SleepRow, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepRow>),
          SleepRow,
          PrefetchHooks Function()
        > {
  $$SleepLogsTableTableManager(_$AppDatabase db, $SleepLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> bedAt = const Value.absent(),
                Value<int> wakeAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepLogsCompanion(
                id: id,
                bedAt: bedAt,
                wakeAt: wakeAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int bedAt,
                required int wakeAt,
                required String source,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SleepLogsCompanion.insert(
                id: id,
                bedAt: bedAt,
                wakeAt: wakeAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepLogsTable, SleepRow>(table),
                  BaseReferences<_$AppDatabase, $SleepLogsTable, SleepRow>(
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

typedef $$SleepLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepLogsTable,
      SleepRow,
      $$SleepLogsTableFilterComposer,
      $$SleepLogsTableOrderingComposer,
      $$SleepLogsTableAnnotationComposer,
      $$SleepLogsTableCreateCompanionBuilder,
      $$SleepLogsTableUpdateCompanionBuilder,
      (SleepRow, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepRow>),
      SleepRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogsTableCreateCompanionBuilder =
    ActivityLogsCompanion Function({
      required String id,
      required String kind,
      Value<int?> durationMinutes,
      Value<int?> steps,
      Value<double?> distanceKm,
      required int recordedAt,
      required String source,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ActivityLogsTableUpdateCompanionBuilder =
    ActivityLogsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<int?> durationMinutes,
      Value<int?> steps,
      Value<double?> distanceKm,
      Value<int> recordedAt,
      Value<String> source,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
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

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivityLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogsTable,
          ActivityRow,
          $$ActivityLogsTableFilterComposer,
          $$ActivityLogsTableOrderingComposer,
          $$ActivityLogsTableAnnotationComposer,
          $$ActivityLogsTableCreateCompanionBuilder,
          $$ActivityLogsTableUpdateCompanionBuilder,
          (
            ActivityRow,
            BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityRow>,
          ),
          ActivityRow,
          PrefetchHooks Function()
        > {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion(
                id: id,
                kind: kind,
                durationMinutes: durationMinutes,
                steps: steps,
                distanceKm: distanceKm,
                recordedAt: recordedAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                Value<int?> durationMinutes = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                required int recordedAt,
                required String source,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogsCompanion.insert(
                id: id,
                kind: kind,
                durationMinutes: durationMinutes,
                steps: steps,
                distanceKm: distanceKm,
                recordedAt: recordedAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityLogsTable, ActivityRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityLogsTable,
                    ActivityRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogsTable,
      ActivityRow,
      $$ActivityLogsTableFilterComposer,
      $$ActivityLogsTableOrderingComposer,
      $$ActivityLogsTableAnnotationComposer,
      $$ActivityLogsTableCreateCompanionBuilder,
      $$ActivityLogsTableUpdateCompanionBuilder,
      (
        ActivityRow,
        BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityRow>,
      ),
      ActivityRow,
      PrefetchHooks Function()
    >;
typedef $$ExerciseSessionsTableCreateCompanionBuilder =
    ExerciseSessionsCompanion Function({
      required String id,
      required String name,
      required String category,
      required int durationMinutes,
      Value<int?> sets,
      Value<int?> reps,
      required int performedAt,
      required String source,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExerciseSessionsTableUpdateCompanionBuilder =
    ExerciseSessionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> durationMinutes,
      Value<int?> sets,
      Value<int?> reps,
      Value<int> performedAt,
      Value<String> source,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ExerciseSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseSessionsTable> {
  $$ExerciseSessionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
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

class $$ExerciseSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseSessionsTable> {
  $$ExerciseSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

class $$ExerciseSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseSessionsTable> {
  $$ExerciseSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExerciseSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseSessionsTable,
          ExerciseSessionRow,
          $$ExerciseSessionsTableFilterComposer,
          $$ExerciseSessionsTableOrderingComposer,
          $$ExerciseSessionsTableAnnotationComposer,
          $$ExerciseSessionsTableCreateCompanionBuilder,
          $$ExerciseSessionsTableUpdateCompanionBuilder,
          (
            ExerciseSessionRow,
            BaseReferences<
              _$AppDatabase,
              $ExerciseSessionsTable,
              ExerciseSessionRow
            >,
          ),
          ExerciseSessionRow,
          PrefetchHooks Function()
        > {
  $$ExerciseSessionsTableTableManager(
    _$AppDatabase db,
    $ExerciseSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int?> sets = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int> performedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSessionsCompanion(
                id: id,
                name: name,
                category: category,
                durationMinutes: durationMinutes,
                sets: sets,
                reps: reps,
                performedAt: performedAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required int durationMinutes,
                Value<int?> sets = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                required int performedAt,
                required String source,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSessionsCompanion.insert(
                id: id,
                name: name,
                category: category,
                durationMinutes: durationMinutes,
                sets: sets,
                reps: reps,
                performedAt: performedAt,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseSessionsTable, ExerciseSessionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ExerciseSessionsTable,
                    ExerciseSessionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseSessionsTable,
      ExerciseSessionRow,
      $$ExerciseSessionsTableFilterComposer,
      $$ExerciseSessionsTableOrderingComposer,
      $$ExerciseSessionsTableAnnotationComposer,
      $$ExerciseSessionsTableCreateCompanionBuilder,
      $$ExerciseSessionsTableUpdateCompanionBuilder,
      (
        ExerciseSessionRow,
        BaseReferences<
          _$AppDatabase,
          $ExerciseSessionsTable,
          ExerciseSessionRow
        >,
      ),
      ExerciseSessionRow,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String name,
  required int weekdays,
  Value<bool> archived,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> weekdays,
  Value<bool> archived,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitRow> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitCompletionsTable, List<HabitCompletionRow>>
  _habitCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitCompletions,
    aliasName: 'habit__id__habit_completion__habit_id',
  );

  $$HabitCompletionsTableProcessedTableManager get habitCompletionsRefs {
    final manager = $$HabitCompletionsTableTableManager(
      $_db,
      $_db.habitCompletions,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
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

  Expression<bool> habitCompletionsRefs(
    Expression<bool> Function($$HabitCompletionsTableFilterComposer f) f,
  ) {
    final $$HabitCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
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

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> habitCompletionsRefs<T extends Object>(
    Expression<T> Function($$HabitCompletionsTableAnnotationComposer a) f,
  ) {
    final $$HabitCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitRow,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitRow, $$HabitsTableReferences),
          HabitRow,
          PrefetchHooks Function({bool habitCompletionsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                weekdays: weekdays,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int weekdays,
                Value<bool> archived = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                weekdays: weekdays,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTable, HabitRow>(table),
                  $$HabitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitCompletionsRefs) db.habitCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitCompletionsRefs)
                    await $_getPrefetchedData<
                      HabitRow,
                      $HabitsTable,
                      HabitCompletionRow
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).habitCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitRow,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitRow, $$HabitsTableReferences),
      HabitRow,
      PrefetchHooks Function({bool habitCompletionsRefs})
    >;
typedef $$HabitCompletionsTableCreateCompanionBuilder =
    HabitCompletionsCompanion Function({
      required String habitId,
      required int day,
      required String status,
      required int recordedAt,
      Value<int> rowid,
    });
typedef $$HabitCompletionsTableUpdateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<String> habitId,
      Value<int> day,
      Value<String> status,
      Value<int> recordedAt,
      Value<int> rowid,
    });

final class $$HabitCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletionRow
        > {
  $$HabitCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_completion__habit_id__habit__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletionRow,
          $$HabitCompletionsTableFilterComposer,
          $$HabitCompletionsTableOrderingComposer,
          $$HabitCompletionsTableAnnotationComposer,
          $$HabitCompletionsTableCreateCompanionBuilder,
          $$HabitCompletionsTableUpdateCompanionBuilder,
          (HabitCompletionRow, $$HabitCompletionsTableReferences),
          HabitCompletionRow,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitCompletionsTableTableManager(
    _$AppDatabase db,
    $HabitCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion(
                habitId: habitId,
                day: day,
                status: status,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required int day,
                required String status,
                required int recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion.insert(
                habitId: habitId,
                day: day,
                status: status,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitCompletionsTable, HabitCompletionRow>(
                    table,
                  ),
                  $$HabitCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitCompletionsTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$HabitCompletionsTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCompletionsTable,
      HabitCompletionRow,
      $$HabitCompletionsTableFilterComposer,
      $$HabitCompletionsTableOrderingComposer,
      $$HabitCompletionsTableAnnotationComposer,
      $$HabitCompletionsTableCreateCompanionBuilder,
      $$HabitCompletionsTableUpdateCompanionBuilder,
      (HabitCompletionRow, $$HabitCompletionsTableReferences),
      HabitCompletionRow,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String name,
  required int weekdays,
  Value<bool> active,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> weekdays,
  Value<bool> active,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, RoutineRow> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineItemsTable, List<RoutineItemRow>>
  _routineItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineItems,
    aliasName: 'routine__id__routine_item__routine_id',
  );

  $$RoutineItemsTableProcessedTableManager get routineItemsRefs {
    final manager = $$RoutineItemsTableTableManager(
      $_db,
      $_db.routineItems,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
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

  Expression<bool> routineItemsRefs(
    Expression<bool> Function($$RoutineItemsTableFilterComposer f) f,
  ) {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableFilterComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
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

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> routineItemsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          RoutineRow,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (RoutineRow, $$RoutinesTableReferences),
          RoutineRow,
          PrefetchHooks Function({bool routineItemsRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                weekdays: weekdays,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int weekdays,
                Value<bool> active = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                weekdays: weekdays,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, RoutineRow>(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (routineItemsRefs) db.routineItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineItemsRefs)
                    await $_getPrefetchedData<
                      RoutineRow,
                      $RoutinesTable,
                      RoutineItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableReferences
                          ._routineItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutinesTableReferences(
                        db,
                        table,
                        p0,
                      ).routineItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      RoutineRow,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (RoutineRow, $$RoutinesTableReferences),
      RoutineRow,
      PrefetchHooks Function({bool routineItemsRefs})
    >;
typedef $$RoutineItemsTableCreateCompanionBuilder =
    RoutineItemsCompanion Function({
      required String id,
      required String routineId,
      required int minuteOfDay,
      required String title,
      required String kind,
      Value<bool> reminder,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineItemsTableUpdateCompanionBuilder =
    RoutineItemsCompanion Function({
      Value<String> id,
      Value<String> routineId,
      Value<int> minuteOfDay,
      Value<String> title,
      Value<String> kind,
      Value<bool> reminder,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineItemsTable, RoutineItemRow> {
  $$RoutineItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_item__routine_id__routine__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlanRecordsTable, List<PlanRecordRow>>
  _planRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planRecords,
    aliasName: 'routine_item__id__routine_completion__item_id',
  );

  $$PlanRecordsTableProcessedTableManager get planRecordsRefs {
    final manager = $$PlanRecordsTableTableManager(
      $_db,
      $_db.planRecords,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableFilterComposer({
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

  ColumnFilters<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminder => $composableBuilder(
    column: $table.reminder,
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

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> planRecordsRefs(
    Expression<bool> Function($$PlanRecordsTableFilterComposer f) f,
  ) {
    final $$PlanRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planRecords,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanRecordsTableFilterComposer(
            $db: $db,
            $table: $db.planRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableOrderingComposer({
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

  ColumnOrderings<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminder => $composableBuilder(
    column: $table.reminder,
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

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get reminder =>
      $composableBuilder(column: $table.reminder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> planRecordsRefs<T extends Object>(
    Expression<T> Function($$PlanRecordsTableAnnotationComposer a) f,
  ) {
    final $$PlanRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planRecords,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.planRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineItemsTable,
          RoutineItemRow,
          $$RoutineItemsTableFilterComposer,
          $$RoutineItemsTableOrderingComposer,
          $$RoutineItemsTableAnnotationComposer,
          $$RoutineItemsTableCreateCompanionBuilder,
          $$RoutineItemsTableUpdateCompanionBuilder,
          (RoutineItemRow, $$RoutineItemsTableReferences),
          RoutineItemRow,
          PrefetchHooks Function({bool routineId, bool planRecordsRefs})
        > {
  $$RoutineItemsTableTableManager(_$AppDatabase db, $RoutineItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<int> minuteOfDay = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> reminder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemsCompanion(
                id: id,
                routineId: routineId,
                minuteOfDay: minuteOfDay,
                title: title,
                kind: kind,
                reminder: reminder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineId,
                required int minuteOfDay,
                required String title,
                required String kind,
                Value<bool> reminder = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemsCompanion.insert(
                id: id,
                routineId: routineId,
                minuteOfDay: minuteOfDay,
                title: title,
                kind: kind,
                reminder: reminder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineItemsTable, RoutineItemRow>(table),
                  $$RoutineItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineId = false, planRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planRecordsRefs) db.planRecords,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$RoutineItemsTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$RoutineItemsTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineItemRow,
                          $RoutineItemsTable,
                          PlanRecordRow
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineItemsTableReferences
                              ._planRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).planRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineItemsTable,
      RoutineItemRow,
      $$RoutineItemsTableFilterComposer,
      $$RoutineItemsTableOrderingComposer,
      $$RoutineItemsTableAnnotationComposer,
      $$RoutineItemsTableCreateCompanionBuilder,
      $$RoutineItemsTableUpdateCompanionBuilder,
      (RoutineItemRow, $$RoutineItemsTableReferences),
      RoutineItemRow,
      PrefetchHooks Function({bool routineId, bool planRecordsRefs})
    >;
typedef $$PlanRecordsTableCreateCompanionBuilder =
    PlanRecordsCompanion Function({
      required String itemId,
      required int day,
      required String outcome,
      Value<int?> rescheduledMinute,
      required int recordedAt,
      Value<int> rowid,
    });
typedef $$PlanRecordsTableUpdateCompanionBuilder =
    PlanRecordsCompanion Function({
      Value<String> itemId,
      Value<int> day,
      Value<String> outcome,
      Value<int?> rescheduledMinute,
      Value<int> recordedAt,
      Value<int> rowid,
    });

final class $$PlanRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $PlanRecordsTable, PlanRecordRow> {
  $$PlanRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutineItemsTable _itemIdTable(_$AppDatabase db) => db.routineItems
      .createAlias('routine_completion__item_id__routine_item__id');

  $$RoutineItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$RoutineItemsTableTableManager(
      $_db,
      $_db.routineItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanRecordsTable> {
  $$PlanRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rescheduledMinute => $composableBuilder(
    column: $table.rescheduledMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineItemsTableFilterComposer get itemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableFilterComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanRecordsTable> {
  $$PlanRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rescheduledMinute => $composableBuilder(
    column: $table.rescheduledMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineItemsTableOrderingComposer get itemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableOrderingComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanRecordsTable> {
  $$PlanRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get rescheduledMinute => $composableBuilder(
    column: $table.rescheduledMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$RoutineItemsTableAnnotationComposer get itemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanRecordsTable,
          PlanRecordRow,
          $$PlanRecordsTableFilterComposer,
          $$PlanRecordsTableOrderingComposer,
          $$PlanRecordsTableAnnotationComposer,
          $$PlanRecordsTableCreateCompanionBuilder,
          $$PlanRecordsTableUpdateCompanionBuilder,
          (PlanRecordRow, $$PlanRecordsTableReferences),
          PlanRecordRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$PlanRecordsTableTableManager(_$AppDatabase db, $PlanRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int?> rescheduledMinute = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanRecordsCompanion(
                itemId: itemId,
                day: day,
                outcome: outcome,
                rescheduledMinute: rescheduledMinute,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required int day,
                required String outcome,
                Value<int?> rescheduledMinute = const Value.absent(),
                required int recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlanRecordsCompanion.insert(
                itemId: itemId,
                day: day,
                outcome: outcome,
                rescheduledMinute: rescheduledMinute,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanRecordsTable, PlanRecordRow>(table),
                  $$PlanRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$PlanRecordsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$PlanRecordsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanRecordsTable,
      PlanRecordRow,
      $$PlanRecordsTableFilterComposer,
      $$PlanRecordsTableOrderingComposer,
      $$PlanRecordsTableAnnotationComposer,
      $$PlanRecordsTableCreateCompanionBuilder,
      $$PlanRecordsTableUpdateCompanionBuilder,
      (PlanRecordRow, $$PlanRecordsTableReferences),
      PlanRecordRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$PostureSessionsTableCreateCompanionBuilder =
    PostureSessionsCompanion Function({
      required String id,
      required int recordedAt,
      required String view,
      required int framesUsed,
      required String confidence,
      required double visibility,
      required String source,
      required String method,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$PostureSessionsTableUpdateCompanionBuilder =
    PostureSessionsCompanion Function({
      Value<String> id,
      Value<int> recordedAt,
      Value<String> view,
      Value<int> framesUsed,
      Value<String> confidence,
      Value<double> visibility,
      Value<String> source,
      Value<String> method,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$PostureSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PostureSessionsTable,
          PostureSessionRow
        > {
  $$PostureSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PostureMetricsTable, List<PostureMetricRow>>
  _postureMetricsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.postureMetrics,
    aliasName: 'posture_session__id__posture_metric__session_id',
  );

  $$PostureMetricsTableProcessedTableManager get postureMetricsRefs {
    final manager = $$PostureMetricsTableTableManager(
      $_db,
      $_db.postureMetrics,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postureMetricsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PostureSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PostureSessionsTable> {
  $$PostureSessionsTableFilterComposer({
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

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get visibility => $composableBuilder(
    column: $table.visibility,
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

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> postureMetricsRefs(
    Expression<bool> Function($$PostureMetricsTableFilterComposer f) f,
  ) {
    final $$PostureMetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postureMetrics,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostureMetricsTableFilterComposer(
            $db: $db,
            $table: $db.postureMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostureSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PostureSessionsTable> {
  $$PostureSessionsTableOrderingComposer({
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

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get visibility => $composableBuilder(
    column: $table.visibility,
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostureSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostureSessionsTable> {
  $$PostureSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get view =>
      $composableBuilder(column: $table.view, builder: (column) => column);

  GeneratedColumn<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> postureMetricsRefs<T extends Object>(
    Expression<T> Function($$PostureMetricsTableAnnotationComposer a) f,
  ) {
    final $$PostureMetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postureMetrics,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostureMetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.postureMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostureSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostureSessionsTable,
          PostureSessionRow,
          $$PostureSessionsTableFilterComposer,
          $$PostureSessionsTableOrderingComposer,
          $$PostureSessionsTableAnnotationComposer,
          $$PostureSessionsTableCreateCompanionBuilder,
          $$PostureSessionsTableUpdateCompanionBuilder,
          (PostureSessionRow, $$PostureSessionsTableReferences),
          PostureSessionRow,
          PrefetchHooks Function({bool postureMetricsRefs})
        > {
  $$PostureSessionsTableTableManager(
    _$AppDatabase db,
    $PostureSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostureSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostureSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostureSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String> view = const Value.absent(),
                Value<int> framesUsed = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<double> visibility = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostureSessionsCompanion(
                id: id,
                recordedAt: recordedAt,
                view: view,
                framesUsed: framesUsed,
                confidence: confidence,
                visibility: visibility,
                source: source,
                method: method,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int recordedAt,
                required String view,
                required int framesUsed,
                required String confidence,
                required double visibility,
                required String source,
                required String method,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PostureSessionsCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                view: view,
                framesUsed: framesUsed,
                confidence: confidence,
                visibility: visibility,
                source: source,
                method: method,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PostureSessionsTable, PostureSessionRow>(table),
                  $$PostureSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postureMetricsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (postureMetricsRefs) db.postureMetrics,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postureMetricsRefs)
                    await $_getPrefetchedData<
                      PostureSessionRow,
                      $PostureSessionsTable,
                      PostureMetricRow
                    >(
                      currentTable: table,
                      referencedTable: $$PostureSessionsTableReferences
                          ._postureMetricsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PostureSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).postureMetricsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PostureSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostureSessionsTable,
      PostureSessionRow,
      $$PostureSessionsTableFilterComposer,
      $$PostureSessionsTableOrderingComposer,
      $$PostureSessionsTableAnnotationComposer,
      $$PostureSessionsTableCreateCompanionBuilder,
      $$PostureSessionsTableUpdateCompanionBuilder,
      (PostureSessionRow, $$PostureSessionsTableReferences),
      PostureSessionRow,
      PrefetchHooks Function({bool postureMetricsRefs})
    >;
typedef $$PostureMetricsTableCreateCompanionBuilder =
    PostureMetricsCompanion Function({
      required String sessionId,
      required String metric,
      required double value,
      required String unit,
      required String direction,
      required String band,
      required double spread,
      required String confidence,
      Value<int> rowid,
    });
typedef $$PostureMetricsTableUpdateCompanionBuilder =
    PostureMetricsCompanion Function({
      Value<String> sessionId,
      Value<String> metric,
      Value<double> value,
      Value<String> unit,
      Value<String> direction,
      Value<String> band,
      Value<double> spread,
      Value<String> confidence,
      Value<int> rowid,
    });

final class $$PostureMetricsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PostureMetricsTable, PostureMetricRow> {
  $$PostureMetricsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PostureSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .postureSessions
      .createAlias('posture_metric__session_id__posture_session__id');

  $$PostureSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$PostureSessionsTableTableManager(
      $_db,
      $_db.postureSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostureMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $PostureMetricsTable> {
  $$PostureMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
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

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get band => $composableBuilder(
    column: $table.band,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spread => $composableBuilder(
    column: $table.spread,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  $$PostureSessionsTableFilterComposer get sessionId {
    final $$PostureSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.postureSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostureSessionsTableFilterComposer(
            $db: $db,
            $table: $db.postureSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostureMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $PostureMetricsTable> {
  $$PostureMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
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

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get band => $composableBuilder(
    column: $table.band,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spread => $composableBuilder(
    column: $table.spread,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  $$PostureSessionsTableOrderingComposer get sessionId {
    final $$PostureSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.postureSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostureSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.postureSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostureMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostureMetricsTable> {
  $$PostureMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get band =>
      $composableBuilder(column: $table.band, builder: (column) => column);

  GeneratedColumn<double> get spread =>
      $composableBuilder(column: $table.spread, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  $$PostureSessionsTableAnnotationComposer get sessionId {
    final $$PostureSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.postureSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostureSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.postureSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostureMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostureMetricsTable,
          PostureMetricRow,
          $$PostureMetricsTableFilterComposer,
          $$PostureMetricsTableOrderingComposer,
          $$PostureMetricsTableAnnotationComposer,
          $$PostureMetricsTableCreateCompanionBuilder,
          $$PostureMetricsTableUpdateCompanionBuilder,
          (PostureMetricRow, $$PostureMetricsTableReferences),
          PostureMetricRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$PostureMetricsTableTableManager(
    _$AppDatabase db,
    $PostureMetricsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostureMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostureMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostureMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> band = const Value.absent(),
                Value<double> spread = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostureMetricsCompanion(
                sessionId: sessionId,
                metric: metric,
                value: value,
                unit: unit,
                direction: direction,
                band: band,
                spread: spread,
                confidence: confidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String metric,
                required double value,
                required String unit,
                required String direction,
                required String band,
                required double spread,
                required String confidence,
                Value<int> rowid = const Value.absent(),
              }) => PostureMetricsCompanion.insert(
                sessionId: sessionId,
                metric: metric,
                value: value,
                unit: unit,
                direction: direction,
                band: band,
                spread: spread,
                confidence: confidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PostureMetricsTable, PostureMetricRow>(table),
                  $$PostureMetricsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$PostureMetricsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$PostureMetricsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostureMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostureMetricsTable,
      PostureMetricRow,
      $$PostureMetricsTableFilterComposer,
      $$PostureMetricsTableOrderingComposer,
      $$PostureMetricsTableAnnotationComposer,
      $$PostureMetricsTableCreateCompanionBuilder,
      $$PostureMetricsTableUpdateCompanionBuilder,
      (PostureMetricRow, $$PostureMetricsTableReferences),
      PostureMetricRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$FaceAnalysesTableCreateCompanionBuilder =
    FaceAnalysesCompanion Function({
      required String id,
      required int recordedAt,
      required String shape,
      Value<String?> alsoLike,
      required String confidence,
      required int framesUsed,
      required String source,
      required String method,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$FaceAnalysesTableUpdateCompanionBuilder =
    FaceAnalysesCompanion Function({
      Value<String> id,
      Value<int> recordedAt,
      Value<String> shape,
      Value<String?> alsoLike,
      Value<String> confidence,
      Value<int> framesUsed,
      Value<String> source,
      Value<String> method,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$FaceAnalysesTableReferences
    extends BaseReferences<_$AppDatabase, $FaceAnalysesTable, FaceAnalysisRow> {
  $$FaceAnalysesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FaceMetricsTable, List<FaceMetricRow>>
  _faceMetricsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.faceMetrics,
    aliasName: 'face_analysis__id__face_metric__analysis_id',
  );

  $$FaceMetricsTableProcessedTableManager get faceMetricsRefs {
    final manager = $$FaceMetricsTableTableManager(
      $_db,
      $_db.faceMetrics,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_faceMetricsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FaceAnalysesTableFilterComposer
    extends Composer<_$AppDatabase, $FaceAnalysesTable> {
  $$FaceAnalysesTableFilterComposer({
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

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shape => $composableBuilder(
    column: $table.shape,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alsoLike => $composableBuilder(
    column: $table.alsoLike,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
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

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> faceMetricsRefs(
    Expression<bool> Function($$FaceMetricsTableFilterComposer f) f,
  ) {
    final $$FaceMetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.faceMetrics,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FaceMetricsTableFilterComposer(
            $db: $db,
            $table: $db.faceMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FaceAnalysesTableOrderingComposer
    extends Composer<_$AppDatabase, $FaceAnalysesTable> {
  $$FaceAnalysesTableOrderingComposer({
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

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shape => $composableBuilder(
    column: $table.shape,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alsoLike => $composableBuilder(
    column: $table.alsoLike,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FaceAnalysesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FaceAnalysesTable> {
  $$FaceAnalysesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => column);

  GeneratedColumn<String> get alsoLike =>
      $composableBuilder(column: $table.alsoLike, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get framesUsed => $composableBuilder(
    column: $table.framesUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> faceMetricsRefs<T extends Object>(
    Expression<T> Function($$FaceMetricsTableAnnotationComposer a) f,
  ) {
    final $$FaceMetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.faceMetrics,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FaceMetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.faceMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FaceAnalysesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FaceAnalysesTable,
          FaceAnalysisRow,
          $$FaceAnalysesTableFilterComposer,
          $$FaceAnalysesTableOrderingComposer,
          $$FaceAnalysesTableAnnotationComposer,
          $$FaceAnalysesTableCreateCompanionBuilder,
          $$FaceAnalysesTableUpdateCompanionBuilder,
          (FaceAnalysisRow, $$FaceAnalysesTableReferences),
          FaceAnalysisRow,
          PrefetchHooks Function({bool faceMetricsRefs})
        > {
  $$FaceAnalysesTableTableManager(_$AppDatabase db, $FaceAnalysesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FaceAnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FaceAnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FaceAnalysesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String> shape = const Value.absent(),
                Value<String?> alsoLike = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<int> framesUsed = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FaceAnalysesCompanion(
                id: id,
                recordedAt: recordedAt,
                shape: shape,
                alsoLike: alsoLike,
                confidence: confidence,
                framesUsed: framesUsed,
                source: source,
                method: method,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int recordedAt,
                required String shape,
                Value<String?> alsoLike = const Value.absent(),
                required String confidence,
                required int framesUsed,
                required String source,
                required String method,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FaceAnalysesCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                shape: shape,
                alsoLike: alsoLike,
                confidence: confidence,
                framesUsed: framesUsed,
                source: source,
                method: method,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FaceAnalysesTable, FaceAnalysisRow>(table),
                  $$FaceAnalysesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({faceMetricsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (faceMetricsRefs) db.faceMetrics],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (faceMetricsRefs)
                    await $_getPrefetchedData<
                      FaceAnalysisRow,
                      $FaceAnalysesTable,
                      FaceMetricRow
                    >(
                      currentTable: table,
                      referencedTable: $$FaceAnalysesTableReferences
                          ._faceMetricsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FaceAnalysesTableReferences(
                            db,
                            table,
                            p0,
                          ).faceMetricsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.analysisId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FaceAnalysesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FaceAnalysesTable,
      FaceAnalysisRow,
      $$FaceAnalysesTableFilterComposer,
      $$FaceAnalysesTableOrderingComposer,
      $$FaceAnalysesTableAnnotationComposer,
      $$FaceAnalysesTableCreateCompanionBuilder,
      $$FaceAnalysesTableUpdateCompanionBuilder,
      (FaceAnalysisRow, $$FaceAnalysesTableReferences),
      FaceAnalysisRow,
      PrefetchHooks Function({bool faceMetricsRefs})
    >;
typedef $$FaceMetricsTableCreateCompanionBuilder =
    FaceMetricsCompanion Function({
      required String analysisId,
      required String metric,
      required double value,
      Value<int> rowid,
    });
typedef $$FaceMetricsTableUpdateCompanionBuilder =
    FaceMetricsCompanion Function({
      Value<String> analysisId,
      Value<String> metric,
      Value<double> value,
      Value<int> rowid,
    });

final class $$FaceMetricsTableReferences
    extends BaseReferences<_$AppDatabase, $FaceMetricsTable, FaceMetricRow> {
  $$FaceMetricsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FaceAnalysesTable _analysisIdTable(_$AppDatabase db) => db
      .faceAnalyses
      .createAlias('face_metric__analysis_id__face_analysis__id');

  $$FaceAnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$FaceAnalysesTableTableManager(
      $_db,
      $_db.faceAnalyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FaceMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $FaceMetricsTable> {
  $$FaceMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$FaceAnalysesTableFilterComposer get analysisId {
    final $$FaceAnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.faceAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FaceAnalysesTableFilterComposer(
            $db: $db,
            $table: $db.faceAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $FaceMetricsTable> {
  $$FaceMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$FaceAnalysesTableOrderingComposer get analysisId {
    final $$FaceAnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.faceAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FaceAnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.faceAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FaceMetricsTable> {
  $$FaceMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$FaceAnalysesTableAnnotationComposer get analysisId {
    final $$FaceAnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.faceAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FaceAnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.faceAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FaceMetricsTable,
          FaceMetricRow,
          $$FaceMetricsTableFilterComposer,
          $$FaceMetricsTableOrderingComposer,
          $$FaceMetricsTableAnnotationComposer,
          $$FaceMetricsTableCreateCompanionBuilder,
          $$FaceMetricsTableUpdateCompanionBuilder,
          (FaceMetricRow, $$FaceMetricsTableReferences),
          FaceMetricRow,
          PrefetchHooks Function({bool analysisId})
        > {
  $$FaceMetricsTableTableManager(_$AppDatabase db, $FaceMetricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FaceMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FaceMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FaceMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> analysisId = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FaceMetricsCompanion(
                analysisId: analysisId,
                metric: metric,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String analysisId,
                required String metric,
                required double value,
                Value<int> rowid = const Value.absent(),
              }) => FaceMetricsCompanion.insert(
                analysisId: analysisId,
                metric: metric,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FaceMetricsTable, FaceMetricRow>(table),
                  $$FaceMetricsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$FaceMetricsTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$FaceMetricsTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FaceMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FaceMetricsTable,
      FaceMetricRow,
      $$FaceMetricsTableFilterComposer,
      $$FaceMetricsTableOrderingComposer,
      $$FaceMetricsTableAnnotationComposer,
      $$FaceMetricsTableCreateCompanionBuilder,
      $$FaceMetricsTableUpdateCompanionBuilder,
      (FaceMetricRow, $$FaceMetricsTableReferences),
      FaceMetricRow,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$StyleFavoritesTableCreateCompanionBuilder =
    StyleFavoritesCompanion Function({
      required String itemId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$StyleFavoritesTableUpdateCompanionBuilder =
    StyleFavoritesCompanion Function({
      Value<String> itemId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$StyleFavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $StyleFavoritesTable> {
  $$StyleFavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StyleFavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $StyleFavoritesTable> {
  $$StyleFavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StyleFavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StyleFavoritesTable> {
  $$StyleFavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StyleFavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StyleFavoritesTable,
          StyleFavoriteRow,
          $$StyleFavoritesTableFilterComposer,
          $$StyleFavoritesTableOrderingComposer,
          $$StyleFavoritesTableAnnotationComposer,
          $$StyleFavoritesTableCreateCompanionBuilder,
          $$StyleFavoritesTableUpdateCompanionBuilder,
          (
            StyleFavoriteRow,
            BaseReferences<
              _$AppDatabase,
              $StyleFavoritesTable,
              StyleFavoriteRow
            >,
          ),
          StyleFavoriteRow,
          PrefetchHooks Function()
        > {
  $$StyleFavoritesTableTableManager(
    _$AppDatabase db,
    $StyleFavoritesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StyleFavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StyleFavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StyleFavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StyleFavoritesCompanion(
                itemId: itemId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StyleFavoritesCompanion.insert(
                itemId: itemId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StyleFavoritesTable, StyleFavoriteRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StyleFavoritesTable,
                    StyleFavoriteRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StyleFavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StyleFavoritesTable,
      StyleFavoriteRow,
      $$StyleFavoritesTableFilterComposer,
      $$StyleFavoritesTableOrderingComposer,
      $$StyleFavoritesTableAnnotationComposer,
      $$StyleFavoritesTableCreateCompanionBuilder,
      $$StyleFavoritesTableUpdateCompanionBuilder,
      (
        StyleFavoriteRow,
        BaseReferences<_$AppDatabase, $StyleFavoritesTable, StyleFavoriteRow>,
      ),
      StyleFavoriteRow,
      PrefetchHooks Function()
    >;
typedef $$SnapshotsTableCreateCompanionBuilder = SnapshotsCompanion Function({
  required String id,
  required String kind,
  required int takenAt,
  required Uint8List jpeg,
  required int width,
  required int height,
  Value<String?> note,
  required int createdAt,
  Value<double?> leftEyeX,
  Value<double?> leftEyeY,
  Value<double?> rightEyeX,
  Value<double?> rightEyeY,
  Value<bool> alignChecked,
  Value<int> rowid,
});
typedef $$SnapshotsTableUpdateCompanionBuilder = SnapshotsCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<int> takenAt,
  Value<Uint8List> jpeg,
  Value<int> width,
  Value<int> height,
  Value<String?> note,
  Value<int> createdAt,
  Value<double?> leftEyeX,
  Value<double?> leftEyeY,
  Value<double?> rightEyeX,
  Value<double?> rightEyeY,
  Value<bool> alignChecked,
  Value<int> rowid,
});

class $$SnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get jpeg => $composableBuilder(
    column: $table.jpeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftEyeX => $composableBuilder(
    column: $table.leftEyeX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftEyeY => $composableBuilder(
    column: $table.leftEyeY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightEyeX => $composableBuilder(
    column: $table.rightEyeX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightEyeY => $composableBuilder(
    column: $table.rightEyeY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alignChecked => $composableBuilder(
    column: $table.alignChecked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get jpeg => $composableBuilder(
    column: $table.jpeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftEyeX => $composableBuilder(
    column: $table.leftEyeX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftEyeY => $composableBuilder(
    column: $table.leftEyeY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightEyeX => $composableBuilder(
    column: $table.rightEyeX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightEyeY => $composableBuilder(
    column: $table.rightEyeY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alignChecked => $composableBuilder(
    column: $table.alignChecked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<Uint8List> get jpeg =>
      $composableBuilder(column: $table.jpeg, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get leftEyeX =>
      $composableBuilder(column: $table.leftEyeX, builder: (column) => column);

  GeneratedColumn<double> get leftEyeY =>
      $composableBuilder(column: $table.leftEyeY, builder: (column) => column);

  GeneratedColumn<double> get rightEyeX =>
      $composableBuilder(column: $table.rightEyeX, builder: (column) => column);

  GeneratedColumn<double> get rightEyeY =>
      $composableBuilder(column: $table.rightEyeY, builder: (column) => column);

  GeneratedColumn<bool> get alignChecked => $composableBuilder(
    column: $table.alignChecked,
    builder: (column) => column,
  );
}

class $$SnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnapshotsTable,
          SnapshotRow,
          $$SnapshotsTableFilterComposer,
          $$SnapshotsTableOrderingComposer,
          $$SnapshotsTableAnnotationComposer,
          $$SnapshotsTableCreateCompanionBuilder,
          $$SnapshotsTableUpdateCompanionBuilder,
          (
            SnapshotRow,
            BaseReferences<_$AppDatabase, $SnapshotsTable, SnapshotRow>,
          ),
          SnapshotRow,
          PrefetchHooks Function()
        > {
  $$SnapshotsTableTableManager(_$AppDatabase db, $SnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> takenAt = const Value.absent(),
                Value<Uint8List> jpeg = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<double?> leftEyeX = const Value.absent(),
                Value<double?> leftEyeY = const Value.absent(),
                Value<double?> rightEyeX = const Value.absent(),
                Value<double?> rightEyeY = const Value.absent(),
                Value<bool> alignChecked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion(
                id: id,
                kind: kind,
                takenAt: takenAt,
                jpeg: jpeg,
                width: width,
                height: height,
                note: note,
                createdAt: createdAt,
                leftEyeX: leftEyeX,
                leftEyeY: leftEyeY,
                rightEyeX: rightEyeX,
                rightEyeY: rightEyeY,
                alignChecked: alignChecked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required int takenAt,
                required Uint8List jpeg,
                required int width,
                required int height,
                Value<String?> note = const Value.absent(),
                required int createdAt,
                Value<double?> leftEyeX = const Value.absent(),
                Value<double?> leftEyeY = const Value.absent(),
                Value<double?> rightEyeX = const Value.absent(),
                Value<double?> rightEyeY = const Value.absent(),
                Value<bool> alignChecked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion.insert(
                id: id,
                kind: kind,
                takenAt: takenAt,
                jpeg: jpeg,
                width: width,
                height: height,
                note: note,
                createdAt: createdAt,
                leftEyeX: leftEyeX,
                leftEyeY: leftEyeY,
                rightEyeX: rightEyeX,
                rightEyeY: rightEyeY,
                alignChecked: alignChecked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SnapshotsTable, SnapshotRow>(table),
                  BaseReferences<_$AppDatabase, $SnapshotsTable, SnapshotRow>(
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

typedef $$SnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnapshotsTable,
      SnapshotRow,
      $$SnapshotsTableFilterComposer,
      $$SnapshotsTableOrderingComposer,
      $$SnapshotsTableAnnotationComposer,
      $$SnapshotsTableCreateCompanionBuilder,
      $$SnapshotsTableUpdateCompanionBuilder,
      (
        SnapshotRow,
        BaseReferences<_$AppDatabase, $SnapshotsTable, SnapshotRow>,
      ),
      SnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$WardrobeItemsTableCreateCompanionBuilder =
    WardrobeItemsCompanion Function({
      required String id,
      required String name,
      required String category,
      required String colorHex,
      required String pattern,
      required int formality,
      Value<String> occasions,
      Value<bool> favorite,
      Value<Uint8List?> photo,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$WardrobeItemsTableUpdateCompanionBuilder =
    WardrobeItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String> colorHex,
      Value<String> pattern,
      Value<int> formality,
      Value<String> occasions,
      Value<bool> favorite,
      Value<Uint8List?> photo,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$WardrobeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WardrobeItemsTable, WardrobeRow> {
  $$WardrobeItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OutfitItemsTable, List<OutfitItemRow>>
  _outfitItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.outfitItems,
    aliasName: 'wardrobe_item__id__outfit_item__item_id',
  );

  $$OutfitItemsTableProcessedTableManager get outfitItemsRefs {
    final manager = $$OutfitItemsTableTableManager(
      $_db,
      $_db.outfitItems,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_outfitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WardrobeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WardrobeItemsTable> {
  $$WardrobeItemsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get formality => $composableBuilder(
    column: $table.formality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occasions => $composableBuilder(
    column: $table.occasions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
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

  Expression<bool> outfitItemsRefs(
    Expression<bool> Function($$OutfitItemsTableFilterComposer f) f,
  ) {
    final $$OutfitItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitItemsTableFilterComposer(
            $db: $db,
            $table: $db.outfitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WardrobeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WardrobeItemsTable> {
  $$WardrobeItemsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get formality => $composableBuilder(
    column: $table.formality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occasions => $composableBuilder(
    column: $table.occasions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
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

class $$WardrobeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WardrobeItemsTable> {
  $$WardrobeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<int> get formality =>
      $composableBuilder(column: $table.formality, builder: (column) => column);

  GeneratedColumn<String> get occasions =>
      $composableBuilder(column: $table.occasions, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<Uint8List> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> outfitItemsRefs<T extends Object>(
    Expression<T> Function($$OutfitItemsTableAnnotationComposer a) f,
  ) {
    final $$OutfitItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.outfitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WardrobeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WardrobeItemsTable,
          WardrobeRow,
          $$WardrobeItemsTableFilterComposer,
          $$WardrobeItemsTableOrderingComposer,
          $$WardrobeItemsTableAnnotationComposer,
          $$WardrobeItemsTableCreateCompanionBuilder,
          $$WardrobeItemsTableUpdateCompanionBuilder,
          (WardrobeRow, $$WardrobeItemsTableReferences),
          WardrobeRow,
          PrefetchHooks Function({bool outfitItemsRefs})
        > {
  $$WardrobeItemsTableTableManager(_$AppDatabase db, $WardrobeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WardrobeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WardrobeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WardrobeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> formality = const Value.absent(),
                Value<String> occasions = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WardrobeItemsCompanion(
                id: id,
                name: name,
                category: category,
                colorHex: colorHex,
                pattern: pattern,
                formality: formality,
                occasions: occasions,
                favorite: favorite,
                photo: photo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required String colorHex,
                required String pattern,
                required int formality,
                Value<String> occasions = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WardrobeItemsCompanion.insert(
                id: id,
                name: name,
                category: category,
                colorHex: colorHex,
                pattern: pattern,
                formality: formality,
                occasions: occasions,
                favorite: favorite,
                photo: photo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WardrobeItemsTable, WardrobeRow>(table),
                  $$WardrobeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({outfitItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (outfitItemsRefs) db.outfitItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (outfitItemsRefs)
                    await $_getPrefetchedData<
                      WardrobeRow,
                      $WardrobeItemsTable,
                      OutfitItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$WardrobeItemsTableReferences
                          ._outfitItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WardrobeItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).outfitItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.itemId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WardrobeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WardrobeItemsTable,
      WardrobeRow,
      $$WardrobeItemsTableFilterComposer,
      $$WardrobeItemsTableOrderingComposer,
      $$WardrobeItemsTableAnnotationComposer,
      $$WardrobeItemsTableCreateCompanionBuilder,
      $$WardrobeItemsTableUpdateCompanionBuilder,
      (WardrobeRow, $$WardrobeItemsTableReferences),
      WardrobeRow,
      PrefetchHooks Function({bool outfitItemsRefs})
    >;
typedef $$OutfitsTableCreateCompanionBuilder = OutfitsCompanion Function({
  required String id,
  required String occasion,
  required int createdAt,
  Value<int> rowid,
});
typedef $$OutfitsTableUpdateCompanionBuilder = OutfitsCompanion Function({
  Value<String> id,
  Value<String> occasion,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$OutfitsTableReferences
    extends BaseReferences<_$AppDatabase, $OutfitsTable, OutfitRow> {
  $$OutfitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OutfitItemsTable, List<OutfitItemRow>>
  _outfitItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.outfitItems,
    aliasName: 'outfit__id__outfit_item__outfit_id',
  );

  $$OutfitItemsTableProcessedTableManager get outfitItemsRefs {
    final manager = $$OutfitItemsTableTableManager(
      $_db,
      $_db.outfitItems,
    ).filter((f) => f.outfitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_outfitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OutfitWearsTable, List<OutfitWearRow>>
  _outfitWearsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.outfitWears,
    aliasName: 'outfit__id__outfit_wear__outfit_id',
  );

  $$OutfitWearsTableProcessedTableManager get outfitWearsRefs {
    final manager = $$OutfitWearsTableTableManager(
      $_db,
      $_db.outfitWears,
    ).filter((f) => f.outfitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_outfitWearsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OutfitsTableFilterComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableFilterComposer({
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

  ColumnFilters<String> get occasion => $composableBuilder(
    column: $table.occasion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> outfitItemsRefs(
    Expression<bool> Function($$OutfitItemsTableFilterComposer f) f,
  ) {
    final $$OutfitItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitItems,
      getReferencedColumn: (t) => t.outfitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitItemsTableFilterComposer(
            $db: $db,
            $table: $db.outfitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outfitWearsRefs(
    Expression<bool> Function($$OutfitWearsTableFilterComposer f) f,
  ) {
    final $$OutfitWearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitWears,
      getReferencedColumn: (t) => t.outfitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitWearsTableFilterComposer(
            $db: $db,
            $table: $db.outfitWears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OutfitsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableOrderingComposer({
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

  ColumnOrderings<String> get occasion => $composableBuilder(
    column: $table.occasion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutfitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutfitsTable> {
  $$OutfitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get occasion =>
      $composableBuilder(column: $table.occasion, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> outfitItemsRefs<T extends Object>(
    Expression<T> Function($$OutfitItemsTableAnnotationComposer a) f,
  ) {
    final $$OutfitItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitItems,
      getReferencedColumn: (t) => t.outfitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.outfitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> outfitWearsRefs<T extends Object>(
    Expression<T> Function($$OutfitWearsTableAnnotationComposer a) f,
  ) {
    final $$OutfitWearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.outfitWears,
      getReferencedColumn: (t) => t.outfitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitWearsTableAnnotationComposer(
            $db: $db,
            $table: $db.outfitWears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OutfitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutfitsTable,
          OutfitRow,
          $$OutfitsTableFilterComposer,
          $$OutfitsTableOrderingComposer,
          $$OutfitsTableAnnotationComposer,
          $$OutfitsTableCreateCompanionBuilder,
          $$OutfitsTableUpdateCompanionBuilder,
          (OutfitRow, $$OutfitsTableReferences),
          OutfitRow,
          PrefetchHooks Function({bool outfitItemsRefs, bool outfitWearsRefs})
        > {
  $$OutfitsTableTableManager(_$AppDatabase db, $OutfitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutfitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutfitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutfitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> occasion = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutfitsCompanion(
                id: id,
                occasion: occasion,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String occasion,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OutfitsCompanion.insert(
                id: id,
                occasion: occasion,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutfitsTable, OutfitRow>(table),
                  $$OutfitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({outfitItemsRefs = false, outfitWearsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (outfitItemsRefs) db.outfitItems,
                    if (outfitWearsRefs) db.outfitWears,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (outfitItemsRefs)
                        await $_getPrefetchedData<
                          OutfitRow,
                          $OutfitsTable,
                          OutfitItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$OutfitsTableReferences
                              ._outfitItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OutfitsTableReferences(
                                db,
                                table,
                                p0,
                              ).outfitItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.outfitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (outfitWearsRefs)
                        await $_getPrefetchedData<
                          OutfitRow,
                          $OutfitsTable,
                          OutfitWearRow
                        >(
                          currentTable: table,
                          referencedTable: $$OutfitsTableReferences
                              ._outfitWearsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OutfitsTableReferences(
                                db,
                                table,
                                p0,
                              ).outfitWearsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.outfitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OutfitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutfitsTable,
      OutfitRow,
      $$OutfitsTableFilterComposer,
      $$OutfitsTableOrderingComposer,
      $$OutfitsTableAnnotationComposer,
      $$OutfitsTableCreateCompanionBuilder,
      $$OutfitsTableUpdateCompanionBuilder,
      (OutfitRow, $$OutfitsTableReferences),
      OutfitRow,
      PrefetchHooks Function({bool outfitItemsRefs, bool outfitWearsRefs})
    >;
typedef $$OutfitItemsTableCreateCompanionBuilder =
    OutfitItemsCompanion Function({
      required String outfitId,
      required String itemId,
      Value<int> rowid,
    });
typedef $$OutfitItemsTableUpdateCompanionBuilder =
    OutfitItemsCompanion Function({
      Value<String> outfitId,
      Value<String> itemId,
      Value<int> rowid,
    });

final class $$OutfitItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OutfitItemsTable, OutfitItemRow> {
  $$OutfitItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OutfitsTable _outfitIdTable(_$AppDatabase db) =>
      db.outfits.createAlias('outfit_item__outfit_id__outfit__id');

  $$OutfitsTableProcessedTableManager get outfitId {
    final $_column = $_itemColumn<String>('outfit_id')!;

    final manager = $$OutfitsTableTableManager(
      $_db,
      $_db.outfits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_outfitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WardrobeItemsTable _itemIdTable(_$AppDatabase db) =>
      db.wardrobeItems.createAlias('outfit_item__item_id__wardrobe_item__id');

  $$WardrobeItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$WardrobeItemsTableTableManager(
      $_db,
      $_db.wardrobeItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OutfitItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OutfitItemsTable> {
  $$OutfitItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OutfitsTableFilterComposer get outfitId {
    final $$OutfitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableFilterComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WardrobeItemsTableFilterComposer get itemId {
    final $$WardrobeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.wardrobeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WardrobeItemsTableFilterComposer(
            $db: $db,
            $table: $db.wardrobeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutfitItemsTable> {
  $$OutfitItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OutfitsTableOrderingComposer get outfitId {
    final $$OutfitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableOrderingComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WardrobeItemsTableOrderingComposer get itemId {
    final $$WardrobeItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.wardrobeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WardrobeItemsTableOrderingComposer(
            $db: $db,
            $table: $db.wardrobeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutfitItemsTable> {
  $$OutfitItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OutfitsTableAnnotationComposer get outfitId {
    final $$OutfitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableAnnotationComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WardrobeItemsTableAnnotationComposer get itemId {
    final $$WardrobeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.wardrobeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WardrobeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.wardrobeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutfitItemsTable,
          OutfitItemRow,
          $$OutfitItemsTableFilterComposer,
          $$OutfitItemsTableOrderingComposer,
          $$OutfitItemsTableAnnotationComposer,
          $$OutfitItemsTableCreateCompanionBuilder,
          $$OutfitItemsTableUpdateCompanionBuilder,
          (OutfitItemRow, $$OutfitItemsTableReferences),
          OutfitItemRow,
          PrefetchHooks Function({bool outfitId, bool itemId})
        > {
  $$OutfitItemsTableTableManager(_$AppDatabase db, $OutfitItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutfitItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutfitItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutfitItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> outfitId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutfitItemsCompanion(
                outfitId: outfitId,
                itemId: itemId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String outfitId,
                required String itemId,
                Value<int> rowid = const Value.absent(),
              }) => OutfitItemsCompanion.insert(
                outfitId: outfitId,
                itemId: itemId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutfitItemsTable, OutfitItemRow>(table),
                  $$OutfitItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({outfitId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (outfitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.outfitId,
                        referencedTable: $$OutfitItemsTableReferences
                            ._outfitIdTable(db),
                        referencedColumn: $$OutfitItemsTableReferences
                            ._outfitIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$OutfitItemsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$OutfitItemsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OutfitItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutfitItemsTable,
      OutfitItemRow,
      $$OutfitItemsTableFilterComposer,
      $$OutfitItemsTableOrderingComposer,
      $$OutfitItemsTableAnnotationComposer,
      $$OutfitItemsTableCreateCompanionBuilder,
      $$OutfitItemsTableUpdateCompanionBuilder,
      (OutfitItemRow, $$OutfitItemsTableReferences),
      OutfitItemRow,
      PrefetchHooks Function({bool outfitId, bool itemId})
    >;
typedef $$OutfitWearsTableCreateCompanionBuilder =
    OutfitWearsCompanion Function({
      required String outfitId,
      required int day,
      Value<int> rowid,
    });
typedef $$OutfitWearsTableUpdateCompanionBuilder =
    OutfitWearsCompanion Function({
      Value<String> outfitId,
      Value<int> day,
      Value<int> rowid,
    });

final class $$OutfitWearsTableReferences
    extends BaseReferences<_$AppDatabase, $OutfitWearsTable, OutfitWearRow> {
  $$OutfitWearsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OutfitsTable _outfitIdTable(_$AppDatabase db) =>
      db.outfits.createAlias('outfit_wear__outfit_id__outfit__id');

  $$OutfitsTableProcessedTableManager get outfitId {
    final $_column = $_itemColumn<String>('outfit_id')!;

    final manager = $$OutfitsTableTableManager(
      $_db,
      $_db.outfits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_outfitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OutfitWearsTableFilterComposer
    extends Composer<_$AppDatabase, $OutfitWearsTable> {
  $$OutfitWearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  $$OutfitsTableFilterComposer get outfitId {
    final $$OutfitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableFilterComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitWearsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutfitWearsTable> {
  $$OutfitWearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  $$OutfitsTableOrderingComposer get outfitId {
    final $$OutfitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableOrderingComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitWearsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutfitWearsTable> {
  $$OutfitWearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  $$OutfitsTableAnnotationComposer get outfitId {
    final $$OutfitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outfitId,
      referencedTable: $db.outfits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OutfitsTableAnnotationComposer(
            $db: $db,
            $table: $db.outfits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OutfitWearsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutfitWearsTable,
          OutfitWearRow,
          $$OutfitWearsTableFilterComposer,
          $$OutfitWearsTableOrderingComposer,
          $$OutfitWearsTableAnnotationComposer,
          $$OutfitWearsTableCreateCompanionBuilder,
          $$OutfitWearsTableUpdateCompanionBuilder,
          (OutfitWearRow, $$OutfitWearsTableReferences),
          OutfitWearRow,
          PrefetchHooks Function({bool outfitId})
        > {
  $$OutfitWearsTableTableManager(_$AppDatabase db, $OutfitWearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutfitWearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutfitWearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutfitWearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> outfitId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutfitWearsCompanion(
                outfitId: outfitId,
                day: day,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String outfitId,
                required int day,
                Value<int> rowid = const Value.absent(),
              }) => OutfitWearsCompanion.insert(
                outfitId: outfitId,
                day: day,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutfitWearsTable, OutfitWearRow>(table),
                  $$OutfitWearsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({outfitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (outfitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.outfitId,
                        referencedTable: $$OutfitWearsTableReferences
                            ._outfitIdTable(db),
                        referencedColumn: $$OutfitWearsTableReferences
                            ._outfitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OutfitWearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutfitWearsTable,
      OutfitWearRow,
      $$OutfitWearsTableFilterComposer,
      $$OutfitWearsTableOrderingComposer,
      $$OutfitWearsTableAnnotationComposer,
      $$OutfitWearsTableCreateCompanionBuilder,
      $$OutfitWearsTableUpdateCompanionBuilder,
      (OutfitWearRow, $$OutfitWearsTableReferences),
      OutfitWearRow,
      PrefetchHooks Function({bool outfitId})
    >;
typedef $$BodyPlansTableCreateCompanionBuilder = BodyPlansCompanion Function({
  required String id,
  required String kind,
  required String pace,
  required String diet,
  required int startDay,
  required double startWeightKg,
  Value<double?> targetWeightKg,
  required int calories,
  required int proteinG,
  required int carbsG,
  required int fatG,
  required int waterMl,
  Value<bool> active,
  required int createdAt,
  Value<int?> endedAt,
  Value<int> rowid,
});
typedef $$BodyPlansTableUpdateCompanionBuilder = BodyPlansCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String> pace,
  Value<String> diet,
  Value<int> startDay,
  Value<double> startWeightKg,
  Value<double?> targetWeightKg,
  Value<int> calories,
  Value<int> proteinG,
  Value<int> carbsG,
  Value<int> fatG,
  Value<int> waterMl,
  Value<bool> active,
  Value<int> createdAt,
  Value<int?> endedAt,
  Value<int> rowid,
});

class $$BodyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $BodyPlansTable> {
  $$BodyPlansTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diet => $composableBuilder(
    column: $table.diet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterMl => $composableBuilder(
    column: $table.waterMl,
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

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyPlansTable> {
  $$BodyPlansTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diet => $composableBuilder(
    column: $table.diet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterMl => $composableBuilder(
    column: $table.waterMl,
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

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyPlansTable> {
  $$BodyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get pace =>
      $composableBuilder(column: $table.pace, builder: (column) => column);

  GeneratedColumn<String> get diet =>
      $composableBuilder(column: $table.diet, builder: (column) => column);

  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<int> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<int> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<int> get waterMl =>
      $composableBuilder(column: $table.waterMl, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$BodyPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyPlansTable,
          BodyPlanRow,
          $$BodyPlansTableFilterComposer,
          $$BodyPlansTableOrderingComposer,
          $$BodyPlansTableAnnotationComposer,
          $$BodyPlansTableCreateCompanionBuilder,
          $$BodyPlansTableUpdateCompanionBuilder,
          (
            BodyPlanRow,
            BaseReferences<_$AppDatabase, $BodyPlansTable, BodyPlanRow>,
          ),
          BodyPlanRow,
          PrefetchHooks Function()
        > {
  $$BodyPlansTableTableManager(_$AppDatabase db, $BodyPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> pace = const Value.absent(),
                Value<String> diet = const Value.absent(),
                Value<int> startDay = const Value.absent(),
                Value<double> startWeightKg = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> proteinG = const Value.absent(),
                Value<int> carbsG = const Value.absent(),
                Value<int> fatG = const Value.absent(),
                Value<int> waterMl = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyPlansCompanion(
                id: id,
                kind: kind,
                pace: pace,
                diet: diet,
                startDay: startDay,
                startWeightKg: startWeightKg,
                targetWeightKg: targetWeightKg,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                waterMl: waterMl,
                active: active,
                createdAt: createdAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String pace,
                required String diet,
                required int startDay,
                required double startWeightKg,
                Value<double?> targetWeightKg = const Value.absent(),
                required int calories,
                required int proteinG,
                required int carbsG,
                required int fatG,
                required int waterMl,
                Value<bool> active = const Value.absent(),
                required int createdAt,
                Value<int?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyPlansCompanion.insert(
                id: id,
                kind: kind,
                pace: pace,
                diet: diet,
                startDay: startDay,
                startWeightKg: startWeightKg,
                targetWeightKg: targetWeightKg,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                waterMl: waterMl,
                active: active,
                createdAt: createdAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyPlansTable, BodyPlanRow>(table),
                  BaseReferences<_$AppDatabase, $BodyPlansTable, BodyPlanRow>(
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

typedef $$BodyPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyPlansTable,
      BodyPlanRow,
      $$BodyPlansTableFilterComposer,
      $$BodyPlansTableOrderingComposer,
      $$BodyPlansTableAnnotationComposer,
      $$BodyPlansTableCreateCompanionBuilder,
      $$BodyPlansTableUpdateCompanionBuilder,
      (
        BodyPlanRow,
        BaseReferences<_$AppDatabase, $BodyPlansTable, BodyPlanRow>,
      ),
      BodyPlanRow,
      PrefetchHooks Function()
    >;
typedef $$MoodLogsTableCreateCompanionBuilder = MoodLogsCompanion Function({
  Value<int> day,
  required int mood,
  required int energy,
  required int recordedAt,
});
typedef $$MoodLogsTableUpdateCompanionBuilder = MoodLogsCompanion Function({
  Value<int> day,
  Value<int> mood,
  Value<int> energy,
  Value<int> recordedAt,
});

class $$MoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodLogsTable> {
  $$MoodLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodLogsTable> {
  $$MoodLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodLogsTable> {
  $$MoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );
}

class $$MoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodLogsTable,
          MoodRow,
          $$MoodLogsTableFilterComposer,
          $$MoodLogsTableOrderingComposer,
          $$MoodLogsTableAnnotationComposer,
          $$MoodLogsTableCreateCompanionBuilder,
          $$MoodLogsTableUpdateCompanionBuilder,
          (MoodRow, BaseReferences<_$AppDatabase, $MoodLogsTable, MoodRow>),
          MoodRow,
          PrefetchHooks Function()
        > {
  $$MoodLogsTableTableManager(_$AppDatabase db, $MoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> energy = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
              }) => MoodLogsCompanion(
                day: day,
                mood: mood,
                energy: energy,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                required int mood,
                required int energy,
                required int recordedAt,
              }) => MoodLogsCompanion.insert(
                day: day,
                mood: mood,
                energy: energy,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodLogsTable, MoodRow>(table),
                  BaseReferences<_$AppDatabase, $MoodLogsTable, MoodRow>(
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

typedef $$MoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodLogsTable,
      MoodRow,
      $$MoodLogsTableFilterComposer,
      $$MoodLogsTableOrderingComposer,
      $$MoodLogsTableAnnotationComposer,
      $$MoodLogsTableCreateCompanionBuilder,
      $$MoodLogsTableUpdateCompanionBuilder,
      (MoodRow, BaseReferences<_$AppDatabase, $MoodLogsTable, MoodRow>),
      MoodRow,
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
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$SleepLogsTableTableManager get sleepLogs =>
      $$SleepLogsTableTableManager(_db, _db.sleepLogs);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$ExerciseSessionsTableTableManager get exerciseSessions =>
      $$ExerciseSessionsTableTableManager(_db, _db.exerciseSessions);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitCompletionsTableTableManager get habitCompletions =>
      $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineItemsTableTableManager get routineItems =>
      $$RoutineItemsTableTableManager(_db, _db.routineItems);
  $$PlanRecordsTableTableManager get planRecords =>
      $$PlanRecordsTableTableManager(_db, _db.planRecords);
  $$PostureSessionsTableTableManager get postureSessions =>
      $$PostureSessionsTableTableManager(_db, _db.postureSessions);
  $$PostureMetricsTableTableManager get postureMetrics =>
      $$PostureMetricsTableTableManager(_db, _db.postureMetrics);
  $$FaceAnalysesTableTableManager get faceAnalyses =>
      $$FaceAnalysesTableTableManager(_db, _db.faceAnalyses);
  $$FaceMetricsTableTableManager get faceMetrics =>
      $$FaceMetricsTableTableManager(_db, _db.faceMetrics);
  $$StyleFavoritesTableTableManager get styleFavorites =>
      $$StyleFavoritesTableTableManager(_db, _db.styleFavorites);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$WardrobeItemsTableTableManager get wardrobeItems =>
      $$WardrobeItemsTableTableManager(_db, _db.wardrobeItems);
  $$OutfitsTableTableManager get outfits =>
      $$OutfitsTableTableManager(_db, _db.outfits);
  $$OutfitItemsTableTableManager get outfitItems =>
      $$OutfitItemsTableTableManager(_db, _db.outfitItems);
  $$OutfitWearsTableTableManager get outfitWears =>
      $$OutfitWearsTableTableManager(_db, _db.outfitWears);
  $$BodyPlansTableTableManager get bodyPlans =>
      $$BodyPlansTableTableManager(_db, _db.bodyPlans);
  $$MoodLogsTableTableManager get moodLogs =>
      $$MoodLogsTableTableManager(_db, _db.moodLogs);
}
