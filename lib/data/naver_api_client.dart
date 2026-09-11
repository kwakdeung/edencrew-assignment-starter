import 'dart:convert';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:http/http.dart' as http;

/// Naver 4개 endpoint에 대한 얇은 HTTP 래퍼입니다.
///
/// 실시간 시세 endpoint는 JSON이지만 응답 헤더가 `EUC-KR`(실제로는 CP949)이라
/// 그대로 UTF-8로 디코딩하면 한글이 깨집니다. 일별 시세 HTML도 동일합니다.
/// 두 응답 모두 여기서 바이트를 CP949로 디코딩한 뒤 호출부에 문자열로 넘깁니다.
///
/// `finance.naver.com`은 User-Agent가 없는 요청을 404로 응답하므로
/// 브라우저 User-Agent를 붙여서 호출합니다.
class NaverApiClient {
  NaverApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const Map<String, String> _browserHeaders = <String, String>{
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0 Safari/537.36',
    'Referer': 'https://finance.naver.com/',
  };

  /// 검색 자동완성. UTF-8 JSON을 반환합니다.
  Future<Map<String, dynamic>> fetchAutocomplete(String query) async {
    final Uri uri = Uri.https('ac.stock.naver.com', '/ac', <String, String>{
      'q': query,
      'target': 'stock,ipo,index,marketindicator',
    });
    final http.Response response = await _client.get(uri);
    _checkOk(response);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  /// 실시간 시세. 관심종목 전체를 한 번에 조회할 수 있도록 콤마로 이어 붙입니다.
  Future<Map<String, dynamic>> fetchRealtime(List<String> symbols) async {
    final Uri uri = Uri.https(
      'polling.finance.naver.com',
      '/api/realtime',
      <String, String>{'query': 'SERVICE_ITEM:${symbols.join(',')}'},
    );
    final http.Response response = await _client.get(uri);
    _checkOk(response);
    return jsonDecode(cp949.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  /// 종목 메타데이터. UTF-8 JSON을 반환합니다.
  Future<Map<String, dynamic>> fetchMeta(String symbol) async {
    final Uri uri = Uri.https(
      'stock.naver.com',
      '/api/securityFe/api/fchart/domestic/stock/$symbol',
    );
    final http.Response response = await _client.get(uri);
    _checkOk(response);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  /// 일별 시세 HTML 한 페이지. 한 페이지에 10거래일이 담겨 있습니다.
  Future<String> fetchDailyPriceHtml(String symbol, int page) async {
    final Uri uri = Uri.https(
      'finance.naver.com',
      '/item/sise_day.naver',
      <String, String>{'code': symbol, 'page': '$page'},
    );
    final http.Response response = await _client.get(uri, headers: _browserHeaders);
    _checkOk(response);
    return cp949.decode(response.bodyBytes);
  }

  void _checkOk(http.Response response) {
    if (response.statusCode != 200) {
      throw NaverApiException(
        'Naver 요청 실패: ${response.request?.url} (${response.statusCode})',
      );
    }
  }

  void close() => _client.close();
}

class NaverApiException implements Exception {
  NaverApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
