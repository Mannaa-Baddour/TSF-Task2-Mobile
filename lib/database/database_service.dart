import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'banking_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'banking.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      onConfigure: configure,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await BankingDB().createTables(database);

  Future<void> configure(Database database) async =>
      await BankingDB().configure(database);
}