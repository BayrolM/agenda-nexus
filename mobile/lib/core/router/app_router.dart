import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/companies/presentation/pages/companies_list_page.dart';
import '../../features/companies/presentation/pages/company_detail_page.dart';
import '../../features/companies/presentation/pages/company_form_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/services/presentation/pages/service_form_page.dart';
import '../../features/billing/presentation/pages/billing_calendar_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

// Helper: Convierte el authStateProvider de Riverpod en algo que GoRouter
// pueda "escuchar" directamente. GoRouter solo entiende ChangeNotifier,
// y Riverpod no es un ChangeNotifier por defecto. Este puente lo soluciona.
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    // Le decimos a Riverpod: "Cada vez que authStateProvider cambie,
    // llama a notifyListeners() para avisarle a GoRouter que re-evalúe el redirect."
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Creamos el puente Riverpod <-> GoRouter
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',

    // Le pasamos el notifier como "escucha". Cuando Riverpod cambie,
    // GoRouter sabrá que debe volver a ejecutar el redirect.
    refreshListenable: notifier,

    // EL GUARDIA DE SEGURIDAD: Se ejecuta cada vez que refreshListenable avisa.
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      // Si Riverpod todavía está cargando la sesión, no movemos a nadie
      if (authState.isLoading) return null;

      final user = authState.value; // Usuario o null

      // Detectamos si el usuario está intentando ir a una pantalla pública
      final uri = state.uri.toString();
      final isOnPublicRoute = uri == '/login' ||
          uri == '/register' ||
          uri.startsWith('/verify-email');

      // REGLA 1: No hay usuario Y está intentando ir a pantalla privada
      //          → Mandarlo al Login
      if (user == null && !isOnPublicRoute) {
        return '/login';
      }

      // REGLA 2: Hay usuario autenticado Y está en una pantalla pública (ej. Login)
      //          → Mandarlo al inicio (Home)
      if (user != null && isOnPublicRoute) {
        return '/';
      }

      // Todo está bien, que siga su camino
      return null;
    },

    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verifyEmail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final pendingId = extra?['pendingId'] as String? ?? '';
          final email = extra?['email'] as String? ?? '';
          return VerifyEmailPage(pendingId: pendingId, email: email);
        },
      ),

      // Company form (BEFORE /company/:id)
      GoRoute(
        path: '/company/new',
        name: 'companyFormNew',
        builder: (context, state) => const CompanyFormPage(),
      ),
      GoRoute(
        path: '/company/:id/edit',
        name: 'companyFormEdit',
        builder: (context, state) {
          final companyId = state.pathParameters['id']!;
          return CompanyFormPage(companyId: companyId);
        },
      ),

      // Main shell (authenticated)
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CompaniesListPage(),
            ),
          ),
          GoRoute(
            path: '/billing',
            name: 'billing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BillingCalendarPage(),
            ),
          ),
        ],
      ),

      // Company detail
      GoRoute(
        path: '/company/:id',
        name: 'companyDetail',
        builder: (context, state) {
          final companyId = state.pathParameters['id']!;
          return CompanyDetailPage(companyId: companyId);
        },
        routes: [
          GoRoute(
            path: 'services',
            name: 'services',
            builder: (context, state) {
              final companyId = state.pathParameters['id']!;
              return ServicesPage(companyId: companyId);
            },
            routes: [
              GoRoute(
                path: 'new',
                name: 'serviceFormNew',
                builder: (context, state) {
                  final companyId = state.pathParameters['id']!;
                  return ServiceFormPage(companyId: companyId);
                },
              ),
              GoRoute(
                path: ':serviceId/edit',
                name: 'serviceFormEdit',
                builder: (context, state) {
                  final companyId = state.pathParameters['id']!;
                  final serviceId = state.pathParameters['serviceId']!;
                  return ServiceFormPage(
                    companyId: companyId,
                    serviceId: serviceId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Empresas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Cobros',
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/billing')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/billing');
    }
  }
}
