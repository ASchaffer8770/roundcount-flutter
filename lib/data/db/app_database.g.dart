// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FirearmsTable extends Firearms with TableInfo<$FirearmsTable, Firearm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FirearmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caliberMeta = const VerificationMeta(
    'caliber',
  );
  @override
  late final GeneratedColumn<String> caliber = GeneratedColumn<String>(
    'caliber',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firearmClassMeta = const VerificationMeta(
    'firearmClass',
  );
  @override
  late final GeneratedColumn<String> firearmClass = GeneratedColumn<String>(
    'firearm_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalRoundsMeta = const VerificationMeta(
    'totalRounds',
  );
  @override
  late final GeneratedColumn<int> totalRounds = GeneratedColumn<int>(
    'total_rounds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brand,
    model,
    caliber,
    firearmClass,
    serialNumber,
    totalRounds,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'firearms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Firearm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('caliber')) {
      context.handle(
        _caliberMeta,
        caliber.isAcceptableOrUnknown(data['caliber']!, _caliberMeta),
      );
    } else if (isInserting) {
      context.missing(_caliberMeta);
    }
    if (data.containsKey('firearm_class')) {
      context.handle(
        _firearmClassMeta,
        firearmClass.isAcceptableOrUnknown(
          data['firearm_class']!,
          _firearmClassMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firearmClassMeta);
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('total_rounds')) {
      context.handle(
        _totalRoundsMeta,
        totalRounds.isAcceptableOrUnknown(
          data['total_rounds']!,
          _totalRoundsMeta,
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
  Firearm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Firearm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      caliber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caliber'],
      )!,
      firearmClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firearm_class'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      ),
      totalRounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_rounds'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FirearmsTable createAlias(String alias) {
    return $FirearmsTable(attachedDatabase, alias);
  }
}

class Firearm extends DataClass implements Insertable<Firearm> {
  final String id;
  final String brand;
  final String model;
  final String caliber;
  final String firearmClass;
  final String? serialNumber;
  final int totalRounds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Firearm({
    required this.id,
    required this.brand,
    required this.model,
    required this.caliber,
    required this.firearmClass,
    this.serialNumber,
    required this.totalRounds,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['caliber'] = Variable<String>(caliber);
    map['firearm_class'] = Variable<String>(firearmClass);
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    map['total_rounds'] = Variable<int>(totalRounds);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FirearmsCompanion toCompanion(bool nullToAbsent) {
    return FirearmsCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      caliber: Value(caliber),
      firearmClass: Value(firearmClass),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      totalRounds: Value(totalRounds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Firearm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Firearm(
      id: serializer.fromJson<String>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      caliber: serializer.fromJson<String>(json['caliber']),
      firearmClass: serializer.fromJson<String>(json['firearmClass']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      totalRounds: serializer.fromJson<int>(json['totalRounds']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'caliber': serializer.toJson<String>(caliber),
      'firearmClass': serializer.toJson<String>(firearmClass),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'totalRounds': serializer.toJson<int>(totalRounds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Firearm copyWith({
    String? id,
    String? brand,
    String? model,
    String? caliber,
    String? firearmClass,
    Value<String?> serialNumber = const Value.absent(),
    int? totalRounds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Firearm(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    caliber: caliber ?? this.caliber,
    firearmClass: firearmClass ?? this.firearmClass,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    totalRounds: totalRounds ?? this.totalRounds,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Firearm copyWithCompanion(FirearmsCompanion data) {
    return Firearm(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      caliber: data.caliber.present ? data.caliber.value : this.caliber,
      firearmClass: data.firearmClass.present
          ? data.firearmClass.value
          : this.firearmClass,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      totalRounds: data.totalRounds.present
          ? data.totalRounds.value
          : this.totalRounds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Firearm(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('caliber: $caliber, ')
          ..write('firearmClass: $firearmClass, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('totalRounds: $totalRounds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    caliber,
    firearmClass,
    serialNumber,
    totalRounds,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Firearm &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.caliber == this.caliber &&
          other.firearmClass == this.firearmClass &&
          other.serialNumber == this.serialNumber &&
          other.totalRounds == this.totalRounds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FirearmsCompanion extends UpdateCompanion<Firearm> {
  final Value<String> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<String> caliber;
  final Value<String> firearmClass;
  final Value<String?> serialNumber;
  final Value<int> totalRounds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FirearmsCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.caliber = const Value.absent(),
    this.firearmClass = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.totalRounds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FirearmsCompanion.insert({
    required String id,
    required String brand,
    required String model,
    required String caliber,
    required String firearmClass,
    this.serialNumber = const Value.absent(),
    this.totalRounds = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       brand = Value(brand),
       model = Value(model),
       caliber = Value(caliber),
       firearmClass = Value(firearmClass),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Firearm> custom({
    Expression<String>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<String>? caliber,
    Expression<String>? firearmClass,
    Expression<String>? serialNumber,
    Expression<int>? totalRounds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (caliber != null) 'caliber': caliber,
      if (firearmClass != null) 'firearm_class': firearmClass,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (totalRounds != null) 'total_rounds': totalRounds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FirearmsCompanion copyWith({
    Value<String>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<String>? caliber,
    Value<String>? firearmClass,
    Value<String?>? serialNumber,
    Value<int>? totalRounds,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FirearmsCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      caliber: caliber ?? this.caliber,
      firearmClass: firearmClass ?? this.firearmClass,
      serialNumber: serialNumber ?? this.serialNumber,
      totalRounds: totalRounds ?? this.totalRounds,
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
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (caliber.present) {
      map['caliber'] = Variable<String>(caliber.value);
    }
    if (firearmClass.present) {
      map['firearm_class'] = Variable<String>(firearmClass.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (totalRounds.present) {
      map['total_rounds'] = Variable<int>(totalRounds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('FirearmsCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('caliber: $caliber, ')
          ..write('firearmClass: $firearmClass, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('totalRounds: $totalRounds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FirearmsTable firearms = $FirearmsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [firearms];
}

typedef $$FirearmsTableCreateCompanionBuilder =
    FirearmsCompanion Function({
      required String id,
      required String brand,
      required String model,
      required String caliber,
      required String firearmClass,
      Value<String?> serialNumber,
      Value<int> totalRounds,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FirearmsTableUpdateCompanionBuilder =
    FirearmsCompanion Function({
      Value<String> id,
      Value<String> brand,
      Value<String> model,
      Value<String> caliber,
      Value<String> firearmClass,
      Value<String?> serialNumber,
      Value<int> totalRounds,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FirearmsTableFilterComposer
    extends Composer<_$AppDatabase, $FirearmsTable> {
  $$FirearmsTableFilterComposer({
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

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caliber => $composableBuilder(
    column: $table.caliber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firearmClass => $composableBuilder(
    column: $table.firearmClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
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
}

class $$FirearmsTableOrderingComposer
    extends Composer<_$AppDatabase, $FirearmsTable> {
  $$FirearmsTableOrderingComposer({
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

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caliber => $composableBuilder(
    column: $table.caliber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firearmClass => $composableBuilder(
    column: $table.firearmClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
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

class $$FirearmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FirearmsTable> {
  $$FirearmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get caliber =>
      $composableBuilder(column: $table.caliber, builder: (column) => column);

  GeneratedColumn<String> get firearmClass => $composableBuilder(
    column: $table.firearmClass,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FirearmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FirearmsTable,
          Firearm,
          $$FirearmsTableFilterComposer,
          $$FirearmsTableOrderingComposer,
          $$FirearmsTableAnnotationComposer,
          $$FirearmsTableCreateCompanionBuilder,
          $$FirearmsTableUpdateCompanionBuilder,
          (Firearm, BaseReferences<_$AppDatabase, $FirearmsTable, Firearm>),
          Firearm,
          PrefetchHooks Function()
        > {
  $$FirearmsTableTableManager(_$AppDatabase db, $FirearmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FirearmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FirearmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FirearmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> caliber = const Value.absent(),
                Value<String> firearmClass = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<int> totalRounds = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FirearmsCompanion(
                id: id,
                brand: brand,
                model: model,
                caliber: caliber,
                firearmClass: firearmClass,
                serialNumber: serialNumber,
                totalRounds: totalRounds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String brand,
                required String model,
                required String caliber,
                required String firearmClass,
                Value<String?> serialNumber = const Value.absent(),
                Value<int> totalRounds = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FirearmsCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                caliber: caliber,
                firearmClass: firearmClass,
                serialNumber: serialNumber,
                totalRounds: totalRounds,
                createdAt: createdAt,
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

typedef $$FirearmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FirearmsTable,
      Firearm,
      $$FirearmsTableFilterComposer,
      $$FirearmsTableOrderingComposer,
      $$FirearmsTableAnnotationComposer,
      $$FirearmsTableCreateCompanionBuilder,
      $$FirearmsTableUpdateCompanionBuilder,
      (Firearm, BaseReferences<_$AppDatabase, $FirearmsTable, Firearm>),
      Firearm,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FirearmsTableTableManager get firearms =>
      $$FirearmsTableTableManager(_db, _db.firearms);
}
