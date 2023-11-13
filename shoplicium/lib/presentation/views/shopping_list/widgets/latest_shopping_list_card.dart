import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../domain/enums/list_item_status_enum.dart';
import '../../../../domain/models/list_item_dto.dart';
import '../../../../domain/models/shopping_list_dto.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../cubits/shopping_list_bloc.dart';

class LatestShoppingListCard extends StatelessWidget {
  const LatestShoppingListCard({super.key, required this.data});

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
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat("EEEE d, MMM y").format(data.date),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 25),
          StreamBuilder<List<ListItemDto>>(
              stream: GetIt.instance<ShoppingListBloc>().listItemsStream,
              builder: (context, snapshot) {
                int remainingItems = 0;
                int inBagItems = 0;
                int notInShopItems = 0;
                int totalItems = 0;

                if (snapshot.hasData) {
                  var listData = snapshot.data;
                  if (listData != null && listData.isNotEmpty) {
                    var itemsOfSelectedShoppingList =
                        listData.where((element) => element.listId == data.listId).toList();

                    remainingItems = itemsOfSelectedShoppingList
                        .where((element) => element.status == ListItemStatusEnum.remaining)
                        .toList()
                        .length;

                    inBagItems = itemsOfSelectedShoppingList
                        .where((element) => element.status == ListItemStatusEnum.inBag)
                        .toList()
                        .length;

                    notInShopItems = itemsOfSelectedShoppingList
                        .where((element) => element.status == ListItemStatusEnum.notInShop)
                        .toList()
                        .length;

                    totalItems = itemsOfSelectedShoppingList.length;
                  }
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 6, top: 4, left: 6, right: 6),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue1,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$remainingItems',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'remaining',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$inBagItems',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'in bag',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$notInShopItems',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'not in shop',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$totalItems',
                          style: const TextStyle(
                            color: AppColors.green3,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'total',
                          style: TextStyle(
                            color: AppColors.green3,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
