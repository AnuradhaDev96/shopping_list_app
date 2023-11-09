import 'package:flutter/material.dart';

import '../../../config/themes/text_styles.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';
import 'widgets/create_new_list_dialog.dart';
import 'widgets/latest_shopping_list_card.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
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
      builder: (dialogContext) => CreateNewListDialog(),
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
