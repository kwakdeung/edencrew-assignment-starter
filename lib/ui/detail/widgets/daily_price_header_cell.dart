import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class DailyPriceHeaderCell extends StatelessWidget {
  const DailyPriceHeaderCell(this.label, {super.key, this.align = TextAlign.right});

  final String label;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    return Expanded(
      child: Text(
        label,
        textAlign: align,
        style: TextStyle(
          color: colors.textTertiary,
          fontSize: 12,
          fontWeight: AppTypography.regular,
        ),
      ),
    );
  }
}
