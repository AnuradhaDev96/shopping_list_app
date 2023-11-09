import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/repositories/local_data_source.dart';
import 'db_helper.dart';

class LocalDataSourceImpl extends LocalDataSource {
  @override
  Future<void> initDatabase() async {
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
