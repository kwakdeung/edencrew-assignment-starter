import 'package:flutter/material.dart';

import '../../../domain/chart_period.dart';
import '../../../theme/theme.dart';

class PeriodTabs extends StatelessWidget {
  const PeriodTabs({super.key, required this.selected, required this.onChanged});

  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Row(
      children: <Widget>[
        for (final ChartPeriod period in ChartPeriod.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: dimens.space2),
              child: InkWell(
                borderRadius: BorderRadius.circular(dimens.radiusMd),
                onTap: () => onChanged(period),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: dimens.space2),
                  decoration: BoxDecoration(
                    color: period == selected ? colors.accentBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(dimens.radiusMd),
                  ),
                  child: Text(
                    period.label,
                    style: TextStyle(
                      color: period == selected ? colors.accentDefault : colors.textTertiary,
                      fontSize: 13,
                      fontWeight:
                          period == selected ? AppTypography.medium : AppTypography.regular,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
