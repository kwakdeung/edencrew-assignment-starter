import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/watchlist_controller.dart';
import '../../theme/theme.dart';
import '../common/empty_state.dart';
import '../detail/stock_detail_screen.dart';
import 'widgets/sort_bottom_sheet.dart';
import 'widgets/watchlist_row.dart';
import 'widgets/watchlist_skeleton_row.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchlistController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final WatchlistController controller = context.watch<WatchlistController>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            _Header(controller: controller),
            if (controller.errorMessage != null)
              _ErrorBanner(message: controller.errorMessage!),
            Expanded(
              child: controller.isEmpty
                  ? const EmptyState(
                      icon: Icons.star_border_rounded,
                      title: '관심 종목이 없습니다',
                      description: '검색 화면에서 관심 종목을 등록하면\n여기에서 모아 볼 수 있습니다.',
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refreshQuotes,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.sortedSymbols.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String symbol = controller.sortedSymbols[index];
                          final bool hasQuote = controller.quoteOf(symbol) != null;
                          final Widget row = hasQuote
                              ? WatchlistRow(
                                  meta: controller.metaOf(symbol),
                                  quote: controller.quoteOf(symbol),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => StockDetailScreen(
                                        symbol: symbol,
                                        initialMeta: controller.metaOf(symbol),
                                      ),
                                    ),
                                  ),
                                )
                              : const WatchlistSkeletonRow();

                          return Dismissible(
                            key: ValueKey<String>(symbol),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => controller.removeFavorite(symbol),
                            background: _DeleteBackground(),
                            child: row,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      color: colors.priceDownBg,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: dimens.space4),
      child: Icon(Icons.delete_outline_rounded, color: colors.priceDownText),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final WatchlistController controller;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space4, dimens.space3, dimens.space4, dimens.space2),
      child: Row(
        children: <Widget>[
          Text(
            '관심',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: AppTypography.bold,
            ),
          ),
          const Spacer(),
          if (!controller.isEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(dimens.radiusMd),
              onTap: () => showSortBottomSheet(
                context: context,
                current: controller.sort,
                onSelected: controller.changeSort,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimens.space3,
                  vertical: dimens.space2,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(dimens.radiusMd),
                  border: Border.all(color: colors.borderSubtle, width: dimens.borderHairline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      controller.sort.label,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: dimens.iconSm,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(width: dimens.space2),
          IconButton(
            onPressed: controller.isRefreshing ? null : controller.refreshQuotes,
            icon: controller.isRefreshing
                ? SizedBox(
                    width: dimens.iconMd,
                    height: dimens.iconMd,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textSecondary,
                    ),
                  )
                : Icon(Icons.refresh_rounded, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space1),
      padding: EdgeInsets.symmetric(horizontal: dimens.space3, vertical: dimens.space2),
      decoration: BoxDecoration(
        color: colors.priceDownBg,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colors.feedbackWarning,
          fontSize: 12,
          fontWeight: AppTypography.regular,
        ),
      ),
    );
  }
}
