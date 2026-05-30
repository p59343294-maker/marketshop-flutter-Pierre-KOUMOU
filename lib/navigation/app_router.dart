// lib/navigation/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/catalogue_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/history_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/catalogue',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => _ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/catalogue',
          pageBuilder: (context, state) => const NoTransitionPage(child: CatalogueScreen()),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (context, state) => const NoTransitionPage(child: CartScreen()),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => const NoTransitionPage(child: HistoryScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/product/:id',
      builder: (context, state) => ProductDetailScreen(
        productId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/order/:id',
      builder: (context, state) => OrderDetailScreen(
        orderId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);

class _ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNav({required this.child});

  static const _tabs = [
    (path: '/catalogue', label: 'Catalogue', icon: Icons.store_outlined, activeIcon: Icons.store),
    (path: '/cart', label: 'Panier', icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart),
    (path: '/history', label: 'Historique', icon: Icons.history_outlined, activeIcon: Icons.history),
    (path: '/profile', label: 'Profil', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.activeIcon),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}
