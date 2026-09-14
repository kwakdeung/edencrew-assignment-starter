import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:edencrew_assignment_starter/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/state/watchlist_controller.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/ui/app_root.dart';

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
