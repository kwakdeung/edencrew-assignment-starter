import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/core/formatters.dart';
import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/stat_box.dart';

/// 시가 · 고가 · 저가 · 거래량 · 시가총액 요약 카드.
///
/// Figma 시안에서는 5개 항목이 하나의 큰 카드가 아니라 항목별로 각각 박스가
/// 있고, (시가·고가·저가) / (거래량·시가총액) 두 줄로 묶여 있습니다.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double thirdWidth = (constraints.maxWidth - dimens.space3 * 2) / 3;
        final double halfWidth = (constraints.maxWidth - dimens.space3) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                StatBox(label: '시가', value: Formatters.comma(quote.open), width: thirdWidth),
                SizedBox(width: dimens.space3),
                StatBox(label: '고가', value: Formatters.comma(quote.high), width: thirdWidth),
                SizedBox(width: dimens.space3),
                StatBox(label: '저가', value: Formatters.comma(quote.low), width: thirdWidth),
              ],
            ),
            SizedBox(height: dimens.space3),
            Row(
              children: <Widget>[
                StatBox(
                  label: '거래량',
                  value: Formatters.compactVolume(quote.accumulatedVolume),
                  width: halfWidth,
                ),
                SizedBox(width: dimens.space3),
                StatBox(
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
