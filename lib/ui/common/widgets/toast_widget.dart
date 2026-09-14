import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class ToastWidget extends StatefulWidget {
  const ToastWidget({
    super.key,
    required this.message,
    required this.isFavorite,
    required this.onFinished,
  });

  final String message;
  final bool isFavorite;
  final VoidCallback onFinished;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
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
                    color: widget.isFavorite ? colors.favoriteActive : colors.textSecondary,
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
