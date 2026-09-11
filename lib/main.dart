import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/stock_repository.dart';
import 'state/watchlist_controller.dart';
import 'theme/theme.dart';
import 'ui/app_root.dart';

void main() {
  runApp(const EdencrewAssignmentApp());
}

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<StockRepository>(
          create: (_) => StockRepository(),
          dispose: (_, StockRepository repository) => repository.dispose(),
        ),
        ChangeNotifierProvider<WatchlistController>(
          create: (BuildContext context) => WatchlistController(context.read()),
        ),
      ],
      child: MaterialApp(
        title: '이든크루 관심종목',
        theme: AppTheme.dark,
        home: const AppRoot(),
      ),
    );
  }
}
