import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/enums/list_item_status_enum.dart';
import '../../../../domain/models/list_item_dto.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';

class ListItemCard extends StatelessWidget {
  const ListItemCard({super.key, required this.data});

  final ListItemDto data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.27),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
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
                '${data.amount} ${data.UOM.symbol}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (data.status != ListItemStatusEnum.remaining)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: AppColors.darkBlue1, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          _manageStatusWidget(),
        ],
      ),
    );
  }

  Widget _manageStatusWidget() {
    switch (data.status) {
      case ListItemStatusEnum.remaining:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(Assets.itemNotInShopIcon, width: 32, height: 32),
                const SizedBox(width: 6),
                SvgPicture.asset(Assets.itemAddToBagIcon, width: 32, height: 32),
              ],
            ),
          ],
        );
      case ListItemStatusEnum.notInShop:
        return SvgPicture.asset(Assets.itemMarkedAsNotFoundIcon);
      case ListItemStatusEnum.inBag:
        return SvgPicture.asset(Assets.itemMarkedAsInShopIcon);
    }
  }
}
