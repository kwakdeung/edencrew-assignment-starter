import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
        border: Border.all(color: colors.borderStrong, width: dimens.borderHairline),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 15,
          fontWeight: AppTypography.regular,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: '종목명 또는 종목코드',
          hintStyle: TextStyle(
            color: colors.textTertiary,
            fontSize: 15,
            fontWeight: AppTypography.medium,
            height: 20 / 15,
            letterSpacing: -0.1,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: dimens.space2),
          prefixIcon: Icon(Icons.search_rounded, color: colors.textTertiary, size: dimens.iconMd),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: onClear,
                icon: SvgPicture.asset(
                  'assets/images/ic_x.svg',
                  width: dimens.iconSm,
                  height: dimens.iconSm,
                  colorFilter: ColorFilter.mode(colors.textTertiary, BlendMode.srcIn),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
