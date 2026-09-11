import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'search/search_screen.dart';
import 'watchlist/watchlist_screen.dart';

/// 관심 / 검색 화면을 전환하는 하단 탭 바 셸입니다.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int _index = 0;

  static const List<Widget> _screens = <Widget>[
    WatchlistScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _BottomNavBar(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return SafeArea(
      top: false,
      child: Container(
        height: dimens.tabBarHeight,
        decoration: BoxDecoration(
          color: colors.surfaceBase,
          border: Border(
            top: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
          ),
        ),
        child: Row(
          children: <Widget>[
            _NavItem(
              icon: Icons.star_rounded,
              label: '관심',
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
            _NavItem(
              icon: Icons.search_rounded,
              label: '검색',
              selected: index == 1,
              onTap: () => onChanged(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final Color color = selected ? colors.navActive : colors.navInactive;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: dimens.iconMd, color: color),
            SizedBox(height: dimens.space1),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? AppTypography.medium : AppTypography.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
