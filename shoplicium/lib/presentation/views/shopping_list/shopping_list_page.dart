import 'package:flutter/material.dart';

import '../../../config/themes/text_styles.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';
import 'widgets/latest_shopping_list_card.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDecoration(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping List'),
        ),
        floatingActionButton: _createNewListButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Text(
                  'Latest list',
                  style: TextStyles.sectionTitleTextStyle,
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: LatestShoppingListCard(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Text(
                  'Previous lists',
                  style: TextStyles.sectionTitleTextStyle,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: ShoppingListErrorWidget(
                    caption: 'No more shopping lists !',
                    actionButton: _createNewListButton(context),
                  ),
                ),
              ),
            ],
          ),
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
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: const Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 26, bottom: 31, left: 20, right: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 23),
                      child: Text(
                        'Create new list',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shopping date',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: PrimaryButtonSkin(
                        title: 'Save & add items',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShoppingListErrorWidget extends StatelessWidget {
  const ShoppingListErrorWidget({super.key, required this.caption, this.actionButton});

  final String caption;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          caption,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        if (actionButton != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionButton!,
          ),
      ],
    );
  }
}
