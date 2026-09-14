import 'package:flutter/material.dart';

import '../../../domain/watchlist_sort.dart';
import '../../../theme/theme.dart';

Future<void> showSortBottomSheet({
  required BuildContext context,
  required WatchlistSort current,
  required ValueChanged<WatchlistSort> onSelected,
}) {
  final AppColors colors = context.colors;
  final AppDimens dimens = context.dimens;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceRaised,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(dimens.radiusLg)),
    ),
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dimens.space3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dimens.space4,
                  vertical: dimens.space2,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '정렬',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
              ),
              for (final WatchlistSort sort in WatchlistSort.values)
                ListTile(
                  onTap: () {
                    onSelected(sort);
                    Navigator.of(sheetContext).pop();
                  },
                  title: Text(
                    sort.label,
                    style: TextStyle(
                      color: sort == current ? colors.textPrimary : colors.textSecondary,
                      fontSize: 15,
                      fontWeight:
                          sort == current ? AppTypography.medium : AppTypography.regular,
                    ),
                  ),
                  trailing: sort == current
                      ? Icon(Icons.check, color: colors.textPrimary, size: dimens.iconMd)
                      : null,
                ),
            ],
          ),
        ),
      );
    },
  );
}
