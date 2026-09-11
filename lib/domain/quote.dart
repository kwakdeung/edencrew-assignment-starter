/// 실시간 시세 한 건. `polling.finance.naver.com/api/realtime` 응답을 정규화한 모델입니다.
class Quote {
  const Quote({
    required this.symbol,
    required this.current,
    required this.previousClose,
    required this.open,
    required this.high,
    required this.low,
    required this.accumulatedVolume,
    required this.listedShares,
  });

  final String symbol;
  final int current;
  final int previousClose;
  final int open;
  final int high;
  final int low;
  final int accumulatedVolume;

  /// 상장 주식 수. 시가총액(`current × listedShares`) 계산에 사용합니다.
  final int listedShares;

  /// 전일 대비 등락액. `nv - pcv`
  int get change => current - previousClose;

  /// 전일 대비 등락률. `(nv - pcv) / pcv`
  double get changeRate =>
      previousClose == 0 ? 0 : change / previousClose * 100;

  int get marketCap => current * listedShares;

  PriceDirection get direction {
    if (change > 0) return PriceDirection.up;
    if (change < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }
}

enum PriceDirection { up, down, flat }
