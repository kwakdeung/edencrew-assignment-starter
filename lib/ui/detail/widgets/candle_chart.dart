import 'package:flutter/material.dart';

import '../../../domain/daily_price.dart';
import '../../../domain/quote.dart';
import '../../../theme/theme.dart';

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
      child: CustomPaint(painter: _CandleChartPainter(prices: prices, colors: colors)),
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  _CandleChartPainter({required this.prices, required this.colors});

  final List<DailyPrice> prices;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final double priceAreaHeight = size.height;
    final double chartWidth = size.width;

    final double maxHigh = prices.map((DailyPrice p) => p.highPrice).reduce(
      (int a, int b) => a > b ? a : b,
    ).toDouble();
    final double minLow = prices.map((DailyPrice p) => p.lowPrice).reduce(
      (int a, int b) => a < b ? a : b,
    ).toDouble();

    final double pricePadding = (maxHigh - minLow) * 0.08 + 1;
    final double topPrice = maxHigh + pricePadding;
    final double bottomPrice = minLow - pricePadding;
    final double priceRange = (topPrice - bottomPrice).clamp(1, double.infinity);

    double yForPrice(double price) {
      return priceAreaHeight * (1 - (price - bottomPrice) / priceRange);
    }

    final double slotWidth = chartWidth / prices.length;
    final double candleWidth = (slotWidth * 0.6).clamp(1.5, 16);

    for (int i = 0; i < prices.length; i++) {
      final DailyPrice price = prices[i];
      final double centerX = slotWidth * i + slotWidth / 2;

      final Color color = switch (price.candleDirection) {
        PriceDirection.up => colors.chartLineUp,
        PriceDirection.down => colors.chartLineDown,
        PriceDirection.flat => colors.chartLineFlat,
      };

      final Paint wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(centerX, yForPrice(price.highPrice.toDouble())),
        Offset(centerX, yForPrice(price.lowPrice.toDouble())),
        wickPaint,
      );

      final double openY = yForPrice(price.openPrice.toDouble());
      final double closeY = yForPrice(price.closePrice.toDouble());
      final double top = openY < closeY ? openY : closeY;
      final double bottom = openY < closeY ? closeY : openY;
      final Rect bodyRect = Rect.fromLTRB(
        centerX - candleWidth / 2,
        top,
        centerX + candleWidth / 2,
        (bottom - top).abs() < 1.5 ? top + 1.5 : bottom,
      );
      canvas.drawRect(bodyRect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) {
    return oldDelegate.prices != prices;
  }
}
