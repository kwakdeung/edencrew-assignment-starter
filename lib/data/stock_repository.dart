import '../domain/chart_period.dart';
import '../domain/daily_price.dart';
import '../domain/quote.dart';
import '../domain/stock_summary.dart';
import 'daily_price_html_parser.dart';
import 'naver_api_client.dart';

/// Naver 4개 endpoint를 묶어 도메인 모델로 정규화하는 저장소입니다.
///
/// - 종목 메타데이터와 일별 시세 페이지는 symbol(·page) 단위로 캐시해서
///   이미 받은 데이터는 재사용하고, 필요한 만큼만 새로 요청합니다.
/// - 실시간 시세는 항상 최신값이 필요하므로 캐시하지 않고, 화면에서 여러 종목을
///   모아 한 번에 요청하도록 [fetchQuotes]에 리스트를 넘깁니다.
class StockRepository {
  StockRepository({NaverApiClient? client})
    : _client = client ?? NaverApiClient();

  final NaverApiClient _client;

  final Map<String, StockSummary> _metaCache = <String, StockSummary>{};

  /// symbol -> { page -> rows }
  final Map<String, Map<int, List<DailyPrice>>> _dailyPriceCache =
      <String, Map<int, List<DailyPrice>>>{};

  /// symbol -> lastPage
  final Map<String, int> _lastPageCache = <String, int>{};

  /// 검색 자동완성. 국내 주식(6자리 종목코드)만 남깁니다.
  Future<List<StockSummary>> search(String query) async {
    if (query.trim().isEmpty) return const <StockSummary>[];
    final Map<String, dynamic> json = await _client.fetchAutocomplete(query);
    final List<dynamic> items =
        (json['items'] as List<dynamic>?) ?? <dynamic>[];
    final RegExp sixDigits = RegExp(r'^\d{6}$');

    final List<StockSummary> results = <StockSummary>[];
    for (final dynamic item in items) {
      final Map<String, dynamic> map = item as Map<String, dynamic>;
      if (map['category'] != 'stock' || map['nationCode'] != 'KOR') continue;
      final String code = (map['code'] as String?) ?? '';
      if (!sixDigits.hasMatch(code)) continue;
      final StockSummary summary = StockSummary(
        symbol: code,
        name: (map['name'] as String?) ?? code,
        market: (map['typeName'] as String?) ?? '',
      );
      results.add(summary);
      // 검색 결과로 받은 이름 · 시장 정보를 메타 캐시에도 채워 두면
      // 관심 화면에서 같은 종목을 또 조회할 필요가 없습니다.
      _metaCache[code] = summary;
    }
    return results;
  }

  /// 종목 메타데이터(이름 · 거래소명). 캐시에 있으면 재요청하지 않습니다.
  Future<StockSummary> fetchMeta(String symbol) async {
    final StockSummary? cached = _metaCache[symbol];
    if (cached != null) return cached;

    final Map<String, dynamic> json = await _client.fetchMeta(symbol);
    final StockSummary summary = StockSummary(
      symbol: (json['symbolCode'] as String?) ?? symbol,
      name: (json['stockName'] as String?) ?? symbol,
      market: (json['stockExchangeNameKor'] as String?) ?? '',
    );
    _metaCache[symbol] = summary;
    return summary;
  }

  /// 실시간 시세를 한 번의 요청으로 조회합니다.
  Future<Map<String, Quote>> fetchQuotes(List<String> symbols) async {
    if (symbols.isEmpty) return <String, Quote>{};
    final Map<String, dynamic> json = await _client.fetchRealtime(symbols);
    final Map<String, dynamic> result =
        (json['result'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final List<dynamic> areas =
        (result['areas'] as List<dynamic>?) ?? <dynamic>[];
    if (areas.isEmpty) return <String, Quote>{};
    final List<dynamic> datas =
        (areas.first as Map<String, dynamic>)['datas'] as List<dynamic>? ??
        <dynamic>[];

    final Map<String, Quote> quotes = <String, Quote>{};
    for (final dynamic item in datas) {
      final Map<String, dynamic> map = item as Map<String, dynamic>;
      final String symbol = map['cd'] as String;
      quotes[symbol] = Quote(
        symbol: symbol,
        current: (map['nv'] as num).toInt(),
        previousClose: (map['pcv'] as num).toInt(),
        open: (map['ov'] as num).toInt(),
        high: (map['hv'] as num).toInt(),
        low: (map['lv'] as num).toInt(),
        accumulatedVolume: (map['aq'] as num).toInt(),
        listedShares: (map['countOfListedStock'] as num?)?.toInt() ?? 0,
      );
    }
    return quotes;
  }

  /// [period]가 필요로 하는 거래일 수만큼 일별 시세를 최신순으로 반환합니다.
  ///
  /// 이미 받은 페이지는 캐시에서 재사용하고, `lastPage`를 넘는 페이지는 요청하지
  /// 않습니다. 반환값은 날짜 오름차순(과거 -> 최근)입니다.
  Future<List<DailyPrice>> fetchDailyPrices(
    String symbol,
    ChartPeriod period,
  ) async {
    final int? lastPage = _lastPageCache[symbol];
    final int pagesToFetch = lastPage == null
        ? period.pagesNeeded
        : period.pagesNeeded.clamp(0, lastPage);

    final Map<int, List<DailyPrice>> cache = _dailyPriceCache.putIfAbsent(
      symbol,
      () => <int, List<DailyPrice>>{},
    );

    for (int page = 1; page <= pagesToFetch; page++) {
      if (cache.containsKey(page)) continue;
      final String html = await _client.fetchDailyPriceHtml(symbol, page);
      cache[page] = DailyPriceHtmlParser.parseRows(html);
      final int? parsedLastPage = DailyPriceHtmlParser.parseLastPage(html);
      if (parsedLastPage != null) {
        _lastPageCache[symbol] = parsedLastPage;
      }
    }

    final List<DailyPrice> merged = <DailyPrice>[];
    final List<int> pages = cache.keys.toList()..sort();
    for (final int page in pages) {
      if (page > pagesToFetch) continue;
      merged.addAll(cache[page]!);
    }
    merged.sort((DailyPrice a, DailyPrice b) => a.date.compareTo(b.date));

    final int take = period.tradingDays;
    if (merged.length <= take) return merged;
    return merged.sublist(merged.length - take);
  }

  void dispose() => _client.close();
}
