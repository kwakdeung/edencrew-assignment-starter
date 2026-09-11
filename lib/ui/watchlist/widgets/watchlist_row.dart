import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../domain/quote.dart';
import '../../../domain/stock_summary.dart';
import '../../../theme/theme.dart';
import '../../common/price_style.dart';

/// 관심 화면의 종목 한 행입니다.
///
/// 종목명 · 코드 · 시장은 관심 등록 시점에 이미 알고 있는 값이라 즉시 표시되고,
/// 시세([quote])만 아직 없다면 가격 영역만 [feedbackSkeleton] 블록으로
/// 대체합니다. (Figma 시안에서도 이름/코드는 그대로 두고 가격 쪽만 로딩 상태로
/// 보여줍니다)
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

    Widget skeletonBar(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.feedbackSkeleton,
          borderRadius: BorderRadius.circular(dimens.radiusSm),
        ),
      );
    }

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
                children: meta == null
                    ? <Widget>[skeletonBar(88, 15), SizedBox(height: dimens.space2), skeletonBar(64, 12)]
                    : <Widget>[
                        Text(
                          meta!.name,
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
                          '${meta!.symbol} · ${meta!.market}',
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
              children: quote == null
                  ? <Widget>[skeletonBar(40, 14), SizedBox(height: dimens.space2), skeletonBar(32, 11)]
                  : <Widget>[
                      Text(
                        Formatters.comma(quote!.current),
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      SizedBox(height: dimens.space1),
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
