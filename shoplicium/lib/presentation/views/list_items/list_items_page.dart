import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../../config/themes/text_styles.dart';
import '../../../domain/models/list_item_dto.dart';
import '../../../domain/models/shopping_list_dto.dart';
import '../../../utils/constants/assets.dart';
import '../../cubits/shopping_list_bloc.dart';
import '../../widgets/list_error_widget.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';
import 'widgets/create_list_item_dialog.dart';
import 'widgets/delete_shopping_list_dialog.dart';
import 'widgets/list_item_card.dart';
import 'widgets/update_list_item_dialog.dart';
import 'widgets/update_shopping_list_dialog.dart';

class ListItemsPage extends StatefulWidget {
  const ListItemsPage({super.key, required this.selectedList});

  final ShoppingListDto selectedList;

  @override
  State<ListItemsPage> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  final _scrollController = ScrollController();

  ListItemFilterEnum _selectedFilter = ListItemFilterEnum.remaining;

  @override
  Widget build(BuildContext context) {
    final displayFilters = ListItemFilterEnum.values.where((element) => element != ListItemFilterEnum.inBag).toList();

    return ScaffoldDecoration(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.selectedList.title),
          leading: Transform.translate(
            offset: const Offset(18, 0),
            child: Transform.scale(
              scale: 0.7,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(Assets.navigateBack, width: 32, height: 32),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  _selectedFilter = ListItemFilterEnum.inBag;
                }),
                child: _selectedFilter == ListItemFilterEnum.inBag
                    ? SvgPicture.asset(Assets.openBagIcon, width: 41, height: 52)
                    : SvgPicture.asset(Assets.showBagIcon, width: 41, height: 45),
              ),
            ),
          ],
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
                          child: SizedBox(
                            height: 55,
                            child: Center(
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var filterItem = displayFilters[index];
                                  bool isSelected = filterItem == _selectedFilter;

                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() {
                                        _selectedFilter = filterItem;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                          Transform.translate(
                                            offset: const Offset(0, 5),
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
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(width: 25),
                                itemCount: displayFilters.length,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Items',
                                    style: TextStyles.sectionTitleTextStyle,
                                  ),
                                  const SizedBox(width: 7),
                                  SvgPicture.asset(
                                    Assets.helpIcon,
                                    width: 26,
                                    height: 26,
                                  ),
                                ],
                              ),
                              Text(
                                '${_getFilteredListItems(itemsOfSelectedShoppingList).length} ${_selectedFilter.counterText}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.08, top: 5),
                            child: ListView.separated(
                              padding: const EdgeInsets.only(top: 7, bottom: 5),
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var listItemData = _getFilteredListItems(itemsOfSelectedShoppingList)[index];
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return UpdateListItemDialog(selectedItem: listItemData);
                                      },
                                    );
                                  },
                                  child: ListItemCard(data: listItemData),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemCount: _getFilteredListItems(itemsOfSelectedShoppingList).length,
                            ),
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
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return UpdateShoppingListDialog(selectedList: widget.selectedList);
                        },
                      );
                    },
                    child: SvgPicture.asset(Assets.editIcon, width: 37, height: 37)),
                const SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return DeleteShoppingListDialog(listId: widget.selectedList.listId);
                      },
                    );
                  },
                  child: SvgPicture.asset(Assets.deleteIconWhite, width: 37, height: 37),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _addNewItemButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => CreateListItemDialog(listId: widget.selectedList.listId),
        );
      },
      child: const PrimaryButtonSkin(title: 'Add new item'),
    );
  }

  List<ListItemDto> _getFilteredListItems(List<ListItemDto> itemsOfShoppingList) {
    switch (_selectedFilter) {
      case ListItemFilterEnum.all:
        return itemsOfShoppingList;
      case ListItemFilterEnum.remaining:
      case ListItemFilterEnum.notInShop:
      case ListItemFilterEnum.inBag:
        return itemsOfShoppingList.where((element) => element.status.dtoValue == _selectedFilter.statusValue).toList();
    }
  }
}

enum ListItemFilterEnum {
  remaining(statusValue: 1, text: "Remaining", counterText: 'remaining'),
  notInShop(statusValue: 3, text: "Not in shop", counterText: 'not found'),

  /// [all] does not have a status value in table
  all(statusValue: 0, text: "All items", counterText: 'total'),
  inBag(statusValue: 2, text: "In bag", counterText: 'in the bag');

  final int statusValue;
  final String text;
  final String counterText;

  const ListItemFilterEnum({required this.statusValue, required this.text, required this.counterText});
}
