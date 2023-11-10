abstract class DbHelper {
  static const dbVersion = 1;
  static const dbName = 'shoplicium_database.db';
  static const shoppingListsTable = 'ShoppingLists';
  static const listItemsTable = 'ListItems';

  static const createListTableCommand =
      'CREATE TABLE $shoppingListsTable(listId TEXT PRIMARY KEY, title TEXT, date TEXT, createdOn TEXT)';
  static const createListItemsTableCommand =
      'CREATE TABLE $listItemsTable(itemId TEXT PRIMARY KEY, title TEXT, amount INTEGER, UOM INTEGER, status INTEGER, listId TEXT, FOREIGN KEY(listId) REFERENCES ShoppingLists(listId))';
}
