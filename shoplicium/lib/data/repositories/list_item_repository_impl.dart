import 'package:shoplicium/domain/models/list_item_dto.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/repositories/list_item_repository.dart';
import '../data_sources/local_data_source_impl.dart';
import '../db_helper.dart';

class ListItemRepositoryImpl implements ListItemRepository {
  final _dataSource = LocalDataSourceImpl();
  final _tableName = DbHelper.listItemsTable;

  @override
  Future<bool> createListItem(ListItemDto instance) async {
    final db = await _dataSource.getDatabase();
    final result = await db.insert(_tableName, instance.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return result == 0 ?  false : true;
  }

  @override
  Future<List<ListItemDto>> getListItems() async {
    final db = await _dataSource.getDatabase();
    final records = await db.query(_tableName);

    return records.map((e) => ListItemDto.fromMap(e)).toList();
  }
}
