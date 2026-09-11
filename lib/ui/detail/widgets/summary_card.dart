import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../domain/quote.dart';
import '../../../theme/theme.dart';

/// 시가 · 고가 · 저가 · 거래량 · 시가총액 요약 카드.
///
/// Figma 시안에서는 5개 항목이 하나의 큰 카드가 아니라 항목별로 각각 박스가
/// 있고, (시가·고가) / (저가) / (거래량·시가총액) 세 줄로 묶여 있습니다.
/// 그대로 3개의 Row로 구성했습니다.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double halfWidth = (constraints.maxWidth - dimens.space3) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _StatBox(label: '시가', value: Formatters.comma(quote.open), width: halfWidth),
                SizedBox(width: dimens.space3),
                _StatBox(label: '고가', value: Formatters.comma(quote.high), width: halfWidth),
              ],
            ),
            SizedBox(height: dimens.space3),
            _StatBox(label: '저가', value: Formatters.comma(quote.low), width: halfWidth),
            SizedBox(height: dimens.space3),
            Row(
              children: <Widget>[
                _StatBox(
                  label: '거래량',
                  value: Formatters.compactVolume(quote.accumulatedVolume),
                  width: halfWidth,
                ),
                SizedBox(width: dimens.space3),
                _StatBox(
                  label: '시가총액',
                  value: Formatters.compactWon(quote.marketCap),
                  width: halfWidth,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, required this.width});

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      width: width,
      padding: EdgeInsets.all(dimens.space3),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
      ),
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
    );
  }
}
