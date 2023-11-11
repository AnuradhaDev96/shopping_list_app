import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../domain/enums/list_item_status_enum.dart';
import '../../../../domain/models/list_item_dto.dart';
import '../../../../domain/models/shopping_list_dto.dart';
import '../../../cubits/shopping_list_bloc.dart';

class PreviousShoppingListItem extends StatelessWidget {
  const PreviousShoppingListItem({super.key, required this.data});

  final ShoppingListDto data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.27),
          offset: const Offset(0, 4),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat("EEEE d, MMM y").format(data.date),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          StreamBuilder<List<ListItemDto>>(
            stream: GetIt.instance<ShoppingListBloc>().listItemsStream,
            builder: (context, snapshot) {
              int remainingItems = 0;
              int notInShopItems = 0;

              if (snapshot.hasData) {
                var listData = snapshot.data;
                if (listData != null && listData.isNotEmpty) {
                  var itemsOfSelectedShoppingList = listData.where((element) => element.listId == data.listId).toList();

                  remainingItems = itemsOfSelectedShoppingList
                      .where((element) => element.status == ListItemStatusEnum.remaining)
                      .toList()
                      .length;

                  notInShopItems = itemsOfSelectedShoppingList
                      .where((element) => element.status == ListItemStatusEnum.notInShop)
                      .toList()
                      .length;
                }
              }

              if (notInShopItems == 0 && remainingItems == 0) {
                return const SizedBox.shrink();
              } else {
                return Container(
                  padding: const EdgeInsets.only(bottom: 6, top: 4, left: 5, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), border: Border.all(width: 1.5, color: Colors.black)),
                  child: Center(
                    child: Row(
                      children: [
                        if (notInShopItems > 0)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$notInShopItems',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                'not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        if (notInShopItems > 0 && remainingItems > 0) const SizedBox(width: 10),
                        if (remainingItems > 0)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$remainingItems',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                'remaining',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
