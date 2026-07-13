import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/companies_controller.dart';

class CompaniesListPage extends ConsumerWidget {
  const CompaniesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final secondaryText = isDark ? AppColors.gray400 : AppColors.gray500;
    final iconMuted = isDark ? AppColors.gray500 : AppColors.gray400;
    final avatarBg = isDark ? AppColors.gray700 : AppColors.gray100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cerrar sesion'),
                  content: const Text('Estas seguro que deseas cerrar sesion?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await ref.read(authStateProvider.notifier).signOut();
                        if (context.mounted) {
                          AppToast.success(context, 'Sesion cerrada exitosamente');
                          context.go('/login');
                        }
                      },
                      child: const Text('Cerrar sesion'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: companiesAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: textColor),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: iconMuted),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => ref.read(companiesProvider.notifier).load(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (companies) {
          if (companies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business_outlined, size: 64, color: iconMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No hay empresas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega tu primera empresa para comenzar',
                    style: TextStyle(color: secondaryText),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = companies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => context.push('/company/${company.id}'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: avatarBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              company.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              if (company.contactEmail != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  company.contactEmail!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: secondaryText,
                                  ),
                                ),
                              ],
                              if (company.billingDay != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 14, color: iconMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Cobro dia ${company.billingDay}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: iconMuted,
                                      ),
                                    ),
                                    if (company.billingAmount != null) ...[
                                      const SizedBox(width: 12),
                                      Text(
                                        AppDateUtils.formatCurrency(company.billingAmount!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: iconMuted),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/company/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
