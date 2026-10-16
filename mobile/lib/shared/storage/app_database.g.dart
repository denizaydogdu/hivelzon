// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserStoryProgressTable extends UserStoryProgress
    with TableInfo<$UserStoryProgressTable, UserStoryProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStoryProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NOT_STARTED'),
  );
  static const VerificationMeta _lastCheckpointNodeIdMeta =
      const VerificationMeta('lastCheckpointNodeId');
  @override
  late final GeneratedColumn<String> lastCheckpointNodeId =
      GeneratedColumn<String>(
        'last_checkpoint_node_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _checkpointSnapshotMeta =
      const VerificationMeta('checkpointSnapshot');
  @override
  late final GeneratedColumn<String> checkpointSnapshot =
      GeneratedColumn<String>(
        'checkpoint_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    status,
    lastCheckpointNodeId,
    checkpointSnapshot,
    startedAt,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_story_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStoryProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_checkpoint_node_id')) {
      context.handle(
        _lastCheckpointNodeIdMeta,
        lastCheckpointNodeId.isAcceptableOrUnknown(
          data['last_checkpoint_node_id']!,
          _lastCheckpointNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('checkpoint_snapshot')) {
      context.handle(
        _checkpointSnapshotMeta,
        checkpointSnapshot.isAcceptableOrUnknown(
          data['checkpoint_snapshot']!,
          _checkpointSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  UserStoryProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStoryProgressData(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastCheckpointNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_checkpoint_node_id'],
      ),
      checkpointSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_snapshot'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserStoryProgressTable createAlias(String alias) {
    return $UserStoryProgressTable(attachedDatabase, alias);
  }
}

class UserStoryProgressData extends DataClass
    implements Insertable<UserStoryProgressData> {
  final String contentId;

  /// `NOT_STARTED` | `IN_PROGRESS` | `COMPLETED`
  final String status;

  /// Kaldığı yer (sahne başı kontrol noktası); bölüm bitince `null`.
  final String? lastCheckpointNodeId;

  /// Motorun tam kaydı (bayraklar, geçilen düğümler, içerik sürümü) — JSON.
  final String? checkpointSnapshot;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const UserStoryProgressData({
    required this.contentId,
    required this.status,
    this.lastCheckpointNodeId,
    this.checkpointSnapshot,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastCheckpointNodeId != null) {
      map['last_checkpoint_node_id'] = Variable<String>(lastCheckpointNodeId);
    }
    if (!nullToAbsent || checkpointSnapshot != null) {
      map['checkpoint_snapshot'] = Variable<String>(checkpointSnapshot);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserStoryProgressCompanion toCompanion(bool nullToAbsent) {
    return UserStoryProgressCompanion(
      contentId: Value(contentId),
      status: Value(status),
      lastCheckpointNodeId: lastCheckpointNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckpointNodeId),
      checkpointSnapshot: checkpointSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointSnapshot),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserStoryProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStoryProgressData(
      contentId: serializer.fromJson<String>(json['contentId']),
      status: serializer.fromJson<String>(json['status']),
      lastCheckpointNodeId: serializer.fromJson<String?>(
        json['lastCheckpointNodeId'],
      ),
      checkpointSnapshot: serializer.fromJson<String?>(
        json['checkpointSnapshot'],
      ),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'status': serializer.toJson<String>(status),
      'lastCheckpointNodeId': serializer.toJson<String?>(lastCheckpointNodeId),
      'checkpointSnapshot': serializer.toJson<String?>(checkpointSnapshot),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserStoryProgressData copyWith({
    String? contentId,
    String? status,
    Value<String?> lastCheckpointNodeId = const Value.absent(),
    Value<String?> checkpointSnapshot = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => UserStoryProgressData(
    contentId: contentId ?? this.contentId,
    status: status ?? this.status,
    lastCheckpointNodeId: lastCheckpointNodeId.present
        ? lastCheckpointNodeId.value
        : this.lastCheckpointNodeId,
    checkpointSnapshot: checkpointSnapshot.present
        ? checkpointSnapshot.value
        : this.checkpointSnapshot,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserStoryProgressData copyWithCompanion(UserStoryProgressCompanion data) {
    return UserStoryProgressData(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      status: data.status.present ? data.status.value : this.status,
      lastCheckpointNodeId: data.lastCheckpointNodeId.present
          ? data.lastCheckpointNodeId.value
          : this.lastCheckpointNodeId,
      checkpointSnapshot: data.checkpointSnapshot.present
          ? data.checkpointSnapshot.value
          : this.checkpointSnapshot,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStoryProgressData(')
          ..write('contentId: $contentId, ')
          ..write('status: $status, ')
          ..write('lastCheckpointNodeId: $lastCheckpointNodeId, ')
          ..write('checkpointSnapshot: $checkpointSnapshot, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    status,
    lastCheckpointNodeId,
    checkpointSnapshot,
    startedAt,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStoryProgressData &&
          other.contentId == this.contentId &&
          other.status == this.status &&
          other.lastCheckpointNodeId == this.lastCheckpointNodeId &&
          other.checkpointSnapshot == this.checkpointSnapshot &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class UserStoryProgressCompanion
    extends UpdateCompanion<UserStoryProgressData> {
  final Value<String> contentId;
  final Value<String> status;
  final Value<String?> lastCheckpointNodeId;
  final Value<String?> checkpointSnapshot;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserStoryProgressCompanion({
    this.contentId = const Value.absent(),
    this.status = const Value.absent(),
    this.lastCheckpointNodeId = const Value.absent(),
    this.checkpointSnapshot = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserStoryProgressCompanion.insert({
    required String contentId,
    this.status = const Value.absent(),
    this.lastCheckpointNodeId = const Value.absent(),
    this.checkpointSnapshot = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       updatedAt = Value(updatedAt);
  static Insertable<UserStoryProgressData> custom({
    Expression<String>? contentId,
    Expression<String>? status,
    Expression<String>? lastCheckpointNodeId,
    Expression<String>? checkpointSnapshot,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (status != null) 'status': status,
      if (lastCheckpointNodeId != null)
        'last_checkpoint_node_id': lastCheckpointNodeId,
      if (checkpointSnapshot != null) 'checkpoint_snapshot': checkpointSnapshot,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserStoryProgressCompanion copyWith({
    Value<String>? contentId,
    Value<String>? status,
    Value<String?>? lastCheckpointNodeId,
    Value<String?>? checkpointSnapshot,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserStoryProgressCompanion(
      contentId: contentId ?? this.contentId,
      status: status ?? this.status,
      lastCheckpointNodeId: lastCheckpointNodeId ?? this.lastCheckpointNodeId,
      checkpointSnapshot: checkpointSnapshot ?? this.checkpointSnapshot,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastCheckpointNodeId.present) {
      map['last_checkpoint_node_id'] = Variable<String>(
        lastCheckpointNodeId.value,
      );
    }
    if (checkpointSnapshot.present) {
      map['checkpoint_snapshot'] = Variable<String>(checkpointSnapshot.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStoryProgressCompanion(')
          ..write('contentId: $contentId, ')
          ..write('status: $status, ')
          ..write('lastCheckpointNodeId: $lastCheckpointNodeId, ')
          ..write('checkpointSnapshot: $checkpointSnapshot, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStoryFlagsTable extends UserStoryFlags
    with TableInfo<$UserStoryFlagsTable, UserStoryFlag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStoryFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagMeta = const VerificationMeta('flag');
  @override
  late final GeneratedColumn<String> flag = GeneratedColumn<String>(
    'flag',
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
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [contentId, flag, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_story_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStoryFlag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('flag')) {
      context.handle(
        _flagMeta,
        flag.isAcceptableOrUnknown(data['flag']!, _flagMeta),
      );
    } else if (isInserting) {
      context.missing(_flagMeta);
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId, flag};
  @override
  UserStoryFlag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStoryFlag(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      flag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserStoryFlagsTable createAlias(String alias) {
    return $UserStoryFlagsTable(attachedDatabase, alias);
  }
}

class UserStoryFlag extends DataClass implements Insertable<UserStoryFlag> {
  final String contentId;
  final String flag;
  final String value;

  /// Son yazan kazanır zamanı (H-038, şema 5).
  final DateTime? updatedAt;
  const UserStoryFlag({
    required this.contentId,
    required this.flag,
    required this.value,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['flag'] = Variable<String>(flag);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserStoryFlagsCompanion toCompanion(bool nullToAbsent) {
    return UserStoryFlagsCompanion(
      contentId: Value(contentId),
      flag: Value(flag),
      value: Value(value),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserStoryFlag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStoryFlag(
      contentId: serializer.fromJson<String>(json['contentId']),
      flag: serializer.fromJson<String>(json['flag']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'flag': serializer.toJson<String>(flag),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserStoryFlag copyWith({
    String? contentId,
    String? flag,
    String? value,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserStoryFlag(
    contentId: contentId ?? this.contentId,
    flag: flag ?? this.flag,
    value: value ?? this.value,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserStoryFlag copyWithCompanion(UserStoryFlagsCompanion data) {
    return UserStoryFlag(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      flag: data.flag.present ? data.flag.value : this.flag,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStoryFlag(')
          ..write('contentId: $contentId, ')
          ..write('flag: $flag, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, flag, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStoryFlag &&
          other.contentId == this.contentId &&
          other.flag == this.flag &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class UserStoryFlagsCompanion extends UpdateCompanion<UserStoryFlag> {
  final Value<String> contentId;
  final Value<String> flag;
  final Value<String> value;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserStoryFlagsCompanion({
    this.contentId = const Value.absent(),
    this.flag = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserStoryFlagsCompanion.insert({
    required String contentId,
    required String flag,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       flag = Value(flag),
       value = Value(value);
  static Insertable<UserStoryFlag> custom({
    Expression<String>? contentId,
    Expression<String>? flag,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (flag != null) 'flag': flag,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserStoryFlagsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? flag,
    Value<String>? value,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserStoryFlagsCompanion(
      contentId: contentId ?? this.contentId,
      flag: flag ?? this.flag,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (flag.present) {
      map['flag'] = Variable<String>(flag.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStoryFlagsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('flag: $flag, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GateProgressTable extends GateProgress
    with TableInfo<$GateProgressTable, GateProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GateProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemKindMeta = const VerificationMeta(
    'itemKind',
  );
  @override
  late final GeneratedColumn<String> itemKind = GeneratedColumn<String>(
    'item_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    itemKind,
    nodeId,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gate_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<GateProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('item_kind')) {
      context.handle(
        _itemKindMeta,
        itemKind.isAcceptableOrUnknown(data['item_kind']!, _itemKindMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKindMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {contentId, itemKind, nodeId};
  @override
  GateProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GateProgressData(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      itemKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_kind'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $GateProgressTable createAlias(String alias) {
    return $GateProgressTable(attachedDatabase, alias);
  }
}

class GateProgressData extends DataClass
    implements Insertable<GateProgressData> {
  final String contentId;

  /// `comprehension` | `targetPhrase` | `activeTask`
  final String itemKind;
  final String nodeId;
  final DateTime recordedAt;
  const GateProgressData({
    required this.contentId,
    required this.itemKind,
    required this.nodeId,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['item_kind'] = Variable<String>(itemKind);
    map['node_id'] = Variable<String>(nodeId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  GateProgressCompanion toCompanion(bool nullToAbsent) {
    return GateProgressCompanion(
      contentId: Value(contentId),
      itemKind: Value(itemKind),
      nodeId: Value(nodeId),
      recordedAt: Value(recordedAt),
    );
  }

  factory GateProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GateProgressData(
      contentId: serializer.fromJson<String>(json['contentId']),
      itemKind: serializer.fromJson<String>(json['itemKind']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'itemKind': serializer.toJson<String>(itemKind),
      'nodeId': serializer.toJson<String>(nodeId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  GateProgressData copyWith({
    String? contentId,
    String? itemKind,
    String? nodeId,
    DateTime? recordedAt,
  }) => GateProgressData(
    contentId: contentId ?? this.contentId,
    itemKind: itemKind ?? this.itemKind,
    nodeId: nodeId ?? this.nodeId,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  GateProgressData copyWithCompanion(GateProgressCompanion data) {
    return GateProgressData(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      itemKind: data.itemKind.present ? data.itemKind.value : this.itemKind,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GateProgressData(')
          ..write('contentId: $contentId, ')
          ..write('itemKind: $itemKind, ')
          ..write('nodeId: $nodeId, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, itemKind, nodeId, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GateProgressData &&
          other.contentId == this.contentId &&
          other.itemKind == this.itemKind &&
          other.nodeId == this.nodeId &&
          other.recordedAt == this.recordedAt);
}

class GateProgressCompanion extends UpdateCompanion<GateProgressData> {
  final Value<String> contentId;
  final Value<String> itemKind;
  final Value<String> nodeId;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const GateProgressCompanion({
    this.contentId = const Value.absent(),
    this.itemKind = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GateProgressCompanion.insert({
    required String contentId,
    required String itemKind,
    required String nodeId,
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       itemKind = Value(itemKind),
       nodeId = Value(nodeId),
       recordedAt = Value(recordedAt);
  static Insertable<GateProgressData> custom({
    Expression<String>? contentId,
    Expression<String>? itemKind,
    Expression<String>? nodeId,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (itemKind != null) 'item_kind': itemKind,
      if (nodeId != null) 'node_id': nodeId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GateProgressCompanion copyWith({
    Value<String>? contentId,
    Value<String>? itemKind,
    Value<String>? nodeId,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return GateProgressCompanion(
      contentId: contentId ?? this.contentId,
      itemKind: itemKind ?? this.itemKind,
      nodeId: nodeId ?? this.nodeId,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (itemKind.present) {
      map['item_kind'] = Variable<String>(itemKind.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GateProgressCompanion(')
          ..write('contentId: $contentId, ')
          ..write('itemKind: $itemKind, ')
          ..write('nodeId: $nodeId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeasonStateTable extends SeasonState
    with TableInfo<$SeasonStateTable, SeasonStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _introSeenMeta = const VerificationMeta(
    'introSeen',
  );
  @override
  late final GeneratedColumn<bool> introSeen = GeneratedColumn<bool>(
    'intro_seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("intro_seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _introSeenAtMeta = const VerificationMeta(
    'introSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> introSeenAt = GeneratedColumn<DateTime>(
    'intro_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seasonId,
    introSeen,
    introSeenAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'season_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeasonStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    }
    if (data.containsKey('intro_seen')) {
      context.handle(
        _introSeenMeta,
        introSeen.isAcceptableOrUnknown(data['intro_seen']!, _introSeenMeta),
      );
    }
    if (data.containsKey('intro_seen_at')) {
      context.handle(
        _introSeenAtMeta,
        introSeenAt.isAcceptableOrUnknown(
          data['intro_seen_at']!,
          _introSeenAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seasonId};
  @override
  SeasonStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeasonStateData(
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      introSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}intro_seen'],
      )!,
      introSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}intro_seen_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $SeasonStateTable createAlias(String alias) {
    return $SeasonStateTable(attachedDatabase, alias);
  }
}

class SeasonStateData extends DataClass implements Insertable<SeasonStateData> {
  final int seasonId;
  final bool introSeen;
  final DateTime? introSeenAt;

  /// Son yazan kazanır zamanı (H-038, şema 5).
  final DateTime? updatedAt;
  const SeasonStateData({
    required this.seasonId,
    required this.introSeen,
    this.introSeenAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['season_id'] = Variable<int>(seasonId);
    map['intro_seen'] = Variable<bool>(introSeen);
    if (!nullToAbsent || introSeenAt != null) {
      map['intro_seen_at'] = Variable<DateTime>(introSeenAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SeasonStateCompanion toCompanion(bool nullToAbsent) {
    return SeasonStateCompanion(
      seasonId: Value(seasonId),
      introSeen: Value(introSeen),
      introSeenAt: introSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(introSeenAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SeasonStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeasonStateData(
      seasonId: serializer.fromJson<int>(json['seasonId']),
      introSeen: serializer.fromJson<bool>(json['introSeen']),
      introSeenAt: serializer.fromJson<DateTime?>(json['introSeenAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seasonId': serializer.toJson<int>(seasonId),
      'introSeen': serializer.toJson<bool>(introSeen),
      'introSeenAt': serializer.toJson<DateTime?>(introSeenAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SeasonStateData copyWith({
    int? seasonId,
    bool? introSeen,
    Value<DateTime?> introSeenAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => SeasonStateData(
    seasonId: seasonId ?? this.seasonId,
    introSeen: introSeen ?? this.introSeen,
    introSeenAt: introSeenAt.present ? introSeenAt.value : this.introSeenAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  SeasonStateData copyWithCompanion(SeasonStateCompanion data) {
    return SeasonStateData(
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      introSeen: data.introSeen.present ? data.introSeen.value : this.introSeen,
      introSeenAt: data.introSeenAt.present
          ? data.introSeenAt.value
          : this.introSeenAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeasonStateData(')
          ..write('seasonId: $seasonId, ')
          ..write('introSeen: $introSeen, ')
          ..write('introSeenAt: $introSeenAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seasonId, introSeen, introSeenAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeasonStateData &&
          other.seasonId == this.seasonId &&
          other.introSeen == this.introSeen &&
          other.introSeenAt == this.introSeenAt &&
          other.updatedAt == this.updatedAt);
}

class SeasonStateCompanion extends UpdateCompanion<SeasonStateData> {
  final Value<int> seasonId;
  final Value<bool> introSeen;
  final Value<DateTime?> introSeenAt;
  final Value<DateTime?> updatedAt;
  const SeasonStateCompanion({
    this.seasonId = const Value.absent(),
    this.introSeen = const Value.absent(),
    this.introSeenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SeasonStateCompanion.insert({
    this.seasonId = const Value.absent(),
    this.introSeen = const Value.absent(),
    this.introSeenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<SeasonStateData> custom({
    Expression<int>? seasonId,
    Expression<bool>? introSeen,
    Expression<DateTime>? introSeenAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (seasonId != null) 'season_id': seasonId,
      if (introSeen != null) 'intro_seen': introSeen,
      if (introSeenAt != null) 'intro_seen_at': introSeenAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SeasonStateCompanion copyWith({
    Value<int>? seasonId,
    Value<bool>? introSeen,
    Value<DateTime?>? introSeenAt,
    Value<DateTime?>? updatedAt,
  }) {
    return SeasonStateCompanion(
      seasonId: seasonId ?? this.seasonId,
      introSeen: introSeen ?? this.introSeen,
      introSeenAt: introSeenAt ?? this.introSeenAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (introSeen.present) {
      map['intro_seen'] = Variable<bool>(introSeen.value);
    }
    if (introSeenAt.present) {
      map['intro_seen_at'] = Variable<DateTime>(introSeenAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonStateCompanion(')
          ..write('seasonId: $seasonId, ')
          ..write('introSeen: $introSeen, ')
          ..write('introSeenAt: $introSeenAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaData> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaData extends DataClass implements Insertable<AppMetaData> {
  final String key;
  final String value;
  const AppMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetaData copyWith({String? key, String? value}) =>
      AppMetaData(key: key ?? this.key, value: value ?? this.value);
  AppMetaData copyWithCompanion(AppMetaCompanion data) {
    return AppMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotebookItemsTable extends NotebookItems
    with TableInfo<$NotebookItemsTable, NotebookItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotebookItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _textEnMeta = const VerificationMeta('textEn');
  @override
  late final GeneratedColumn<String> textEn = GeneratedColumn<String>(
    'text_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textTrMeta = const VerificationMeta('textTr');
  @override
  late final GeneratedColumn<String> textTr = GeneratedColumn<String>(
    'text_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleEnMeta = const VerificationMeta(
    'exampleEn',
  );
  @override
  late final GeneratedColumn<String> exampleEn = GeneratedColumn<String>(
    'example_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleTrMeta = const VerificationMeta(
    'exampleTr',
  );
  @override
  late final GeneratedColumn<String> exampleTr = GeneratedColumn<String>(
    'example_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cueIdMeta = const VerificationMeta('cueId');
  @override
  late final GeneratedColumn<String> cueId = GeneratedColumn<String>(
    'cue_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageCropMeta = const VerificationMeta(
    'imageCrop',
  );
  @override
  late final GeneratedColumn<String> imageCrop = GeneratedColumn<String>(
    'image_crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioStartMeta = const VerificationMeta(
    'audioStart',
  );
  @override
  late final GeneratedColumn<double> audioStart = GeneratedColumn<double>(
    'audio_start',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioEndMeta = const VerificationMeta(
    'audioEnd',
  );
  @override
  late final GeneratedColumn<double> audioEnd = GeneratedColumn<double>(
    'audio_end',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleStartMeta = const VerificationMeta(
    'exampleStart',
  );
  @override
  late final GeneratedColumn<double> exampleStart = GeneratedColumn<double>(
    'example_start',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleEndMeta = const VerificationMeta(
    'exampleEnd',
  );
  @override
  late final GeneratedColumn<double> exampleEnd = GeneratedColumn<double>(
    'example_end',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
  static const VerificationMeta _sourceTitleMeta = const VerificationMeta(
    'sourceTitle',
  );
  @override
  late final GeneratedColumn<String> sourceTitle = GeneratedColumn<String>(
    'source_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemKey,
    kind,
    textEn,
    textTr,
    exampleEn,
    exampleTr,
    contentId,
    cueId,
    imagePath,
    imageCrop,
    audioPath,
    audioStart,
    audioEnd,
    exampleStart,
    exampleEnd,
    source,
    sourceTitle,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notebook_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotebookItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('text_en')) {
      context.handle(
        _textEnMeta,
        textEn.isAcceptableOrUnknown(data['text_en']!, _textEnMeta),
      );
    } else if (isInserting) {
      context.missing(_textEnMeta);
    }
    if (data.containsKey('text_tr')) {
      context.handle(
        _textTrMeta,
        textTr.isAcceptableOrUnknown(data['text_tr']!, _textTrMeta),
      );
    }
    if (data.containsKey('example_en')) {
      context.handle(
        _exampleEnMeta,
        exampleEn.isAcceptableOrUnknown(data['example_en']!, _exampleEnMeta),
      );
    }
    if (data.containsKey('example_tr')) {
      context.handle(
        _exampleTrMeta,
        exampleTr.isAcceptableOrUnknown(data['example_tr']!, _exampleTrMeta),
      );
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    }
    if (data.containsKey('cue_id')) {
      context.handle(
        _cueIdMeta,
        cueId.isAcceptableOrUnknown(data['cue_id']!, _cueIdMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('image_crop')) {
      context.handle(
        _imageCropMeta,
        imageCrop.isAcceptableOrUnknown(data['image_crop']!, _imageCropMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('audio_start')) {
      context.handle(
        _audioStartMeta,
        audioStart.isAcceptableOrUnknown(data['audio_start']!, _audioStartMeta),
      );
    }
    if (data.containsKey('audio_end')) {
      context.handle(
        _audioEndMeta,
        audioEnd.isAcceptableOrUnknown(data['audio_end']!, _audioEndMeta),
      );
    }
    if (data.containsKey('example_start')) {
      context.handle(
        _exampleStartMeta,
        exampleStart.isAcceptableOrUnknown(
          data['example_start']!,
          _exampleStartMeta,
        ),
      );
    }
    if (data.containsKey('example_end')) {
      context.handle(
        _exampleEndMeta,
        exampleEnd.isAcceptableOrUnknown(data['example_end']!, _exampleEndMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_title')) {
      context.handle(
        _sourceTitleMeta,
        sourceTitle.isAcceptableOrUnknown(
          data['source_title']!,
          _sourceTitleMeta,
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotebookItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotebookItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      textEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_en'],
      )!,
      textTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_tr'],
      ),
      exampleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_en'],
      ),
      exampleTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_tr'],
      ),
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      ),
      cueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cue_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      imageCrop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_crop'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      audioStart: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}audio_start'],
      ),
      audioEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}audio_end'],
      ),
      exampleStart: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}example_start'],
      ),
      exampleEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}example_end'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_title'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $NotebookItemsTable createAlias(String alias) {
    return $NotebookItemsTable(attachedDatabase, alias);
  }
}

class NotebookItemRow extends DataClass implements Insertable<NotebookItemRow> {
  final int id;

  /// `<kind>|<normalleştirilmiş İngilizce>`: aynı ifade iki kez girmez.
  final String itemKey;

  /// `word` | `phrase` | `sentence`
  final String kind;
  final String textEn;
  final String? textTr;
  final String? exampleEn;
  final String? exampleTr;

  /// Kaynak bölüm ve satır (`A1-001`, `s02-04`).
  final String? contentId;
  final String? cueId;

  /// Bölüm paketindeki görsel (`stills/T2-pov.jpg`) ve isteğe bağlı kırpma
  /// (normalleştirilmiş `x,y,w,h`; yoksa görselin tamamı).
  final String? imagePath;
  final String? imageCrop;

  /// Ses: segment videosu (`segments/s02.mp4`) + ifadenin aralığı (sn) ya da
  /// tek ses dosyası (`audio/x.m4a`, aralık yok).
  final String? audioPath;
  final double? audioStart;
  final double? audioEnd;

  /// Örnek cümlenin aralığı (aynı ses dosyasında).
  final double? exampleStart;
  final double? exampleEnd;

  /// `auto_target_phrase` | `user_saved` | `lookup` | `topic_set` | `book`
  final String source;

  /// Kaynağın adı (şema 6, H-067): kitaptan eklenende kitabın başlığı
  /// (`Kitap: <başlık>, s. N` satırı için; sayfa `cueId`'den).
  final String? sourceTitle;
  final DateTime createdAt;

  /// Son yazan kazanır zamanı (H-038, şema 5).
  final DateTime? updatedAt;
  const NotebookItemRow({
    required this.id,
    required this.itemKey,
    required this.kind,
    required this.textEn,
    this.textTr,
    this.exampleEn,
    this.exampleTr,
    this.contentId,
    this.cueId,
    this.imagePath,
    this.imageCrop,
    this.audioPath,
    this.audioStart,
    this.audioEnd,
    this.exampleStart,
    this.exampleEnd,
    required this.source,
    this.sourceTitle,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_key'] = Variable<String>(itemKey);
    map['kind'] = Variable<String>(kind);
    map['text_en'] = Variable<String>(textEn);
    if (!nullToAbsent || textTr != null) {
      map['text_tr'] = Variable<String>(textTr);
    }
    if (!nullToAbsent || exampleEn != null) {
      map['example_en'] = Variable<String>(exampleEn);
    }
    if (!nullToAbsent || exampleTr != null) {
      map['example_tr'] = Variable<String>(exampleTr);
    }
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<String>(contentId);
    }
    if (!nullToAbsent || cueId != null) {
      map['cue_id'] = Variable<String>(cueId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || imageCrop != null) {
      map['image_crop'] = Variable<String>(imageCrop);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || audioStart != null) {
      map['audio_start'] = Variable<double>(audioStart);
    }
    if (!nullToAbsent || audioEnd != null) {
      map['audio_end'] = Variable<double>(audioEnd);
    }
    if (!nullToAbsent || exampleStart != null) {
      map['example_start'] = Variable<double>(exampleStart);
    }
    if (!nullToAbsent || exampleEnd != null) {
      map['example_end'] = Variable<double>(exampleEnd);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceTitle != null) {
      map['source_title'] = Variable<String>(sourceTitle);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  NotebookItemsCompanion toCompanion(bool nullToAbsent) {
    return NotebookItemsCompanion(
      id: Value(id),
      itemKey: Value(itemKey),
      kind: Value(kind),
      textEn: Value(textEn),
      textTr: textTr == null && nullToAbsent
          ? const Value.absent()
          : Value(textTr),
      exampleEn: exampleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleEn),
      exampleTr: exampleTr == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleTr),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
      cueId: cueId == null && nullToAbsent
          ? const Value.absent()
          : Value(cueId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      imageCrop: imageCrop == null && nullToAbsent
          ? const Value.absent()
          : Value(imageCrop),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      audioStart: audioStart == null && nullToAbsent
          ? const Value.absent()
          : Value(audioStart),
      audioEnd: audioEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(audioEnd),
      exampleStart: exampleStart == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleStart),
      exampleEnd: exampleEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleEnd),
      source: Value(source),
      sourceTitle: sourceTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTitle),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory NotebookItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotebookItemRow(
      id: serializer.fromJson<int>(json['id']),
      itemKey: serializer.fromJson<String>(json['itemKey']),
      kind: serializer.fromJson<String>(json['kind']),
      textEn: serializer.fromJson<String>(json['textEn']),
      textTr: serializer.fromJson<String?>(json['textTr']),
      exampleEn: serializer.fromJson<String?>(json['exampleEn']),
      exampleTr: serializer.fromJson<String?>(json['exampleTr']),
      contentId: serializer.fromJson<String?>(json['contentId']),
      cueId: serializer.fromJson<String?>(json['cueId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      imageCrop: serializer.fromJson<String?>(json['imageCrop']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      audioStart: serializer.fromJson<double?>(json['audioStart']),
      audioEnd: serializer.fromJson<double?>(json['audioEnd']),
      exampleStart: serializer.fromJson<double?>(json['exampleStart']),
      exampleEnd: serializer.fromJson<double?>(json['exampleEnd']),
      source: serializer.fromJson<String>(json['source']),
      sourceTitle: serializer.fromJson<String?>(json['sourceTitle']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemKey': serializer.toJson<String>(itemKey),
      'kind': serializer.toJson<String>(kind),
      'textEn': serializer.toJson<String>(textEn),
      'textTr': serializer.toJson<String?>(textTr),
      'exampleEn': serializer.toJson<String?>(exampleEn),
      'exampleTr': serializer.toJson<String?>(exampleTr),
      'contentId': serializer.toJson<String?>(contentId),
      'cueId': serializer.toJson<String?>(cueId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'imageCrop': serializer.toJson<String?>(imageCrop),
      'audioPath': serializer.toJson<String?>(audioPath),
      'audioStart': serializer.toJson<double?>(audioStart),
      'audioEnd': serializer.toJson<double?>(audioEnd),
      'exampleStart': serializer.toJson<double?>(exampleStart),
      'exampleEnd': serializer.toJson<double?>(exampleEnd),
      'source': serializer.toJson<String>(source),
      'sourceTitle': serializer.toJson<String?>(sourceTitle),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  NotebookItemRow copyWith({
    int? id,
    String? itemKey,
    String? kind,
    String? textEn,
    Value<String?> textTr = const Value.absent(),
    Value<String?> exampleEn = const Value.absent(),
    Value<String?> exampleTr = const Value.absent(),
    Value<String?> contentId = const Value.absent(),
    Value<String?> cueId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> imageCrop = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    Value<double?> audioStart = const Value.absent(),
    Value<double?> audioEnd = const Value.absent(),
    Value<double?> exampleStart = const Value.absent(),
    Value<double?> exampleEnd = const Value.absent(),
    String? source,
    Value<String?> sourceTitle = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => NotebookItemRow(
    id: id ?? this.id,
    itemKey: itemKey ?? this.itemKey,
    kind: kind ?? this.kind,
    textEn: textEn ?? this.textEn,
    textTr: textTr.present ? textTr.value : this.textTr,
    exampleEn: exampleEn.present ? exampleEn.value : this.exampleEn,
    exampleTr: exampleTr.present ? exampleTr.value : this.exampleTr,
    contentId: contentId.present ? contentId.value : this.contentId,
    cueId: cueId.present ? cueId.value : this.cueId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    imageCrop: imageCrop.present ? imageCrop.value : this.imageCrop,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    audioStart: audioStart.present ? audioStart.value : this.audioStart,
    audioEnd: audioEnd.present ? audioEnd.value : this.audioEnd,
    exampleStart: exampleStart.present ? exampleStart.value : this.exampleStart,
    exampleEnd: exampleEnd.present ? exampleEnd.value : this.exampleEnd,
    source: source ?? this.source,
    sourceTitle: sourceTitle.present ? sourceTitle.value : this.sourceTitle,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  NotebookItemRow copyWithCompanion(NotebookItemsCompanion data) {
    return NotebookItemRow(
      id: data.id.present ? data.id.value : this.id,
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      kind: data.kind.present ? data.kind.value : this.kind,
      textEn: data.textEn.present ? data.textEn.value : this.textEn,
      textTr: data.textTr.present ? data.textTr.value : this.textTr,
      exampleEn: data.exampleEn.present ? data.exampleEn.value : this.exampleEn,
      exampleTr: data.exampleTr.present ? data.exampleTr.value : this.exampleTr,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      cueId: data.cueId.present ? data.cueId.value : this.cueId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      imageCrop: data.imageCrop.present ? data.imageCrop.value : this.imageCrop,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      audioStart: data.audioStart.present
          ? data.audioStart.value
          : this.audioStart,
      audioEnd: data.audioEnd.present ? data.audioEnd.value : this.audioEnd,
      exampleStart: data.exampleStart.present
          ? data.exampleStart.value
          : this.exampleStart,
      exampleEnd: data.exampleEnd.present
          ? data.exampleEnd.value
          : this.exampleEnd,
      source: data.source.present ? data.source.value : this.source,
      sourceTitle: data.sourceTitle.present
          ? data.sourceTitle.value
          : this.sourceTitle,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotebookItemRow(')
          ..write('id: $id, ')
          ..write('itemKey: $itemKey, ')
          ..write('kind: $kind, ')
          ..write('textEn: $textEn, ')
          ..write('textTr: $textTr, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleTr: $exampleTr, ')
          ..write('contentId: $contentId, ')
          ..write('cueId: $cueId, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageCrop: $imageCrop, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioStart: $audioStart, ')
          ..write('audioEnd: $audioEnd, ')
          ..write('exampleStart: $exampleStart, ')
          ..write('exampleEnd: $exampleEnd, ')
          ..write('source: $source, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemKey,
    kind,
    textEn,
    textTr,
    exampleEn,
    exampleTr,
    contentId,
    cueId,
    imagePath,
    imageCrop,
    audioPath,
    audioStart,
    audioEnd,
    exampleStart,
    exampleEnd,
    source,
    sourceTitle,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotebookItemRow &&
          other.id == this.id &&
          other.itemKey == this.itemKey &&
          other.kind == this.kind &&
          other.textEn == this.textEn &&
          other.textTr == this.textTr &&
          other.exampleEn == this.exampleEn &&
          other.exampleTr == this.exampleTr &&
          other.contentId == this.contentId &&
          other.cueId == this.cueId &&
          other.imagePath == this.imagePath &&
          other.imageCrop == this.imageCrop &&
          other.audioPath == this.audioPath &&
          other.audioStart == this.audioStart &&
          other.audioEnd == this.audioEnd &&
          other.exampleStart == this.exampleStart &&
          other.exampleEnd == this.exampleEnd &&
          other.source == this.source &&
          other.sourceTitle == this.sourceTitle &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotebookItemsCompanion extends UpdateCompanion<NotebookItemRow> {
  final Value<int> id;
  final Value<String> itemKey;
  final Value<String> kind;
  final Value<String> textEn;
  final Value<String?> textTr;
  final Value<String?> exampleEn;
  final Value<String?> exampleTr;
  final Value<String?> contentId;
  final Value<String?> cueId;
  final Value<String?> imagePath;
  final Value<String?> imageCrop;
  final Value<String?> audioPath;
  final Value<double?> audioStart;
  final Value<double?> audioEnd;
  final Value<double?> exampleStart;
  final Value<double?> exampleEnd;
  final Value<String> source;
  final Value<String?> sourceTitle;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const NotebookItemsCompanion({
    this.id = const Value.absent(),
    this.itemKey = const Value.absent(),
    this.kind = const Value.absent(),
    this.textEn = const Value.absent(),
    this.textTr = const Value.absent(),
    this.exampleEn = const Value.absent(),
    this.exampleTr = const Value.absent(),
    this.contentId = const Value.absent(),
    this.cueId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.imageCrop = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.audioStart = const Value.absent(),
    this.audioEnd = const Value.absent(),
    this.exampleStart = const Value.absent(),
    this.exampleEnd = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceTitle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotebookItemsCompanion.insert({
    this.id = const Value.absent(),
    required String itemKey,
    required String kind,
    required String textEn,
    this.textTr = const Value.absent(),
    this.exampleEn = const Value.absent(),
    this.exampleTr = const Value.absent(),
    this.contentId = const Value.absent(),
    this.cueId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.imageCrop = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.audioStart = const Value.absent(),
    this.audioEnd = const Value.absent(),
    this.exampleStart = const Value.absent(),
    this.exampleEnd = const Value.absent(),
    required String source,
    this.sourceTitle = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  }) : itemKey = Value(itemKey),
       kind = Value(kind),
       textEn = Value(textEn),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<NotebookItemRow> custom({
    Expression<int>? id,
    Expression<String>? itemKey,
    Expression<String>? kind,
    Expression<String>? textEn,
    Expression<String>? textTr,
    Expression<String>? exampleEn,
    Expression<String>? exampleTr,
    Expression<String>? contentId,
    Expression<String>? cueId,
    Expression<String>? imagePath,
    Expression<String>? imageCrop,
    Expression<String>? audioPath,
    Expression<double>? audioStart,
    Expression<double>? audioEnd,
    Expression<double>? exampleStart,
    Expression<double>? exampleEnd,
    Expression<String>? source,
    Expression<String>? sourceTitle,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemKey != null) 'item_key': itemKey,
      if (kind != null) 'kind': kind,
      if (textEn != null) 'text_en': textEn,
      if (textTr != null) 'text_tr': textTr,
      if (exampleEn != null) 'example_en': exampleEn,
      if (exampleTr != null) 'example_tr': exampleTr,
      if (contentId != null) 'content_id': contentId,
      if (cueId != null) 'cue_id': cueId,
      if (imagePath != null) 'image_path': imagePath,
      if (imageCrop != null) 'image_crop': imageCrop,
      if (audioPath != null) 'audio_path': audioPath,
      if (audioStart != null) 'audio_start': audioStart,
      if (audioEnd != null) 'audio_end': audioEnd,
      if (exampleStart != null) 'example_start': exampleStart,
      if (exampleEnd != null) 'example_end': exampleEnd,
      if (source != null) 'source': source,
      if (sourceTitle != null) 'source_title': sourceTitle,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotebookItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? itemKey,
    Value<String>? kind,
    Value<String>? textEn,
    Value<String?>? textTr,
    Value<String?>? exampleEn,
    Value<String?>? exampleTr,
    Value<String?>? contentId,
    Value<String?>? cueId,
    Value<String?>? imagePath,
    Value<String?>? imageCrop,
    Value<String?>? audioPath,
    Value<double?>? audioStart,
    Value<double?>? audioEnd,
    Value<double?>? exampleStart,
    Value<double?>? exampleEnd,
    Value<String>? source,
    Value<String?>? sourceTitle,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return NotebookItemsCompanion(
      id: id ?? this.id,
      itemKey: itemKey ?? this.itemKey,
      kind: kind ?? this.kind,
      textEn: textEn ?? this.textEn,
      textTr: textTr ?? this.textTr,
      exampleEn: exampleEn ?? this.exampleEn,
      exampleTr: exampleTr ?? this.exampleTr,
      contentId: contentId ?? this.contentId,
      cueId: cueId ?? this.cueId,
      imagePath: imagePath ?? this.imagePath,
      imageCrop: imageCrop ?? this.imageCrop,
      audioPath: audioPath ?? this.audioPath,
      audioStart: audioStart ?? this.audioStart,
      audioEnd: audioEnd ?? this.audioEnd,
      exampleStart: exampleStart ?? this.exampleStart,
      exampleEnd: exampleEnd ?? this.exampleEnd,
      source: source ?? this.source,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (textEn.present) {
      map['text_en'] = Variable<String>(textEn.value);
    }
    if (textTr.present) {
      map['text_tr'] = Variable<String>(textTr.value);
    }
    if (exampleEn.present) {
      map['example_en'] = Variable<String>(exampleEn.value);
    }
    if (exampleTr.present) {
      map['example_tr'] = Variable<String>(exampleTr.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (cueId.present) {
      map['cue_id'] = Variable<String>(cueId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (imageCrop.present) {
      map['image_crop'] = Variable<String>(imageCrop.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (audioStart.present) {
      map['audio_start'] = Variable<double>(audioStart.value);
    }
    if (audioEnd.present) {
      map['audio_end'] = Variable<double>(audioEnd.value);
    }
    if (exampleStart.present) {
      map['example_start'] = Variable<double>(exampleStart.value);
    }
    if (exampleEnd.present) {
      map['example_end'] = Variable<double>(exampleEnd.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceTitle.present) {
      map['source_title'] = Variable<String>(sourceTitle.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotebookItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemKey: $itemKey, ')
          ..write('kind: $kind, ')
          ..write('textEn: $textEn, ')
          ..write('textTr: $textTr, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleTr: $exampleTr, ')
          ..write('contentId: $contentId, ')
          ..write('cueId: $cueId, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageCrop: $imageCrop, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioStart: $audioStart, ')
          ..write('audioEnd: $audioEnd, ')
          ..write('exampleStart: $exampleStart, ')
          ..write('exampleEnd: $exampleEnd, ')
          ..write('source: $source, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewCardsTable extends ReviewCards
    with TableInfo<$ReviewCardsTable, ReviewCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES notebook_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewMeta = const VerificationMeta(
    'lastReview',
  );
  @override
  late final GeneratedColumn<DateTime> lastReview = GeneratedColumn<DateTime>(
    'last_review',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    state,
    step,
    stability,
    difficulty,
    due,
    reps,
    lapses,
    lastReview,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('last_review')) {
      context.handle(
        _lastReviewMeta,
        lastReview.isAcceptableOrUnknown(data['last_review']!, _lastReviewMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      ),
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      ),
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ReviewCardsTable createAlias(String alias) {
    return $ReviewCardsTable(attachedDatabase, alias);
  }
}

class ReviewCardRow extends DataClass implements Insertable<ReviewCardRow> {
  final int id;
  final int itemId;

  /// FSRS durumu: 1 learning, 2 review, 3 relearning.
  final int state;
  final int? step;
  final double? stability;
  final double? difficulty;
  final DateTime due;
  final int reps;
  final int lapses;
  final DateTime? lastReview;

  /// Son yazan kazanır zamanı (H-038, şema 5).
  final DateTime? updatedAt;
  const ReviewCardRow({
    required this.id,
    required this.itemId,
    required this.state,
    this.step,
    this.stability,
    this.difficulty,
    required this.due,
    required this.reps,
    required this.lapses,
    this.lastReview,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['state'] = Variable<int>(state);
    if (!nullToAbsent || step != null) {
      map['step'] = Variable<int>(step);
    }
    if (!nullToAbsent || stability != null) {
      map['stability'] = Variable<double>(stability);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<double>(difficulty);
    }
    map['due'] = Variable<DateTime>(due);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<DateTime>(lastReview);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ReviewCardsCompanion toCompanion(bool nullToAbsent) {
    return ReviewCardsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      state: Value(state),
      step: step == null && nullToAbsent ? const Value.absent() : Value(step),
      stability: stability == null && nullToAbsent
          ? const Value.absent()
          : Value(stability),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      due: Value(due),
      reps: Value(reps),
      lapses: Value(lapses),
      lastReview: lastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReview),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ReviewCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewCardRow(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      state: serializer.fromJson<int>(json['state']),
      step: serializer.fromJson<int?>(json['step']),
      stability: serializer.fromJson<double?>(json['stability']),
      difficulty: serializer.fromJson<double?>(json['difficulty']),
      due: serializer.fromJson<DateTime>(json['due']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReview: serializer.fromJson<DateTime?>(json['lastReview']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'state': serializer.toJson<int>(state),
      'step': serializer.toJson<int?>(step),
      'stability': serializer.toJson<double?>(stability),
      'difficulty': serializer.toJson<double?>(difficulty),
      'due': serializer.toJson<DateTime>(due),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'lastReview': serializer.toJson<DateTime?>(lastReview),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ReviewCardRow copyWith({
    int? id,
    int? itemId,
    int? state,
    Value<int?> step = const Value.absent(),
    Value<double?> stability = const Value.absent(),
    Value<double?> difficulty = const Value.absent(),
    DateTime? due,
    int? reps,
    int? lapses,
    Value<DateTime?> lastReview = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ReviewCardRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    state: state ?? this.state,
    step: step.present ? step.value : this.step,
    stability: stability.present ? stability.value : this.stability,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    due: due ?? this.due,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    lastReview: lastReview.present ? lastReview.value : this.lastReview,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ReviewCardRow copyWithCompanion(ReviewCardsCompanion data) {
    return ReviewCardRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      state: data.state.present ? data.state.value : this.state,
      step: data.step.present ? data.step.value : this.step,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      due: data.due.present ? data.due.value : this.due,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReview: data.lastReview.present
          ? data.lastReview.value
          : this.lastReview,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCardRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('state: $state, ')
          ..write('step: $step, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('due: $due, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReview: $lastReview, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    state,
    step,
    stability,
    difficulty,
    due,
    reps,
    lapses,
    lastReview,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewCardRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.state == this.state &&
          other.step == this.step &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.due == this.due &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.lastReview == this.lastReview &&
          other.updatedAt == this.updatedAt);
}

class ReviewCardsCompanion extends UpdateCompanion<ReviewCardRow> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> state;
  final Value<int?> step;
  final Value<double?> stability;
  final Value<double?> difficulty;
  final Value<DateTime> due;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<DateTime?> lastReview;
  final Value<DateTime?> updatedAt;
  const ReviewCardsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.state = const Value.absent(),
    this.step = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.due = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReviewCardsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    this.state = const Value.absent(),
    this.step = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    required DateTime due,
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : itemId = Value(itemId),
       due = Value(due);
  static Insertable<ReviewCardRow> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? state,
    Expression<int>? step,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<DateTime>? due,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<DateTime>? lastReview,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (state != null) 'state': state,
      if (step != null) 'step': step,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (due != null) 'due': due,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (lastReview != null) 'last_review': lastReview,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReviewCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<int>? state,
    Value<int?>? step,
    Value<double?>? stability,
    Value<double?>? difficulty,
    Value<DateTime>? due,
    Value<int>? reps,
    Value<int>? lapses,
    Value<DateTime?>? lastReview,
    Value<DateTime?>? updatedAt,
  }) {
    return ReviewCardsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      state: state ?? this.state,
      step: step ?? this.step,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      due: due ?? this.due,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastReview: lastReview ?? this.lastReview,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<DateTime>(lastReview.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCardsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('state: $state, ')
          ..write('step: $step, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('due: $due, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReview: $lastReview, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES review_cards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _dontKnowMeta = const VerificationMeta(
    'dontKnow',
  );
  @override
  late final GeneratedColumn<bool> dontKnow = GeneratedColumn<bool>(
    'dont_know',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dont_know" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wasNewMeta = const VerificationMeta('wasNew');
  @override
  late final GeneratedColumn<bool> wasNew = GeneratedColumn<bool>(
    'was_new',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_new" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: SyncIds.v4,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    rating,
    reviewedAt,
    taskType,
    correct,
    dontKnow,
    durationMs,
    wasNew,
    clientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('dont_know')) {
      context.handle(
        _dontKnowMeta,
        dontKnow.isAcceptableOrUnknown(data['dont_know']!, _dontKnowMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('was_new')) {
      context.handle(
        _wasNewMeta,
        wasNew.isAcceptableOrUnknown(data['was_new']!, _wasNewMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      dontKnow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dont_know'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      wasNew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_new'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLogRow extends DataClass implements Insertable<ReviewLogRow> {
  final int id;
  final int cardId;

  /// 1 Again, 2 Hard, 3 Good, 4 Easy.
  final int rating;
  final DateTime reviewedAt;

  /// `picture_choice` | `listen_choice` | `arrange` | `type` | `self_check`
  final String taskType;
  final bool correct;

  /// "Bilmiyorum" seçildi mi.
  final bool dontKnow;
  final int durationMs;

  /// İnceleme öncesi kart yeni miydi (günlük yeni kart sınırı için).
  final bool wasNew;

  /// Eşitleme kimliği (H-038, şema 5): kart + zaman + nottan UUIDv5
  /// ([SyncIds.reviewLog]); verilmezse rastgele UUIDv4. Tekil (dizin).
  final String? clientId;
  const ReviewLogRow({
    required this.id,
    required this.cardId,
    required this.rating,
    required this.reviewedAt,
    required this.taskType,
    required this.correct,
    required this.dontKnow,
    required this.durationMs,
    required this.wasNew,
    this.clientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['rating'] = Variable<int>(rating);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['task_type'] = Variable<String>(taskType);
    map['correct'] = Variable<bool>(correct);
    map['dont_know'] = Variable<bool>(dontKnow);
    map['duration_ms'] = Variable<int>(durationMs);
    map['was_new'] = Variable<bool>(wasNew);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      taskType: Value(taskType),
      correct: Value(correct),
      dontKnow: Value(dontKnow),
      durationMs: Value(durationMs),
      wasNew: Value(wasNew),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
    );
  }

  factory ReviewLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      rating: serializer.fromJson<int>(json['rating']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      taskType: serializer.fromJson<String>(json['taskType']),
      correct: serializer.fromJson<bool>(json['correct']),
      dontKnow: serializer.fromJson<bool>(json['dontKnow']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      wasNew: serializer.fromJson<bool>(json['wasNew']),
      clientId: serializer.fromJson<String?>(json['clientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'rating': serializer.toJson<int>(rating),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'taskType': serializer.toJson<String>(taskType),
      'correct': serializer.toJson<bool>(correct),
      'dontKnow': serializer.toJson<bool>(dontKnow),
      'durationMs': serializer.toJson<int>(durationMs),
      'wasNew': serializer.toJson<bool>(wasNew),
      'clientId': serializer.toJson<String?>(clientId),
    };
  }

  ReviewLogRow copyWith({
    int? id,
    int? cardId,
    int? rating,
    DateTime? reviewedAt,
    String? taskType,
    bool? correct,
    bool? dontKnow,
    int? durationMs,
    bool? wasNew,
    Value<String?> clientId = const Value.absent(),
  }) => ReviewLogRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    rating: rating ?? this.rating,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    taskType: taskType ?? this.taskType,
    correct: correct ?? this.correct,
    dontKnow: dontKnow ?? this.dontKnow,
    durationMs: durationMs ?? this.durationMs,
    wasNew: wasNew ?? this.wasNew,
    clientId: clientId.present ? clientId.value : this.clientId,
  );
  ReviewLogRow copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLogRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      correct: data.correct.present ? data.correct.value : this.correct,
      dontKnow: data.dontKnow.present ? data.dontKnow.value : this.dontKnow,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      wasNew: data.wasNew.present ? data.wasNew.value : this.wasNew,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('taskType: $taskType, ')
          ..write('correct: $correct, ')
          ..write('dontKnow: $dontKnow, ')
          ..write('durationMs: $durationMs, ')
          ..write('wasNew: $wasNew, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    rating,
    reviewedAt,
    taskType,
    correct,
    dontKnow,
    durationMs,
    wasNew,
    clientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.taskType == this.taskType &&
          other.correct == this.correct &&
          other.dontKnow == this.dontKnow &&
          other.durationMs == this.durationMs &&
          other.wasNew == this.wasNew &&
          other.clientId == this.clientId);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLogRow> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<int> rating;
  final Value<DateTime> reviewedAt;
  final Value<String> taskType;
  final Value<bool> correct;
  final Value<bool> dontKnow;
  final Value<int> durationMs;
  final Value<bool> wasNew;
  final Value<String?> clientId;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.taskType = const Value.absent(),
    this.correct = const Value.absent(),
    this.dontKnow = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.wasNew = const Value.absent(),
    this.clientId = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required int rating,
    required DateTime reviewedAt,
    required String taskType,
    required bool correct,
    this.dontKnow = const Value.absent(),
    required int durationMs,
    this.wasNew = const Value.absent(),
    this.clientId = const Value.absent(),
  }) : cardId = Value(cardId),
       rating = Value(rating),
       reviewedAt = Value(reviewedAt),
       taskType = Value(taskType),
       correct = Value(correct),
       durationMs = Value(durationMs);
  static Insertable<ReviewLogRow> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<int>? rating,
    Expression<DateTime>? reviewedAt,
    Expression<String>? taskType,
    Expression<bool>? correct,
    Expression<bool>? dontKnow,
    Expression<int>? durationMs,
    Expression<bool>? wasNew,
    Expression<String>? clientId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (taskType != null) 'task_type': taskType,
      if (correct != null) 'correct': correct,
      if (dontKnow != null) 'dont_know': dontKnow,
      if (durationMs != null) 'duration_ms': durationMs,
      if (wasNew != null) 'was_new': wasNew,
      if (clientId != null) 'client_id': clientId,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<int>? rating,
    Value<DateTime>? reviewedAt,
    Value<String>? taskType,
    Value<bool>? correct,
    Value<bool>? dontKnow,
    Value<int>? durationMs,
    Value<bool>? wasNew,
    Value<String?>? clientId,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      taskType: taskType ?? this.taskType,
      correct: correct ?? this.correct,
      dontKnow: dontKnow ?? this.dontKnow,
      durationMs: durationMs ?? this.durationMs,
      wasNew: wasNew ?? this.wasNew,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (dontKnow.present) {
      map['dont_know'] = Variable<bool>(dontKnow.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (wasNew.present) {
      map['was_new'] = Variable<bool>(wasNew.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('taskType: $taskType, ')
          ..write('correct: $correct, ')
          ..write('dontKnow: $dontKnow, ')
          ..write('durationMs: $durationMs, ')
          ..write('wasNew: $wasNew, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }
}

class $LearningEventsTable extends LearningEvents
    with TableInfo<$LearningEventsTable, LearningEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientEventIdMeta = const VerificationMeta(
    'clientEventId',
  );
  @override
  late final GeneratedColumn<String> clientEventId = GeneratedColumn<String>(
    'client_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorTypeMeta = const VerificationMeta(
    'errorType',
  );
  @override
  late final GeneratedColumn<String> errorType = GeneratedColumn<String>(
    'error_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorTaxonomyVersionMeta =
      const VerificationMeta('errorTaxonomyVersion');
  @override
  late final GeneratedColumn<int> errorTaxonomyVersion = GeneratedColumn<int>(
    'error_taxonomy_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: SyncIds.v4,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientEventId,
    contentId,
    sourceId,
    target,
    at,
    errorType,
    errorTaxonomyVersion,
    clientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_event_id')) {
      context.handle(
        _clientEventIdMeta,
        clientEventId.isAcceptableOrUnknown(
          data['client_event_id']!,
          _clientEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEventIdMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('error_type')) {
      context.handle(
        _errorTypeMeta,
        errorType.isAcceptableOrUnknown(data['error_type']!, _errorTypeMeta),
      );
    }
    if (data.containsKey('error_taxonomy_version')) {
      context.handle(
        _errorTaxonomyVersionMeta,
        errorTaxonomyVersion.isAcceptableOrUnknown(
          data['error_taxonomy_version']!,
          _errorTaxonomyVersionMeta,
        ),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_event_id'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      errorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_type'],
      ),
      errorTaxonomyVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}error_taxonomy_version'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
    );
  }

  @override
  $LearningEventsTable createAlias(String alias) {
    return $LearningEventsTable(attachedDatabase, alias);
  }
}

class LearningEventRow extends DataClass
    implements Insertable<LearningEventRow> {
  final int id;

  /// İstemci kimliği: eşitlemede çift kaydı önler.
  final String clientEventId;
  final String contentId;
  final String sourceId;
  final String target;
  final DateTime at;

  /// Hata türü (isteğe bağlı) ve sürümlü sınıflandırma
  /// (`shared/meaning/error_taxonomy.dart`). Bakmak hata değildir: null.
  final String? errorType;
  final int? errorTaxonomyVersion;

  /// Eşitleme kimliği (H-038, şema 5; UUID). Eski kayıtlarda
  /// [clientEventId]'nin tireli biçimi. Tekil (dizin).
  final String? clientId;
  const LearningEventRow({
    required this.id,
    required this.clientEventId,
    required this.contentId,
    required this.sourceId,
    required this.target,
    required this.at,
    this.errorType,
    this.errorTaxonomyVersion,
    this.clientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_event_id'] = Variable<String>(clientEventId);
    map['content_id'] = Variable<String>(contentId);
    map['source_id'] = Variable<String>(sourceId);
    map['target'] = Variable<String>(target);
    map['at'] = Variable<DateTime>(at);
    if (!nullToAbsent || errorType != null) {
      map['error_type'] = Variable<String>(errorType);
    }
    if (!nullToAbsent || errorTaxonomyVersion != null) {
      map['error_taxonomy_version'] = Variable<int>(errorTaxonomyVersion);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    return map;
  }

  LearningEventsCompanion toCompanion(bool nullToAbsent) {
    return LearningEventsCompanion(
      id: Value(id),
      clientEventId: Value(clientEventId),
      contentId: Value(contentId),
      sourceId: Value(sourceId),
      target: Value(target),
      at: Value(at),
      errorType: errorType == null && nullToAbsent
          ? const Value.absent()
          : Value(errorType),
      errorTaxonomyVersion: errorTaxonomyVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(errorTaxonomyVersion),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
    );
  }

  factory LearningEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningEventRow(
      id: serializer.fromJson<int>(json['id']),
      clientEventId: serializer.fromJson<String>(json['clientEventId']),
      contentId: serializer.fromJson<String>(json['contentId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      target: serializer.fromJson<String>(json['target']),
      at: serializer.fromJson<DateTime>(json['at']),
      errorType: serializer.fromJson<String?>(json['errorType']),
      errorTaxonomyVersion: serializer.fromJson<int?>(
        json['errorTaxonomyVersion'],
      ),
      clientId: serializer.fromJson<String?>(json['clientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientEventId': serializer.toJson<String>(clientEventId),
      'contentId': serializer.toJson<String>(contentId),
      'sourceId': serializer.toJson<String>(sourceId),
      'target': serializer.toJson<String>(target),
      'at': serializer.toJson<DateTime>(at),
      'errorType': serializer.toJson<String?>(errorType),
      'errorTaxonomyVersion': serializer.toJson<int?>(errorTaxonomyVersion),
      'clientId': serializer.toJson<String?>(clientId),
    };
  }

  LearningEventRow copyWith({
    int? id,
    String? clientEventId,
    String? contentId,
    String? sourceId,
    String? target,
    DateTime? at,
    Value<String?> errorType = const Value.absent(),
    Value<int?> errorTaxonomyVersion = const Value.absent(),
    Value<String?> clientId = const Value.absent(),
  }) => LearningEventRow(
    id: id ?? this.id,
    clientEventId: clientEventId ?? this.clientEventId,
    contentId: contentId ?? this.contentId,
    sourceId: sourceId ?? this.sourceId,
    target: target ?? this.target,
    at: at ?? this.at,
    errorType: errorType.present ? errorType.value : this.errorType,
    errorTaxonomyVersion: errorTaxonomyVersion.present
        ? errorTaxonomyVersion.value
        : this.errorTaxonomyVersion,
    clientId: clientId.present ? clientId.value : this.clientId,
  );
  LearningEventRow copyWithCompanion(LearningEventsCompanion data) {
    return LearningEventRow(
      id: data.id.present ? data.id.value : this.id,
      clientEventId: data.clientEventId.present
          ? data.clientEventId.value
          : this.clientEventId,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      target: data.target.present ? data.target.value : this.target,
      at: data.at.present ? data.at.value : this.at,
      errorType: data.errorType.present ? data.errorType.value : this.errorType,
      errorTaxonomyVersion: data.errorTaxonomyVersion.present
          ? data.errorTaxonomyVersion.value
          : this.errorTaxonomyVersion,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningEventRow(')
          ..write('id: $id, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('contentId: $contentId, ')
          ..write('sourceId: $sourceId, ')
          ..write('target: $target, ')
          ..write('at: $at, ')
          ..write('errorType: $errorType, ')
          ..write('errorTaxonomyVersion: $errorTaxonomyVersion, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientEventId,
    contentId,
    sourceId,
    target,
    at,
    errorType,
    errorTaxonomyVersion,
    clientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningEventRow &&
          other.id == this.id &&
          other.clientEventId == this.clientEventId &&
          other.contentId == this.contentId &&
          other.sourceId == this.sourceId &&
          other.target == this.target &&
          other.at == this.at &&
          other.errorType == this.errorType &&
          other.errorTaxonomyVersion == this.errorTaxonomyVersion &&
          other.clientId == this.clientId);
}

class LearningEventsCompanion extends UpdateCompanion<LearningEventRow> {
  final Value<int> id;
  final Value<String> clientEventId;
  final Value<String> contentId;
  final Value<String> sourceId;
  final Value<String> target;
  final Value<DateTime> at;
  final Value<String?> errorType;
  final Value<int?> errorTaxonomyVersion;
  final Value<String?> clientId;
  const LearningEventsCompanion({
    this.id = const Value.absent(),
    this.clientEventId = const Value.absent(),
    this.contentId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.target = const Value.absent(),
    this.at = const Value.absent(),
    this.errorType = const Value.absent(),
    this.errorTaxonomyVersion = const Value.absent(),
    this.clientId = const Value.absent(),
  });
  LearningEventsCompanion.insert({
    this.id = const Value.absent(),
    required String clientEventId,
    required String contentId,
    required String sourceId,
    required String target,
    required DateTime at,
    this.errorType = const Value.absent(),
    this.errorTaxonomyVersion = const Value.absent(),
    this.clientId = const Value.absent(),
  }) : clientEventId = Value(clientEventId),
       contentId = Value(contentId),
       sourceId = Value(sourceId),
       target = Value(target),
       at = Value(at);
  static Insertable<LearningEventRow> custom({
    Expression<int>? id,
    Expression<String>? clientEventId,
    Expression<String>? contentId,
    Expression<String>? sourceId,
    Expression<String>? target,
    Expression<DateTime>? at,
    Expression<String>? errorType,
    Expression<int>? errorTaxonomyVersion,
    Expression<String>? clientId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientEventId != null) 'client_event_id': clientEventId,
      if (contentId != null) 'content_id': contentId,
      if (sourceId != null) 'source_id': sourceId,
      if (target != null) 'target': target,
      if (at != null) 'at': at,
      if (errorType != null) 'error_type': errorType,
      if (errorTaxonomyVersion != null)
        'error_taxonomy_version': errorTaxonomyVersion,
      if (clientId != null) 'client_id': clientId,
    });
  }

  LearningEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? clientEventId,
    Value<String>? contentId,
    Value<String>? sourceId,
    Value<String>? target,
    Value<DateTime>? at,
    Value<String?>? errorType,
    Value<int?>? errorTaxonomyVersion,
    Value<String?>? clientId,
  }) {
    return LearningEventsCompanion(
      id: id ?? this.id,
      clientEventId: clientEventId ?? this.clientEventId,
      contentId: contentId ?? this.contentId,
      sourceId: sourceId ?? this.sourceId,
      target: target ?? this.target,
      at: at ?? this.at,
      errorType: errorType ?? this.errorType,
      errorTaxonomyVersion: errorTaxonomyVersion ?? this.errorTaxonomyVersion,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientEventId.present) {
      map['client_event_id'] = Variable<String>(clientEventId.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (errorType.present) {
      map['error_type'] = Variable<String>(errorType.value);
    }
    if (errorTaxonomyVersion.present) {
      map['error_taxonomy_version'] = Variable<int>(errorTaxonomyVersion.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningEventsCompanion(')
          ..write('id: $id, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('contentId: $contentId, ')
          ..write('sourceId: $sourceId, ')
          ..write('target: $target, ')
          ..write('at: $at, ')
          ..write('errorType: $errorType, ')
          ..write('errorTaxonomyVersion: $errorTaxonomyVersion, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }
}

class $CluesTable extends Clues with TableInfo<$CluesTable, ClueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CluesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clueIdMeta = const VerificationMeta('clueId');
  @override
  late final GeneratedColumn<String> clueId = GeneratedColumn<String>(
    'clue_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textTrMeta = const VerificationMeta('textTr');
  @override
  late final GeneratedColumn<String> textTr = GeneratedColumn<String>(
    'text_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textEnMeta = const VerificationMeta('textEn');
  @override
  late final GeneratedColumn<String> textEn = GeneratedColumn<String>(
    'text_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    clueId,
    textTr,
    textEn,
    unlockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clues';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('clue_id')) {
      context.handle(
        _clueIdMeta,
        clueId.isAcceptableOrUnknown(data['clue_id']!, _clueIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clueIdMeta);
    }
    if (data.containsKey('text_tr')) {
      context.handle(
        _textTrMeta,
        textTr.isAcceptableOrUnknown(data['text_tr']!, _textTrMeta),
      );
    } else if (isInserting) {
      context.missing(_textTrMeta);
    }
    if (data.containsKey('text_en')) {
      context.handle(
        _textEnMeta,
        textEn.isAcceptableOrUnknown(data['text_en']!, _textEnMeta),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId, clueId};
  @override
  ClueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClueRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      clueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clue_id'],
      )!,
      textTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_tr'],
      )!,
      textEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_en'],
      ),
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $CluesTable createAlias(String alias) {
    return $CluesTable(attachedDatabase, alias);
  }
}

class ClueRow extends DataClass implements Insertable<ClueRow> {
  final String contentId;
  final String clueId;
  final String textTr;
  final String? textEn;
  final DateTime unlockedAt;
  const ClueRow({
    required this.contentId,
    required this.clueId,
    required this.textTr,
    this.textEn,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['clue_id'] = Variable<String>(clueId);
    map['text_tr'] = Variable<String>(textTr);
    if (!nullToAbsent || textEn != null) {
      map['text_en'] = Variable<String>(textEn);
    }
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  CluesCompanion toCompanion(bool nullToAbsent) {
    return CluesCompanion(
      contentId: Value(contentId),
      clueId: Value(clueId),
      textTr: Value(textTr),
      textEn: textEn == null && nullToAbsent
          ? const Value.absent()
          : Value(textEn),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory ClueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClueRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      clueId: serializer.fromJson<String>(json['clueId']),
      textTr: serializer.fromJson<String>(json['textTr']),
      textEn: serializer.fromJson<String?>(json['textEn']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'clueId': serializer.toJson<String>(clueId),
      'textTr': serializer.toJson<String>(textTr),
      'textEn': serializer.toJson<String?>(textEn),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  ClueRow copyWith({
    String? contentId,
    String? clueId,
    String? textTr,
    Value<String?> textEn = const Value.absent(),
    DateTime? unlockedAt,
  }) => ClueRow(
    contentId: contentId ?? this.contentId,
    clueId: clueId ?? this.clueId,
    textTr: textTr ?? this.textTr,
    textEn: textEn.present ? textEn.value : this.textEn,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  ClueRow copyWithCompanion(CluesCompanion data) {
    return ClueRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      clueId: data.clueId.present ? data.clueId.value : this.clueId,
      textTr: data.textTr.present ? data.textTr.value : this.textTr,
      textEn: data.textEn.present ? data.textEn.value : this.textEn,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClueRow(')
          ..write('contentId: $contentId, ')
          ..write('clueId: $clueId, ')
          ..write('textTr: $textTr, ')
          ..write('textEn: $textEn, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(contentId, clueId, textTr, textEn, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClueRow &&
          other.contentId == this.contentId &&
          other.clueId == this.clueId &&
          other.textTr == this.textTr &&
          other.textEn == this.textEn &&
          other.unlockedAt == this.unlockedAt);
}

class CluesCompanion extends UpdateCompanion<ClueRow> {
  final Value<String> contentId;
  final Value<String> clueId;
  final Value<String> textTr;
  final Value<String?> textEn;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const CluesCompanion({
    this.contentId = const Value.absent(),
    this.clueId = const Value.absent(),
    this.textTr = const Value.absent(),
    this.textEn = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CluesCompanion.insert({
    required String contentId,
    required String clueId,
    required String textTr,
    this.textEn = const Value.absent(),
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       clueId = Value(clueId),
       textTr = Value(textTr),
       unlockedAt = Value(unlockedAt);
  static Insertable<ClueRow> custom({
    Expression<String>? contentId,
    Expression<String>? clueId,
    Expression<String>? textTr,
    Expression<String>? textEn,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (clueId != null) 'clue_id': clueId,
      if (textTr != null) 'text_tr': textTr,
      if (textEn != null) 'text_en': textEn,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CluesCompanion copyWith({
    Value<String>? contentId,
    Value<String>? clueId,
    Value<String>? textTr,
    Value<String?>? textEn,
    Value<DateTime>? unlockedAt,
    Value<int>? rowid,
  }) {
    return CluesCompanion(
      contentId: contentId ?? this.contentId,
      clueId: clueId ?? this.clueId,
      textTr: textTr ?? this.textTr,
      textEn: textEn ?? this.textEn,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (clueId.present) {
      map['clue_id'] = Variable<String>(clueId.value);
    }
    if (textTr.present) {
      map['text_tr'] = Variable<String>(textTr.value);
    }
    if (textEn.present) {
      map['text_en'] = Variable<String>(textEn.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CluesCompanion(')
          ..write('contentId: $contentId, ')
          ..write('clueId: $clueId, ')
          ..write('textTr: $textTr, ')
          ..write('textEn: $textEn, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryLinksTable extends StoryLinks
    with TableInfo<$StoryLinksTable, StoryLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openQuestionIdMeta = const VerificationMeta(
    'openQuestionId',
  );
  @override
  late final GeneratedColumn<String> openQuestionId = GeneratedColumn<String>(
    'open_question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openQuestionTrMeta = const VerificationMeta(
    'openQuestionTr',
  );
  @override
  late final GeneratedColumn<String> openQuestionTr = GeneratedColumn<String>(
    'open_question_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answersMeta = const VerificationMeta(
    'answers',
  );
  @override
  late final GeneratedColumn<String> answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partialNotesMeta = const VerificationMeta(
    'partialNotes',
  );
  @override
  late final GeneratedColumn<String> partialNotes = GeneratedColumn<String>(
    'partial_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    number,
    openQuestionId,
    openQuestionTr,
    answers,
    partialNotes,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryLinkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('open_question_id')) {
      context.handle(
        _openQuestionIdMeta,
        openQuestionId.isAcceptableOrUnknown(
          data['open_question_id']!,
          _openQuestionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openQuestionIdMeta);
    }
    if (data.containsKey('open_question_tr')) {
      context.handle(
        _openQuestionTrMeta,
        openQuestionTr.isAcceptableOrUnknown(
          data['open_question_tr']!,
          _openQuestionTrMeta,
        ),
      );
    }
    if (data.containsKey('answers')) {
      context.handle(
        _answersMeta,
        answers.isAcceptableOrUnknown(data['answers']!, _answersMeta),
      );
    } else if (isInserting) {
      context.missing(_answersMeta);
    }
    if (data.containsKey('partial_notes')) {
      context.handle(
        _partialNotesMeta,
        partialNotes.isAcceptableOrUnknown(
          data['partial_notes']!,
          _partialNotesMeta,
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
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  StoryLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryLinkRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      openQuestionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}open_question_id'],
      )!,
      openQuestionTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}open_question_tr'],
      ),
      answers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers'],
      )!,
      partialNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partial_notes'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $StoryLinksTable createAlias(String alias) {
    return $StoryLinksTable(attachedDatabase, alias);
  }
}

class StoryLinkRow extends DataClass implements Insertable<StoryLinkRow> {
  final String contentId;
  final int number;

  /// Bölümün açtığı soru (`Q1`) ve spoiler'sız Türkçe metni.
  final String openQuestionId;
  final String? openQuestionTr;

  /// Cevapladığı sorular, JSON dizi (`["Q1:partial"]`).
  final String answers;

  /// Kısmi cevap notları, JSON nesne (`{"Q1": "limanda"}`).
  final String partialNotes;
  final DateTime recordedAt;
  const StoryLinkRow({
    required this.contentId,
    required this.number,
    required this.openQuestionId,
    this.openQuestionTr,
    required this.answers,
    required this.partialNotes,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['number'] = Variable<int>(number);
    map['open_question_id'] = Variable<String>(openQuestionId);
    if (!nullToAbsent || openQuestionTr != null) {
      map['open_question_tr'] = Variable<String>(openQuestionTr);
    }
    map['answers'] = Variable<String>(answers);
    map['partial_notes'] = Variable<String>(partialNotes);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  StoryLinksCompanion toCompanion(bool nullToAbsent) {
    return StoryLinksCompanion(
      contentId: Value(contentId),
      number: Value(number),
      openQuestionId: Value(openQuestionId),
      openQuestionTr: openQuestionTr == null && nullToAbsent
          ? const Value.absent()
          : Value(openQuestionTr),
      answers: Value(answers),
      partialNotes: Value(partialNotes),
      recordedAt: Value(recordedAt),
    );
  }

  factory StoryLinkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryLinkRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      number: serializer.fromJson<int>(json['number']),
      openQuestionId: serializer.fromJson<String>(json['openQuestionId']),
      openQuestionTr: serializer.fromJson<String?>(json['openQuestionTr']),
      answers: serializer.fromJson<String>(json['answers']),
      partialNotes: serializer.fromJson<String>(json['partialNotes']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'number': serializer.toJson<int>(number),
      'openQuestionId': serializer.toJson<String>(openQuestionId),
      'openQuestionTr': serializer.toJson<String?>(openQuestionTr),
      'answers': serializer.toJson<String>(answers),
      'partialNotes': serializer.toJson<String>(partialNotes),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  StoryLinkRow copyWith({
    String? contentId,
    int? number,
    String? openQuestionId,
    Value<String?> openQuestionTr = const Value.absent(),
    String? answers,
    String? partialNotes,
    DateTime? recordedAt,
  }) => StoryLinkRow(
    contentId: contentId ?? this.contentId,
    number: number ?? this.number,
    openQuestionId: openQuestionId ?? this.openQuestionId,
    openQuestionTr: openQuestionTr.present
        ? openQuestionTr.value
        : this.openQuestionTr,
    answers: answers ?? this.answers,
    partialNotes: partialNotes ?? this.partialNotes,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  StoryLinkRow copyWithCompanion(StoryLinksCompanion data) {
    return StoryLinkRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      number: data.number.present ? data.number.value : this.number,
      openQuestionId: data.openQuestionId.present
          ? data.openQuestionId.value
          : this.openQuestionId,
      openQuestionTr: data.openQuestionTr.present
          ? data.openQuestionTr.value
          : this.openQuestionTr,
      answers: data.answers.present ? data.answers.value : this.answers,
      partialNotes: data.partialNotes.present
          ? data.partialNotes.value
          : this.partialNotes,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryLinkRow(')
          ..write('contentId: $contentId, ')
          ..write('number: $number, ')
          ..write('openQuestionId: $openQuestionId, ')
          ..write('openQuestionTr: $openQuestionTr, ')
          ..write('answers: $answers, ')
          ..write('partialNotes: $partialNotes, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    number,
    openQuestionId,
    openQuestionTr,
    answers,
    partialNotes,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryLinkRow &&
          other.contentId == this.contentId &&
          other.number == this.number &&
          other.openQuestionId == this.openQuestionId &&
          other.openQuestionTr == this.openQuestionTr &&
          other.answers == this.answers &&
          other.partialNotes == this.partialNotes &&
          other.recordedAt == this.recordedAt);
}

class StoryLinksCompanion extends UpdateCompanion<StoryLinkRow> {
  final Value<String> contentId;
  final Value<int> number;
  final Value<String> openQuestionId;
  final Value<String?> openQuestionTr;
  final Value<String> answers;
  final Value<String> partialNotes;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const StoryLinksCompanion({
    this.contentId = const Value.absent(),
    this.number = const Value.absent(),
    this.openQuestionId = const Value.absent(),
    this.openQuestionTr = const Value.absent(),
    this.answers = const Value.absent(),
    this.partialNotes = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryLinksCompanion.insert({
    required String contentId,
    required int number,
    required String openQuestionId,
    this.openQuestionTr = const Value.absent(),
    required String answers,
    this.partialNotes = const Value.absent(),
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       number = Value(number),
       openQuestionId = Value(openQuestionId),
       answers = Value(answers),
       recordedAt = Value(recordedAt);
  static Insertable<StoryLinkRow> custom({
    Expression<String>? contentId,
    Expression<int>? number,
    Expression<String>? openQuestionId,
    Expression<String>? openQuestionTr,
    Expression<String>? answers,
    Expression<String>? partialNotes,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (number != null) 'number': number,
      if (openQuestionId != null) 'open_question_id': openQuestionId,
      if (openQuestionTr != null) 'open_question_tr': openQuestionTr,
      if (answers != null) 'answers': answers,
      if (partialNotes != null) 'partial_notes': partialNotes,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryLinksCompanion copyWith({
    Value<String>? contentId,
    Value<int>? number,
    Value<String>? openQuestionId,
    Value<String?>? openQuestionTr,
    Value<String>? answers,
    Value<String>? partialNotes,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return StoryLinksCompanion(
      contentId: contentId ?? this.contentId,
      number: number ?? this.number,
      openQuestionId: openQuestionId ?? this.openQuestionId,
      openQuestionTr: openQuestionTr ?? this.openQuestionTr,
      answers: answers ?? this.answers,
      partialNotes: partialNotes ?? this.partialNotes,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (openQuestionId.present) {
      map['open_question_id'] = Variable<String>(openQuestionId.value);
    }
    if (openQuestionTr.present) {
      map['open_question_tr'] = Variable<String>(openQuestionTr.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(answers.value);
    }
    if (partialNotes.present) {
      map['partial_notes'] = Variable<String>(partialNotes.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryLinksCompanion(')
          ..write('contentId: $contentId, ')
          ..write('number: $number, ')
          ..write('openQuestionId: $openQuestionId, ')
          ..write('openQuestionTr: $openQuestionTr, ')
          ..write('answers: $answers, ')
          ..write('partialNotes: $partialNotes, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HiRecordsTable extends HiRecords
    with TableInfo<$HiRecordsTable, HiRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kind, refId, status, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hi_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
  Set<GeneratedColumn> get $primaryKey => {kind, refId};
  @override
  HiRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiRecordRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HiRecordsTable createAlias(String alias) {
    return $HiRecordsTable(attachedDatabase, alias);
  }
}

class HiRecordRow extends DataClass implements Insertable<HiRecordRow> {
  /// `topic_intro` | `bridge_task` | `note_read`
  final String kind;

  /// Konu ya da görev kimliği; `note_read` için hata türü kodu.
  final String refId;

  /// `seen` | `done` | `dismissed` | `read`
  final String status;
  final DateTime updatedAt;
  const HiRecordRow({
    required this.kind,
    required this.refId,
    required this.status,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['ref_id'] = Variable<String>(refId);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HiRecordsCompanion toCompanion(bool nullToAbsent) {
    return HiRecordsCompanion(
      kind: Value(kind),
      refId: Value(refId),
      status: Value(status),
      updatedAt: Value(updatedAt),
    );
  }

  factory HiRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiRecordRow(
      kind: serializer.fromJson<String>(json['kind']),
      refId: serializer.fromJson<String>(json['refId']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'refId': serializer.toJson<String>(refId),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HiRecordRow copyWith({
    String? kind,
    String? refId,
    String? status,
    DateTime? updatedAt,
  }) => HiRecordRow(
    kind: kind ?? this.kind,
    refId: refId ?? this.refId,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HiRecordRow copyWithCompanion(HiRecordsCompanion data) {
    return HiRecordRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      refId: data.refId.present ? data.refId.value : this.refId,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiRecordRow(')
          ..write('kind: $kind, ')
          ..write('refId: $refId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, refId, status, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiRecordRow &&
          other.kind == this.kind &&
          other.refId == this.refId &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class HiRecordsCompanion extends UpdateCompanion<HiRecordRow> {
  final Value<String> kind;
  final Value<String> refId;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HiRecordsCompanion({
    this.kind = const Value.absent(),
    this.refId = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HiRecordsCompanion.insert({
    required String kind,
    required String refId,
    required String status,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       refId = Value(refId),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<HiRecordRow> custom({
    Expression<String>? kind,
    Expression<String>? refId,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (refId != null) 'ref_id': refId,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HiRecordsCompanion copyWith({
    Value<String>? kind,
    Value<String>? refId,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HiRecordsCompanion(
      kind: kind ?? this.kind,
      refId: refId ?? this.refId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiRecordsCompanion(')
          ..write('kind: $kind, ')
          ..write('refId: $refId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeechAttemptsTable extends SpeechAttempts
    with TableInfo<$SpeechAttemptsTable, SpeechAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeechAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemRefMeta = const VerificationMeta(
    'itemRef',
  );
  @override
  late final GeneratedColumn<String> itemRef = GeneratedColumn<String>(
    'item_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchLevelMeta = const VerificationMeta(
    'matchLevel',
  );
  @override
  late final GeneratedColumn<String> matchLevel = GeneratedColumn<String>(
    'match_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _missingCountMeta = const VerificationMeta(
    'missingCount',
  );
  @override
  late final GeneratedColumn<int> missingCount = GeneratedColumn<int>(
    'missing_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorNoteIdMeta = const VerificationMeta(
    'errorNoteId',
  );
  @override
  late final GeneratedColumn<String> errorNoteId = GeneratedColumn<String>(
    'error_note_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: SyncIds.v4,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    place,
    contentId,
    itemRef,
    matchLevel,
    missingCount,
    errorNoteId,
    at,
    clientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speech_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeechAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    } else if (isInserting) {
      context.missing(_placeMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    }
    if (data.containsKey('item_ref')) {
      context.handle(
        _itemRefMeta,
        itemRef.isAcceptableOrUnknown(data['item_ref']!, _itemRefMeta),
      );
    } else if (isInserting) {
      context.missing(_itemRefMeta);
    }
    if (data.containsKey('match_level')) {
      context.handle(
        _matchLevelMeta,
        matchLevel.isAcceptableOrUnknown(data['match_level']!, _matchLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_matchLevelMeta);
    }
    if (data.containsKey('missing_count')) {
      context.handle(
        _missingCountMeta,
        missingCount.isAcceptableOrUnknown(
          data['missing_count']!,
          _missingCountMeta,
        ),
      );
    }
    if (data.containsKey('error_note_id')) {
      context.handle(
        _errorNoteIdMeta,
        errorNoteId.isAcceptableOrUnknown(
          data['error_note_id']!,
          _errorNoteIdMeta,
        ),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeechAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeechAttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      ),
      itemRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_ref'],
      )!,
      matchLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_level'],
      )!,
      missingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}missing_count'],
      )!,
      errorNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_note_id'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
    );
  }

  @override
  $SpeechAttemptsTable createAlias(String alias) {
    return $SpeechAttemptsTable(attachedDatabase, alias);
  }
}

class SpeechAttemptRow extends DataClass
    implements Insertable<SpeechAttemptRow> {
  final int id;

  /// `review` | `meaning` | `decision` | `episode_end`
  final String place;
  final String? contentId;

  /// Beklenen ifade (içerikteki metin) ya da karar seçeneği (`k1#a`).
  final String itemRef;

  /// `full` | `close` | `no` (karar anında seçilemediyse `no`).
  final String matchLevel;
  final int missingCount;

  /// Hata kataloğu kimliği (`can-short-answer` vb.).
  final String? errorNoteId;
  final DateTime at;

  /// Eşitleme kimliği (H-038, şema 5; UUIDv4). Tekil (dizin).
  final String? clientId;
  const SpeechAttemptRow({
    required this.id,
    required this.place,
    this.contentId,
    required this.itemRef,
    required this.matchLevel,
    required this.missingCount,
    this.errorNoteId,
    required this.at,
    this.clientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['place'] = Variable<String>(place);
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<String>(contentId);
    }
    map['item_ref'] = Variable<String>(itemRef);
    map['match_level'] = Variable<String>(matchLevel);
    map['missing_count'] = Variable<int>(missingCount);
    if (!nullToAbsent || errorNoteId != null) {
      map['error_note_id'] = Variable<String>(errorNoteId);
    }
    map['at'] = Variable<DateTime>(at);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    return map;
  }

  SpeechAttemptsCompanion toCompanion(bool nullToAbsent) {
    return SpeechAttemptsCompanion(
      id: Value(id),
      place: Value(place),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
      itemRef: Value(itemRef),
      matchLevel: Value(matchLevel),
      missingCount: Value(missingCount),
      errorNoteId: errorNoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(errorNoteId),
      at: Value(at),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
    );
  }

  factory SpeechAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeechAttemptRow(
      id: serializer.fromJson<int>(json['id']),
      place: serializer.fromJson<String>(json['place']),
      contentId: serializer.fromJson<String?>(json['contentId']),
      itemRef: serializer.fromJson<String>(json['itemRef']),
      matchLevel: serializer.fromJson<String>(json['matchLevel']),
      missingCount: serializer.fromJson<int>(json['missingCount']),
      errorNoteId: serializer.fromJson<String?>(json['errorNoteId']),
      at: serializer.fromJson<DateTime>(json['at']),
      clientId: serializer.fromJson<String?>(json['clientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'place': serializer.toJson<String>(place),
      'contentId': serializer.toJson<String?>(contentId),
      'itemRef': serializer.toJson<String>(itemRef),
      'matchLevel': serializer.toJson<String>(matchLevel),
      'missingCount': serializer.toJson<int>(missingCount),
      'errorNoteId': serializer.toJson<String?>(errorNoteId),
      'at': serializer.toJson<DateTime>(at),
      'clientId': serializer.toJson<String?>(clientId),
    };
  }

  SpeechAttemptRow copyWith({
    int? id,
    String? place,
    Value<String?> contentId = const Value.absent(),
    String? itemRef,
    String? matchLevel,
    int? missingCount,
    Value<String?> errorNoteId = const Value.absent(),
    DateTime? at,
    Value<String?> clientId = const Value.absent(),
  }) => SpeechAttemptRow(
    id: id ?? this.id,
    place: place ?? this.place,
    contentId: contentId.present ? contentId.value : this.contentId,
    itemRef: itemRef ?? this.itemRef,
    matchLevel: matchLevel ?? this.matchLevel,
    missingCount: missingCount ?? this.missingCount,
    errorNoteId: errorNoteId.present ? errorNoteId.value : this.errorNoteId,
    at: at ?? this.at,
    clientId: clientId.present ? clientId.value : this.clientId,
  );
  SpeechAttemptRow copyWithCompanion(SpeechAttemptsCompanion data) {
    return SpeechAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      place: data.place.present ? data.place.value : this.place,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      itemRef: data.itemRef.present ? data.itemRef.value : this.itemRef,
      matchLevel: data.matchLevel.present
          ? data.matchLevel.value
          : this.matchLevel,
      missingCount: data.missingCount.present
          ? data.missingCount.value
          : this.missingCount,
      errorNoteId: data.errorNoteId.present
          ? data.errorNoteId.value
          : this.errorNoteId,
      at: data.at.present ? data.at.value : this.at,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeechAttemptRow(')
          ..write('id: $id, ')
          ..write('place: $place, ')
          ..write('contentId: $contentId, ')
          ..write('itemRef: $itemRef, ')
          ..write('matchLevel: $matchLevel, ')
          ..write('missingCount: $missingCount, ')
          ..write('errorNoteId: $errorNoteId, ')
          ..write('at: $at, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    place,
    contentId,
    itemRef,
    matchLevel,
    missingCount,
    errorNoteId,
    at,
    clientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeechAttemptRow &&
          other.id == this.id &&
          other.place == this.place &&
          other.contentId == this.contentId &&
          other.itemRef == this.itemRef &&
          other.matchLevel == this.matchLevel &&
          other.missingCount == this.missingCount &&
          other.errorNoteId == this.errorNoteId &&
          other.at == this.at &&
          other.clientId == this.clientId);
}

class SpeechAttemptsCompanion extends UpdateCompanion<SpeechAttemptRow> {
  final Value<int> id;
  final Value<String> place;
  final Value<String?> contentId;
  final Value<String> itemRef;
  final Value<String> matchLevel;
  final Value<int> missingCount;
  final Value<String?> errorNoteId;
  final Value<DateTime> at;
  final Value<String?> clientId;
  const SpeechAttemptsCompanion({
    this.id = const Value.absent(),
    this.place = const Value.absent(),
    this.contentId = const Value.absent(),
    this.itemRef = const Value.absent(),
    this.matchLevel = const Value.absent(),
    this.missingCount = const Value.absent(),
    this.errorNoteId = const Value.absent(),
    this.at = const Value.absent(),
    this.clientId = const Value.absent(),
  });
  SpeechAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String place,
    this.contentId = const Value.absent(),
    required String itemRef,
    required String matchLevel,
    this.missingCount = const Value.absent(),
    this.errorNoteId = const Value.absent(),
    required DateTime at,
    this.clientId = const Value.absent(),
  }) : place = Value(place),
       itemRef = Value(itemRef),
       matchLevel = Value(matchLevel),
       at = Value(at);
  static Insertable<SpeechAttemptRow> custom({
    Expression<int>? id,
    Expression<String>? place,
    Expression<String>? contentId,
    Expression<String>? itemRef,
    Expression<String>? matchLevel,
    Expression<int>? missingCount,
    Expression<String>? errorNoteId,
    Expression<DateTime>? at,
    Expression<String>? clientId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (place != null) 'place': place,
      if (contentId != null) 'content_id': contentId,
      if (itemRef != null) 'item_ref': itemRef,
      if (matchLevel != null) 'match_level': matchLevel,
      if (missingCount != null) 'missing_count': missingCount,
      if (errorNoteId != null) 'error_note_id': errorNoteId,
      if (at != null) 'at': at,
      if (clientId != null) 'client_id': clientId,
    });
  }

  SpeechAttemptsCompanion copyWith({
    Value<int>? id,
    Value<String>? place,
    Value<String?>? contentId,
    Value<String>? itemRef,
    Value<String>? matchLevel,
    Value<int>? missingCount,
    Value<String?>? errorNoteId,
    Value<DateTime>? at,
    Value<String?>? clientId,
  }) {
    return SpeechAttemptsCompanion(
      id: id ?? this.id,
      place: place ?? this.place,
      contentId: contentId ?? this.contentId,
      itemRef: itemRef ?? this.itemRef,
      matchLevel: matchLevel ?? this.matchLevel,
      missingCount: missingCount ?? this.missingCount,
      errorNoteId: errorNoteId ?? this.errorNoteId,
      at: at ?? this.at,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (itemRef.present) {
      map['item_ref'] = Variable<String>(itemRef.value);
    }
    if (matchLevel.present) {
      map['match_level'] = Variable<String>(matchLevel.value);
    }
    if (missingCount.present) {
      map['missing_count'] = Variable<int>(missingCount.value);
    }
    if (errorNoteId.present) {
      map['error_note_id'] = Variable<String>(errorNoteId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeechAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('place: $place, ')
          ..write('contentId: $contentId, ')
          ..write('itemRef: $itemRef, ')
          ..write('matchLevel: $matchLevel, ')
          ..write('missingCount: $missingCount, ')
          ..write('errorNoteId: $errorNoteId, ')
          ..write('at: $at, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _accountUserIdMeta = const VerificationMeta(
    'accountUserId',
  );
  @override
  late final GeneratedColumn<String> accountUserId = GeneratedColumn<String>(
    'account_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMaskedMeta = const VerificationMeta(
    'emailMasked',
  );
  @override
  late final GeneratedColumn<String> emailMasked = GeneratedColumn<String>(
    'email_masked',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountStatusMeta = const VerificationMeta(
    'accountStatus',
  );
  @override
  late final GeneratedColumn<String> accountStatus = GeneratedColumn<String>(
    'account_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledPurgeAtMeta = const VerificationMeta(
    'scheduledPurgeAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledPurgeAt =
      GeneratedColumn<DateTime>(
        'scheduled_purge_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPullCursorMeta = const VerificationMeta(
    'lastPullCursor',
  );
  @override
  late final GeneratedColumn<int> lastPullCursor = GeneratedColumn<int>(
    'last_pull_cursor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPushAtMeta = const VerificationMeta(
    'lastPushAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPushAt = GeneratedColumn<DateTime>(
    'last_push_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialUploadDoneMeta = const VerificationMeta(
    'initialUploadDone',
  );
  @override
  late final GeneratedColumn<bool> initialUploadDone = GeneratedColumn<bool>(
    'initial_upload_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("initial_upload_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _applyingMeta = const VerificationMeta(
    'applying',
  );
  @override
  late final GeneratedColumn<bool> applying = GeneratedColumn<bool>(
    'applying',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applying" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingSpeechDeleteMeta =
      const VerificationMeta('pendingSpeechDelete');
  @override
  late final GeneratedColumn<bool> pendingSpeechDelete = GeneratedColumn<bool>(
    'pending_speech_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_speech_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastErrorCodeMeta = const VerificationMeta(
    'lastErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastErrorCode = GeneratedColumn<String>(
    'last_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedOutReasonMeta = const VerificationMeta(
    'signedOutReason',
  );
  @override
  late final GeneratedColumn<String> signedOutReason = GeneratedColumn<String>(
    'signed_out_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountUserId,
    emailMasked,
    accountStatus,
    scheduledPurgeAt,
    deviceId,
    lastPullCursor,
    lastSyncAt,
    lastPushAt,
    initialUploadDone,
    applying,
    pendingSpeechDelete,
    lastErrorCode,
    signedOutReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_user_id')) {
      context.handle(
        _accountUserIdMeta,
        accountUserId.isAcceptableOrUnknown(
          data['account_user_id']!,
          _accountUserIdMeta,
        ),
      );
    }
    if (data.containsKey('email_masked')) {
      context.handle(
        _emailMaskedMeta,
        emailMasked.isAcceptableOrUnknown(
          data['email_masked']!,
          _emailMaskedMeta,
        ),
      );
    }
    if (data.containsKey('account_status')) {
      context.handle(
        _accountStatusMeta,
        accountStatus.isAcceptableOrUnknown(
          data['account_status']!,
          _accountStatusMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_purge_at')) {
      context.handle(
        _scheduledPurgeAtMeta,
        scheduledPurgeAt.isAcceptableOrUnknown(
          data['scheduled_purge_at']!,
          _scheduledPurgeAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('last_pull_cursor')) {
      context.handle(
        _lastPullCursorMeta,
        lastPullCursor.isAcceptableOrUnknown(
          data['last_pull_cursor']!,
          _lastPullCursorMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('last_push_at')) {
      context.handle(
        _lastPushAtMeta,
        lastPushAt.isAcceptableOrUnknown(
          data['last_push_at']!,
          _lastPushAtMeta,
        ),
      );
    }
    if (data.containsKey('initial_upload_done')) {
      context.handle(
        _initialUploadDoneMeta,
        initialUploadDone.isAcceptableOrUnknown(
          data['initial_upload_done']!,
          _initialUploadDoneMeta,
        ),
      );
    }
    if (data.containsKey('applying')) {
      context.handle(
        _applyingMeta,
        applying.isAcceptableOrUnknown(data['applying']!, _applyingMeta),
      );
    }
    if (data.containsKey('pending_speech_delete')) {
      context.handle(
        _pendingSpeechDeleteMeta,
        pendingSpeechDelete.isAcceptableOrUnknown(
          data['pending_speech_delete']!,
          _pendingSpeechDeleteMeta,
        ),
      );
    }
    if (data.containsKey('last_error_code')) {
      context.handle(
        _lastErrorCodeMeta,
        lastErrorCode.isAcceptableOrUnknown(
          data['last_error_code']!,
          _lastErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('signed_out_reason')) {
      context.handle(
        _signedOutReasonMeta,
        signedOutReason.isAcceptableOrUnknown(
          data['signed_out_reason']!,
          _signedOutReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_user_id'],
      ),
      emailMasked: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_masked'],
      ),
      accountStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_status'],
      ),
      scheduledPurgeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_purge_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      lastPullCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_pull_cursor'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      lastPushAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_push_at'],
      ),
      initialUploadDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}initial_upload_done'],
      )!,
      applying: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applying'],
      )!,
      pendingSpeechDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_speech_delete'],
      )!,
      lastErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_code'],
      ),
      signedOutReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_out_reason'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final int id;

  /// Hesabın kimliği (`/me` → `id`); yalnızca oturum açıkken dolu.
  final String? accountUserId;

  /// Gösterim için maskeli e-posta (`d•••@example.com`); açık e-posta
  /// cihazda saklanmaz.
  final String? emailMasked;

  /// `ACTIVE` | `PENDING_DELETION`
  final String? accountStatus;
  final DateTime? scheduledPurgeAt;

  /// Bu kurulumun rastgele kimliği (itmede `deviceId`; sunucu saklamaz).
  final String? deviceId;

  /// Çekme imleci (`/sync/pull?since=`).
  final int lastPullCursor;
  final DateTime? lastSyncAt;
  final DateTime? lastPushAt;

  /// Cihazdaki verinin hesaba ilk yüklemesi bitti mi.
  final bool initialUploadDone;

  /// Sunucudan gelen satırlar yazılırken 1: tetikleyiciler kuyruğa yazmaz.
  final bool applying;

  /// "Hi'nin kayıtlarını sil" sonrası `DELETE /sync/speech-attempts` bekliyor.
  final bool pendingSpeechDelete;

  /// Son eşitleme hatasının kodu (`NETWORK`, `RATE_LIMITED` …); başarıda boş.
  final String? lastErrorCode;

  /// Oturum cihazda kapatıldıysa nedeni (`TOKEN_REUSED` …); gösterilince silinir.
  final String? signedOutReason;
  const SyncStateRow({
    required this.id,
    this.accountUserId,
    this.emailMasked,
    this.accountStatus,
    this.scheduledPurgeAt,
    this.deviceId,
    required this.lastPullCursor,
    this.lastSyncAt,
    this.lastPushAt,
    required this.initialUploadDone,
    required this.applying,
    required this.pendingSpeechDelete,
    this.lastErrorCode,
    this.signedOutReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || accountUserId != null) {
      map['account_user_id'] = Variable<String>(accountUserId);
    }
    if (!nullToAbsent || emailMasked != null) {
      map['email_masked'] = Variable<String>(emailMasked);
    }
    if (!nullToAbsent || accountStatus != null) {
      map['account_status'] = Variable<String>(accountStatus);
    }
    if (!nullToAbsent || scheduledPurgeAt != null) {
      map['scheduled_purge_at'] = Variable<DateTime>(scheduledPurgeAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['last_pull_cursor'] = Variable<int>(lastPullCursor);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || lastPushAt != null) {
      map['last_push_at'] = Variable<DateTime>(lastPushAt);
    }
    map['initial_upload_done'] = Variable<bool>(initialUploadDone);
    map['applying'] = Variable<bool>(applying);
    map['pending_speech_delete'] = Variable<bool>(pendingSpeechDelete);
    if (!nullToAbsent || lastErrorCode != null) {
      map['last_error_code'] = Variable<String>(lastErrorCode);
    }
    if (!nullToAbsent || signedOutReason != null) {
      map['signed_out_reason'] = Variable<String>(signedOutReason);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      accountUserId: accountUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountUserId),
      emailMasked: emailMasked == null && nullToAbsent
          ? const Value.absent()
          : Value(emailMasked),
      accountStatus: accountStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(accountStatus),
      scheduledPurgeAt: scheduledPurgeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledPurgeAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      lastPullCursor: Value(lastPullCursor),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      lastPushAt: lastPushAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPushAt),
      initialUploadDone: Value(initialUploadDone),
      applying: Value(applying),
      pendingSpeechDelete: Value(pendingSpeechDelete),
      lastErrorCode: lastErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCode),
      signedOutReason: signedOutReason == null && nullToAbsent
          ? const Value.absent()
          : Value(signedOutReason),
    );
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      id: serializer.fromJson<int>(json['id']),
      accountUserId: serializer.fromJson<String?>(json['accountUserId']),
      emailMasked: serializer.fromJson<String?>(json['emailMasked']),
      accountStatus: serializer.fromJson<String?>(json['accountStatus']),
      scheduledPurgeAt: serializer.fromJson<DateTime?>(
        json['scheduledPurgeAt'],
      ),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      lastPullCursor: serializer.fromJson<int>(json['lastPullCursor']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      lastPushAt: serializer.fromJson<DateTime?>(json['lastPushAt']),
      initialUploadDone: serializer.fromJson<bool>(json['initialUploadDone']),
      applying: serializer.fromJson<bool>(json['applying']),
      pendingSpeechDelete: serializer.fromJson<bool>(
        json['pendingSpeechDelete'],
      ),
      lastErrorCode: serializer.fromJson<String?>(json['lastErrorCode']),
      signedOutReason: serializer.fromJson<String?>(json['signedOutReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountUserId': serializer.toJson<String?>(accountUserId),
      'emailMasked': serializer.toJson<String?>(emailMasked),
      'accountStatus': serializer.toJson<String?>(accountStatus),
      'scheduledPurgeAt': serializer.toJson<DateTime?>(scheduledPurgeAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'lastPullCursor': serializer.toJson<int>(lastPullCursor),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'lastPushAt': serializer.toJson<DateTime?>(lastPushAt),
      'initialUploadDone': serializer.toJson<bool>(initialUploadDone),
      'applying': serializer.toJson<bool>(applying),
      'pendingSpeechDelete': serializer.toJson<bool>(pendingSpeechDelete),
      'lastErrorCode': serializer.toJson<String?>(lastErrorCode),
      'signedOutReason': serializer.toJson<String?>(signedOutReason),
    };
  }

  SyncStateRow copyWith({
    int? id,
    Value<String?> accountUserId = const Value.absent(),
    Value<String?> emailMasked = const Value.absent(),
    Value<String?> accountStatus = const Value.absent(),
    Value<DateTime?> scheduledPurgeAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    int? lastPullCursor,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    Value<DateTime?> lastPushAt = const Value.absent(),
    bool? initialUploadDone,
    bool? applying,
    bool? pendingSpeechDelete,
    Value<String?> lastErrorCode = const Value.absent(),
    Value<String?> signedOutReason = const Value.absent(),
  }) => SyncStateRow(
    id: id ?? this.id,
    accountUserId: accountUserId.present
        ? accountUserId.value
        : this.accountUserId,
    emailMasked: emailMasked.present ? emailMasked.value : this.emailMasked,
    accountStatus: accountStatus.present
        ? accountStatus.value
        : this.accountStatus,
    scheduledPurgeAt: scheduledPurgeAt.present
        ? scheduledPurgeAt.value
        : this.scheduledPurgeAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    lastPullCursor: lastPullCursor ?? this.lastPullCursor,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    lastPushAt: lastPushAt.present ? lastPushAt.value : this.lastPushAt,
    initialUploadDone: initialUploadDone ?? this.initialUploadDone,
    applying: applying ?? this.applying,
    pendingSpeechDelete: pendingSpeechDelete ?? this.pendingSpeechDelete,
    lastErrorCode: lastErrorCode.present
        ? lastErrorCode.value
        : this.lastErrorCode,
    signedOutReason: signedOutReason.present
        ? signedOutReason.value
        : this.signedOutReason,
  );
  SyncStateRow copyWithCompanion(SyncStateCompanion data) {
    return SyncStateRow(
      id: data.id.present ? data.id.value : this.id,
      accountUserId: data.accountUserId.present
          ? data.accountUserId.value
          : this.accountUserId,
      emailMasked: data.emailMasked.present
          ? data.emailMasked.value
          : this.emailMasked,
      accountStatus: data.accountStatus.present
          ? data.accountStatus.value
          : this.accountStatus,
      scheduledPurgeAt: data.scheduledPurgeAt.present
          ? data.scheduledPurgeAt.value
          : this.scheduledPurgeAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      lastPullCursor: data.lastPullCursor.present
          ? data.lastPullCursor.value
          : this.lastPullCursor,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      lastPushAt: data.lastPushAt.present
          ? data.lastPushAt.value
          : this.lastPushAt,
      initialUploadDone: data.initialUploadDone.present
          ? data.initialUploadDone.value
          : this.initialUploadDone,
      applying: data.applying.present ? data.applying.value : this.applying,
      pendingSpeechDelete: data.pendingSpeechDelete.present
          ? data.pendingSpeechDelete.value
          : this.pendingSpeechDelete,
      lastErrorCode: data.lastErrorCode.present
          ? data.lastErrorCode.value
          : this.lastErrorCode,
      signedOutReason: data.signedOutReason.present
          ? data.signedOutReason.value
          : this.signedOutReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('id: $id, ')
          ..write('accountUserId: $accountUserId, ')
          ..write('emailMasked: $emailMasked, ')
          ..write('accountStatus: $accountStatus, ')
          ..write('scheduledPurgeAt: $scheduledPurgeAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastPullCursor: $lastPullCursor, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('initialUploadDone: $initialUploadDone, ')
          ..write('applying: $applying, ')
          ..write('pendingSpeechDelete: $pendingSpeechDelete, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('signedOutReason: $signedOutReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountUserId,
    emailMasked,
    accountStatus,
    scheduledPurgeAt,
    deviceId,
    lastPullCursor,
    lastSyncAt,
    lastPushAt,
    initialUploadDone,
    applying,
    pendingSpeechDelete,
    lastErrorCode,
    signedOutReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.id == this.id &&
          other.accountUserId == this.accountUserId &&
          other.emailMasked == this.emailMasked &&
          other.accountStatus == this.accountStatus &&
          other.scheduledPurgeAt == this.scheduledPurgeAt &&
          other.deviceId == this.deviceId &&
          other.lastPullCursor == this.lastPullCursor &&
          other.lastSyncAt == this.lastSyncAt &&
          other.lastPushAt == this.lastPushAt &&
          other.initialUploadDone == this.initialUploadDone &&
          other.applying == this.applying &&
          other.pendingSpeechDelete == this.pendingSpeechDelete &&
          other.lastErrorCode == this.lastErrorCode &&
          other.signedOutReason == this.signedOutReason);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<int> id;
  final Value<String?> accountUserId;
  final Value<String?> emailMasked;
  final Value<String?> accountStatus;
  final Value<DateTime?> scheduledPurgeAt;
  final Value<String?> deviceId;
  final Value<int> lastPullCursor;
  final Value<DateTime?> lastSyncAt;
  final Value<DateTime?> lastPushAt;
  final Value<bool> initialUploadDone;
  final Value<bool> applying;
  final Value<bool> pendingSpeechDelete;
  final Value<String?> lastErrorCode;
  final Value<String?> signedOutReason;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.accountUserId = const Value.absent(),
    this.emailMasked = const Value.absent(),
    this.accountStatus = const Value.absent(),
    this.scheduledPurgeAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.lastPullCursor = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.initialUploadDone = const Value.absent(),
    this.applying = const Value.absent(),
    this.pendingSpeechDelete = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.signedOutReason = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    this.accountUserId = const Value.absent(),
    this.emailMasked = const Value.absent(),
    this.accountStatus = const Value.absent(),
    this.scheduledPurgeAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.lastPullCursor = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.initialUploadDone = const Value.absent(),
    this.applying = const Value.absent(),
    this.pendingSpeechDelete = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.signedOutReason = const Value.absent(),
  });
  static Insertable<SyncStateRow> custom({
    Expression<int>? id,
    Expression<String>? accountUserId,
    Expression<String>? emailMasked,
    Expression<String>? accountStatus,
    Expression<DateTime>? scheduledPurgeAt,
    Expression<String>? deviceId,
    Expression<int>? lastPullCursor,
    Expression<DateTime>? lastSyncAt,
    Expression<DateTime>? lastPushAt,
    Expression<bool>? initialUploadDone,
    Expression<bool>? applying,
    Expression<bool>? pendingSpeechDelete,
    Expression<String>? lastErrorCode,
    Expression<String>? signedOutReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountUserId != null) 'account_user_id': accountUserId,
      if (emailMasked != null) 'email_masked': emailMasked,
      if (accountStatus != null) 'account_status': accountStatus,
      if (scheduledPurgeAt != null) 'scheduled_purge_at': scheduledPurgeAt,
      if (deviceId != null) 'device_id': deviceId,
      if (lastPullCursor != null) 'last_pull_cursor': lastPullCursor,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (lastPushAt != null) 'last_push_at': lastPushAt,
      if (initialUploadDone != null) 'initial_upload_done': initialUploadDone,
      if (applying != null) 'applying': applying,
      if (pendingSpeechDelete != null)
        'pending_speech_delete': pendingSpeechDelete,
      if (lastErrorCode != null) 'last_error_code': lastErrorCode,
      if (signedOutReason != null) 'signed_out_reason': signedOutReason,
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<String?>? accountUserId,
    Value<String?>? emailMasked,
    Value<String?>? accountStatus,
    Value<DateTime?>? scheduledPurgeAt,
    Value<String?>? deviceId,
    Value<int>? lastPullCursor,
    Value<DateTime?>? lastSyncAt,
    Value<DateTime?>? lastPushAt,
    Value<bool>? initialUploadDone,
    Value<bool>? applying,
    Value<bool>? pendingSpeechDelete,
    Value<String?>? lastErrorCode,
    Value<String?>? signedOutReason,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      accountUserId: accountUserId ?? this.accountUserId,
      emailMasked: emailMasked ?? this.emailMasked,
      accountStatus: accountStatus ?? this.accountStatus,
      scheduledPurgeAt: scheduledPurgeAt ?? this.scheduledPurgeAt,
      deviceId: deviceId ?? this.deviceId,
      lastPullCursor: lastPullCursor ?? this.lastPullCursor,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastPushAt: lastPushAt ?? this.lastPushAt,
      initialUploadDone: initialUploadDone ?? this.initialUploadDone,
      applying: applying ?? this.applying,
      pendingSpeechDelete: pendingSpeechDelete ?? this.pendingSpeechDelete,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      signedOutReason: signedOutReason ?? this.signedOutReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountUserId.present) {
      map['account_user_id'] = Variable<String>(accountUserId.value);
    }
    if (emailMasked.present) {
      map['email_masked'] = Variable<String>(emailMasked.value);
    }
    if (accountStatus.present) {
      map['account_status'] = Variable<String>(accountStatus.value);
    }
    if (scheduledPurgeAt.present) {
      map['scheduled_purge_at'] = Variable<DateTime>(scheduledPurgeAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (lastPullCursor.present) {
      map['last_pull_cursor'] = Variable<int>(lastPullCursor.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (lastPushAt.present) {
      map['last_push_at'] = Variable<DateTime>(lastPushAt.value);
    }
    if (initialUploadDone.present) {
      map['initial_upload_done'] = Variable<bool>(initialUploadDone.value);
    }
    if (applying.present) {
      map['applying'] = Variable<bool>(applying.value);
    }
    if (pendingSpeechDelete.present) {
      map['pending_speech_delete'] = Variable<bool>(pendingSpeechDelete.value);
    }
    if (lastErrorCode.present) {
      map['last_error_code'] = Variable<String>(lastErrorCode.value);
    }
    if (signedOutReason.present) {
      map['signed_out_reason'] = Variable<String>(signedOutReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('accountUserId: $accountUserId, ')
          ..write('emailMasked: $emailMasked, ')
          ..write('accountStatus: $accountStatus, ')
          ..write('scheduledPurgeAt: $scheduledPurgeAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastPullCursor: $lastPullCursor, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('initialUploadDone: $initialUploadDone, ')
          ..write('applying: $applying, ')
          ..write('pendingSpeechDelete: $pendingSpeechDelete, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('signedOutReason: $signedOutReason')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tblMeta = const VerificationMeta('tbl');
  @override
  late final GeneratedColumn<String> tbl = GeneratedColumn<String>(
    'tbl',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _k1Meta = const VerificationMeta('k1');
  @override
  late final GeneratedColumn<String> k1 = GeneratedColumn<String>(
    'k1',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _k2Meta = const VerificationMeta('k2');
  @override
  late final GeneratedColumn<String> k2 = GeneratedColumn<String>(
    'k2',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _k3Meta = const VerificationMeta('k3');
  @override
  late final GeneratedColumn<String> k3 = GeneratedColumn<String>(
    'k3',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockedMeta = const VerificationMeta(
    'blocked',
  );
  @override
  late final GeneratedColumn<bool> blocked = GeneratedColumn<bool>(
    'blocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("blocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    tbl,
    k1,
    k2,
    k3,
    deleted,
    rev,
    changedAt,
    blocked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tbl')) {
      context.handle(
        _tblMeta,
        tbl.isAcceptableOrUnknown(data['tbl']!, _tblMeta),
      );
    } else if (isInserting) {
      context.missing(_tblMeta);
    }
    if (data.containsKey('k1')) {
      context.handle(_k1Meta, k1.isAcceptableOrUnknown(data['k1']!, _k1Meta));
    } else if (isInserting) {
      context.missing(_k1Meta);
    }
    if (data.containsKey('k2')) {
      context.handle(_k2Meta, k2.isAcceptableOrUnknown(data['k2']!, _k2Meta));
    }
    if (data.containsKey('k3')) {
      context.handle(_k3Meta, k3.isAcceptableOrUnknown(data['k3']!, _k3Meta));
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('blocked')) {
      context.handle(
        _blockedMeta,
        blocked.isAcceptableOrUnknown(data['blocked']!, _blockedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tbl, k1, k2, k3};
  @override
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      tbl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tbl'],
      )!,
      k1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}k1'],
      )!,
      k2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}k2'],
      )!,
      k3: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}k3'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      blocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}blocked'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final String tbl;
  final String k1;
  final String k2;
  final String k3;

  /// Değişiklik silme miydi (bilgi; satırın varlığı esastır).
  final bool deleted;

  /// Her değişiklikte artar: itme sırasında yeniden değişen satır kuyrukta kalır.
  final int rev;
  final DateTime changedAt;

  /// Sunucu bu satırı reddettiyse 1: satır yeniden değişene kadar atlanır
  /// (eşitlemenin tamamı takılmasın).
  final bool blocked;
  const SyncOutboxRow({
    required this.tbl,
    required this.k1,
    required this.k2,
    required this.k3,
    required this.deleted,
    required this.rev,
    required this.changedAt,
    required this.blocked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tbl'] = Variable<String>(tbl);
    map['k1'] = Variable<String>(k1);
    map['k2'] = Variable<String>(k2);
    map['k3'] = Variable<String>(k3);
    map['deleted'] = Variable<bool>(deleted);
    map['rev'] = Variable<int>(rev);
    map['changed_at'] = Variable<DateTime>(changedAt);
    map['blocked'] = Variable<bool>(blocked);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      tbl: Value(tbl),
      k1: Value(k1),
      k2: Value(k2),
      k3: Value(k3),
      deleted: Value(deleted),
      rev: Value(rev),
      changedAt: Value(changedAt),
      blocked: Value(blocked),
    );
  }

  factory SyncOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      tbl: serializer.fromJson<String>(json['tbl']),
      k1: serializer.fromJson<String>(json['k1']),
      k2: serializer.fromJson<String>(json['k2']),
      k3: serializer.fromJson<String>(json['k3']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      rev: serializer.fromJson<int>(json['rev']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      blocked: serializer.fromJson<bool>(json['blocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tbl': serializer.toJson<String>(tbl),
      'k1': serializer.toJson<String>(k1),
      'k2': serializer.toJson<String>(k2),
      'k3': serializer.toJson<String>(k3),
      'deleted': serializer.toJson<bool>(deleted),
      'rev': serializer.toJson<int>(rev),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'blocked': serializer.toJson<bool>(blocked),
    };
  }

  SyncOutboxRow copyWith({
    String? tbl,
    String? k1,
    String? k2,
    String? k3,
    bool? deleted,
    int? rev,
    DateTime? changedAt,
    bool? blocked,
  }) => SyncOutboxRow(
    tbl: tbl ?? this.tbl,
    k1: k1 ?? this.k1,
    k2: k2 ?? this.k2,
    k3: k3 ?? this.k3,
    deleted: deleted ?? this.deleted,
    rev: rev ?? this.rev,
    changedAt: changedAt ?? this.changedAt,
    blocked: blocked ?? this.blocked,
  );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      tbl: data.tbl.present ? data.tbl.value : this.tbl,
      k1: data.k1.present ? data.k1.value : this.k1,
      k2: data.k2.present ? data.k2.value : this.k2,
      k3: data.k3.present ? data.k3.value : this.k3,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      rev: data.rev.present ? data.rev.value : this.rev,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      blocked: data.blocked.present ? data.blocked.value : this.blocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('tbl: $tbl, ')
          ..write('k1: $k1, ')
          ..write('k2: $k2, ')
          ..write('k3: $k3, ')
          ..write('deleted: $deleted, ')
          ..write('rev: $rev, ')
          ..write('changedAt: $changedAt, ')
          ..write('blocked: $blocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tbl, k1, k2, k3, deleted, rev, changedAt, blocked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.tbl == this.tbl &&
          other.k1 == this.k1 &&
          other.k2 == this.k2 &&
          other.k3 == this.k3 &&
          other.deleted == this.deleted &&
          other.rev == this.rev &&
          other.changedAt == this.changedAt &&
          other.blocked == this.blocked);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<String> tbl;
  final Value<String> k1;
  final Value<String> k2;
  final Value<String> k3;
  final Value<bool> deleted;
  final Value<int> rev;
  final Value<DateTime> changedAt;
  final Value<bool> blocked;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.tbl = const Value.absent(),
    this.k1 = const Value.absent(),
    this.k2 = const Value.absent(),
    this.k3 = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rev = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.blocked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String tbl,
    required String k1,
    this.k2 = const Value.absent(),
    this.k3 = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rev = const Value.absent(),
    required DateTime changedAt,
    this.blocked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tbl = Value(tbl),
       k1 = Value(k1),
       changedAt = Value(changedAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<String>? tbl,
    Expression<String>? k1,
    Expression<String>? k2,
    Expression<String>? k3,
    Expression<bool>? deleted,
    Expression<int>? rev,
    Expression<DateTime>? changedAt,
    Expression<bool>? blocked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tbl != null) 'tbl': tbl,
      if (k1 != null) 'k1': k1,
      if (k2 != null) 'k2': k2,
      if (k3 != null) 'k3': k3,
      if (deleted != null) 'deleted': deleted,
      if (rev != null) 'rev': rev,
      if (changedAt != null) 'changed_at': changedAt,
      if (blocked != null) 'blocked': blocked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? tbl,
    Value<String>? k1,
    Value<String>? k2,
    Value<String>? k3,
    Value<bool>? deleted,
    Value<int>? rev,
    Value<DateTime>? changedAt,
    Value<bool>? blocked,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      tbl: tbl ?? this.tbl,
      k1: k1 ?? this.k1,
      k2: k2 ?? this.k2,
      k3: k3 ?? this.k3,
      deleted: deleted ?? this.deleted,
      rev: rev ?? this.rev,
      changedAt: changedAt ?? this.changedAt,
      blocked: blocked ?? this.blocked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tbl.present) {
      map['tbl'] = Variable<String>(tbl.value);
    }
    if (k1.present) {
      map['k1'] = Variable<String>(k1.value);
    }
    if (k2.present) {
      map['k2'] = Variable<String>(k2.value);
    }
    if (k3.present) {
      map['k3'] = Variable<String>(k3.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (blocked.present) {
      map['blocked'] = Variable<bool>(blocked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('tbl: $tbl, ')
          ..write('k1: $k1, ')
          ..write('k2: $k2, ')
          ..write('k3: $k3, ')
          ..write('deleted: $deleted, ')
          ..write('rev: $rev, ')
          ..write('changedAt: $changedAt, ')
          ..write('blocked: $blocked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserBookProgressTable extends UserBookProgress
    with TableInfo<$UserBookProgressTable, UserBookProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserBookProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NOT_STARTED'),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentenceIndexMeta = const VerificationMeta(
    'sentenceIndex',
  );
  @override
  late final GeneratedColumn<int> sentenceIndex = GeneratedColumn<int>(
    'sentence_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionSecMeta = const VerificationMeta(
    'positionSec',
  );
  @override
  late final GeneratedColumn<double> positionSec = GeneratedColumn<double>(
    'position_sec',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    status,
    chapterId,
    pageNumber,
    sentenceIndex,
    positionSec,
    startedAt,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_book_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserBookProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('sentence_index')) {
      context.handle(
        _sentenceIndexMeta,
        sentenceIndex.isAcceptableOrUnknown(
          data['sentence_index']!,
          _sentenceIndexMeta,
        ),
      );
    }
    if (data.containsKey('position_sec')) {
      context.handle(
        _positionSecMeta,
        positionSec.isAcceptableOrUnknown(
          data['position_sec']!,
          _positionSecMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  UserBookProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserBookProgressData(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      sentenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_index'],
      ),
      positionSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_sec'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserBookProgressTable createAlias(String alias) {
    return $UserBookProgressTable(attachedDatabase, alias);
  }
}

class UserBookProgressData extends DataClass
    implements Insertable<UserBookProgressData> {
  final String bookId;

  /// `NOT_STARTED` | `IN_PROGRESS` | `COMPLETED`
  final String status;

  /// Kalınan yer: bölüm (`c1`), sayfa numarası, sayfadaki cümle sırası
  /// (−1: bölüm başlığı) ve bölüm sesindeki konum (sn).
  final String? chapterId;
  final int? pageNumber;
  final int? sentenceIndex;
  final double? positionSec;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const UserBookProgressData({
    required this.bookId,
    required this.status,
    this.chapterId,
    this.pageNumber,
    this.sentenceIndex,
    this.positionSec,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    if (!nullToAbsent || sentenceIndex != null) {
      map['sentence_index'] = Variable<int>(sentenceIndex);
    }
    if (!nullToAbsent || positionSec != null) {
      map['position_sec'] = Variable<double>(positionSec);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserBookProgressCompanion toCompanion(bool nullToAbsent) {
    return UserBookProgressCompanion(
      bookId: Value(bookId),
      status: Value(status),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      sentenceIndex: sentenceIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(sentenceIndex),
      positionSec: positionSec == null && nullToAbsent
          ? const Value.absent()
          : Value(positionSec),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserBookProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserBookProgressData(
      bookId: serializer.fromJson<String>(json['bookId']),
      status: serializer.fromJson<String>(json['status']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      sentenceIndex: serializer.fromJson<int?>(json['sentenceIndex']),
      positionSec: serializer.fromJson<double?>(json['positionSec']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'status': serializer.toJson<String>(status),
      'chapterId': serializer.toJson<String?>(chapterId),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'sentenceIndex': serializer.toJson<int?>(sentenceIndex),
      'positionSec': serializer.toJson<double?>(positionSec),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserBookProgressData copyWith({
    String? bookId,
    String? status,
    Value<String?> chapterId = const Value.absent(),
    Value<int?> pageNumber = const Value.absent(),
    Value<int?> sentenceIndex = const Value.absent(),
    Value<double?> positionSec = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => UserBookProgressData(
    bookId: bookId ?? this.bookId,
    status: status ?? this.status,
    chapterId: chapterId.present ? chapterId.value : this.chapterId,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    sentenceIndex: sentenceIndex.present
        ? sentenceIndex.value
        : this.sentenceIndex,
    positionSec: positionSec.present ? positionSec.value : this.positionSec,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserBookProgressData copyWithCompanion(UserBookProgressCompanion data) {
    return UserBookProgressData(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      status: data.status.present ? data.status.value : this.status,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      sentenceIndex: data.sentenceIndex.present
          ? data.sentenceIndex.value
          : this.sentenceIndex,
      positionSec: data.positionSec.present
          ? data.positionSec.value
          : this.positionSec,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserBookProgressData(')
          ..write('bookId: $bookId, ')
          ..write('status: $status, ')
          ..write('chapterId: $chapterId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('sentenceIndex: $sentenceIndex, ')
          ..write('positionSec: $positionSec, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookId,
    status,
    chapterId,
    pageNumber,
    sentenceIndex,
    positionSec,
    startedAt,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBookProgressData &&
          other.bookId == this.bookId &&
          other.status == this.status &&
          other.chapterId == this.chapterId &&
          other.pageNumber == this.pageNumber &&
          other.sentenceIndex == this.sentenceIndex &&
          other.positionSec == this.positionSec &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class UserBookProgressCompanion extends UpdateCompanion<UserBookProgressData> {
  final Value<String> bookId;
  final Value<String> status;
  final Value<String?> chapterId;
  final Value<int?> pageNumber;
  final Value<int?> sentenceIndex;
  final Value<double?> positionSec;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserBookProgressCompanion({
    this.bookId = const Value.absent(),
    this.status = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.sentenceIndex = const Value.absent(),
    this.positionSec = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserBookProgressCompanion.insert({
    required String bookId,
    this.status = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.sentenceIndex = const Value.absent(),
    this.positionSec = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       updatedAt = Value(updatedAt);
  static Insertable<UserBookProgressData> custom({
    Expression<String>? bookId,
    Expression<String>? status,
    Expression<String>? chapterId,
    Expression<int>? pageNumber,
    Expression<int>? sentenceIndex,
    Expression<double>? positionSec,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (status != null) 'status': status,
      if (chapterId != null) 'chapter_id': chapterId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (sentenceIndex != null) 'sentence_index': sentenceIndex,
      if (positionSec != null) 'position_sec': positionSec,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserBookProgressCompanion copyWith({
    Value<String>? bookId,
    Value<String>? status,
    Value<String?>? chapterId,
    Value<int?>? pageNumber,
    Value<int?>? sentenceIndex,
    Value<double?>? positionSec,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserBookProgressCompanion(
      bookId: bookId ?? this.bookId,
      status: status ?? this.status,
      chapterId: chapterId ?? this.chapterId,
      pageNumber: pageNumber ?? this.pageNumber,
      sentenceIndex: sentenceIndex ?? this.sentenceIndex,
      positionSec: positionSec ?? this.positionSec,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (sentenceIndex.present) {
      map['sentence_index'] = Variable<int>(sentenceIndex.value);
    }
    if (positionSec.present) {
      map['position_sec'] = Variable<double>(positionSec.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserBookProgressCompanion(')
          ..write('bookId: $bookId, ')
          ..write('status: $status, ')
          ..write('chapterId: $chapterId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('sentenceIndex: $sentenceIndex, ')
          ..write('positionSec: $positionSec, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserGrammarProgressTable extends UserGrammarProgress
    with TableInfo<$UserGrammarProgressTable, UserGrammarProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGrammarProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NOT_STARTED'),
  );
  static const VerificationMeta _lastCardMeta = const VerificationMeta(
    'lastCard',
  );
  @override
  late final GeneratedColumn<String> lastCard = GeneratedColumn<String>(
    'last_card',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    status,
    lastCard,
    startedAt,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_grammar_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGrammarProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_card')) {
      context.handle(
        _lastCardMeta,
        lastCard.isAcceptableOrUnknown(data['last_card']!, _lastCardMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  UserGrammarProgressData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGrammarProgressData(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastCard: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_card'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserGrammarProgressTable createAlias(String alias) {
    return $UserGrammarProgressTable(attachedDatabase, alias);
  }
}

class UserGrammarProgressData extends DataClass
    implements Insertable<UserGrammarProgressData> {
  /// Ders kimliği (`G-A1-03-third-person-s`).
  final String lessonId;

  /// `NOT_STARTED` | `IN_PROGRESS` | `COMPLETED`
  final String status;

  /// Kalınan kart (`c03`).
  final String? lastCard;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const UserGrammarProgressData({
    required this.lessonId,
    required this.status,
    this.lastCard,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastCard != null) {
      map['last_card'] = Variable<String>(lastCard);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserGrammarProgressCompanion toCompanion(bool nullToAbsent) {
    return UserGrammarProgressCompanion(
      lessonId: Value(lessonId),
      status: Value(status),
      lastCard: lastCard == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCard),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserGrammarProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGrammarProgressData(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      lastCard: serializer.fromJson<String?>(json['lastCard']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'status': serializer.toJson<String>(status),
      'lastCard': serializer.toJson<String?>(lastCard),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserGrammarProgressData copyWith({
    String? lessonId,
    String? status,
    Value<String?> lastCard = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => UserGrammarProgressData(
    lessonId: lessonId ?? this.lessonId,
    status: status ?? this.status,
    lastCard: lastCard.present ? lastCard.value : this.lastCard,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserGrammarProgressData copyWithCompanion(UserGrammarProgressCompanion data) {
    return UserGrammarProgressData(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      lastCard: data.lastCard.present ? data.lastCard.value : this.lastCard,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGrammarProgressData(')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('lastCard: $lastCard, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    lessonId,
    status,
    lastCard,
    startedAt,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGrammarProgressData &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.lastCard == this.lastCard &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class UserGrammarProgressCompanion
    extends UpdateCompanion<UserGrammarProgressData> {
  final Value<String> lessonId;
  final Value<String> status;
  final Value<String?> lastCard;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserGrammarProgressCompanion({
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.lastCard = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserGrammarProgressCompanion.insert({
    required String lessonId,
    this.status = const Value.absent(),
    this.lastCard = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId),
       updatedAt = Value(updatedAt);
  static Insertable<UserGrammarProgressData> custom({
    Expression<String>? lessonId,
    Expression<String>? status,
    Expression<String>? lastCard,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (lastCard != null) 'last_card': lastCard,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserGrammarProgressCompanion copyWith({
    Value<String>? lessonId,
    Value<String>? status,
    Value<String?>? lastCard,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserGrammarProgressCompanion(
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      lastCard: lastCard ?? this.lastCard,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastCard.present) {
      map['last_card'] = Variable<String>(lastCard.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGrammarProgressCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('lastCard: $lastCard, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyActivityTable extends DailyActivity
    with TableInfo<$DailyActivityTable, DailyActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeSecondsMeta = const VerificationMeta(
    'activeSeconds',
  );
  @override
  late final GeneratedColumn<int> activeSeconds = GeneratedColumn<int>(
    'active_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    sourceId,
    activeSeconds,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('active_seconds')) {
      context.handle(
        _activeSecondsMeta,
        activeSeconds.isAcceptableOrUnknown(
          data['active_seconds']!,
          _activeSecondsMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {day, sourceId};
  @override
  DailyActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      activeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_seconds'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyActivityTable createAlias(String alias) {
    return $DailyActivityTable(attachedDatabase, alias);
  }
}

class DailyActivityRow extends DataClass
    implements Insertable<DailyActivityRow> {
  /// Yerel gün (`2026-10-14`).
  final String day;
  final String sourceId;

  /// O gün bu kaynakta ölçülen etkin süre (sn).
  final int activeSeconds;
  final DateTime updatedAt;
  const DailyActivityRow({
    required this.day,
    required this.sourceId,
    required this.activeSeconds,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['source_id'] = Variable<String>(sourceId);
    map['active_seconds'] = Variable<int>(activeSeconds);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyActivityCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityCompanion(
      day: Value(day),
      sourceId: Value(sourceId),
      activeSeconds: Value(activeSeconds),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityRow(
      day: serializer.fromJson<String>(json['day']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      activeSeconds: serializer.fromJson<int>(json['activeSeconds']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'sourceId': serializer.toJson<String>(sourceId),
      'activeSeconds': serializer.toJson<int>(activeSeconds),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyActivityRow copyWith({
    String? day,
    String? sourceId,
    int? activeSeconds,
    DateTime? updatedAt,
  }) => DailyActivityRow(
    day: day ?? this.day,
    sourceId: sourceId ?? this.sourceId,
    activeSeconds: activeSeconds ?? this.activeSeconds,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyActivityRow copyWithCompanion(DailyActivityCompanion data) {
    return DailyActivityRow(
      day: data.day.present ? data.day.value : this.day,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      activeSeconds: data.activeSeconds.present
          ? data.activeSeconds.value
          : this.activeSeconds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityRow(')
          ..write('day: $day, ')
          ..write('sourceId: $sourceId, ')
          ..write('activeSeconds: $activeSeconds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, sourceId, activeSeconds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityRow &&
          other.day == this.day &&
          other.sourceId == this.sourceId &&
          other.activeSeconds == this.activeSeconds &&
          other.updatedAt == this.updatedAt);
}

class DailyActivityCompanion extends UpdateCompanion<DailyActivityRow> {
  final Value<String> day;
  final Value<String> sourceId;
  final Value<int> activeSeconds;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyActivityCompanion({
    this.day = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.activeSeconds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityCompanion.insert({
    required String day,
    required String sourceId,
    this.activeSeconds = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       sourceId = Value(sourceId),
       updatedAt = Value(updatedAt);
  static Insertable<DailyActivityRow> custom({
    Expression<String>? day,
    Expression<String>? sourceId,
    Expression<int>? activeSeconds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (sourceId != null) 'source_id': sourceId,
      if (activeSeconds != null) 'active_seconds': activeSeconds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityCompanion copyWith({
    Value<String>? day,
    Value<String>? sourceId,
    Value<int>? activeSeconds,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyActivityCompanion(
      day: day ?? this.day,
      sourceId: sourceId ?? this.sourceId,
      activeSeconds: activeSeconds ?? this.activeSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (activeSeconds.present) {
      map['active_seconds'] = Variable<int>(activeSeconds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityCompanion(')
          ..write('day: $day, ')
          ..write('sourceId: $sourceId, ')
          ..write('activeSeconds: $activeSeconds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceRecordsTable extends EvidenceRecords
    with TableInfo<$EvidenceRecordsTable, EvidenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemKey, stage, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expression_evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemKey, stage};
  @override
  EvidenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceRow(
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $EvidenceRecordsTable createAlias(String alias) {
    return $EvidenceRecordsTable(attachedDatabase, alias);
  }
}

class EvidenceRow extends DataClass implements Insertable<EvidenceRow> {
  /// Defterdeki ifadenin anahtarı (`notebook_items.item_key`).
  final String itemKey;

  /// `helped` | `own_use` | `recalled_later`
  final String stage;
  final DateTime at;
  const EvidenceRow({
    required this.itemKey,
    required this.stage,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_key'] = Variable<String>(itemKey);
    map['stage'] = Variable<String>(stage);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  EvidenceRecordsCompanion toCompanion(bool nullToAbsent) {
    return EvidenceRecordsCompanion(
      itemKey: Value(itemKey),
      stage: Value(stage),
      at: Value(at),
    );
  }

  factory EvidenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceRow(
      itemKey: serializer.fromJson<String>(json['itemKey']),
      stage: serializer.fromJson<String>(json['stage']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemKey': serializer.toJson<String>(itemKey),
      'stage': serializer.toJson<String>(stage),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  EvidenceRow copyWith({String? itemKey, String? stage, DateTime? at}) =>
      EvidenceRow(
        itemKey: itemKey ?? this.itemKey,
        stage: stage ?? this.stage,
        at: at ?? this.at,
      );
  EvidenceRow copyWithCompanion(EvidenceRecordsCompanion data) {
    return EvidenceRow(
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      stage: data.stage.present ? data.stage.value : this.stage,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceRow(')
          ..write('itemKey: $itemKey, ')
          ..write('stage: $stage, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemKey, stage, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceRow &&
          other.itemKey == this.itemKey &&
          other.stage == this.stage &&
          other.at == this.at);
}

class EvidenceRecordsCompanion extends UpdateCompanion<EvidenceRow> {
  final Value<String> itemKey;
  final Value<String> stage;
  final Value<DateTime> at;
  final Value<int> rowid;
  const EvidenceRecordsCompanion({
    this.itemKey = const Value.absent(),
    this.stage = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceRecordsCompanion.insert({
    required String itemKey,
    required String stage,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : itemKey = Value(itemKey),
       stage = Value(stage),
       at = Value(at);
  static Insertable<EvidenceRow> custom({
    Expression<String>? itemKey,
    Expression<String>? stage,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemKey != null) 'item_key': itemKey,
      if (stage != null) 'stage': stage,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceRecordsCompanion copyWith({
    Value<String>? itemKey,
    Value<String>? stage,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return EvidenceRecordsCompanion(
      itemKey: itemKey ?? this.itemKey,
      stage: stage ?? this.stage,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceRecordsCompanion(')
          ..write('itemKey: $itemKey, ')
          ..write('stage: $stage, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserStoryProgressTable userStoryProgress =
      $UserStoryProgressTable(this);
  late final $UserStoryFlagsTable userStoryFlags = $UserStoryFlagsTable(this);
  late final $GateProgressTable gateProgress = $GateProgressTable(this);
  late final $SeasonStateTable seasonState = $SeasonStateTable(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  late final $NotebookItemsTable notebookItems = $NotebookItemsTable(this);
  late final $ReviewCardsTable reviewCards = $ReviewCardsTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $LearningEventsTable learningEvents = $LearningEventsTable(this);
  late final $CluesTable clues = $CluesTable(this);
  late final $StoryLinksTable storyLinks = $StoryLinksTable(this);
  late final $HiRecordsTable hiRecords = $HiRecordsTable(this);
  late final $SpeechAttemptsTable speechAttempts = $SpeechAttemptsTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $UserBookProgressTable userBookProgress = $UserBookProgressTable(
    this,
  );
  late final $UserGrammarProgressTable userGrammarProgress =
      $UserGrammarProgressTable(this);
  late final $DailyActivityTable dailyActivity = $DailyActivityTable(this);
  late final $EvidenceRecordsTable evidenceRecords = $EvidenceRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userStoryProgress,
    userStoryFlags,
    gateProgress,
    seasonState,
    appMeta,
    notebookItems,
    reviewCards,
    reviewLogs,
    learningEvents,
    clues,
    storyLinks,
    hiRecords,
    speechAttempts,
    syncState,
    syncOutbox,
    userBookProgress,
    userGrammarProgress,
    dailyActivity,
    evidenceRecords,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notebook_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'review_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_logs', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UserStoryProgressTableCreateCompanionBuilder =
    UserStoryProgressCompanion Function({
      required String contentId,
      Value<String> status,
      Value<String?> lastCheckpointNodeId,
      Value<String?> checkpointSnapshot,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserStoryProgressTableUpdateCompanionBuilder =
    UserStoryProgressCompanion Function({
      Value<String> contentId,
      Value<String> status,
      Value<String?> lastCheckpointNodeId,
      Value<String?> checkpointSnapshot,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserStoryProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserStoryProgressTable> {
  $$UserStoryProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCheckpointNodeId => $composableBuilder(
    column: $table.lastCheckpointNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpointSnapshot => $composableBuilder(
    column: $table.checkpointSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStoryProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStoryProgressTable> {
  $$UserStoryProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCheckpointNodeId => $composableBuilder(
    column: $table.lastCheckpointNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpointSnapshot => $composableBuilder(
    column: $table.checkpointSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStoryProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStoryProgressTable> {
  $$UserStoryProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastCheckpointNodeId => $composableBuilder(
    column: $table.lastCheckpointNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkpointSnapshot => $composableBuilder(
    column: $table.checkpointSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserStoryProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStoryProgressTable,
          UserStoryProgressData,
          $$UserStoryProgressTableFilterComposer,
          $$UserStoryProgressTableOrderingComposer,
          $$UserStoryProgressTableAnnotationComposer,
          $$UserStoryProgressTableCreateCompanionBuilder,
          $$UserStoryProgressTableUpdateCompanionBuilder,
          (
            UserStoryProgressData,
            BaseReferences<
              _$AppDatabase,
              $UserStoryProgressTable,
              UserStoryProgressData
            >,
          ),
          UserStoryProgressData,
          PrefetchHooks Function()
        > {
  $$UserStoryProgressTableTableManager(
    _$AppDatabase db,
    $UserStoryProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStoryProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStoryProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStoryProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastCheckpointNodeId = const Value.absent(),
                Value<String?> checkpointSnapshot = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserStoryProgressCompanion(
                contentId: contentId,
                status: status,
                lastCheckpointNodeId: lastCheckpointNodeId,
                checkpointSnapshot: checkpointSnapshot,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                Value<String> status = const Value.absent(),
                Value<String?> lastCheckpointNodeId = const Value.absent(),
                Value<String?> checkpointSnapshot = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserStoryProgressCompanion.insert(
                contentId: contentId,
                status: status,
                lastCheckpointNodeId: lastCheckpointNodeId,
                checkpointSnapshot: checkpointSnapshot,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStoryProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStoryProgressTable,
      UserStoryProgressData,
      $$UserStoryProgressTableFilterComposer,
      $$UserStoryProgressTableOrderingComposer,
      $$UserStoryProgressTableAnnotationComposer,
      $$UserStoryProgressTableCreateCompanionBuilder,
      $$UserStoryProgressTableUpdateCompanionBuilder,
      (
        UserStoryProgressData,
        BaseReferences<
          _$AppDatabase,
          $UserStoryProgressTable,
          UserStoryProgressData
        >,
      ),
      UserStoryProgressData,
      PrefetchHooks Function()
    >;
typedef $$UserStoryFlagsTableCreateCompanionBuilder =
    UserStoryFlagsCompanion Function({
      required String contentId,
      required String flag,
      required String value,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserStoryFlagsTableUpdateCompanionBuilder =
    UserStoryFlagsCompanion Function({
      Value<String> contentId,
      Value<String> flag,
      Value<String> value,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserStoryFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStoryFlagsTable> {
  $$UserStoryFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStoryFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStoryFlagsTable> {
  $$UserStoryFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStoryFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStoryFlagsTable> {
  $$UserStoryFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserStoryFlagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStoryFlagsTable,
          UserStoryFlag,
          $$UserStoryFlagsTableFilterComposer,
          $$UserStoryFlagsTableOrderingComposer,
          $$UserStoryFlagsTableAnnotationComposer,
          $$UserStoryFlagsTableCreateCompanionBuilder,
          $$UserStoryFlagsTableUpdateCompanionBuilder,
          (
            UserStoryFlag,
            BaseReferences<_$AppDatabase, $UserStoryFlagsTable, UserStoryFlag>,
          ),
          UserStoryFlag,
          PrefetchHooks Function()
        > {
  $$UserStoryFlagsTableTableManager(
    _$AppDatabase db,
    $UserStoryFlagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStoryFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStoryFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStoryFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> flag = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserStoryFlagsCompanion(
                contentId: contentId,
                flag: flag,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String flag,
                required String value,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserStoryFlagsCompanion.insert(
                contentId: contentId,
                flag: flag,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStoryFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStoryFlagsTable,
      UserStoryFlag,
      $$UserStoryFlagsTableFilterComposer,
      $$UserStoryFlagsTableOrderingComposer,
      $$UserStoryFlagsTableAnnotationComposer,
      $$UserStoryFlagsTableCreateCompanionBuilder,
      $$UserStoryFlagsTableUpdateCompanionBuilder,
      (
        UserStoryFlag,
        BaseReferences<_$AppDatabase, $UserStoryFlagsTable, UserStoryFlag>,
      ),
      UserStoryFlag,
      PrefetchHooks Function()
    >;
typedef $$GateProgressTableCreateCompanionBuilder =
    GateProgressCompanion Function({
      required String contentId,
      required String itemKind,
      required String nodeId,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$GateProgressTableUpdateCompanionBuilder =
    GateProgressCompanion Function({
      Value<String> contentId,
      Value<String> itemKind,
      Value<String> nodeId,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

class $$GateProgressTableFilterComposer
    extends Composer<_$AppDatabase, $GateProgressTable> {
  $$GateProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemKind => $composableBuilder(
    column: $table.itemKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GateProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $GateProgressTable> {
  $$GateProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemKind => $composableBuilder(
    column: $table.itemKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GateProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $GateProgressTable> {
  $$GateProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get itemKind =>
      $composableBuilder(column: $table.itemKind, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );
}

class $$GateProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GateProgressTable,
          GateProgressData,
          $$GateProgressTableFilterComposer,
          $$GateProgressTableOrderingComposer,
          $$GateProgressTableAnnotationComposer,
          $$GateProgressTableCreateCompanionBuilder,
          $$GateProgressTableUpdateCompanionBuilder,
          (
            GateProgressData,
            BaseReferences<_$AppDatabase, $GateProgressTable, GateProgressData>,
          ),
          GateProgressData,
          PrefetchHooks Function()
        > {
  $$GateProgressTableTableManager(_$AppDatabase db, $GateProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GateProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GateProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GateProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> itemKind = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GateProgressCompanion(
                contentId: contentId,
                itemKind: itemKind,
                nodeId: nodeId,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String itemKind,
                required String nodeId,
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => GateProgressCompanion.insert(
                contentId: contentId,
                itemKind: itemKind,
                nodeId: nodeId,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GateProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GateProgressTable,
      GateProgressData,
      $$GateProgressTableFilterComposer,
      $$GateProgressTableOrderingComposer,
      $$GateProgressTableAnnotationComposer,
      $$GateProgressTableCreateCompanionBuilder,
      $$GateProgressTableUpdateCompanionBuilder,
      (
        GateProgressData,
        BaseReferences<_$AppDatabase, $GateProgressTable, GateProgressData>,
      ),
      GateProgressData,
      PrefetchHooks Function()
    >;
typedef $$SeasonStateTableCreateCompanionBuilder =
    SeasonStateCompanion Function({
      Value<int> seasonId,
      Value<bool> introSeen,
      Value<DateTime?> introSeenAt,
      Value<DateTime?> updatedAt,
    });
typedef $$SeasonStateTableUpdateCompanionBuilder =
    SeasonStateCompanion Function({
      Value<int> seasonId,
      Value<bool> introSeen,
      Value<DateTime?> introSeenAt,
      Value<DateTime?> updatedAt,
    });

class $$SeasonStateTableFilterComposer
    extends Composer<_$AppDatabase, $SeasonStateTable> {
  $$SeasonStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get introSeen => $composableBuilder(
    column: $table.introSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get introSeenAt => $composableBuilder(
    column: $table.introSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeasonStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SeasonStateTable> {
  $$SeasonStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get introSeen => $composableBuilder(
    column: $table.introSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get introSeenAt => $composableBuilder(
    column: $table.introSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeasonStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeasonStateTable> {
  $$SeasonStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seasonId =>
      $composableBuilder(column: $table.seasonId, builder: (column) => column);

  GeneratedColumn<bool> get introSeen =>
      $composableBuilder(column: $table.introSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get introSeenAt => $composableBuilder(
    column: $table.introSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SeasonStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeasonStateTable,
          SeasonStateData,
          $$SeasonStateTableFilterComposer,
          $$SeasonStateTableOrderingComposer,
          $$SeasonStateTableAnnotationComposer,
          $$SeasonStateTableCreateCompanionBuilder,
          $$SeasonStateTableUpdateCompanionBuilder,
          (
            SeasonStateData,
            BaseReferences<_$AppDatabase, $SeasonStateTable, SeasonStateData>,
          ),
          SeasonStateData,
          PrefetchHooks Function()
        > {
  $$SeasonStateTableTableManager(_$AppDatabase db, $SeasonStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasonStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasonStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasonStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seasonId = const Value.absent(),
                Value<bool> introSeen = const Value.absent(),
                Value<DateTime?> introSeenAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SeasonStateCompanion(
                seasonId: seasonId,
                introSeen: introSeen,
                introSeenAt: introSeenAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> seasonId = const Value.absent(),
                Value<bool> introSeen = const Value.absent(),
                Value<DateTime?> introSeenAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SeasonStateCompanion.insert(
                seasonId: seasonId,
                introSeen: introSeen,
                introSeenAt: introSeenAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeasonStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeasonStateTable,
      SeasonStateData,
      $$SeasonStateTableFilterComposer,
      $$SeasonStateTableOrderingComposer,
      $$SeasonStateTableAnnotationComposer,
      $$SeasonStateTableCreateCompanionBuilder,
      $$SeasonStateTableUpdateCompanionBuilder,
      (
        SeasonStateData,
        BaseReferences<_$AppDatabase, $SeasonStateTable, SeasonStateData>,
      ),
      SeasonStateData,
      PrefetchHooks Function()
    >;
typedef $$AppMetaTableCreateCompanionBuilder =
    AppMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetaTableUpdateCompanionBuilder =
    AppMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetaTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
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
}

class $$AppMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
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
}

class $$AppMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
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
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaData,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (
            AppMetaData,
            BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>,
          ),
          AppMetaData,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaData,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaData, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>),
      AppMetaData,
      PrefetchHooks Function()
    >;
typedef $$NotebookItemsTableCreateCompanionBuilder =
    NotebookItemsCompanion Function({
      Value<int> id,
      required String itemKey,
      required String kind,
      required String textEn,
      Value<String?> textTr,
      Value<String?> exampleEn,
      Value<String?> exampleTr,
      Value<String?> contentId,
      Value<String?> cueId,
      Value<String?> imagePath,
      Value<String?> imageCrop,
      Value<String?> audioPath,
      Value<double?> audioStart,
      Value<double?> audioEnd,
      Value<double?> exampleStart,
      Value<double?> exampleEnd,
      required String source,
      Value<String?> sourceTitle,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$NotebookItemsTableUpdateCompanionBuilder =
    NotebookItemsCompanion Function({
      Value<int> id,
      Value<String> itemKey,
      Value<String> kind,
      Value<String> textEn,
      Value<String?> textTr,
      Value<String?> exampleEn,
      Value<String?> exampleTr,
      Value<String?> contentId,
      Value<String?> cueId,
      Value<String?> imagePath,
      Value<String?> imageCrop,
      Value<String?> audioPath,
      Value<double?> audioStart,
      Value<double?> audioEnd,
      Value<double?> exampleStart,
      Value<double?> exampleEnd,
      Value<String> source,
      Value<String?> sourceTitle,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$NotebookItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $NotebookItemsTable, NotebookItemRow> {
  $$NotebookItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ReviewCardsTable, List<ReviewCardRow>>
  _reviewCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewCards,
    aliasName: $_aliasNameGenerator(db.notebookItems.id, db.reviewCards.itemId),
  );

  $$ReviewCardsTableProcessedTableManager get reviewCardsRefs {
    final manager = $$ReviewCardsTableTableManager(
      $_db,
      $_db.reviewCards,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotebookItemsTableFilterComposer
    extends Composer<_$AppDatabase, $NotebookItemsTable> {
  $$NotebookItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textEn => $composableBuilder(
    column: $table.textEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textTr => $composableBuilder(
    column: $table.textTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleTr => $composableBuilder(
    column: $table.exampleTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cueId => $composableBuilder(
    column: $table.cueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageCrop => $composableBuilder(
    column: $table.imageCrop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get audioStart => $composableBuilder(
    column: $table.audioStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get audioEnd => $composableBuilder(
    column: $table.audioEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exampleStart => $composableBuilder(
    column: $table.exampleStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exampleEnd => $composableBuilder(
    column: $table.exampleEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reviewCardsRefs(
    Expression<bool> Function($$ReviewCardsTableFilterComposer f) f,
  ) {
    final $$ReviewCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableFilterComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotebookItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotebookItemsTable> {
  $$NotebookItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textEn => $composableBuilder(
    column: $table.textEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textTr => $composableBuilder(
    column: $table.textTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleTr => $composableBuilder(
    column: $table.exampleTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueId => $composableBuilder(
    column: $table.cueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageCrop => $composableBuilder(
    column: $table.imageCrop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get audioStart => $composableBuilder(
    column: $table.audioStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get audioEnd => $composableBuilder(
    column: $table.audioEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exampleStart => $composableBuilder(
    column: $table.exampleStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exampleEnd => $composableBuilder(
    column: $table.exampleEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotebookItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotebookItemsTable> {
  $$NotebookItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => column);

  GeneratedColumn<String> get textTr =>
      $composableBuilder(column: $table.textTr, builder: (column) => column);

  GeneratedColumn<String> get exampleEn =>
      $composableBuilder(column: $table.exampleEn, builder: (column) => column);

  GeneratedColumn<String> get exampleTr =>
      $composableBuilder(column: $table.exampleTr, builder: (column) => column);

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get cueId =>
      $composableBuilder(column: $table.cueId, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get imageCrop =>
      $composableBuilder(column: $table.imageCrop, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<double> get audioStart => $composableBuilder(
    column: $table.audioStart,
    builder: (column) => column,
  );

  GeneratedColumn<double> get audioEnd =>
      $composableBuilder(column: $table.audioEnd, builder: (column) => column);

  GeneratedColumn<double> get exampleStart => $composableBuilder(
    column: $table.exampleStart,
    builder: (column) => column,
  );

  GeneratedColumn<double> get exampleEnd => $composableBuilder(
    column: $table.exampleEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> reviewCardsRefs<T extends Object>(
    Expression<T> Function($$ReviewCardsTableAnnotationComposer a) f,
  ) {
    final $$ReviewCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotebookItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotebookItemsTable,
          NotebookItemRow,
          $$NotebookItemsTableFilterComposer,
          $$NotebookItemsTableOrderingComposer,
          $$NotebookItemsTableAnnotationComposer,
          $$NotebookItemsTableCreateCompanionBuilder,
          $$NotebookItemsTableUpdateCompanionBuilder,
          (NotebookItemRow, $$NotebookItemsTableReferences),
          NotebookItemRow,
          PrefetchHooks Function({bool reviewCardsRefs})
        > {
  $$NotebookItemsTableTableManager(_$AppDatabase db, $NotebookItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotebookItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotebookItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotebookItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemKey = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> textEn = const Value.absent(),
                Value<String?> textTr = const Value.absent(),
                Value<String?> exampleEn = const Value.absent(),
                Value<String?> exampleTr = const Value.absent(),
                Value<String?> contentId = const Value.absent(),
                Value<String?> cueId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> imageCrop = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<double?> audioStart = const Value.absent(),
                Value<double?> audioEnd = const Value.absent(),
                Value<double?> exampleStart = const Value.absent(),
                Value<double?> exampleEnd = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceTitle = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => NotebookItemsCompanion(
                id: id,
                itemKey: itemKey,
                kind: kind,
                textEn: textEn,
                textTr: textTr,
                exampleEn: exampleEn,
                exampleTr: exampleTr,
                contentId: contentId,
                cueId: cueId,
                imagePath: imagePath,
                imageCrop: imageCrop,
                audioPath: audioPath,
                audioStart: audioStart,
                audioEnd: audioEnd,
                exampleStart: exampleStart,
                exampleEnd: exampleEnd,
                source: source,
                sourceTitle: sourceTitle,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemKey,
                required String kind,
                required String textEn,
                Value<String?> textTr = const Value.absent(),
                Value<String?> exampleEn = const Value.absent(),
                Value<String?> exampleTr = const Value.absent(),
                Value<String?> contentId = const Value.absent(),
                Value<String?> cueId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> imageCrop = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<double?> audioStart = const Value.absent(),
                Value<double?> audioEnd = const Value.absent(),
                Value<double?> exampleStart = const Value.absent(),
                Value<double?> exampleEnd = const Value.absent(),
                required String source,
                Value<String?> sourceTitle = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => NotebookItemsCompanion.insert(
                id: id,
                itemKey: itemKey,
                kind: kind,
                textEn: textEn,
                textTr: textTr,
                exampleEn: exampleEn,
                exampleTr: exampleTr,
                contentId: contentId,
                cueId: cueId,
                imagePath: imagePath,
                imageCrop: imageCrop,
                audioPath: audioPath,
                audioStart: audioStart,
                audioEnd: audioEnd,
                exampleStart: exampleStart,
                exampleEnd: exampleEnd,
                source: source,
                sourceTitle: sourceTitle,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotebookItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reviewCardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reviewCardsRefs) db.reviewCards],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewCardsRefs)
                    await $_getPrefetchedData<
                      NotebookItemRow,
                      $NotebookItemsTable,
                      ReviewCardRow
                    >(
                      currentTable: table,
                      referencedTable: $$NotebookItemsTableReferences
                          ._reviewCardsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NotebookItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).reviewCardsRefs,
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

typedef $$NotebookItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotebookItemsTable,
      NotebookItemRow,
      $$NotebookItemsTableFilterComposer,
      $$NotebookItemsTableOrderingComposer,
      $$NotebookItemsTableAnnotationComposer,
      $$NotebookItemsTableCreateCompanionBuilder,
      $$NotebookItemsTableUpdateCompanionBuilder,
      (NotebookItemRow, $$NotebookItemsTableReferences),
      NotebookItemRow,
      PrefetchHooks Function({bool reviewCardsRefs})
    >;
typedef $$ReviewCardsTableCreateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> id,
      required int itemId,
      Value<int> state,
      Value<int?> step,
      Value<double?> stability,
      Value<double?> difficulty,
      required DateTime due,
      Value<int> reps,
      Value<int> lapses,
      Value<DateTime?> lastReview,
      Value<DateTime?> updatedAt,
    });
typedef $$ReviewCardsTableUpdateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<int> state,
      Value<int?> step,
      Value<double?> stability,
      Value<double?> difficulty,
      Value<DateTime> due,
      Value<int> reps,
      Value<int> lapses,
      Value<DateTime?> lastReview,
      Value<DateTime?> updatedAt,
    });

final class $$ReviewCardsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewCardsTable, ReviewCardRow> {
  $$ReviewCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotebookItemsTable _itemIdTable(_$AppDatabase db) =>
      db.notebookItems.createAlias(
        $_aliasNameGenerator(db.reviewCards.itemId, db.notebookItems.id),
      );

  $$NotebookItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$NotebookItemsTableTableManager(
      $_db,
      $_db.notebookItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReviewLogsTable, List<ReviewLogRow>>
  _reviewLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLogs,
    aliasName: $_aliasNameGenerator(db.reviewCards.id, db.reviewLogs.cardId),
  );

  $$ReviewLogsTableProcessedTableManager get reviewLogsRefs {
    final manager = $$ReviewLogsTableTableManager(
      $_db,
      $_db.reviewLogs,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReviewCardsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotebookItemsTableFilterComposer get itemId {
    final $$NotebookItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.notebookItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebookItemsTableFilterComposer(
            $db: $db,
            $table: $db.notebookItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reviewLogsRefs(
    Expression<bool> Function($$ReviewLogsTableFilterComposer f) f,
  ) {
    final $$ReviewLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableFilterComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReviewCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotebookItemsTableOrderingComposer get itemId {
    final $$NotebookItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.notebookItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebookItemsTableOrderingComposer(
            $db: $db,
            $table: $db.notebookItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NotebookItemsTableAnnotationComposer get itemId {
    final $$NotebookItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.notebookItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebookItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.notebookItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reviewLogsRefs<T extends Object>(
    Expression<T> Function($$ReviewLogsTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReviewCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewCardsTable,
          ReviewCardRow,
          $$ReviewCardsTableFilterComposer,
          $$ReviewCardsTableOrderingComposer,
          $$ReviewCardsTableAnnotationComposer,
          $$ReviewCardsTableCreateCompanionBuilder,
          $$ReviewCardsTableUpdateCompanionBuilder,
          (ReviewCardRow, $$ReviewCardsTableReferences),
          ReviewCardRow,
          PrefetchHooks Function({bool itemId, bool reviewLogsRefs})
        > {
  $$ReviewCardsTableTableManager(_$AppDatabase db, $ReviewCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int?> step = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ReviewCardsCompanion(
                id: id,
                itemId: itemId,
                state: state,
                step: step,
                stability: stability,
                difficulty: difficulty,
                due: due,
                reps: reps,
                lapses: lapses,
                lastReview: lastReview,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                Value<int> state = const Value.absent(),
                Value<int?> step = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                required DateTime due,
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ReviewCardsCompanion.insert(
                id: id,
                itemId: itemId,
                state: state,
                step: step,
                stability: stability,
                difficulty: difficulty,
                due: due,
                reps: reps,
                lapses: lapses,
                lastReview: lastReview,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, reviewLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reviewLogsRefs) db.reviewLogs],
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
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$ReviewCardsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$ReviewCardsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewLogsRefs)
                    await $_getPrefetchedData<
                      ReviewCardRow,
                      $ReviewCardsTable,
                      ReviewLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$ReviewCardsTableReferences
                          ._reviewLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ReviewCardsTableReferences(
                            db,
                            table,
                            p0,
                          ).reviewLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReviewCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewCardsTable,
      ReviewCardRow,
      $$ReviewCardsTableFilterComposer,
      $$ReviewCardsTableOrderingComposer,
      $$ReviewCardsTableAnnotationComposer,
      $$ReviewCardsTableCreateCompanionBuilder,
      $$ReviewCardsTableUpdateCompanionBuilder,
      (ReviewCardRow, $$ReviewCardsTableReferences),
      ReviewCardRow,
      PrefetchHooks Function({bool itemId, bool reviewLogsRefs})
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      required int cardId,
      required int rating,
      required DateTime reviewedAt,
      required String taskType,
      required bool correct,
      Value<bool> dontKnow,
      required int durationMs,
      Value<bool> wasNew,
      Value<String?> clientId,
    });
typedef $$ReviewLogsTableUpdateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<int> cardId,
      Value<int> rating,
      Value<DateTime> reviewedAt,
      Value<String> taskType,
      Value<bool> correct,
      Value<bool> dontKnow,
      Value<int> durationMs,
      Value<bool> wasNew,
      Value<String?> clientId,
    });

final class $$ReviewLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLogRow> {
  $$ReviewLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReviewCardsTable _cardIdTable(_$AppDatabase db) =>
      db.reviewCards.createAlias(
        $_aliasNameGenerator(db.reviewLogs.cardId, db.reviewCards.id),
      );

  $$ReviewCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$ReviewCardsTableTableManager(
      $_db,
      $_db.reviewCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dontKnow => $composableBuilder(
    column: $table.dontKnow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasNew => $composableBuilder(
    column: $table.wasNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  $$ReviewCardsTableFilterComposer get cardId {
    final $$ReviewCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableFilterComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dontKnow => $composableBuilder(
    column: $table.dontKnow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasNew => $composableBuilder(
    column: $table.wasNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReviewCardsTableOrderingComposer get cardId {
    final $$ReviewCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableOrderingComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<bool> get dontKnow =>
      $composableBuilder(column: $table.dontKnow, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasNew =>
      $composableBuilder(column: $table.wasNew, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  $$ReviewCardsTableAnnotationComposer get cardId {
    final $$ReviewCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLogRow,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (ReviewLogRow, $$ReviewLogsTableReferences),
          ReviewLogRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<bool> dontKnow = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<bool> wasNew = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                cardId: cardId,
                rating: rating,
                reviewedAt: reviewedAt,
                taskType: taskType,
                correct: correct,
                dontKnow: dontKnow,
                durationMs: durationMs,
                wasNew: wasNew,
                clientId: clientId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required int rating,
                required DateTime reviewedAt,
                required String taskType,
                required bool correct,
                Value<bool> dontKnow = const Value.absent(),
                required int durationMs,
                Value<bool> wasNew = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
              }) => ReviewLogsCompanion.insert(
                id: id,
                cardId: cardId,
                rating: rating,
                reviewedAt: reviewedAt,
                taskType: taskType,
                correct: correct,
                dontKnow: dontKnow,
                durationMs: durationMs,
                wasNew: wasNew,
                clientId: clientId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable: $$ReviewLogsTableReferences
                                    ._cardIdTable(db),
                                referencedColumn: $$ReviewLogsTableReferences
                                    ._cardIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLogRow,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLogRow, $$ReviewLogsTableReferences),
      ReviewLogRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$LearningEventsTableCreateCompanionBuilder =
    LearningEventsCompanion Function({
      Value<int> id,
      required String clientEventId,
      required String contentId,
      required String sourceId,
      required String target,
      required DateTime at,
      Value<String?> errorType,
      Value<int?> errorTaxonomyVersion,
      Value<String?> clientId,
    });
typedef $$LearningEventsTableUpdateCompanionBuilder =
    LearningEventsCompanion Function({
      Value<int> id,
      Value<String> clientEventId,
      Value<String> contentId,
      Value<String> sourceId,
      Value<String> target,
      Value<DateTime> at,
      Value<String?> errorType,
      Value<int?> errorTaxonomyVersion,
      Value<String?> clientId,
    });

class $$LearningEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LearningEventsTable> {
  $$LearningEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorType => $composableBuilder(
    column: $table.errorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get errorTaxonomyVersion => $composableBuilder(
    column: $table.errorTaxonomyVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearningEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningEventsTable> {
  $$LearningEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorType => $composableBuilder(
    column: $table.errorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get errorTaxonomyVersion => $composableBuilder(
    column: $table.errorTaxonomyVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearningEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningEventsTable> {
  $$LearningEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get errorType =>
      $composableBuilder(column: $table.errorType, builder: (column) => column);

  GeneratedColumn<int> get errorTaxonomyVersion => $composableBuilder(
    column: $table.errorTaxonomyVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);
}

class $$LearningEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearningEventsTable,
          LearningEventRow,
          $$LearningEventsTableFilterComposer,
          $$LearningEventsTableOrderingComposer,
          $$LearningEventsTableAnnotationComposer,
          $$LearningEventsTableCreateCompanionBuilder,
          $$LearningEventsTableUpdateCompanionBuilder,
          (
            LearningEventRow,
            BaseReferences<
              _$AppDatabase,
              $LearningEventsTable,
              LearningEventRow
            >,
          ),
          LearningEventRow,
          PrefetchHooks Function()
        > {
  $$LearningEventsTableTableManager(
    _$AppDatabase db,
    $LearningEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientEventId = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String?> errorType = const Value.absent(),
                Value<int?> errorTaxonomyVersion = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
              }) => LearningEventsCompanion(
                id: id,
                clientEventId: clientEventId,
                contentId: contentId,
                sourceId: sourceId,
                target: target,
                at: at,
                errorType: errorType,
                errorTaxonomyVersion: errorTaxonomyVersion,
                clientId: clientId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientEventId,
                required String contentId,
                required String sourceId,
                required String target,
                required DateTime at,
                Value<String?> errorType = const Value.absent(),
                Value<int?> errorTaxonomyVersion = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
              }) => LearningEventsCompanion.insert(
                id: id,
                clientEventId: clientEventId,
                contentId: contentId,
                sourceId: sourceId,
                target: target,
                at: at,
                errorType: errorType,
                errorTaxonomyVersion: errorTaxonomyVersion,
                clientId: clientId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearningEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearningEventsTable,
      LearningEventRow,
      $$LearningEventsTableFilterComposer,
      $$LearningEventsTableOrderingComposer,
      $$LearningEventsTableAnnotationComposer,
      $$LearningEventsTableCreateCompanionBuilder,
      $$LearningEventsTableUpdateCompanionBuilder,
      (
        LearningEventRow,
        BaseReferences<_$AppDatabase, $LearningEventsTable, LearningEventRow>,
      ),
      LearningEventRow,
      PrefetchHooks Function()
    >;
typedef $$CluesTableCreateCompanionBuilder =
    CluesCompanion Function({
      required String contentId,
      required String clueId,
      required String textTr,
      Value<String?> textEn,
      required DateTime unlockedAt,
      Value<int> rowid,
    });
typedef $$CluesTableUpdateCompanionBuilder =
    CluesCompanion Function({
      Value<String> contentId,
      Value<String> clueId,
      Value<String> textTr,
      Value<String?> textEn,
      Value<DateTime> unlockedAt,
      Value<int> rowid,
    });

class $$CluesTableFilterComposer extends Composer<_$AppDatabase, $CluesTable> {
  $$CluesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clueId => $composableBuilder(
    column: $table.clueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textTr => $composableBuilder(
    column: $table.textTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textEn => $composableBuilder(
    column: $table.textEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CluesTableOrderingComposer
    extends Composer<_$AppDatabase, $CluesTable> {
  $$CluesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clueId => $composableBuilder(
    column: $table.clueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textTr => $composableBuilder(
    column: $table.textTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textEn => $composableBuilder(
    column: $table.textEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CluesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CluesTable> {
  $$CluesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get clueId =>
      $composableBuilder(column: $table.clueId, builder: (column) => column);

  GeneratedColumn<String> get textTr =>
      $composableBuilder(column: $table.textTr, builder: (column) => column);

  GeneratedColumn<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$CluesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CluesTable,
          ClueRow,
          $$CluesTableFilterComposer,
          $$CluesTableOrderingComposer,
          $$CluesTableAnnotationComposer,
          $$CluesTableCreateCompanionBuilder,
          $$CluesTableUpdateCompanionBuilder,
          (ClueRow, BaseReferences<_$AppDatabase, $CluesTable, ClueRow>),
          ClueRow,
          PrefetchHooks Function()
        > {
  $$CluesTableTableManager(_$AppDatabase db, $CluesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CluesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CluesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CluesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> clueId = const Value.absent(),
                Value<String> textTr = const Value.absent(),
                Value<String?> textEn = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CluesCompanion(
                contentId: contentId,
                clueId: clueId,
                textTr: textTr,
                textEn: textEn,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String clueId,
                required String textTr,
                Value<String?> textEn = const Value.absent(),
                required DateTime unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => CluesCompanion.insert(
                contentId: contentId,
                clueId: clueId,
                textTr: textTr,
                textEn: textEn,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CluesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CluesTable,
      ClueRow,
      $$CluesTableFilterComposer,
      $$CluesTableOrderingComposer,
      $$CluesTableAnnotationComposer,
      $$CluesTableCreateCompanionBuilder,
      $$CluesTableUpdateCompanionBuilder,
      (ClueRow, BaseReferences<_$AppDatabase, $CluesTable, ClueRow>),
      ClueRow,
      PrefetchHooks Function()
    >;
typedef $$StoryLinksTableCreateCompanionBuilder =
    StoryLinksCompanion Function({
      required String contentId,
      required int number,
      required String openQuestionId,
      Value<String?> openQuestionTr,
      required String answers,
      Value<String> partialNotes,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$StoryLinksTableUpdateCompanionBuilder =
    StoryLinksCompanion Function({
      Value<String> contentId,
      Value<int> number,
      Value<String> openQuestionId,
      Value<String?> openQuestionTr,
      Value<String> answers,
      Value<String> partialNotes,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

class $$StoryLinksTableFilterComposer
    extends Composer<_$AppDatabase, $StoryLinksTable> {
  $$StoryLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openQuestionId => $composableBuilder(
    column: $table.openQuestionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openQuestionTr => $composableBuilder(
    column: $table.openQuestionTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partialNotes => $composableBuilder(
    column: $table.partialNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoryLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryLinksTable> {
  $$StoryLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openQuestionId => $composableBuilder(
    column: $table.openQuestionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openQuestionTr => $composableBuilder(
    column: $table.openQuestionTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partialNotes => $composableBuilder(
    column: $table.partialNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoryLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryLinksTable> {
  $$StoryLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get openQuestionId => $composableBuilder(
    column: $table.openQuestionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get openQuestionTr => $composableBuilder(
    column: $table.openQuestionTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<String> get partialNotes => $composableBuilder(
    column: $table.partialNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );
}

class $$StoryLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryLinksTable,
          StoryLinkRow,
          $$StoryLinksTableFilterComposer,
          $$StoryLinksTableOrderingComposer,
          $$StoryLinksTableAnnotationComposer,
          $$StoryLinksTableCreateCompanionBuilder,
          $$StoryLinksTableUpdateCompanionBuilder,
          (
            StoryLinkRow,
            BaseReferences<_$AppDatabase, $StoryLinksTable, StoryLinkRow>,
          ),
          StoryLinkRow,
          PrefetchHooks Function()
        > {
  $$StoryLinksTableTableManager(_$AppDatabase db, $StoryLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> openQuestionId = const Value.absent(),
                Value<String?> openQuestionTr = const Value.absent(),
                Value<String> answers = const Value.absent(),
                Value<String> partialNotes = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryLinksCompanion(
                contentId: contentId,
                number: number,
                openQuestionId: openQuestionId,
                openQuestionTr: openQuestionTr,
                answers: answers,
                partialNotes: partialNotes,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required int number,
                required String openQuestionId,
                Value<String?> openQuestionTr = const Value.absent(),
                required String answers,
                Value<String> partialNotes = const Value.absent(),
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryLinksCompanion.insert(
                contentId: contentId,
                number: number,
                openQuestionId: openQuestionId,
                openQuestionTr: openQuestionTr,
                answers: answers,
                partialNotes: partialNotes,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoryLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryLinksTable,
      StoryLinkRow,
      $$StoryLinksTableFilterComposer,
      $$StoryLinksTableOrderingComposer,
      $$StoryLinksTableAnnotationComposer,
      $$StoryLinksTableCreateCompanionBuilder,
      $$StoryLinksTableUpdateCompanionBuilder,
      (
        StoryLinkRow,
        BaseReferences<_$AppDatabase, $StoryLinksTable, StoryLinkRow>,
      ),
      StoryLinkRow,
      PrefetchHooks Function()
    >;
typedef $$HiRecordsTableCreateCompanionBuilder =
    HiRecordsCompanion Function({
      required String kind,
      required String refId,
      required String status,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HiRecordsTableUpdateCompanionBuilder =
    HiRecordsCompanion Function({
      Value<String> kind,
      Value<String> refId,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$HiRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HiRecordsTable> {
  $$HiRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HiRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HiRecordsTable> {
  $$HiRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HiRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiRecordsTable> {
  $$HiRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HiRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiRecordsTable,
          HiRecordRow,
          $$HiRecordsTableFilterComposer,
          $$HiRecordsTableOrderingComposer,
          $$HiRecordsTableAnnotationComposer,
          $$HiRecordsTableCreateCompanionBuilder,
          $$HiRecordsTableUpdateCompanionBuilder,
          (
            HiRecordRow,
            BaseReferences<_$AppDatabase, $HiRecordsTable, HiRecordRow>,
          ),
          HiRecordRow,
          PrefetchHooks Function()
        > {
  $$HiRecordsTableTableManager(_$AppDatabase db, $HiRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HiRecordsCompanion(
                kind: kind,
                refId: refId,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required String refId,
                required String status,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HiRecordsCompanion.insert(
                kind: kind,
                refId: refId,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HiRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiRecordsTable,
      HiRecordRow,
      $$HiRecordsTableFilterComposer,
      $$HiRecordsTableOrderingComposer,
      $$HiRecordsTableAnnotationComposer,
      $$HiRecordsTableCreateCompanionBuilder,
      $$HiRecordsTableUpdateCompanionBuilder,
      (
        HiRecordRow,
        BaseReferences<_$AppDatabase, $HiRecordsTable, HiRecordRow>,
      ),
      HiRecordRow,
      PrefetchHooks Function()
    >;
typedef $$SpeechAttemptsTableCreateCompanionBuilder =
    SpeechAttemptsCompanion Function({
      Value<int> id,
      required String place,
      Value<String?> contentId,
      required String itemRef,
      required String matchLevel,
      Value<int> missingCount,
      Value<String?> errorNoteId,
      required DateTime at,
      Value<String?> clientId,
    });
typedef $$SpeechAttemptsTableUpdateCompanionBuilder =
    SpeechAttemptsCompanion Function({
      Value<int> id,
      Value<String> place,
      Value<String?> contentId,
      Value<String> itemRef,
      Value<String> matchLevel,
      Value<int> missingCount,
      Value<String?> errorNoteId,
      Value<DateTime> at,
      Value<String?> clientId,
    });

class $$SpeechAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeechAttemptsTable> {
  $$SpeechAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemRef => $composableBuilder(
    column: $table.itemRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchLevel => $composableBuilder(
    column: $table.matchLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missingCount => $composableBuilder(
    column: $table.missingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorNoteId => $composableBuilder(
    column: $table.errorNoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpeechAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeechAttemptsTable> {
  $$SpeechAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemRef => $composableBuilder(
    column: $table.itemRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchLevel => $composableBuilder(
    column: $table.matchLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missingCount => $composableBuilder(
    column: $table.missingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorNoteId => $composableBuilder(
    column: $table.errorNoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeechAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeechAttemptsTable> {
  $$SpeechAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get itemRef =>
      $composableBuilder(column: $table.itemRef, builder: (column) => column);

  GeneratedColumn<String> get matchLevel => $composableBuilder(
    column: $table.matchLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missingCount => $composableBuilder(
    column: $table.missingCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorNoteId => $composableBuilder(
    column: $table.errorNoteId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);
}

class $$SpeechAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeechAttemptsTable,
          SpeechAttemptRow,
          $$SpeechAttemptsTableFilterComposer,
          $$SpeechAttemptsTableOrderingComposer,
          $$SpeechAttemptsTableAnnotationComposer,
          $$SpeechAttemptsTableCreateCompanionBuilder,
          $$SpeechAttemptsTableUpdateCompanionBuilder,
          (
            SpeechAttemptRow,
            BaseReferences<
              _$AppDatabase,
              $SpeechAttemptsTable,
              SpeechAttemptRow
            >,
          ),
          SpeechAttemptRow,
          PrefetchHooks Function()
        > {
  $$SpeechAttemptsTableTableManager(
    _$AppDatabase db,
    $SpeechAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeechAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeechAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeechAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> place = const Value.absent(),
                Value<String?> contentId = const Value.absent(),
                Value<String> itemRef = const Value.absent(),
                Value<String> matchLevel = const Value.absent(),
                Value<int> missingCount = const Value.absent(),
                Value<String?> errorNoteId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
              }) => SpeechAttemptsCompanion(
                id: id,
                place: place,
                contentId: contentId,
                itemRef: itemRef,
                matchLevel: matchLevel,
                missingCount: missingCount,
                errorNoteId: errorNoteId,
                at: at,
                clientId: clientId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String place,
                Value<String?> contentId = const Value.absent(),
                required String itemRef,
                required String matchLevel,
                Value<int> missingCount = const Value.absent(),
                Value<String?> errorNoteId = const Value.absent(),
                required DateTime at,
                Value<String?> clientId = const Value.absent(),
              }) => SpeechAttemptsCompanion.insert(
                id: id,
                place: place,
                contentId: contentId,
                itemRef: itemRef,
                matchLevel: matchLevel,
                missingCount: missingCount,
                errorNoteId: errorNoteId,
                at: at,
                clientId: clientId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeechAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeechAttemptsTable,
      SpeechAttemptRow,
      $$SpeechAttemptsTableFilterComposer,
      $$SpeechAttemptsTableOrderingComposer,
      $$SpeechAttemptsTableAnnotationComposer,
      $$SpeechAttemptsTableCreateCompanionBuilder,
      $$SpeechAttemptsTableUpdateCompanionBuilder,
      (
        SpeechAttemptRow,
        BaseReferences<_$AppDatabase, $SpeechAttemptsTable, SpeechAttemptRow>,
      ),
      SpeechAttemptRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      Value<String?> accountUserId,
      Value<String?> emailMasked,
      Value<String?> accountStatus,
      Value<DateTime?> scheduledPurgeAt,
      Value<String?> deviceId,
      Value<int> lastPullCursor,
      Value<DateTime?> lastSyncAt,
      Value<DateTime?> lastPushAt,
      Value<bool> initialUploadDone,
      Value<bool> applying,
      Value<bool> pendingSpeechDelete,
      Value<String?> lastErrorCode,
      Value<String?> signedOutReason,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      Value<String?> accountUserId,
      Value<String?> emailMasked,
      Value<String?> accountStatus,
      Value<DateTime?> scheduledPurgeAt,
      Value<String?> deviceId,
      Value<int> lastPullCursor,
      Value<DateTime?> lastSyncAt,
      Value<DateTime?> lastPushAt,
      Value<bool> initialUploadDone,
      Value<bool> applying,
      Value<bool> pendingSpeechDelete,
      Value<String?> lastErrorCode,
      Value<String?> signedOutReason,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountUserId => $composableBuilder(
    column: $table.accountUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailMasked => $composableBuilder(
    column: $table.emailMasked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledPurgeAt => $composableBuilder(
    column: $table.scheduledPurgeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPullCursor => $composableBuilder(
    column: $table.lastPullCursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get initialUploadDone => $composableBuilder(
    column: $table.initialUploadDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get applying => $composableBuilder(
    column: $table.applying,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSpeechDelete => $composableBuilder(
    column: $table.pendingSpeechDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedOutReason => $composableBuilder(
    column: $table.signedOutReason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountUserId => $composableBuilder(
    column: $table.accountUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailMasked => $composableBuilder(
    column: $table.emailMasked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledPurgeAt => $composableBuilder(
    column: $table.scheduledPurgeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPullCursor => $composableBuilder(
    column: $table.lastPullCursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get initialUploadDone => $composableBuilder(
    column: $table.initialUploadDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get applying => $composableBuilder(
    column: $table.applying,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSpeechDelete => $composableBuilder(
    column: $table.pendingSpeechDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedOutReason => $composableBuilder(
    column: $table.signedOutReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountUserId => $composableBuilder(
    column: $table.accountUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emailMasked => $composableBuilder(
    column: $table.emailMasked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledPurgeAt => $composableBuilder(
    column: $table.scheduledPurgeAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get lastPullCursor => $composableBuilder(
    column: $table.lastPullCursor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get initialUploadDone => $composableBuilder(
    column: $table.initialUploadDone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get applying =>
      $composableBuilder(column: $table.applying, builder: (column) => column);

  GeneratedColumn<bool> get pendingSpeechDelete => $composableBuilder(
    column: $table.pendingSpeechDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signedOutReason => $composableBuilder(
    column: $table.signedOutReason,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateRow,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> accountUserId = const Value.absent(),
                Value<String?> emailMasked = const Value.absent(),
                Value<String?> accountStatus = const Value.absent(),
                Value<DateTime?> scheduledPurgeAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> lastPullCursor = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime?> lastPushAt = const Value.absent(),
                Value<bool> initialUploadDone = const Value.absent(),
                Value<bool> applying = const Value.absent(),
                Value<bool> pendingSpeechDelete = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> signedOutReason = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                accountUserId: accountUserId,
                emailMasked: emailMasked,
                accountStatus: accountStatus,
                scheduledPurgeAt: scheduledPurgeAt,
                deviceId: deviceId,
                lastPullCursor: lastPullCursor,
                lastSyncAt: lastSyncAt,
                lastPushAt: lastPushAt,
                initialUploadDone: initialUploadDone,
                applying: applying,
                pendingSpeechDelete: pendingSpeechDelete,
                lastErrorCode: lastErrorCode,
                signedOutReason: signedOutReason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> accountUserId = const Value.absent(),
                Value<String?> emailMasked = const Value.absent(),
                Value<String?> accountStatus = const Value.absent(),
                Value<DateTime?> scheduledPurgeAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> lastPullCursor = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime?> lastPushAt = const Value.absent(),
                Value<bool> initialUploadDone = const Value.absent(),
                Value<bool> applying = const Value.absent(),
                Value<bool> pendingSpeechDelete = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> signedOutReason = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                accountUserId: accountUserId,
                emailMasked: emailMasked,
                accountStatus: accountStatus,
                scheduledPurgeAt: scheduledPurgeAt,
                deviceId: deviceId,
                lastPullCursor: lastPullCursor,
                lastSyncAt: lastSyncAt,
                lastPushAt: lastPushAt,
                initialUploadDone: initialUploadDone,
                applying: applying,
                pendingSpeechDelete: pendingSpeechDelete,
                lastErrorCode: lastErrorCode,
                signedOutReason: signedOutReason,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateRow,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String tbl,
      required String k1,
      Value<String> k2,
      Value<String> k3,
      Value<bool> deleted,
      Value<int> rev,
      required DateTime changedAt,
      Value<bool> blocked,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> tbl,
      Value<String> k1,
      Value<String> k2,
      Value<String> k3,
      Value<bool> deleted,
      Value<int> rev,
      Value<DateTime> changedAt,
      Value<bool> blocked,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tbl => $composableBuilder(
    column: $table.tbl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get k1 => $composableBuilder(
    column: $table.k1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get k2 => $composableBuilder(
    column: $table.k2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get k3 => $composableBuilder(
    column: $table.k3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blocked => $composableBuilder(
    column: $table.blocked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tbl => $composableBuilder(
    column: $table.tbl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get k1 => $composableBuilder(
    column: $table.k1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get k2 => $composableBuilder(
    column: $table.k2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get k3 => $composableBuilder(
    column: $table.k3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blocked => $composableBuilder(
    column: $table.blocked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tbl =>
      $composableBuilder(column: $table.tbl, builder: (column) => column);

  GeneratedColumn<String> get k1 =>
      $composableBuilder(column: $table.k1, builder: (column) => column);

  GeneratedColumn<String> get k2 =>
      $composableBuilder(column: $table.k2, builder: (column) => column);

  GeneratedColumn<String> get k3 =>
      $composableBuilder(column: $table.k3, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<bool> get blocked =>
      $composableBuilder(column: $table.blocked, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
          ),
          SyncOutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tbl = const Value.absent(),
                Value<String> k1 = const Value.absent(),
                Value<String> k2 = const Value.absent(),
                Value<String> k3 = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<bool> blocked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                tbl: tbl,
                k1: k1,
                k2: k2,
                k3: k3,
                deleted: deleted,
                rev: rev,
                changedAt: changedAt,
                blocked: blocked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tbl,
                required String k1,
                Value<String> k2 = const Value.absent(),
                Value<String> k3 = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rev = const Value.absent(),
                required DateTime changedAt,
                Value<bool> blocked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                tbl: tbl,
                k1: k1,
                k2: k2,
                k3: k3,
                deleted: deleted,
                rev: rev,
                changedAt: changedAt,
                blocked: blocked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxRow,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
      ),
      SyncOutboxRow,
      PrefetchHooks Function()
    >;
typedef $$UserBookProgressTableCreateCompanionBuilder =
    UserBookProgressCompanion Function({
      required String bookId,
      Value<String> status,
      Value<String?> chapterId,
      Value<int?> pageNumber,
      Value<int?> sentenceIndex,
      Value<double?> positionSec,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserBookProgressTableUpdateCompanionBuilder =
    UserBookProgressCompanion Function({
      Value<String> bookId,
      Value<String> status,
      Value<String?> chapterId,
      Value<int?> pageNumber,
      Value<int?> sentenceIndex,
      Value<double?> positionSec,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserBookProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserBookProgressTable> {
  $$UserBookProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sentenceIndex => $composableBuilder(
    column: $table.sentenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionSec => $composableBuilder(
    column: $table.positionSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserBookProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserBookProgressTable> {
  $$UserBookProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sentenceIndex => $composableBuilder(
    column: $table.sentenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionSec => $composableBuilder(
    column: $table.positionSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserBookProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserBookProgressTable> {
  $$UserBookProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sentenceIndex => $composableBuilder(
    column: $table.sentenceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get positionSec => $composableBuilder(
    column: $table.positionSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserBookProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserBookProgressTable,
          UserBookProgressData,
          $$UserBookProgressTableFilterComposer,
          $$UserBookProgressTableOrderingComposer,
          $$UserBookProgressTableAnnotationComposer,
          $$UserBookProgressTableCreateCompanionBuilder,
          $$UserBookProgressTableUpdateCompanionBuilder,
          (
            UserBookProgressData,
            BaseReferences<
              _$AppDatabase,
              $UserBookProgressTable,
              UserBookProgressData
            >,
          ),
          UserBookProgressData,
          PrefetchHooks Function()
        > {
  $$UserBookProgressTableTableManager(
    _$AppDatabase db,
    $UserBookProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserBookProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserBookProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserBookProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> sentenceIndex = const Value.absent(),
                Value<double?> positionSec = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserBookProgressCompanion(
                bookId: bookId,
                status: status,
                chapterId: chapterId,
                pageNumber: pageNumber,
                sentenceIndex: sentenceIndex,
                positionSec: positionSec,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                Value<String> status = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> sentenceIndex = const Value.absent(),
                Value<double?> positionSec = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserBookProgressCompanion.insert(
                bookId: bookId,
                status: status,
                chapterId: chapterId,
                pageNumber: pageNumber,
                sentenceIndex: sentenceIndex,
                positionSec: positionSec,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserBookProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserBookProgressTable,
      UserBookProgressData,
      $$UserBookProgressTableFilterComposer,
      $$UserBookProgressTableOrderingComposer,
      $$UserBookProgressTableAnnotationComposer,
      $$UserBookProgressTableCreateCompanionBuilder,
      $$UserBookProgressTableUpdateCompanionBuilder,
      (
        UserBookProgressData,
        BaseReferences<
          _$AppDatabase,
          $UserBookProgressTable,
          UserBookProgressData
        >,
      ),
      UserBookProgressData,
      PrefetchHooks Function()
    >;
typedef $$UserGrammarProgressTableCreateCompanionBuilder =
    UserGrammarProgressCompanion Function({
      required String lessonId,
      Value<String> status,
      Value<String?> lastCard,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserGrammarProgressTableUpdateCompanionBuilder =
    UserGrammarProgressCompanion Function({
      Value<String> lessonId,
      Value<String> status,
      Value<String?> lastCard,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserGrammarProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserGrammarProgressTable> {
  $$UserGrammarProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCard => $composableBuilder(
    column: $table.lastCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserGrammarProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGrammarProgressTable> {
  $$UserGrammarProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCard => $composableBuilder(
    column: $table.lastCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserGrammarProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGrammarProgressTable> {
  $$UserGrammarProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastCard =>
      $composableBuilder(column: $table.lastCard, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserGrammarProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserGrammarProgressTable,
          UserGrammarProgressData,
          $$UserGrammarProgressTableFilterComposer,
          $$UserGrammarProgressTableOrderingComposer,
          $$UserGrammarProgressTableAnnotationComposer,
          $$UserGrammarProgressTableCreateCompanionBuilder,
          $$UserGrammarProgressTableUpdateCompanionBuilder,
          (
            UserGrammarProgressData,
            BaseReferences<
              _$AppDatabase,
              $UserGrammarProgressTable,
              UserGrammarProgressData
            >,
          ),
          UserGrammarProgressData,
          PrefetchHooks Function()
        > {
  $$UserGrammarProgressTableTableManager(
    _$AppDatabase db,
    $UserGrammarProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGrammarProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGrammarProgressTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserGrammarProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastCard = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserGrammarProgressCompanion(
                lessonId: lessonId,
                status: status,
                lastCard: lastCard,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                Value<String> status = const Value.absent(),
                Value<String?> lastCard = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserGrammarProgressCompanion.insert(
                lessonId: lessonId,
                status: status,
                lastCard: lastCard,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserGrammarProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserGrammarProgressTable,
      UserGrammarProgressData,
      $$UserGrammarProgressTableFilterComposer,
      $$UserGrammarProgressTableOrderingComposer,
      $$UserGrammarProgressTableAnnotationComposer,
      $$UserGrammarProgressTableCreateCompanionBuilder,
      $$UserGrammarProgressTableUpdateCompanionBuilder,
      (
        UserGrammarProgressData,
        BaseReferences<
          _$AppDatabase,
          $UserGrammarProgressTable,
          UserGrammarProgressData
        >,
      ),
      UserGrammarProgressData,
      PrefetchHooks Function()
    >;
typedef $$DailyActivityTableCreateCompanionBuilder =
    DailyActivityCompanion Function({
      required String day,
      required String sourceId,
      Value<int> activeSeconds,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyActivityTableUpdateCompanionBuilder =
    DailyActivityCompanion Function({
      Value<String> day,
      Value<String> sourceId,
      Value<int> activeSeconds,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyActivityTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyActivityTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyActivityTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyActivityTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyActivityTable,
          DailyActivityRow,
          $$DailyActivityTableFilterComposer,
          $$DailyActivityTableOrderingComposer,
          $$DailyActivityTableAnnotationComposer,
          $$DailyActivityTableCreateCompanionBuilder,
          $$DailyActivityTableUpdateCompanionBuilder,
          (
            DailyActivityRow,
            BaseReferences<
              _$AppDatabase,
              $DailyActivityTable,
              DailyActivityRow
            >,
          ),
          DailyActivityRow,
          PrefetchHooks Function()
        > {
  $$DailyActivityTableTableManager(_$AppDatabase db, $DailyActivityTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActivityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActivityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyActivityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<int> activeSeconds = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion(
                day: day,
                sourceId: sourceId,
                activeSeconds: activeSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                required String sourceId,
                Value<int> activeSeconds = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion.insert(
                day: day,
                sourceId: sourceId,
                activeSeconds: activeSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyActivityTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyActivityTable,
      DailyActivityRow,
      $$DailyActivityTableFilterComposer,
      $$DailyActivityTableOrderingComposer,
      $$DailyActivityTableAnnotationComposer,
      $$DailyActivityTableCreateCompanionBuilder,
      $$DailyActivityTableUpdateCompanionBuilder,
      (
        DailyActivityRow,
        BaseReferences<_$AppDatabase, $DailyActivityTable, DailyActivityRow>,
      ),
      DailyActivityRow,
      PrefetchHooks Function()
    >;
typedef $$EvidenceRecordsTableCreateCompanionBuilder =
    EvidenceRecordsCompanion Function({
      required String itemKey,
      required String stage,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$EvidenceRecordsTableUpdateCompanionBuilder =
    EvidenceRecordsCompanion Function({
      Value<String> itemKey,
      Value<String> stage,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$EvidenceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceRecordsTable> {
  $$EvidenceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EvidenceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceRecordsTable> {
  $$EvidenceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidenceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceRecordsTable> {
  $$EvidenceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$EvidenceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvidenceRecordsTable,
          EvidenceRow,
          $$EvidenceRecordsTableFilterComposer,
          $$EvidenceRecordsTableOrderingComposer,
          $$EvidenceRecordsTableAnnotationComposer,
          $$EvidenceRecordsTableCreateCompanionBuilder,
          $$EvidenceRecordsTableUpdateCompanionBuilder,
          (
            EvidenceRow,
            BaseReferences<_$AppDatabase, $EvidenceRecordsTable, EvidenceRow>,
          ),
          EvidenceRow,
          PrefetchHooks Function()
        > {
  $$EvidenceRecordsTableTableManager(
    _$AppDatabase db,
    $EvidenceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemKey = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceRecordsCompanion(
                itemKey: itemKey,
                stage: stage,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemKey,
                required String stage,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => EvidenceRecordsCompanion.insert(
                itemKey: itemKey,
                stage: stage,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EvidenceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvidenceRecordsTable,
      EvidenceRow,
      $$EvidenceRecordsTableFilterComposer,
      $$EvidenceRecordsTableOrderingComposer,
      $$EvidenceRecordsTableAnnotationComposer,
      $$EvidenceRecordsTableCreateCompanionBuilder,
      $$EvidenceRecordsTableUpdateCompanionBuilder,
      (
        EvidenceRow,
        BaseReferences<_$AppDatabase, $EvidenceRecordsTable, EvidenceRow>,
      ),
      EvidenceRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserStoryProgressTableTableManager get userStoryProgress =>
      $$UserStoryProgressTableTableManager(_db, _db.userStoryProgress);
  $$UserStoryFlagsTableTableManager get userStoryFlags =>
      $$UserStoryFlagsTableTableManager(_db, _db.userStoryFlags);
  $$GateProgressTableTableManager get gateProgress =>
      $$GateProgressTableTableManager(_db, _db.gateProgress);
  $$SeasonStateTableTableManager get seasonState =>
      $$SeasonStateTableTableManager(_db, _db.seasonState);
  $$AppMetaTableTableManager get appMeta =>
      $$AppMetaTableTableManager(_db, _db.appMeta);
  $$NotebookItemsTableTableManager get notebookItems =>
      $$NotebookItemsTableTableManager(_db, _db.notebookItems);
  $$ReviewCardsTableTableManager get reviewCards =>
      $$ReviewCardsTableTableManager(_db, _db.reviewCards);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$LearningEventsTableTableManager get learningEvents =>
      $$LearningEventsTableTableManager(_db, _db.learningEvents);
  $$CluesTableTableManager get clues =>
      $$CluesTableTableManager(_db, _db.clues);
  $$StoryLinksTableTableManager get storyLinks =>
      $$StoryLinksTableTableManager(_db, _db.storyLinks);
  $$HiRecordsTableTableManager get hiRecords =>
      $$HiRecordsTableTableManager(_db, _db.hiRecords);
  $$SpeechAttemptsTableTableManager get speechAttempts =>
      $$SpeechAttemptsTableTableManager(_db, _db.speechAttempts);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$UserBookProgressTableTableManager get userBookProgress =>
      $$UserBookProgressTableTableManager(_db, _db.userBookProgress);
  $$UserGrammarProgressTableTableManager get userGrammarProgress =>
      $$UserGrammarProgressTableTableManager(_db, _db.userGrammarProgress);
  $$DailyActivityTableTableManager get dailyActivity =>
      $$DailyActivityTableTableManager(_db, _db.dailyActivity);
  $$EvidenceRecordsTableTableManager get evidenceRecords =>
      $$EvidenceRecordsTableTableManager(_db, _db.evidenceRecords);
}
