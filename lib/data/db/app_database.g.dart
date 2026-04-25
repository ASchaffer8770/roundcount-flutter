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

class $AmmoProductsTable extends AmmoProducts
    with TableInfo<$AmmoProductsTable, AmmoProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AmmoProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productLineMeta = const VerificationMeta(
    'productLine',
  );
  @override
  late final GeneratedColumn<String> productLine = GeneratedColumn<String>(
    'product_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _grainMeta = const VerificationMeta('grain');
  @override
  late final GeneratedColumn<int> grain = GeneratedColumn<int>(
    'grain',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bulletTypeMeta = const VerificationMeta(
    'bulletType',
  );
  @override
  late final GeneratedColumn<String> bulletType = GeneratedColumn<String>(
    'bullet_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caseMaterialMeta = const VerificationMeta(
    'caseMaterial',
  );
  @override
  late final GeneratedColumn<String> caseMaterial = GeneratedColumn<String>(
    'case_material',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityPerBoxMeta = const VerificationMeta(
    'quantityPerBox',
  );
  @override
  late final GeneratedColumn<int> quantityPerBox = GeneratedColumn<int>(
    'quantity_per_box',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costPerBoxMeta = const VerificationMeta(
    'costPerBox',
  );
  @override
  late final GeneratedColumn<double> costPerBox = GeneratedColumn<double>(
    'cost_per_box',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roundsOnHandMeta = const VerificationMeta(
    'roundsOnHand',
  );
  @override
  late final GeneratedColumn<int> roundsOnHand = GeneratedColumn<int>(
    'rounds_on_hand',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    productLine,
    caliber,
    grain,
    bulletType,
    caseMaterial,
    quantityPerBox,
    costPerBox,
    roundsOnHand,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ammo_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<AmmoProduct> instance, {
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
    if (data.containsKey('product_line')) {
      context.handle(
        _productLineMeta,
        productLine.isAcceptableOrUnknown(
          data['product_line']!,
          _productLineMeta,
        ),
      );
    }
    if (data.containsKey('caliber')) {
      context.handle(
        _caliberMeta,
        caliber.isAcceptableOrUnknown(data['caliber']!, _caliberMeta),
      );
    } else if (isInserting) {
      context.missing(_caliberMeta);
    }
    if (data.containsKey('grain')) {
      context.handle(
        _grainMeta,
        grain.isAcceptableOrUnknown(data['grain']!, _grainMeta),
      );
    }
    if (data.containsKey('bullet_type')) {
      context.handle(
        _bulletTypeMeta,
        bulletType.isAcceptableOrUnknown(data['bullet_type']!, _bulletTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_bulletTypeMeta);
    }
    if (data.containsKey('case_material')) {
      context.handle(
        _caseMaterialMeta,
        caseMaterial.isAcceptableOrUnknown(
          data['case_material']!,
          _caseMaterialMeta,
        ),
      );
    }
    if (data.containsKey('quantity_per_box')) {
      context.handle(
        _quantityPerBoxMeta,
        quantityPerBox.isAcceptableOrUnknown(
          data['quantity_per_box']!,
          _quantityPerBoxMeta,
        ),
      );
    }
    if (data.containsKey('cost_per_box')) {
      context.handle(
        _costPerBoxMeta,
        costPerBox.isAcceptableOrUnknown(
          data['cost_per_box']!,
          _costPerBoxMeta,
        ),
      );
    }
    if (data.containsKey('rounds_on_hand')) {
      context.handle(
        _roundsOnHandMeta,
        roundsOnHand.isAcceptableOrUnknown(
          data['rounds_on_hand']!,
          _roundsOnHandMeta,
        ),
      );
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
  AmmoProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AmmoProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      productLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_line'],
      ),
      caliber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caliber'],
      )!,
      grain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grain'],
      ),
      bulletType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bullet_type'],
      )!,
      caseMaterial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_material'],
      ),
      quantityPerBox: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_per_box'],
      ),
      costPerBox: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_box'],
      ),
      roundsOnHand: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds_on_hand'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
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
  $AmmoProductsTable createAlias(String alias) {
    return $AmmoProductsTable(attachedDatabase, alias);
  }
}

class AmmoProduct extends DataClass implements Insertable<AmmoProduct> {
  final String id;
  final String brand;
  final String? productLine;
  final String caliber;
  final int? grain;
  final String bulletType;
  final String? caseMaterial;
  final int? quantityPerBox;
  final double? costPerBox;
  final int? roundsOnHand;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AmmoProduct({
    required this.id,
    required this.brand,
    this.productLine,
    required this.caliber,
    this.grain,
    required this.bulletType,
    this.caseMaterial,
    this.quantityPerBox,
    this.costPerBox,
    this.roundsOnHand,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['brand'] = Variable<String>(brand);
    if (!nullToAbsent || productLine != null) {
      map['product_line'] = Variable<String>(productLine);
    }
    map['caliber'] = Variable<String>(caliber);
    if (!nullToAbsent || grain != null) {
      map['grain'] = Variable<int>(grain);
    }
    map['bullet_type'] = Variable<String>(bulletType);
    if (!nullToAbsent || caseMaterial != null) {
      map['case_material'] = Variable<String>(caseMaterial);
    }
    if (!nullToAbsent || quantityPerBox != null) {
      map['quantity_per_box'] = Variable<int>(quantityPerBox);
    }
    if (!nullToAbsent || costPerBox != null) {
      map['cost_per_box'] = Variable<double>(costPerBox);
    }
    if (!nullToAbsent || roundsOnHand != null) {
      map['rounds_on_hand'] = Variable<int>(roundsOnHand);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AmmoProductsCompanion toCompanion(bool nullToAbsent) {
    return AmmoProductsCompanion(
      id: Value(id),
      brand: Value(brand),
      productLine: productLine == null && nullToAbsent
          ? const Value.absent()
          : Value(productLine),
      caliber: Value(caliber),
      grain: grain == null && nullToAbsent
          ? const Value.absent()
          : Value(grain),
      bulletType: Value(bulletType),
      caseMaterial: caseMaterial == null && nullToAbsent
          ? const Value.absent()
          : Value(caseMaterial),
      quantityPerBox: quantityPerBox == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityPerBox),
      costPerBox: costPerBox == null && nullToAbsent
          ? const Value.absent()
          : Value(costPerBox),
      roundsOnHand: roundsOnHand == null && nullToAbsent
          ? const Value.absent()
          : Value(roundsOnHand),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AmmoProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AmmoProduct(
      id: serializer.fromJson<String>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      productLine: serializer.fromJson<String?>(json['productLine']),
      caliber: serializer.fromJson<String>(json['caliber']),
      grain: serializer.fromJson<int?>(json['grain']),
      bulletType: serializer.fromJson<String>(json['bulletType']),
      caseMaterial: serializer.fromJson<String?>(json['caseMaterial']),
      quantityPerBox: serializer.fromJson<int?>(json['quantityPerBox']),
      costPerBox: serializer.fromJson<double?>(json['costPerBox']),
      roundsOnHand: serializer.fromJson<int?>(json['roundsOnHand']),
      notes: serializer.fromJson<String?>(json['notes']),
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
      'productLine': serializer.toJson<String?>(productLine),
      'caliber': serializer.toJson<String>(caliber),
      'grain': serializer.toJson<int?>(grain),
      'bulletType': serializer.toJson<String>(bulletType),
      'caseMaterial': serializer.toJson<String?>(caseMaterial),
      'quantityPerBox': serializer.toJson<int?>(quantityPerBox),
      'costPerBox': serializer.toJson<double?>(costPerBox),
      'roundsOnHand': serializer.toJson<int?>(roundsOnHand),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AmmoProduct copyWith({
    String? id,
    String? brand,
    Value<String?> productLine = const Value.absent(),
    String? caliber,
    Value<int?> grain = const Value.absent(),
    String? bulletType,
    Value<String?> caseMaterial = const Value.absent(),
    Value<int?> quantityPerBox = const Value.absent(),
    Value<double?> costPerBox = const Value.absent(),
    Value<int?> roundsOnHand = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AmmoProduct(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    productLine: productLine.present ? productLine.value : this.productLine,
    caliber: caliber ?? this.caliber,
    grain: grain.present ? grain.value : this.grain,
    bulletType: bulletType ?? this.bulletType,
    caseMaterial: caseMaterial.present ? caseMaterial.value : this.caseMaterial,
    quantityPerBox: quantityPerBox.present
        ? quantityPerBox.value
        : this.quantityPerBox,
    costPerBox: costPerBox.present ? costPerBox.value : this.costPerBox,
    roundsOnHand: roundsOnHand.present ? roundsOnHand.value : this.roundsOnHand,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AmmoProduct copyWithCompanion(AmmoProductsCompanion data) {
    return AmmoProduct(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      productLine: data.productLine.present
          ? data.productLine.value
          : this.productLine,
      caliber: data.caliber.present ? data.caliber.value : this.caliber,
      grain: data.grain.present ? data.grain.value : this.grain,
      bulletType: data.bulletType.present
          ? data.bulletType.value
          : this.bulletType,
      caseMaterial: data.caseMaterial.present
          ? data.caseMaterial.value
          : this.caseMaterial,
      quantityPerBox: data.quantityPerBox.present
          ? data.quantityPerBox.value
          : this.quantityPerBox,
      costPerBox: data.costPerBox.present
          ? data.costPerBox.value
          : this.costPerBox,
      roundsOnHand: data.roundsOnHand.present
          ? data.roundsOnHand.value
          : this.roundsOnHand,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AmmoProduct(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('productLine: $productLine, ')
          ..write('caliber: $caliber, ')
          ..write('grain: $grain, ')
          ..write('bulletType: $bulletType, ')
          ..write('caseMaterial: $caseMaterial, ')
          ..write('quantityPerBox: $quantityPerBox, ')
          ..write('costPerBox: $costPerBox, ')
          ..write('roundsOnHand: $roundsOnHand, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    productLine,
    caliber,
    grain,
    bulletType,
    caseMaterial,
    quantityPerBox,
    costPerBox,
    roundsOnHand,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AmmoProduct &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.productLine == this.productLine &&
          other.caliber == this.caliber &&
          other.grain == this.grain &&
          other.bulletType == this.bulletType &&
          other.caseMaterial == this.caseMaterial &&
          other.quantityPerBox == this.quantityPerBox &&
          other.costPerBox == this.costPerBox &&
          other.roundsOnHand == this.roundsOnHand &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AmmoProductsCompanion extends UpdateCompanion<AmmoProduct> {
  final Value<String> id;
  final Value<String> brand;
  final Value<String?> productLine;
  final Value<String> caliber;
  final Value<int?> grain;
  final Value<String> bulletType;
  final Value<String?> caseMaterial;
  final Value<int?> quantityPerBox;
  final Value<double?> costPerBox;
  final Value<int?> roundsOnHand;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AmmoProductsCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.productLine = const Value.absent(),
    this.caliber = const Value.absent(),
    this.grain = const Value.absent(),
    this.bulletType = const Value.absent(),
    this.caseMaterial = const Value.absent(),
    this.quantityPerBox = const Value.absent(),
    this.costPerBox = const Value.absent(),
    this.roundsOnHand = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AmmoProductsCompanion.insert({
    required String id,
    required String brand,
    this.productLine = const Value.absent(),
    required String caliber,
    this.grain = const Value.absent(),
    required String bulletType,
    this.caseMaterial = const Value.absent(),
    this.quantityPerBox = const Value.absent(),
    this.costPerBox = const Value.absent(),
    this.roundsOnHand = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       brand = Value(brand),
       caliber = Value(caliber),
       bulletType = Value(bulletType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AmmoProduct> custom({
    Expression<String>? id,
    Expression<String>? brand,
    Expression<String>? productLine,
    Expression<String>? caliber,
    Expression<int>? grain,
    Expression<String>? bulletType,
    Expression<String>? caseMaterial,
    Expression<int>? quantityPerBox,
    Expression<double>? costPerBox,
    Expression<int>? roundsOnHand,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (productLine != null) 'product_line': productLine,
      if (caliber != null) 'caliber': caliber,
      if (grain != null) 'grain': grain,
      if (bulletType != null) 'bullet_type': bulletType,
      if (caseMaterial != null) 'case_material': caseMaterial,
      if (quantityPerBox != null) 'quantity_per_box': quantityPerBox,
      if (costPerBox != null) 'cost_per_box': costPerBox,
      if (roundsOnHand != null) 'rounds_on_hand': roundsOnHand,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AmmoProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? brand,
    Value<String?>? productLine,
    Value<String>? caliber,
    Value<int?>? grain,
    Value<String>? bulletType,
    Value<String?>? caseMaterial,
    Value<int?>? quantityPerBox,
    Value<double?>? costPerBox,
    Value<int?>? roundsOnHand,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AmmoProductsCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      productLine: productLine ?? this.productLine,
      caliber: caliber ?? this.caliber,
      grain: grain ?? this.grain,
      bulletType: bulletType ?? this.bulletType,
      caseMaterial: caseMaterial ?? this.caseMaterial,
      quantityPerBox: quantityPerBox ?? this.quantityPerBox,
      costPerBox: costPerBox ?? this.costPerBox,
      roundsOnHand: roundsOnHand ?? this.roundsOnHand,
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
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (productLine.present) {
      map['product_line'] = Variable<String>(productLine.value);
    }
    if (caliber.present) {
      map['caliber'] = Variable<String>(caliber.value);
    }
    if (grain.present) {
      map['grain'] = Variable<int>(grain.value);
    }
    if (bulletType.present) {
      map['bullet_type'] = Variable<String>(bulletType.value);
    }
    if (caseMaterial.present) {
      map['case_material'] = Variable<String>(caseMaterial.value);
    }
    if (quantityPerBox.present) {
      map['quantity_per_box'] = Variable<int>(quantityPerBox.value);
    }
    if (costPerBox.present) {
      map['cost_per_box'] = Variable<double>(costPerBox.value);
    }
    if (roundsOnHand.present) {
      map['rounds_on_hand'] = Variable<int>(roundsOnHand.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('AmmoProductsCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('productLine: $productLine, ')
          ..write('caliber: $caliber, ')
          ..write('grain: $grain, ')
          ..write('bulletType: $bulletType, ')
          ..write('caseMaterial: $caseMaterial, ')
          ..write('quantityPerBox: $quantityPerBox, ')
          ..write('costPerBox: $costPerBox, ')
          ..write('roundsOnHand: $roundsOnHand, ')
          ..write('notes: $notes, ')
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
  late final $AmmoProductsTable ammoProducts = $AmmoProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [firearms, ammoProducts];
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
typedef $$AmmoProductsTableCreateCompanionBuilder =
    AmmoProductsCompanion Function({
      required String id,
      required String brand,
      Value<String?> productLine,
      required String caliber,
      Value<int?> grain,
      required String bulletType,
      Value<String?> caseMaterial,
      Value<int?> quantityPerBox,
      Value<double?> costPerBox,
      Value<int?> roundsOnHand,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AmmoProductsTableUpdateCompanionBuilder =
    AmmoProductsCompanion Function({
      Value<String> id,
      Value<String> brand,
      Value<String?> productLine,
      Value<String> caliber,
      Value<int?> grain,
      Value<String> bulletType,
      Value<String?> caseMaterial,
      Value<int?> quantityPerBox,
      Value<double?> costPerBox,
      Value<int?> roundsOnHand,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AmmoProductsTableFilterComposer
    extends Composer<_$AppDatabase, $AmmoProductsTable> {
  $$AmmoProductsTableFilterComposer({
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

  ColumnFilters<String> get productLine => $composableBuilder(
    column: $table.productLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caliber => $composableBuilder(
    column: $table.caliber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grain => $composableBuilder(
    column: $table.grain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caseMaterial => $composableBuilder(
    column: $table.caseMaterial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityPerBox => $composableBuilder(
    column: $table.quantityPerBox,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerBox => $composableBuilder(
    column: $table.costPerBox,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundsOnHand => $composableBuilder(
    column: $table.roundsOnHand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

class $$AmmoProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $AmmoProductsTable> {
  $$AmmoProductsTableOrderingComposer({
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

  ColumnOrderings<String> get productLine => $composableBuilder(
    column: $table.productLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caliber => $composableBuilder(
    column: $table.caliber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grain => $composableBuilder(
    column: $table.grain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caseMaterial => $composableBuilder(
    column: $table.caseMaterial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityPerBox => $composableBuilder(
    column: $table.quantityPerBox,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerBox => $composableBuilder(
    column: $table.costPerBox,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundsOnHand => $composableBuilder(
    column: $table.roundsOnHand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

class $$AmmoProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AmmoProductsTable> {
  $$AmmoProductsTableAnnotationComposer({
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

  GeneratedColumn<String> get productLine => $composableBuilder(
    column: $table.productLine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caliber =>
      $composableBuilder(column: $table.caliber, builder: (column) => column);

  GeneratedColumn<int> get grain =>
      $composableBuilder(column: $table.grain, builder: (column) => column);

  GeneratedColumn<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caseMaterial => $composableBuilder(
    column: $table.caseMaterial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityPerBox => $composableBuilder(
    column: $table.quantityPerBox,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costPerBox => $composableBuilder(
    column: $table.costPerBox,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roundsOnHand => $composableBuilder(
    column: $table.roundsOnHand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AmmoProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AmmoProductsTable,
          AmmoProduct,
          $$AmmoProductsTableFilterComposer,
          $$AmmoProductsTableOrderingComposer,
          $$AmmoProductsTableAnnotationComposer,
          $$AmmoProductsTableCreateCompanionBuilder,
          $$AmmoProductsTableUpdateCompanionBuilder,
          (
            AmmoProduct,
            BaseReferences<_$AppDatabase, $AmmoProductsTable, AmmoProduct>,
          ),
          AmmoProduct,
          PrefetchHooks Function()
        > {
  $$AmmoProductsTableTableManager(_$AppDatabase db, $AmmoProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AmmoProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AmmoProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AmmoProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String?> productLine = const Value.absent(),
                Value<String> caliber = const Value.absent(),
                Value<int?> grain = const Value.absent(),
                Value<String> bulletType = const Value.absent(),
                Value<String?> caseMaterial = const Value.absent(),
                Value<int?> quantityPerBox = const Value.absent(),
                Value<double?> costPerBox = const Value.absent(),
                Value<int?> roundsOnHand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AmmoProductsCompanion(
                id: id,
                brand: brand,
                productLine: productLine,
                caliber: caliber,
                grain: grain,
                bulletType: bulletType,
                caseMaterial: caseMaterial,
                quantityPerBox: quantityPerBox,
                costPerBox: costPerBox,
                roundsOnHand: roundsOnHand,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String brand,
                Value<String?> productLine = const Value.absent(),
                required String caliber,
                Value<int?> grain = const Value.absent(),
                required String bulletType,
                Value<String?> caseMaterial = const Value.absent(),
                Value<int?> quantityPerBox = const Value.absent(),
                Value<double?> costPerBox = const Value.absent(),
                Value<int?> roundsOnHand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AmmoProductsCompanion.insert(
                id: id,
                brand: brand,
                productLine: productLine,
                caliber: caliber,
                grain: grain,
                bulletType: bulletType,
                caseMaterial: caseMaterial,
                quantityPerBox: quantityPerBox,
                costPerBox: costPerBox,
                roundsOnHand: roundsOnHand,
                notes: notes,
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

typedef $$AmmoProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AmmoProductsTable,
      AmmoProduct,
      $$AmmoProductsTableFilterComposer,
      $$AmmoProductsTableOrderingComposer,
      $$AmmoProductsTableAnnotationComposer,
      $$AmmoProductsTableCreateCompanionBuilder,
      $$AmmoProductsTableUpdateCompanionBuilder,
      (
        AmmoProduct,
        BaseReferences<_$AppDatabase, $AmmoProductsTable, AmmoProduct>,
      ),
      AmmoProduct,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FirearmsTableTableManager get firearms =>
      $$FirearmsTableTableManager(_db, _db.firearms);
  $$AmmoProductsTableTableManager get ammoProducts =>
      $$AmmoProductsTableTableManager(_db, _db.ammoProducts);
}
