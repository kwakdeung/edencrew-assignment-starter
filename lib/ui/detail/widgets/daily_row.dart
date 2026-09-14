import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/core/formatters.dart';
import 'package:edencrew_assignment_starter/domain/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/common/price_style.dart';

class DailyRow extends StatelessWidget {
  const DailyRow({super.key, required this.price, required this.previousClose});

  final DailyPrice price;
  final int? previousClose;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final int? change = previousClose == null ? null : price.closePrice - previousClose!;

    final PriceDirection direction = change == null
        ? PriceDirection.flat
        : change > 0
            ? PriceDirection.up
            : change < 0
                ? PriceDirection.down
                : PriceDirection.flat;
    final PriceStyle style = PriceStyle.of(context, direction);

    return Container(
      padding: EdgeInsets.symmetric(vertical: dimens.space2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              Formatters.monthDay(price.date),
              textAlign: TextAlign.left,
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              Formatters.comma(price.closePrice),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              change == null ? '-' : Formatters.signedComma(change),
              textAlign: TextAlign.right,
              style: TextStyle(color: style.textColor, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              Formatters.comma(price.volume),
              textAlign: TextAlign.right,
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
