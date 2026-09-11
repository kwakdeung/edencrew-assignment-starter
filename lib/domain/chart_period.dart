/// 종목상세 화면의 기간 탭. `tradingDays`는 필요한 대략적인 거래일 수이고,
/// `finance.naver.com/item/sise_day.naver`는 한 페이지에 10거래일을 담고 있어
/// `pagesNeeded`만큼만 페이지를 요청하면 됩니다.
enum ChartPeriod {
  oneMonth('1개월', 20),
  threeMonths('3개월', 60),
  sixMonths('6개월', 120),
  oneYear('1년', 245);

  const ChartPeriod(this.label, this.tradingDays);

  final String label;
  final int tradingDays;

  static const int daysPerPage = 10;

  int get pagesNeeded => (tradingDays / daysPerPage).ceil();
}
