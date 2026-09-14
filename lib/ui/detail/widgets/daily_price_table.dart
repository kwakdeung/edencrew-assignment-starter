import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../domain/daily_price.dart';
import '../../../domain/quote.dart';
import '../../../theme/theme.dart';
import '../../common/price_style.dart';

/// 일별 시세 표. 등락은 전날 종가 대비로 계산합니다(HTML의 전일비 셀은 아이콘과
/// 뒤섞인 마크업이라 파싱하지 않고 직접 계산했습니다 — README 참고).
class DailyPriceTable extends StatelessWidget {
  const DailyPriceTable({super.key, required this.prices});

  /// 날짜 오름차순(과거 -> 최근)으로 정렬되어 있어야 합니다.
  final List<DailyPrice> prices;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final List<DailyPrice> descending = prices.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: dimens.space2),
          child: Row(
            children: <Widget>[
              _HeaderCell('날짜', align: TextAlign.left),
              _HeaderCell('종가'),
              _HeaderCell('등락'),
              _HeaderCell('거래량'),
            ],
          ),
        ),
        Divider(height: dimens.borderHairline, color: colors.borderStrong),
        for (int i = 0; i < descending.length; i++)
          _DailyRow(
            price: descending[i],
            previousClose: i + 1 < descending.length ? descending[i + 1].closePrice : null,
          ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label, {this.align = TextAlign.right});

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

class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.price, required this.previousClose});

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
