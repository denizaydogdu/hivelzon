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
  @override
  List<GeneratedColumn> get $columns => [contentId, flag, value];
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
  const UserStoryFlag({
    required this.contentId,
    required this.flag,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['flag'] = Variable<String>(flag);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserStoryFlagsCompanion toCompanion(bool nullToAbsent) {
    return UserStoryFlagsCompanion(
      contentId: Value(contentId),
      flag: Value(flag),
      value: Value(value),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'flag': serializer.toJson<String>(flag),
      'value': serializer.toJson<String>(value),
    };
  }

  UserStoryFlag copyWith({String? contentId, String? flag, String? value}) =>
      UserStoryFlag(
        contentId: contentId ?? this.contentId,
        flag: flag ?? this.flag,
        value: value ?? this.value,
      );
  UserStoryFlag copyWithCompanion(UserStoryFlagsCompanion data) {
    return UserStoryFlag(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      flag: data.flag.present ? data.flag.value : this.flag,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStoryFlag(')
          ..write('contentId: $contentId, ')
          ..write('flag: $flag, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, flag, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStoryFlag &&
          other.contentId == this.contentId &&
          other.flag == this.flag &&
          other.value == this.value);
}

class UserStoryFlagsCompanion extends UpdateCompanion<UserStoryFlag> {
  final Value<String> contentId;
  final Value<String> flag;
  final Value<String> value;
  final Value<int> rowid;
  const UserStoryFlagsCompanion({
    this.contentId = const Value.absent(),
    this.flag = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserStoryFlagsCompanion.insert({
    required String contentId,
    required String flag,
    required String value,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       flag = Value(flag),
       value = Value(value);
  static Insertable<UserStoryFlag> custom({
    Expression<String>? contentId,
    Expression<String>? flag,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (flag != null) 'flag': flag,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserStoryFlagsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? flag,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return UserStoryFlagsCompanion(
      contentId: contentId ?? this.contentId,
      flag: flag ?? this.flag,
      value: value ?? this.value,
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
  @override
  List<GeneratedColumn> get $columns => [seasonId, introSeen, introSeenAt];
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
  const SeasonStateData({
    required this.seasonId,
    required this.introSeen,
    this.introSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['season_id'] = Variable<int>(seasonId);
    map['intro_seen'] = Variable<bool>(introSeen);
    if (!nullToAbsent || introSeenAt != null) {
      map['intro_seen_at'] = Variable<DateTime>(introSeenAt);
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seasonId': serializer.toJson<int>(seasonId),
      'introSeen': serializer.toJson<bool>(introSeen),
      'introSeenAt': serializer.toJson<DateTime?>(introSeenAt),
    };
  }

  SeasonStateData copyWith({
    int? seasonId,
    bool? introSeen,
    Value<DateTime?> introSeenAt = const Value.absent(),
  }) => SeasonStateData(
    seasonId: seasonId ?? this.seasonId,
    introSeen: introSeen ?? this.introSeen,
    introSeenAt: introSeenAt.present ? introSeenAt.value : this.introSeenAt,
  );
  SeasonStateData copyWithCompanion(SeasonStateCompanion data) {
    return SeasonStateData(
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      introSeen: data.introSeen.present ? data.introSeen.value : this.introSeen,
      introSeenAt: data.introSeenAt.present
          ? data.introSeenAt.value
          : this.introSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeasonStateData(')
          ..write('seasonId: $seasonId, ')
          ..write('introSeen: $introSeen, ')
          ..write('introSeenAt: $introSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seasonId, introSeen, introSeenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeasonStateData &&
          other.seasonId == this.seasonId &&
          other.introSeen == this.introSeen &&
          other.introSeenAt == this.introSeenAt);
}

class SeasonStateCompanion extends UpdateCompanion<SeasonStateData> {
  final Value<int> seasonId;
  final Value<bool> introSeen;
  final Value<DateTime?> introSeenAt;
  const SeasonStateCompanion({
    this.seasonId = const Value.absent(),
    this.introSeen = const Value.absent(),
    this.introSeenAt = const Value.absent(),
  });
  SeasonStateCompanion.insert({
    this.seasonId = const Value.absent(),
    this.introSeen = const Value.absent(),
    this.introSeenAt = const Value.absent(),
  });
  static Insertable<SeasonStateData> custom({
    Expression<int>? seasonId,
    Expression<bool>? introSeen,
    Expression<DateTime>? introSeenAt,
  }) {
    return RawValuesInsertable({
      if (seasonId != null) 'season_id': seasonId,
      if (introSeen != null) 'intro_seen': introSeen,
      if (introSeenAt != null) 'intro_seen_at': introSeenAt,
    });
  }

  SeasonStateCompanion copyWith({
    Value<int>? seasonId,
    Value<bool>? introSeen,
    Value<DateTime?>? introSeenAt,
  }) {
    return SeasonStateCompanion(
      seasonId: seasonId ?? this.seasonId,
      introSeen: introSeen ?? this.introSeen,
      introSeenAt: introSeenAt ?? this.introSeenAt,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonStateCompanion(')
          ..write('seasonId: $seasonId, ')
          ..write('introSeen: $introSeen, ')
          ..write('introSeenAt: $introSeenAt')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserStoryProgressTable userStoryProgress =
      $UserStoryProgressTable(this);
  late final $UserStoryFlagsTable userStoryFlags = $UserStoryFlagsTable(this);
  late final $GateProgressTable gateProgress = $GateProgressTable(this);
  late final $SeasonStateTable seasonState = $SeasonStateTable(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
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
  ];
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
      Value<int> rowid,
    });
typedef $$UserStoryFlagsTableUpdateCompanionBuilder =
    UserStoryFlagsCompanion Function({
      Value<String> contentId,
      Value<String> flag,
      Value<String> value,
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
                Value<int> rowid = const Value.absent(),
              }) => UserStoryFlagsCompanion(
                contentId: contentId,
                flag: flag,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String flag,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => UserStoryFlagsCompanion.insert(
                contentId: contentId,
                flag: flag,
                value: value,
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
    });
typedef $$SeasonStateTableUpdateCompanionBuilder =
    SeasonStateCompanion Function({
      Value<int> seasonId,
      Value<bool> introSeen,
      Value<DateTime?> introSeenAt,
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
              }) => SeasonStateCompanion(
                seasonId: seasonId,
                introSeen: introSeen,
                introSeenAt: introSeenAt,
              ),
          createCompanionCallback:
              ({
                Value<int> seasonId = const Value.absent(),
                Value<bool> introSeen = const Value.absent(),
                Value<DateTime?> introSeenAt = const Value.absent(),
              }) => SeasonStateCompanion.insert(
                seasonId: seasonId,
                introSeen: introSeen,
                introSeenAt: introSeenAt,
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
}
