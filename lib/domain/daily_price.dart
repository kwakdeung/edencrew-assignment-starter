import 'quote.dart';

/// 일별 시세 한 건. `finance.naver.com/item/sise_day.naver` HTML 한 행을 정규화한 모델입니다.
class DailyPrice {
  const DailyPrice({
    required this.date,
    required this.closePrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
  });

  /// `yyyyMMdd` 기준으로 정규화된 날짜입니다.
  final DateTime date;
  final int closePrice;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int volume;

  /// 캔들 몸통 색상 판단 기준. 종가가 시가보다 높으면 상승(빨강)입니다.
  PriceDirection get candleDirection {
    if (closePrice > openPrice) return PriceDirection.up;
    if (closePrice < openPrice) return PriceDirection.down;
    return PriceDirection.flat;
  }
}
