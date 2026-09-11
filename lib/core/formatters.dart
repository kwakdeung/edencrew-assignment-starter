import 'package:intl/intl.dart';

/// 화면 전반에서 쓰는 숫자 / 날짜 표기 헬퍼입니다.
abstract final class Formatters {
  static final NumberFormat _comma = NumberFormat.decimalPattern('ko_KR');
  static final DateFormat _monthDay = DateFormat('MM.dd');

  /// `1,234,000` 형태의 천 단위 콤마 표기.
  static String comma(num value) => _comma.format(value);

  /// 등락액. 부호를 붙입니다. (예: `-400`, `+1,200`, `0`)
  static String signedComma(num value) {
    if (value > 0) return '+${_comma.format(value)}';
    if (value < 0) return '-${_comma.format(value.abs())}';
    return '0';
  }

  /// 등락률. 부호와 `%`를 붙입니다. (예: `-0.22%`)
  static String signedPercent(double value) {
    final String formatted = value.abs().toStringAsFixed(2);
    if (value > 0) return '+$formatted%';
    if (value < 0) return '-$formatted%';
    return '0.00%';
  }

  /// `MM.DD` 형태의 날짜 표기.
  static String monthDay(DateTime date) => _monthDay.format(date);

  /// 거래량 축약 표기. 1,000 단위로 나눠 `천` 단위를 붙입니다. (예: `29,113천`)
  static String compactVolume(num value) {
    final int thousands = (value / 1000).round();
    return '${_comma.format(thousands)}천';
  }

  /// 시가총액 축약 표기. 조 / 억 단위로 나눠 붙입니다. (예: `1,063조`, `532억`)
  static String compactWon(num value) {
    const int jo = 1000000000000; // 1조
    const int eok = 100000000; // 1억
    if (value.abs() >= jo) {
      return '${_comma.format((value / jo).round())}조';
    }
    if (value.abs() >= eok) {
      return '${_comma.format((value / eok).round())}억';
    }
    return _comma.format(value.round());
  }
}
