import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/common/empty_state.dart';
import 'package:edencrew_assignment_starter/ui/detail/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/widgets/delete_background.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/widgets/error_banner.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/widgets/watchlist_header.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/widgets/watchlist_row.dart';

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
            WatchlistHeader(controller: controller),
            if (controller.errorMessage != null)
              ErrorBanner(message: controller.errorMessage!),
            Expanded(
              child: controller.isEmpty
                  ? const EmptyState(
                      iconAsset: 'assets/images/ic_star_outlined.svg',
                      title: '관심 종목이 없습니다',
                      description: '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refreshQuotes,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.sortedSymbols.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String symbol = controller.sortedSymbols[index];

                          return Dismissible(
                            key: ValueKey<String>(symbol),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) =>
                                controller.removeFavorite(symbol),
                            background: const DeleteBackground(),
                            child: WatchlistRow(
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
                            ),
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
