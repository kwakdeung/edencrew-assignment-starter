import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/widgets/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return SafeArea(
      top: false,
      child: Container(
        height: dimens.tabBarHeight,
        decoration: BoxDecoration(
          color: colors.surfaceBase,
          border: Border(
            top: BorderSide(
              color: colors.borderSubtle,
              width: dimens.borderHairline,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            NavItem(
              iconAsset: 'assets/images/ic_star.svg',
              selectedIconAsset: 'assets/images/ic_star_fill.svg',
              label: '관심',
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
            NavItem(
              iconAsset: 'assets/images/ic_search.svg',
              label: '검색',
              selected: index == 1,
              onTap: () => onChanged(1),
            ),
          ],
        ),
      ),
    );
  }
}
