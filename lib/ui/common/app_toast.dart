import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// 검색 화면의 관심 등록 / 해제 토스트입니다.
///
/// Figma에 노출 시간과 사라지는 방식이 정의되어 있지 않아 다음과 같이 직접 판단했습니다.
/// - 2초간 노출 후 자동으로 사라집니다. (스낵바류 UI의 일반적인 노출 시간)
/// - 짧은 페이드 + 위로 슬라이드 인/아웃 애니메이션을 적용해 갑자기 나타나고
///   사라지는 느낌을 줄였습니다.
/// - 연속으로 여러 번 누르면 이전 토스트를 즉시 교체합니다. (겹쳐 쌓이지 않도록)
class AppToast {
  AppToast._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    required bool isFavorite,
  }) {
    _current?.remove();
    final OverlayState overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) => _ToastWidget(
        message: message,
        isFavorite: isFavorite,
        onFinished: () {
          if (_current == entry) {
            _current = null;
          }
          entry.remove();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.isFavorite,
    required this.onFinished,
  });

  final String message;
  final bool isFavorite;
  final VoidCallback onFinished;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future<void>.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final MediaQueryData media = MediaQuery.of(context);

    return Positioned(
      left: dimens.space5,
      right: dimens.space5,
      bottom: media.padding.bottom + dimens.tabBarHeight + dimens.space4,
      child: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.space4,
                vertical: dimens.space3,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceOverlay,
                borderRadius: BorderRadius.circular(dimens.radiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    widget.isFavorite ? Icons.star : Icons.star_border,
                    size: dimens.iconMd,
                    color: colors.favoriteActive,
                  ),
                  SizedBox(width: dimens.space2),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
