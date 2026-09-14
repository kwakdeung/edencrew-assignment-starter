import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/widgets/sort_bottom_sheet.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key, required this.controller});

  final WatchlistController controller;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        dimens.space4,
        dimens.space3,
        dimens.space4,
        dimens.space2,
      ),
      child: Row(
        children: <Widget>[
          Text(
            '관심',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 19,
              fontWeight: AppTypography.bold,
              height: 22 / 19,
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(dimens.radiusMd),
            onTap: () => showSortBottomSheet(
              context: context,
              current: controller.sort,
              onSelected: controller.changeSort,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.space2,
                vertical: dimens.space2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    controller.sort.label,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      fontWeight: AppTypography.bold,
                      height: 18 / 13,
                    ),
                  ),
                  SizedBox(width: dimens.space1),
                  SvgPicture.asset(
                    'assets/images/ic_align.svg',
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      colors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: dimens.space2),
          IconButton(
            onPressed: controller.isRefreshing
                ? null
                : controller.refreshQuotes,
            icon: controller.isRefreshing
                ? SizedBox(
                    width: dimens.iconMd,
                    height: dimens.iconMd,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textSecondary,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/images/ic_refresh.svg',
                    width: dimens.iconMd,
                    height: dimens.iconMd,
                    colorFilter: ColorFilter.mode(
                      colors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
