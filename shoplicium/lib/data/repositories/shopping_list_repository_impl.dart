import 'package:sqflite/sqflite.dart';

import '../../domain/models/shopping_list_dto.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import '../data_sources/local_data_source_impl.dart';
import '../db_helper.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {

  final _dataSource = LocalDataSourceImpl();
  final _tableName = DbHelper.shoppingListsTable;

  @override
  Future<bool> createShoppingList(ShoppingListDto instance) async {
    final db = await _dataSource.getDatabase();
    final result = await db.insert(_tableName, instance.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return result == 0 ?  false : true;
  }

  @override
  Future<List<ShoppingListDto>> getShoppingLists() async {
    final db = await _dataSource.getDatabase();
    final records = await db.query(_tableName);

    var list = records.map((e) => ShoppingListDto.fromMap(e)).toList();
    list.sort((a, b) => b.createdOn.compareTo(a.createdOn));

    return list;
  }

  @override
  Future<bool> deleteShoppingList(String listId) async {
    final db = await _dataSource.getDatabase();
    final deletedRowCount = await db.delete(_tableName, where: 'listId = ?', whereArgs: [listId]);

    return deletedRowCount > 0 ? true : false;
  }

  @override
  Future<bool> updateShoppingList(ShoppingListDto instance) async {
    final db = await _dataSource.getDatabase();
    final affectedRowCount = await db.update(_tableName, instance.toMap(), where: 'listId = ?', whereArgs: [instance.listId]);

    return affectedRowCount > 0 ?  true : false;
  }
}
