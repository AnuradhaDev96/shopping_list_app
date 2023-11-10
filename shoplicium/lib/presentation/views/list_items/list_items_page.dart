import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/models/shopping_list_dto.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/primary_button_skin.dart';
import '../../widgets/scaffold_decoration.dart';

class ListItemsPage extends StatefulWidget {
  const ListItemsPage({super.key, required this.selectedList});
  final ShoppingListDto selectedList;

  @override
  State<ListItemsPage> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldDecoration(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.selectedList.title),
        ),
        floatingActionButton: _bottomFloatingBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _bottomFloatingBar(BuildContext context) => Row(
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
  );

  Widget _addNewItemButton(BuildContext context) {
    return GestureDetector(
      // onTap: () => showCreateNewListDialog(context),
      child: const PrimaryButtonSkin(title: 'Add new item'),
    );
  }
}
