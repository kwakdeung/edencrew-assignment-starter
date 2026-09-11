import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/stock_repository.dart';
import '../domain/stock_summary.dart';

enum SearchStatus { initial, loading, loaded }

/// 검색 화면 상태. 입력 디바운스와 자동완성 결과를 관리합니다.
class StockSearchController extends ChangeNotifier {
  StockSearchController(this._repository);

  final StockRepository _repository;

  static const Duration _debounce = Duration(milliseconds: 300);

  String _query = '';
  SearchStatus _status = SearchStatus.initial;
  List<StockSummary> _results = <StockSummary>[];
  Timer? _debounceTimer;
  int _requestId = 0;

  String get query => _query;
  SearchStatus get status => _status;
  List<StockSummary> get results => List<StockSummary>.unmodifiable(_results);

  void onQueryChanged(String query) {
    _query = query;
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _status = SearchStatus.initial;
      _results = <StockSummary>[];
      notifyListeners();
      return;
    }

    _status = SearchStatus.loading;
    notifyListeners();

    _debounceTimer = Timer(_debounce, () => _runSearch(query));
  }

  void clear() {
    _debounceTimer?.cancel();
    _query = '';
    _status = SearchStatus.initial;
    _results = <StockSummary>[];
    notifyListeners();
  }

  Future<void> _runSearch(String query) async {
    final int requestId = ++_requestId;
    try {
      final List<StockSummary> results = await _repository.search(query);
      // 응답이 늦게 도착한 이전 검색어 결과가 최신 검색어 결과를 덮어쓰지 않도록 합니다.
      if (requestId != _requestId) return;
      _results = results;
      _status = SearchStatus.loaded;
      notifyListeners();
    } catch (_) {
      if (requestId != _requestId) return;
      _results = <StockSummary>[];
      _status = SearchStatus.loaded;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
