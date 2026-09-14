import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/ui/common/widgets/toast_widget.dart';

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
      builder: (BuildContext context) => ToastWidget(
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
