import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/list_item_dto.dart';
import '../../../domain/models/shopping_list_dto.dart';
import '../../../utils/constants/assets.dart';
import '../../cubits/shopping_list_bloc.dart';
import '../../widgets/list_error_widget.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';

class ListItemsPage extends StatefulWidget {
  const ListItemsPage({super.key, required this.selectedList});

  final ShoppingListDto selectedList;

  @override
  State<ListItemsPage> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  final _scrollController = ScrollController();

  ListItemFilterEnum _selectedFilter = ListItemFilterEnum.all;

  @override
  Widget build(BuildContext context) {
    return ScaffoldDecoration(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.selectedList.title),
        ),
        floatingActionButton: _bottomFloatingBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: StreamBuilder<List<ListItemDto>>(
          stream: GetIt.instance<ShoppingListBloc>().listItemsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator(radius: 20));
            }

            if (snapshot.hasData) {
              var listData = snapshot.data;

              // all list can be null. hence handle it first
              if (listData == null) {
                return Center(
                  child: ListErrorWidget(
                    caption: 'This shopping list\n does not have any items',
                    actionButton: _addNewItemButton(context),
                  ),
                );
              } else {
                // listData has at least one record
                var itemsOfSelectedShoppingList =
                    listData.where((element) => element.listId == widget.selectedList.listId).toList();

                if (itemsOfSelectedShoppingList.isEmpty) {
                  return Center(
                    child: ListErrorWidget(
                      caption: 'This shopping list\n does not have any items',
                      actionButton: _addNewItemButton(context),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 23, left: 25, right: 25),
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var filterItem = ListItemFilterEnum.values[index];
                                  bool isSelected = filterItem == _selectedFilter;

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        filterItem.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
                                        ),
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: 30,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(width: 25),
                                itemCount: ListItemFilterEnum.values.length,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
            } else {
              return const Center(
                child: Text(
                  'Something went wrong!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _bottomFloatingBar(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 27, right: 20),
    child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _addNewItemButton(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(Assets.editIcon, width: 37, height: 37),
                SvgPicture.asset(Assets.deleteIconWhite, width: 37, height: 37),
              ],
            ),
          ],
        ),
  );

  Widget _addNewItemButton(BuildContext context) {
    return GestureDetector(
      // onTap: () => showCreateNewListDialog(context),
      child: const PrimaryButtonSkin(title: 'Add new item'),
    );
  }
}

enum ListItemFilterEnum {
  /// [all] does not have a status value in table
  all(statusValue: 0, text: "All items"),
  remaining(statusValue: 1, text: "Remaining"),
  notInShop(statusValue: 3, text: "Not in shop");

  final int statusValue;
  final String text;

  const ListItemFilterEnum({required this.statusValue, required this.text});
}
