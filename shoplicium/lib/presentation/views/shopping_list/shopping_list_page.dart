import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../config/themes/text_styles.dart';
import '../../../domain/models/shopping_list_dto.dart';
import '../../cubits/shopping_list_bloc.dart';
import '../../widgets/list_error_widget.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';
import '../list_items/list_items_page.dart';
import 'widgets/create_new_list_dialog.dart';
import 'widgets/latest_shopping_list_card.dart';
import 'widgets/previous_shopping_list_item.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDecoration(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping List'),
        ),
        floatingActionButton: _createNewListButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: StreamBuilder<List<ShoppingListDto>>(
          stream: GetIt.instance<ShoppingListBloc>().shoppingListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator(radius: 20));
            }

            if (snapshot.hasData) {
              var listData = snapshot.data;

              if (listData == null || listData.isEmpty) {
                return Center(
                  child: ListErrorWidget(
                    caption: 'You don’t have any\nshopping lists',
                    actionButton: _createNewListButton(context),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top:5, left: 25, right: 25),
                  child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Text(
                          'Latest shopping list',
                          style: TextStyles.sectionTitleTextStyle,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListItemsPage(
                                  selectedList: listData.first,
                                  isLatestList: true,
                                ),
                              ),
                            ),
                            child: LatestShoppingListCard(data: listData.first),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Previous lists',
                            style: TextStyles.sectionTitleTextStyle,
                          ),
                        ),
                      ),
                      listData.length == 1
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).width * 0.1),
                                child: ListErrorWidget(
                                  caption: 'No more shopping lists !',
                                  actionButton: _createNewListButton(context),
                                ),
                              ),
                            )
                          : SliverFillRemaining(
                              child: ListView.separated(
                                padding: const EdgeInsets.only(bottom: 70),
                                physics: const BouncingScrollPhysics(),
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListItemsPage(
                                            selectedList: listData[index],
                                          ),
                                        ),
                                      ),
                                      child: PreviousShoppingListItem(data: listData[index]),
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemCount: listData.length,
                              ),
                            ),
                    ],
                  ),
                );
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

  Widget _createNewListButton(BuildContext context) => GestureDetector(
        onTap: () => showCreateNewListDialog(context),
        child: const PrimaryButtonSkin(title: 'Create new list'),
      );

  void showCreateNewListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => const CreateNewListDialog(),
    );
  }
}
