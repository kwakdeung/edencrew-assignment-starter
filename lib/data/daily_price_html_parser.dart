import '../domain/daily_price.dart';

/// `finance.naver.com/item/sise_day.naver`가 반환하는 HTML 한 페이지를 파싱합니다.
///
/// 표의 각 데이터 행은 `<tr onMouseOver="mouseOver(this)" ...>` 로 시작하고,
/// 날짜 셀은 `tah p10 gray03`, 나머지 6개 숫자 셀(종가 · 전일비 · 시가 · 고가 · 저가 · 거래량)은
/// `tah p11`로 시작하는 class를 가진 `<span>`에 들어 있습니다. 전일비는 등락 아이콘까지
/// 함께 감싸는 마크업이라 파싱하지 않고, 화면에서는 연속된 날짜의 종가를 비교해 계산합니다.
abstract final class DailyPriceHtmlParser {
  static final RegExp _rowPattern = RegExp(
    r'<tr onMouseOver="mouseOver\(this\)" onMouseOut="mouseOut\(this\)">(.*?)</tr>',
    dotAll: true,
  );
  static final RegExp _datePattern =
      RegExp(r'class="tah p10 gray03">([\d.]+)<');
  static final RegExp _numberPattern =
      RegExp(r'class="tah p11[^"]*">\s*([\d,]+)\s*<');
  static final RegExp _lastPagePattern =
      RegExp(r'class="pgRR">\s*<a href="[^"]*page=(\d+)"');

  static List<DailyPrice> parseRows(String html) {
    final List<DailyPrice> rows = <DailyPrice>[];
    for (final RegExpMatch rowMatch in _rowPattern.allMatches(html)) {
      final String row = rowMatch.group(1)!;
      final RegExpMatch? dateMatch = _datePattern.firstMatch(row);
      final List<String> numbers = _numberPattern
          .allMatches(row)
          .map((RegExpMatch m) => m.group(1)!.replaceAll(',', ''))
          .toList();
      if (dateMatch == null || numbers.length < 6) {
        continue;
      }
      final DateTime? date = _parseDate(dateMatch.group(1)!);
      if (date == null) continue;

      rows.add(
        DailyPrice(
          date: date,
          closePrice: int.parse(numbers[0]),
          // numbers[1] == 전일비, 사용하지 않습니다.
          openPrice: int.parse(numbers[2]),
          highPrice: int.parse(numbers[3]),
          lowPrice: int.parse(numbers[4]),
          volume: int.parse(numbers[5]),
        ),
      );
    }
    return rows;
  }

  /// 페이지네이션의 `맨뒤` 링크에서 마지막 페이지 번호를 읽습니다.
  static int? parseLastPage(String html) {
    final RegExpMatch? match = _lastPagePattern.firstMatch(html);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  static DateTime? _parseDate(String raw) {
    // "2026.09.11" -> yyyyMMdd 기준으로 정규화
    final List<String> parts = raw.split('.');
    if (parts.length != 3) return null;
    final int? year = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    final int? day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }
}
