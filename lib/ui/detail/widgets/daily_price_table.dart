import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/domain/daily_price.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/daily_price_header_cell.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/daily_row.dart';

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
              DailyPriceHeaderCell('날짜', align: TextAlign.left),
              DailyPriceHeaderCell('종가'),
              DailyPriceHeaderCell('등락'),
              DailyPriceHeaderCell('거래량'),
            ],
          ),
        ),
        Divider(height: dimens.borderHairline, color: colors.borderStrong),
        for (int i = 0; i < descending.length; i++)
          DailyRow(
            price: descending[i],
            previousClose: i + 1 < descending.length ? descending[i + 1].closePrice : null,
          ),
      ],
    );
  }
}
