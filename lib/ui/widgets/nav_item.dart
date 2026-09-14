import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.iconAsset,
    this.selectedIconAsset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String iconAsset;
  final String? selectedIconAsset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final Color color = selected ? colors.navActive : colors.navInactive;
    final String asset = selected ? (selectedIconAsset ?? iconAsset) : iconAsset;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              asset,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: dimens.space1),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: AppTypography.regular,
                height: 14 / 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
