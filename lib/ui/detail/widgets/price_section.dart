import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/core/formatters.dart';
import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/common/price_style.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final PriceStyle style = PriceStyle.of(context, quote.direction);

    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space4, dimens.space2, dimens.space4, dimens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Formatters.comma(quote.current),
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 32,
              fontWeight: AppTypography.bold,
            ),
          ),
          SizedBox(height: dimens.space1),
          Row(
            children: <Widget>[
              if (style.arrow.isNotEmpty)
                Text(style.arrow, style: TextStyle(color: style.textColor, fontSize: 14)),
              if (style.arrow.isNotEmpty) SizedBox(width: dimens.space1),
              Text(
                // 방향은 화살표로 이미 표시하고 있어 등락액은 절댓값만 보여줍니다.
                '${Formatters.comma(quote.change.abs())} (${Formatters.signedPercent(quote.changeRate)})',
                style: TextStyle(
                  color: style.textColor,
                  fontSize: 14,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
