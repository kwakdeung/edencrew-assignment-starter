import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

/// 시세를 아직 받지 못한 관심종목 행. `feedbackSkeleton` 토큰으로 블록만 표시합니다.
class WatchlistSkeletonRow extends StatelessWidget {
  const WatchlistSkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    Widget bar(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.feedbackSkeleton,
          borderRadius: BorderRadius.circular(dimens.radiusSm),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
      padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                bar(88, 15),
                SizedBox(height: dimens.space2),
                bar(64, 12),
              ],
            ),
          ),
          SizedBox(width: dimens.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              bar(56, 15),
              SizedBox(height: dimens.space2),
              bar(72, 12),
            ],
          ),
        ],
      ),
    );
  }
}
