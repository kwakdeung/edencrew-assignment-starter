import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/domain/stock_summary.dart';
import 'package:edencrew_assignment_starter/state/search_controller.dart' as search;
import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/common/app_toast.dart';
import 'package:edencrew_assignment_starter/ui/search/widgets/search_body.dart';
import 'package:edencrew_assignment_starter/ui/search/widgets/search_field.dart';

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
                child: SearchField(
                  controller: _textController,
                  onChanged: _searchController.onQueryChanged,
                  onClear: () {
                    _textController.clear();
                    _searchController.clear();
                  },
                ),
              ),
              Expanded(child: SearchBody(onToggleFavorite: _toggleFavorite)),
            ],
          ),
        ),
      ),
    );
  }
}
