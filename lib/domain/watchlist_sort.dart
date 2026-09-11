/// 관심 화면 정렬 기준.
enum WatchlistSort {
  priceDesc('현재가순'),
  changeRateDesc('등락률순'),
  nameAsc('가나다순');

  const WatchlistSort(this.label);

  final String label;
}
