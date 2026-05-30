// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'navigation/app_router.dart';
import 'providers/catalogue_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/profile_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogueProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..load()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..load()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..load()),
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return MaterialApp.router(
            title: 'Mini E-Commerce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: profileProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
