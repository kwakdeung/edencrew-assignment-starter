import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      color: colors.priceDownBg,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: dimens.space4),
      child: Icon(Icons.delete_outline_rounded, color: colors.priceDownText),
    );
  }
}
