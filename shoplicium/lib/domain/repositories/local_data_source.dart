import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> initDatabase();

  Future<Database> getDatabase();
}
