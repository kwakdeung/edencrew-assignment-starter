import 'package:flutter/foundation.dart';

import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/domain/chart_period.dart';
import 'package:edencrew_assignment_starter/domain/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/domain/stock_summary.dart';

enum DetailLoadStatus { loading, loaded, error }

/// 종목상세 화면 상태. 기간 탭을 바꿀 때마다 이미 받은 페이지는 재사용하고,
/// 부족한 페이지만 [StockRepository]에 요청합니다.
class StockDetailController extends ChangeNotifier {
  StockDetailController(this._repository, this.symbol, {StockSummary? initialMeta})
      : _meta = initialMeta;

  final StockRepository _repository;
  final String symbol;

  StockSummary? _meta;
  Quote? _quote;
  ChartPeriod _period = ChartPeriod.oneMonth;
  List<DailyPrice> _dailyPrices = <DailyPrice>[];
  DetailLoadStatus _status = DetailLoadStatus.loading;

  StockSummary? get meta => _meta;
  Quote? get quote => _quote;
  ChartPeriod get period => _period;
  List<DailyPrice> get dailyPrices => List<DailyPrice>.unmodifiable(_dailyPrices);
  DetailLoadStatus get status => _status;

  Future<void> load() async {
    _status = DetailLoadStatus.loading;
    notifyListeners();
    try {
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        _meta == null ? _repository.fetchMeta(symbol) : Future<StockSummary>.value(_meta),
        _repository.fetchQuotes(<String>[symbol]),
        _repository.fetchDailyPrices(symbol, _period),
      ]);
      _meta = results[0] as StockSummary;
      final Map<String, Quote> quotes = results[1] as Map<String, Quote>;
      _quote = quotes[symbol];
      _dailyPrices = results[2] as List<DailyPrice>;
      _status = DetailLoadStatus.loaded;
    } catch (_) {
      _status = DetailLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> changePeriod(ChartPeriod period) async {
    if (_period == period) return;
    _period = period;
    notifyListeners();
    try {
      _dailyPrices = await _repository.fetchDailyPrices(symbol, period);
    } catch (_) {
      // 기간 전환 실패 시 이전 데이터를 유지합니다.
    }
    notifyListeners();
  }
}
