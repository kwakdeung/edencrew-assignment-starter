import 'package:flutter/material.dart';

import '../../domain/quote.dart';
import '../../theme/theme.dart';

/// 등락 방향에 따른 텍스트 / 배경 색상, 화살표를 한 곳에서 계산합니다.
/// 상승은 빨강(`priceUpText`), 하락은 파랑(`priceDownText`) — 국내 시장 관행입니다.
class PriceStyle {
  const PriceStyle({required this.textColor, required this.bgColor, required this.arrow});

  final Color textColor;
  final Color bgColor;

  /// 상승 ▲ / 하락 ▼ / 보합에는 표시하지 않는 빈 문자열.
  final String arrow;

  static PriceStyle of(BuildContext context, PriceDirection direction) {
    final AppColors colors = context.colors;
    switch (direction) {
      case PriceDirection.up:
        return PriceStyle(textColor: colors.priceUpText, bgColor: colors.priceUpBg, arrow: '▲');
      case PriceDirection.down:
        return PriceStyle(
          textColor: colors.priceDownText,
          bgColor: colors.priceDownBg,
          arrow: '▼',
        );
      case PriceDirection.flat:
        return PriceStyle(textColor: colors.priceFlatText, bgColor: colors.priceFlatBg, arrow: '');
    }
  }
}
