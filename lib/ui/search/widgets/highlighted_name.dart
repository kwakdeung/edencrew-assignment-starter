import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class HighlightedName extends StatelessWidget {
  const HighlightedName({super.key, required this.name, required this.query});

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
