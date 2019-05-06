
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}

// инициализация бд - если нет файла то копируем бд из assets
// и еще добавляем таблицы для избранного

class DBLoader {

  static final _dbName = 'demo1';

  static loadDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "$_dbName.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("DB: Creating new copy from asset");

      // Copy from asset
      var data = await rootBundle.load(join("assets", "spells.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);
      
    } else {
      print("DB: Opening existing database");
    }

    // open the database
    var db = await openDatabase(
      path, 
      version: 2, 
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
      readOnly: false
    );

    return db;
  }

  static _onCreate(Database db, int version) async {
    // Database is created, create the table
    print("DB: Creation call");

    // version 1 - add favoriteSpells table
    await db.execute("CREATE TABLE IF NOT EXISTS favoriteSpells (id INTEGER PRIMARY KEY, spellId INTEGER)");
  }

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("DB: Upgrade call");
    
  }
  
}