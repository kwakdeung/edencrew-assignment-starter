import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../domain/quote.dart';
import '../../../theme/theme.dart';

/// 시가 · 고가 · 저가 · 거래량 · 시가총액 요약 카드.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final List<(String, String)> items = <(String, String)>[
      ('시가', Formatters.comma(quote.open)),
      ('고가', Formatters.comma(quote.high)),
      ('저가', Formatters.comma(quote.low)),
      ('거래량', Formatters.compactVolume(quote.accumulatedVolume)),
      ('시가총액', Formatters.compactWon(quote.marketCap)),
    ];

    return Container(
      padding: EdgeInsets.all(dimens.space4),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusLg),
        border: Border.all(color: colors.borderSubtle, width: dimens.borderHairline),
      ),
      child: Wrap(
        spacing: dimens.space4,
        runSpacing: dimens.space3,
        children: <Widget>[
          for (final (String label, String value) in items)
            SizedBox(
              width: (MediaQuery.of(context).size.width - dimens.space4 * 4) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 12,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                  SizedBox(height: dimens.space1),
                  Text(
                    value,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
