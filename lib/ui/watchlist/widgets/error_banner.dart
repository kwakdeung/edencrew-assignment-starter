import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space1,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space3,
        vertical: dimens.space2,
      ),
      decoration: BoxDecoration(
        color: colors.priceDownBg,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colors.feedbackWarning,
          fontSize: 12,
          fontWeight: AppTypography.regular,
        ),
      ),
    );
  }
}
