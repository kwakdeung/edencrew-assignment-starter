import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/stock_summary.dart';
import '../../state/search_controller.dart' as search;
import '../../state/watchlist_controller.dart';
import '../../theme/theme.dart';
import '../common/app_toast.dart';
import '../common/empty_state.dart';
import '../detail/stock_detail_screen.dart';
import 'widgets/search_result_row.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  late final search.StockSearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = search.StockSearchController(context.read());
  }

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite(StockSummary summary) async {
    final WatchlistController watchlist = context.read<WatchlistController>();
    final bool wasFavorite = watchlist.isFavorite(summary.symbol);
    await watchlist.toggleFavorite(summary);
    if (!mounted) return;
    AppToast.show(
      context,
      isFavorite: !wasFavorite,
      message: wasFavorite ? '관심이 해제되었습니다' : '관심이 등록되었습니다',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return ChangeNotifierProvider<search.StockSearchController>.value(
      value: _searchController,
      child: Scaffold(
        backgroundColor: colors.surfaceBase,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  dimens.space4,
                  dimens.space3,
                  dimens.space4,
                  dimens.space2,
                ),
                child: _SearchField(
                  controller: _textController,
                  onChanged: _searchController.onQueryChanged,
                  onClear: () {
                    _textController.clear();
                    _searchController.clear();
                  },
                ),
              ),
              Expanded(child: _SearchBody(onToggleFavorite: _toggleFavorite)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
        border: Border.all(color: colors.borderSubtle, width: dimens.borderHairline),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 15,
          fontWeight: AppTypography.regular,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: '종목명 또는 종목코드를 검색하세요',
          hintStyle: TextStyle(color: colors.textDisabled, fontSize: 15),
          contentPadding: EdgeInsets.symmetric(vertical: dimens.space3),
          prefixIcon: Icon(Icons.search_rounded, color: colors.textTertiary, size: dimens.iconMd),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.cancel_rounded,
                  color: colors.textTertiary,
                  size: dimens.iconSm,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.onToggleFavorite});

  final ValueChanged<StockSummary> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final search.StockSearchController searchController =
        context.watch<search.StockSearchController>();
    final WatchlistController watchlist = context.watch<WatchlistController>();

    switch (searchController.status) {
      case search.SearchStatus.initial:
        return const EmptyState(
          icon: Icons.search_rounded,
          title: '종목을 검색해 보세요',
          description: '종목명 또는 종목코드로\n국내 주식을 찾을 수 있습니다.',
        );
      case search.SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case search.SearchStatus.loaded:
        if (searchController.results.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
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
