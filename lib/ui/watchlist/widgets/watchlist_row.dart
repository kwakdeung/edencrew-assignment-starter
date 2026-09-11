import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../domain/quote.dart';
import '../../../domain/stock_summary.dart';
import '../../../theme/theme.dart';
import '../../common/price_style.dart';

class WatchlistRow extends StatelessWidget {
  const WatchlistRow({
    super.key,
    required this.meta,
    required this.quote,
    required this.onTap,
  });

  final StockSummary? meta;
  final Quote? quote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final PriceStyle style =
        PriceStyle.of(context, quote?.direction ?? PriceDirection.flat);

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(horizontal: dimens.space4, vertical: dimens.space3),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    meta?.name ?? '',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: AppTypography.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: dimens.space1),
                  Text(
                    meta == null ? '' : '${meta!.symbol} · ${meta!.market}',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 12,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: dimens.space3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  quote == null ? '' : Formatters.comma(quote!.current),
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                SizedBox(height: dimens.space1),
                if (quote != null)
                  Text(
                    '${Formatters.signedComma(quote!.change)} (${Formatters.signedPercent(quote!.changeRate)})',
                    style: TextStyle(
                      color: style.textColor,
                      fontSize: 12,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
