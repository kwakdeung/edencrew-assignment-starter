import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/domain/quote.dart';
import 'package:edencrew_assignment_starter/domain/stock_summary.dart';
import 'package:edencrew_assignment_starter/state/stock_detail_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/candle_chart.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/daily_price_table.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/period_tabs.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/price_section.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/stock_detail_header.dart';
import 'package:edencrew_assignment_starter/ui/detail/widgets/summary_card.dart';

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
          StockDetailHeader(symbol: widget.symbol, meta: controller.meta),
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
          StockDetailHeader(symbol: widget.symbol, meta: controller.meta),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    }

    final Quote? quote = controller.quote;

    return ListView(
      padding: EdgeInsets.only(bottom: dimens.space6),
      children: <Widget>[
        StockDetailHeader(symbol: widget.symbol, meta: controller.meta),
        if (quote != null) PriceSection(quote: quote),
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
