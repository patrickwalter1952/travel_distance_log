import 'package:distance_travel_log/models/distance_travel_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const DatabaseService instance = DatabaseService._();

  const DatabaseService._();

  static const String _distTraveledTable = 'distTraveled_table';
  static const String _colId = 'id';
  static const String _colDate = 'date';
  static const String _colStartOdometer = 'startOdometer';
  static const String _colEndOdometer = 'endOdometer';
  static const String _colDistance = 'distance';

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path + '/distance_travel.db';

    ///data/user/0/com.example.distance_travel_log/app_flutter/distance_travel.db
    print ("DATABASE PATH: $path");

    final distTraveledListDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_distTraveledTable (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colDate TEXT,
            $_colStartOdometer INTEGER,
            $_colEndOdometer INTEGER,
            $_colDistance INTEGER
          )
        ''');
      },
    );
    return distTraveledListDb;
  }

  Future<DistanceTravel> insert(DistanceTravel distanceTravel) async {
    final db = await this.db;
    final id = await db.insert(_distTraveledTable, distanceTravel.toMap());
    final distanceTravelWithId = distanceTravel.copyWith(id: id);
    return distanceTravelWithId;
  }

  Future<List<DistanceTravel>> getAllDistanceTravel() async {
    final db = await this.db;
    final distTraveledData =
        await db.query(_distTraveledTable,
            orderBy: '$_colDate DESC, $_colStartOdometer DESC');
    return distTraveledData.map((e) => DistanceTravel.fromMap(e)).toList();
  }

  Future<int> update(DistanceTravel distanceTravel) async {
    final db = await this.db;
    return await db.update(
      _distTraveledTable,
      distanceTravel.toMap(),
      where: '$_colId = ?',
      whereArgs: [distanceTravel.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await this.db;
    return await db.delete(
      _distTraveledTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }
}
