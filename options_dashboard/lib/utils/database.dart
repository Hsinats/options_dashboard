import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/search_history.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'search_history.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE searchHistory(
          ticker TEXT , name TEXT, date PRIMARY KEY INT
        )
        ''');
      },
      version: 1,
    );
  }

  newSearch(SearchHistory newSearchHistory) async {
    final db = await database;

    var res;
    try {
      res = await db.rawInsert('''
      INSERT INTO searchHistory (
        ticker, name, date
      ) VALUES (?,?,?)
    ''', [
        newSearchHistory.ticker,
        newSearchHistory.name,
        newSearchHistory.date
      ]);
    } catch (e) {
      res = await db.rawUpdate('''
      UPDATE  searchHistory
      SET date = ?
      WHERE ticker = ?
      ''', [
        newSearchHistory.date,
        newSearchHistory.ticker,
      ]);
    }

    return res;
  }

  Future<dynamic> getSearchHistory() async {
    final db = await database;
    var res = await db.query('searchHistory');

    if (res.length == 0) {
      return null;
    } else if (res.length < 10) {
      var resMap = res;
      return resMap.isNotEmpty ? resMap : Null;
    } else {
      var resMap = res;
      return resMap.isNotEmpty ? resMap : Null;
    }
  }
}
