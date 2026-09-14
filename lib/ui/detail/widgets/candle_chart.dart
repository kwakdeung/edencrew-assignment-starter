import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/domain/daily_price.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/candle_chart_painter.dart';

/// 캔들 차트를 `CustomPainter`로 직접 그립니다.
///
/// 패키지 없이 직접 구현한 이유는 메모에 남겨 두었습니다(README 참고) — 토큰 색과
/// Figma 여백을 그대로 맞추기 쉬운 캔들 차트 패키지가 마땅치 않았습니다.
/// 캔들 안쪽 렌더링 디테일(두께 · 간격 · Y축 범위)은 과제 문서에서 자유도를
/// 허용한 부분이라 화면에 맞춰 임의로 잡았습니다.
class CandleChart extends StatelessWidget {
  const CandleChart({super.key, required this.prices, this.height = 220});

  final List<DailyPrice> prices;
  final double height;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    if (prices.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            '표시할 데이터가 없습니다',
            style: TextStyle(color: colors.textTertiary, fontSize: 13),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: CandleChartPainter(prices: prices, colors: colors)),
    );
  }
}
