import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../controllers/companies_controller.dart';

class CompanyDetailPage extends ConsumerWidget {
  final String companyId;

  const CompanyDetailPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyAsync = ref.watch(companyDetailProvider(companyId));
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final secondaryText = isDark ? AppColors.gray400 : AppColors.gray500;
    final avatarBg = isDark ? AppColors.gray700 : AppColors.gray100;
    final cardBg = isDark ? AppColors.gray800 : AppColors.gray50;
    final cardBorder = isDark ? AppColors.gray600 : AppColors.gray200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Empresa'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'edit') {
                context.push('/company/$companyId/edit');
              } else if (value == 'delete') {
                _showDeleteDialog(context, ref, companyId);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: companyAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: textColor),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (company) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: avatarBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          company.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    if (company.description != null && company.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        company.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Informacion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context: context,
                icon: Icons.email_outlined,
                label: 'Correo',
                value: company.contactEmail ?? 'No especificado',
              ),
              _buildInfoCard(
                context: context,
                icon: Icons.phone_outlined,
                label: 'Telefono',
                value: company.contactPhone ?? 'No especificado',
              ),
              _buildInfoCard(
                context: context,
                icon: Icons.calendar_today,
                label: 'Dia de cobro',
                value: company.billingDay != null ? 'Dia ${company.billingDay}' : 'No especificado',
              ),
              _buildInfoCard(
                context: context,
                icon: Icons.attach_money,
                label: 'Monto',
                value: company.billingAmount != null
                    ? '\$${company.billingAmount!.toStringAsFixed(2)} ${company.currency}'
                    : 'No especificado',
              ),
              if (company.notes != null && company.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Notas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Text(
                    company.notes!,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/company/$companyId/services'),
                  icon: const Icon(Icons.dns_outlined),
                  label: const Text('Ver Servicios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final iconMuted = isDark ? AppColors.gray500 : AppColors.gray400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: iconMuted,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String companyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Empresa'),
        content: const Text('Esta seguro? Esta accion no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(companiesProvider.notifier).delete(companyId);
              if (context.mounted) {
                Navigator.pop(context);
                AppToast.success(context, 'Empresa eliminada exitosamente');
                context.go('/');
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
