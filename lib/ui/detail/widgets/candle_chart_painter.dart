import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/domain/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class CandleChartPainter extends CustomPainter {
  CandleChartPainter({required this.prices, required this.colors});

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
  bool shouldRepaint(covariant CandleChartPainter oldDelegate) {
    return oldDelegate.prices != prices;
  }
}
