import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../domain/quote.dart';
import '../../domain/stock_summary.dart';
import '../../state/stock_detail_controller.dart';
import '../../state/watchlist_controller.dart';
import '../../theme/theme.dart';
import '../common/price_style.dart';
import 'widgets/candle_chart.dart';
import 'widgets/daily_price_table.dart';
import 'widgets/period_tabs.dart';
import 'widgets/summary_card.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.symbol, this.initialMeta});

  final String symbol;
  final StockSummary? initialMeta;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late final StockDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StockDetailController(
      context.read(),
      widget.symbol,
      initialMeta: widget.initialMeta,
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return ChangeNotifierProvider<StockDetailController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: colors.surfaceBase,
        body: SafeArea(child: Consumer<StockDetailController>(builder: _buildBody)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, StockDetailController controller, _) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    if (controller.status == DetailLoadStatus.error) {
      return Column(
        children: <Widget>[
          _Header(symbol: widget.symbol, meta: controller.meta),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '데이터를 불러오지 못했습니다',
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  ),
                  SizedBox(height: dimens.space3),
                  TextButton(onPressed: controller.load, child: const Text('다시 시도')),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (controller.status == DetailLoadStatus.loading && controller.quote == null) {
      return Column(
        children: <Widget>[
          _Header(symbol: widget.symbol, meta: controller.meta),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    }

    final Quote? quote = controller.quote;

    return ListView(
      padding: EdgeInsets.only(bottom: dimens.space6),
      children: <Widget>[
        _Header(symbol: widget.symbol, meta: controller.meta),
        if (quote != null) _PriceSection(quote: quote),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space4),
          child: PeriodTabs(selected: controller.period, onChanged: controller.changePeriod),
        ),
        SizedBox(height: dimens.space3),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space4),
          child: CandleChart(prices: controller.dailyPrices),
        ),
        SizedBox(height: dimens.space4),
        if (quote != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimens.space4),
            child: SummaryCard(quote: quote),
          ),
        SizedBox(height: dimens.space5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space4),
          child: Text(
            '일별 시세',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space4),
          child: DailyPriceTable(prices: controller.dailyPrices),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.symbol, required this.meta});

  final String symbol;
  final StockSummary? meta;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final WatchlistController watchlist = context.watch<WatchlistController>();
    final bool isFavorite = watchlist.isFavorite(symbol);

    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space2, dimens.space2, dimens.space3, dimens.space2),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  meta?.name ?? symbol,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (meta != null)
                  Text(
                    '${meta!.symbol} · ${meta!.market}',
                    style: TextStyle(color: colors.textTertiary, fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              if (meta == null) return;
              await watchlist.toggleFavorite(meta!);
            },
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? colors.favoriteActive : colors.favoriteInactive,
              size: dimens.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final PriceStyle style = PriceStyle.of(context, quote.direction);

    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space4, dimens.space2, dimens.space4, dimens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Formatters.comma(quote.current),
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 32,
              fontWeight: AppTypography.bold,
            ),
          ),
          SizedBox(height: dimens.space1),
          Row(
            children: <Widget>[
              if (style.arrow.isNotEmpty)
                Text(style.arrow, style: TextStyle(color: style.textColor, fontSize: 14)),
              if (style.arrow.isNotEmpty) SizedBox(width: dimens.space1),
              Text(
                // 방향은 화살표로 이미 표시하고 있어 등락액은 절댓값만 보여줍니다.
                '${Formatters.comma(quote.change.abs())} (${Formatters.signedPercent(quote.changeRate)})',
                style: TextStyle(
                  color: style.textColor,
                  fontSize: 14,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
