import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ammo/presentation/add_ammo_screen.dart';
import '../features/ammo/presentation/ammo_detail_screen.dart';
import '../features/ammo/presentation/ammo_screen.dart';
import '../features/ammo/presentation/edit_ammo_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/firearms/presentation/add_firearm_screen.dart';
import '../features/firearms/presentation/edit_firearm_screen.dart';
import '../features/firearms/presentation/firearm_detail_screen.dart';
import '../features/firearms/presentation/firearms_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/sessions/presentation/add_firearm_run_screen.dart';
import '../features/sessions/presentation/session_detail_screen.dart';
import '../features/sessions/presentation/sessions_screen.dart';
import '../features/sessions/presentation/start_session_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return RoundCountShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/sessions',
          builder: (context, state) => const SessionsScreen(),
          routes: [
            GoRoute(
              path: 'start',
              builder: (context, state) => const StartSessionScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => SessionDetailScreen(
                id: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'add-run',
                  builder: (context, state) => AddFirearmRunScreen(
                    sessionId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/firearms',
          builder: (context, state) => const FirearmsScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddFirearmScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => FirearmDetailScreen(
                id: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => EditFirearmScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/ammo',
          builder: (context, state) => const AmmoScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddAmmoScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => AmmoDetailScreen(
                id: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => EditAmmoScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsScreen(),
        ),
      ],
    ),
  ],
);

class RoundCountShell extends StatelessWidget {
  const RoundCountShell({
    super.key,
    required this.child,
  });

  final Widget child;

  int _selectedIndex(String location) {
    if (location.startsWith('/sessions')) return 1;
    if (location.startsWith('/firearms')) return 2;
    if (location.startsWith('/ammo')) return 3;
    if (location.startsWith('/insights')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/sessions');
        break;
      case 2:
        context.go('/firearms');
        break;
      case 3:
        context.go('/ammo');
        break;
      case 4:
        context.go('/insights');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Armory',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Ammo',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}