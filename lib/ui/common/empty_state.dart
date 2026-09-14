import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

/// 관심 · 검색 화면이 공통으로 쓰는 빈 상태 레이아웃입니다.
/// (아이콘 + 제목 + 안내 문구, 화면 중앙 정렬)
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    this.iconAsset,
    required this.title,
    required this.description,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (iconAsset != null)
              SvgPicture.asset(
                iconAsset!,
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(colors.textDisabled, BlendMode.srcIn),
              )
            else
              Icon(icon, size: 48, color: colors.textDisabled),
            SizedBox(height: dimens.space4),
            Text(
              title,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 19,
                fontWeight: AppTypography.bold,
                height: 22 / 19,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: dimens.space2),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textTertiary,
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
