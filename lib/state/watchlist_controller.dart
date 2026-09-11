import 'package:flutter/foundation.dart';

import '../data/stock_repository.dart';
import '../domain/quote.dart';
import '../domain/stock_summary.dart';
import '../domain/watchlist_sort.dart';

/// 관심종목 상태의 단일 출처입니다.
///
/// 관심 / 검색 / 상세 화면이 모두 이 컨트롤러를 구독해서, 한 화면에서 별 아이콘을
/// 누르면 나머지 화면에도 즉시 반영됩니다. (과제 요구사항의 "상태 동기화")
class WatchlistController extends ChangeNotifier {
  WatchlistController(this._repository) {
    _seedDefaults();
  }

  final StockRepository _repository;

  /// 관심 등록 순서를 유지하기 위한 리스트입니다. (Set만 쓰면 순서가 보장되지 않습니다)
  final List<String> _symbols = <String>[];
  final Map<String, StockSummary> _metas = <String, StockSummary>{};
  final Map<String, Quote> _quotes = <String, Quote>{};

  WatchlistSort _sort = WatchlistSort.priceDesc;
  bool _isRefreshing = false;
  String? _errorMessage;

  List<String> get symbols => List<String>.unmodifiable(_symbols);
  WatchlistSort get sort => _sort;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _symbols.isEmpty;

  bool isFavorite(String symbol) => _symbols.contains(symbol);
  StockSummary? metaOf(String symbol) => _metas[symbol];
  Quote? quoteOf(String symbol) => _quotes[symbol];

  /// 정렬을 적용한 symbol 목록. 시세를 아직 받지 못한 행은 정렬 기준과 무관하게
  /// 맨 아래로 보냅니다. (값이 없는데 0으로 취급해서 위/아래로 끼어드는 것을 방지)
  List<String> get sortedSymbols {
    final List<String> withQuote =
        _symbols.where((String s) => _quotes.containsKey(s)).toList();
    final List<String> withoutQuote =
        _symbols.where((String s) => !_quotes.containsKey(s)).toList();

    switch (_sort) {
      case WatchlistSort.priceDesc:
        withQuote.sort(
          (String a, String b) => _quotes[b]!.current.compareTo(_quotes[a]!.current),
        );
      case WatchlistSort.changeRateDesc:
        withQuote.sort(
          (String a, String b) =>
              _quotes[b]!.changeRate.compareTo(_quotes[a]!.changeRate),
        );
      case WatchlistSort.nameAsc:
        withQuote.sort((String a, String b) {
          final String nameA = _metas[a]?.name ?? a;
          final String nameB = _metas[b]?.name ?? b;
          return nameA.compareTo(nameB);
        });
    }
    return <String>[...withQuote, ...withoutQuote];
  }

  void changeSort(WatchlistSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    notifyListeners();
  }

  /// 검색 화면 등 이미 메타 정보를 알고 있는 곳에서 관심 등록할 때 사용합니다.
  /// 메타를 다시 요청하지 않아도 되어 효율적입니다.
  Future<void> addFavorite(StockSummary summary) async {
    if (_symbols.contains(summary.symbol)) return;
    _symbols.add(summary.symbol);
    _metas[summary.symbol] = summary;
    notifyListeners();
    await refreshQuotes();
  }

  void removeFavorite(String symbol) {
    if (!_symbols.remove(symbol)) return;
    _quotes.remove(symbol);
    notifyListeners();
  }

  Future<void> toggleFavorite(StockSummary summary) async {
    if (isFavorite(summary.symbol)) {
      removeFavorite(summary.symbol);
    } else {
      await addFavorite(summary);
    }
  }

  /// 상단 새로고침 버튼과 초기 진입 시 사용합니다. 관심종목 전체를 한 번의
  /// 요청으로 조회합니다.
  Future<void> refreshQuotes() async {
    if (_symbols.isEmpty) return;
    _isRefreshing = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final Map<String, Quote> fresh = await _repository.fetchQuotes(_symbols);
      _quotes.addAll(fresh);
      await _hydrateMissingMetas();
    } catch (_) {
      _errorMessage = '시세를 불러오지 못했습니다. 다시 시도해 주세요.';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> _hydrateMissingMetas() async {
    final List<String> missing =
        _symbols.where((String s) => !_metas.containsKey(s)).toList();
    for (final String symbol in missing) {
      try {
        _metas[symbol] = await _repository.fetchMeta(symbol);
      } catch (_) {
        // 메타 조회 실패는 개별 행에서 종목코드만 보여주는 것으로 대체합니다.
      }
    }
  }

  /// 처음 실행했을 때 빈 목록만 보이면 기능 확인이 어려워, 대표 종목 몇 개를
  /// 기본 관심종목으로 시드합니다. (로컬 저장은 선택 항목이라 앱을 껐다 켜면
  /// 다시 이 기본값으로 돌아갑니다 — README에 명시)
  void _seedDefaults() {
    const List<String> defaults = <String>['005930', '000660', '035420'];
    _symbols.addAll(defaults);
  }

  Future<void> init() => refreshQuotes();
}
