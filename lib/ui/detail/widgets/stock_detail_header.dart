import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/domain/stock_summary.dart';
import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/common/app_toast.dart';

class StockDetailHeader extends StatelessWidget {
  const StockDetailHeader({super.key, required this.symbol, required this.meta});

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
              final bool wasFavorite = isFavorite;
              await watchlist.toggleFavorite(meta!);
              if (!context.mounted) return;
              AppToast.show(
                context,
                isFavorite: !wasFavorite,
                message: wasFavorite ? '관심이 해제되었습니다' : '관심이 등록되었습니다',
              );
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
