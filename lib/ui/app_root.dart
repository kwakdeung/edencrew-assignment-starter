import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/ui/search/search_screen.dart';
import 'package:edencrew_assignment_starter/ui/watchlist/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/ui/widgets/bottom_nav_bar.dart';

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
      bottomNavigationBar: BottomNavBar(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
      ),
    );
  }
}
