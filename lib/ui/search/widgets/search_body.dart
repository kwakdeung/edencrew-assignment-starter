import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/domain/stock_summary.dart';
import 'package:edencrew_assignment_starter/state/search_controller.dart' as search;
import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/ui/common/empty_state.dart';
import 'package:edencrew_assignment_starter/ui/detail/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/ui/search/widgets/search_result_row.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key, required this.onToggleFavorite});

  final ValueChanged<StockSummary> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final search.StockSearchController searchController =
        context.watch<search.StockSearchController>();
    final WatchlistController watchlist = context.watch<WatchlistController>();

    switch (searchController.status) {
      case search.SearchStatus.initial:
        return const EmptyState(
          iconAsset: 'assets/images/ic_search_request.svg',
          title: '종목을 검색해 보세요',
          description: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
        );
      case search.SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case search.SearchStatus.loaded:
        if (searchController.results.isEmpty) {
          return EmptyState(
            iconAsset: 'assets/images/ic_search_empty.svg',
            title: '검색 결과가 없습니다',
            description: "'${searchController.query}'와 일치하는 검색 결과를 찾지 못했습니다.",
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: searchController.results.length,
          itemBuilder: (BuildContext context, int index) {
            final StockSummary summary = searchController.results[index];
            return SearchResultRow(
              summary: summary,
              query: searchController.query,
              isFavorite: watchlist.isFavorite(summary.symbol),
              onFavoriteTap: () => onToggleFavorite(summary),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => StockDetailScreen(symbol: summary.symbol, initialMeta: summary),
                ),
              ),
            );
          },
        );
    }
  }
}
