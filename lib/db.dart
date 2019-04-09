
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
}

// инициализация бд - если нет файла то копируем бд из assets
// и еще добавляем таблицы для избранного

class DBLoader {

  static final _dbName = 'catalog';

  static loadDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "$_dbName.db");

    // try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(
        path, 
        version: 3, 
        onUpgrade: _onUpgrade,
        onCreate: _onCreate
      );
    } catch (e) {
      print("Error $e");
    }

    if (db == null) {
      // Should happen only the first time you launch your application
      print("DB: Creating new copy from asset");

      // Copy from asset
      var data = await rootBundle.load(join("assets", "spells.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      // open the database
      db = await openDatabase(
        path, 
        version: 3, 
        onUpgrade: _onUpgrade,
        onCreate: _onCreate
      );
      
    } else {
      print("DB: Opening existing database");
    }

    return db;
  }

  static _onCreate(Database db, int version) async {
    // Database is created, create the table
    print("DB: Creation call");
  }

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("DB: Upgrade call");
    // version 1 - add favoriteSpells table
    await db.execute("CREATE TABLE IF NOT EXISTS favoriteSpells (id INTEGER PRIMARY KEY, spellId INTEGER)");
  }
  
}