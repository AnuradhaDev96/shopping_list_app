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
        floatingActionButton: const PrimaryButtonSkin(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: const Padding(
          padding: EdgeInsets.only(top: 20, left: 25, right: 25),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  'Latest list',
                  style: TextStyles.sectionTitleTextStyle,
                ),
              ),
              SliverToBoxAdapter(
                child: LatestShoppingListCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShoppingListErrorWidget extends StatelessWidget {
  const _ShoppingListErrorWidget({super.key, required this.caption});

  final String caption;

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
      ],
    );
  }
}
