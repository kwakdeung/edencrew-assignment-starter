/// 종목의 정적 정보(이름·시장)와 식별자를 담는 모델입니다.
///
/// 검색 자동완성, 종목 메타데이터 두 endpoint 모두 이 모델로 정규화됩니다.
class StockSummary {
  const StockSummary({
    required this.symbol,
    required this.name,
    required this.market,
  });

  /// 6자리 종목코드. (예: `005930`)
  final String symbol;

  /// 종목명. (예: `삼성전자`)
  final String name;

  /// 시장명. (예: `코스피`, `코스닥`)
  final String market;

  /// 화면 전반에서 쓰는 canonical id. (예: `domestic:005930`)
  String get canonicalId => 'domestic:$symbol';

  StockSummary copyWith({String? name, String? market}) {
    return StockSummary(
      symbol: symbol,
      name: name ?? this.name,
      market: market ?? this.market,
    );
  }
}
