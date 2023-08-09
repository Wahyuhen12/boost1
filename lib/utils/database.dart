import 'dart:io';

import 'database_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "baca_meter.db";
  static const _databaseVersion = 1;

  String path = "";

  // make this a singleton class
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String pathdb = join(path, _databaseName);
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      pathdb = join(documentsDirectory.path, _databaseName);
    } catch (e) {
      print(e);
    }
    print(pathdb);
    print('================================================================');
    return await openDatabase(pathdb,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    TablesDB().getTables().forEach((element) async {
      await db.execute(element).then((value) {
        print('database berhasil');
      }).catchError((err) {
        print('Error ${err.toString()}');
      });
    });

    print('Table created');
  }

  //QUERY ROWS
  Future<List<Map<String, dynamic>>> queryRows(
      String table, String where, List<Object> whereArgs) async {
    Database db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> selecQuery() async {
    Database db = await database;
    return await db.rawQuery(
        "SELECT koderbm,COUNT(nosal) AS JML_PLG,SUM(COALESCE(status_baca,1,0)) AS JML_TERBACA,SUM(COALESCE(status_baca,1,0)) AS JML_DATA_TERKIRIM FROM pembacaan GROUP BY koderbm;");
  }

  //INSERT ROW
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(
      table,
      row,
    );
  }

  //INSERT ROW
  Future<int> insertIgnore(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  //INSERT ROW
  Future<int> insertReplace(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future insertBatch(String table, List<Map<String, dynamic>> rows) async {
    Database db = await database;

    await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var row in rows) {
        batch.insert(table, row, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      batch.commit();
    });
  }

  Future insertBatchList(String table, List<List<dynamic>> datarows) async {
    final datarowslenght = datarows.length;
    if (datarowslenght <= 1) {
      return;
    }

    List<Map<String, dynamic>> rows = [];
    List<String> header = List<String>.from(datarows[0]);
    for (var i = 1; i < datarowslenght; i++) {
      final datarow = datarows[i];
      final datarowlenght = datarow.length;
      Map<String, dynamic> rowi = {};
      for (var j = 0; j < datarowlenght; j++) {
        rowi[header[j]] = datarow[j];
      }
      rows.add(rowi);
    }

    await insertBatch(table, rows);
  }

  //UPDATE ROW
  Future<int> update(String table, Map<String, dynamic> row, String where,
      List<Object> whereArgs) async {
    Database db = await database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  //DELETE ROW
  Future<int> delete(String table, String where, List<Object> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  //GET ALL ROW TABLE
  Future<List<Map<String, Object?>>> getData(
    String tableName, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    Database db = await database;
    return await db.query(
      tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  //EXECUTE
  Future<void> execute(String sql) async {
    Database db = await database;
    return await db.execute(sql);
  }
}
