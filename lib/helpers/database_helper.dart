import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Database? _db;

  DatabaseHelper._internal();

  Future<void> updateRecords(ParkingRecord record, String carNumber) async {
    final dbClient = await initDatabase();
    await dbClient.update(
      'parking_records',
      record.toMap(),
      where: 'carNumber',
      whereArgs: [record.carNumber],
    );
    
  }
Future<void> updateRecord(ParkingRecord record) async {
    final dbClient = await initDatabase();
    await dbClient.update(
      'parking_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<Database> initDatabase() async {
    if (_db != null) {
      return _db!;
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'parking_database.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  Future<void> updateCheckInRecord(ParkingRecord record) async {
    final dbClient = await initDatabase();
    await dbClient.update(
      'parking_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<ParkingRecord?> getOpenCheckInRecord(String carNumber) async {
    final dbClient = await initDatabase();
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'parking_records',
      where: 'carNumber = ? AND checkOutTime IS NULL',
      whereArgs: [carNumber],
    );

    if (maps.isNotEmpty) {
      return ParkingRecord.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> clearOldRecords() async {
    final dbClient = await initDatabase();
    await dbClient.delete('parking_records', where: 'checkOutTime IS NULL');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parking_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carNumber TEXT,
        checkInTime TEXT,
        checkInLatitude REAL,
        checkInLongitude REAL,
        checkOutTime TEXT,
        checkOutLatitude REAL,
        checkOutLongitude REAL
      )
    ''');
  }

  Future<int> insertRecord(ParkingRecord record) async {
    final dbClient = await initDatabase();
    return await dbClient.insert('parking_records', record.toMap());
  }

  Future<List<ParkingRecord>> getAllRecords() async {
    final dbClient = await initDatabase();
    final List<Map<String, dynamic>> maps =
        await dbClient.query('parking_records');
    return List.generate(maps.length, (i) {
      return ParkingRecord.fromMap(maps[i]);
    });
  }
}

class ParkingRecord {
  int? id;
  String? carNumber;
  DateTime checkInTime;
  double checkInLatitude;
  double checkInLongitude;
  DateTime? checkOutTime;
  double? checkOutLatitude;
  double? checkOutLongitude;

  ParkingRecord({
    this.id,
    this.carNumber,
    required this.checkInTime,
    required this.checkInLatitude,
    required this.checkInLongitude,
    this.checkOutTime,
    this.checkOutLatitude,
    this.checkOutLongitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carNumber': carNumber,
      'checkInTime': checkInTime.toIso8601String(),
      'checkInLatitude': checkInLatitude,
      'checkInLongitude': checkInLongitude,
      'checkOutTime': checkOutTime?.toIso8601String(),
      'checkOutLatitude': checkOutLatitude,
      'checkOutLongitude': checkOutLongitude,
    };
  }

  factory ParkingRecord.fromMap(Map<String, dynamic> map) {
    return ParkingRecord(
      id: map['id'],
      carNumber: map['carNumber'],
      checkInTime: DateTime.parse(map['checkInTime']),
      checkInLatitude: map['checkInLatitude'],
      checkInLongitude: map['checkInLongitude'],
      checkOutTime: map['checkOutTime'] != null
          ? DateTime.parse(map['checkOutTime'])
          : null,
      checkOutLatitude: map['checkOutLatitude'],
      checkOutLongitude: map['checkOutLongitude'],
    );
  }
}
