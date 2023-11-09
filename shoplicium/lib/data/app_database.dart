import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppDatabase {
  static Future<void> initDatabase() async {
    try {
      await openDatabase(
        join(await getDatabasesPath(), DbHelper.dbName),
        onCreate: (db, version) async {
          await db.execute(DbHelper.createListTableCommand);
          await db.execute(DbHelper.createListItemsTableCommand);
        },
        version: 1,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

abstract class DbHelper {
  static const dbName = 'shoplicium_database.db';
  static const shoppingListsTable = 'ShoppingLists';
  static const listItemsTable = 'ListItems';

  static const createListTableCommand =
      'CREATE TABLE $shoppingListsTable(listId TEXT PRIMARY KEY, title TEXT, date TEXT, createdOn TEXT)';
  static const createListItemsTableCommand =
      'CREATE TABLE $listItemsTable(itemId TEXT PRIMARY KEY, title TEXT, amount INTEGER, UOM INTEGER, status INTEGER, listId TEXT, FOREIGN KEY(listId) REFERENCES ShoppingLists(listId))';
}
