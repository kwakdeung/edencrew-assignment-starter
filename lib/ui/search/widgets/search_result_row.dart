import 'package:flutter/material.dart';

import '../../../domain/stock_summary.dart';
import '../../../theme/theme.dart';

class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    super.key,
    required this.summary,
    required this.query,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final StockSummary summary;
  final String query;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

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
                  _HighlightedName(name: summary.name, query: query),
                  SizedBox(height: dimens.space1),
                  Text(
                    '${summary.symbol} · ${summary.market}',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 12,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite ? colors.favoriteActive : colors.favoriteInactive,
                size: dimens.iconMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedName extends StatelessWidget {
  const _HighlightedName({required this.name, required this.query});

  final String name;
  final String query;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final TextStyle base = TextStyle(
      color: colors.textPrimary,
      fontSize: 15,
      fontWeight: AppTypography.medium,
    );

    if (query.trim().isEmpty) {
      return Text(name, style: base, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final int index = name.toLowerCase().indexOf(query.toLowerCase());
    if (index < 0) {
      return Text(name, style: base, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: base,
        children: <TextSpan>[
          TextSpan(text: name.substring(0, index)),
          TextSpan(
            text: name.substring(index, index + query.length),
            style: base.copyWith(color: colors.searchHighlight),
          ),
          TextSpan(text: name.substring(index + query.length)),
        ],
      ),
    );
  }
}
