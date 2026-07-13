import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/company_service.dart';
import '../controllers/services_controller.dart';

class ServicesPage extends ConsumerWidget {
  final String companyId;

  const ServicesPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesByCompanyProvider(companyId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final secondaryText = isDark ? AppColors.gray400 : AppColors.gray500;
    final iconMuted = isDark ? AppColors.gray500 : AppColors.gray400;
    final avatarBg = isDark ? AppColors.gray700 : AppColors.gray100;
    final iconInAvatar = isDark ? AppColors.gray300 : AppColors.gray600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: servicesAsync.when(
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
                onPressed: () => ref
                    .read(servicesByCompanyProvider(companyId).notifier)
                    .load(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dns_outlined, size: 64, color: iconMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No hay servicios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega cuentas, dominios, APIs, etc.',
                    style: TextStyle(color: secondaryText),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () =>
                      context.push('/company/$companyId/services/${service.id}/edit'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: avatarBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              _getServiceIcon(service.serviceType),
                              color: iconInAvatar,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getServiceTypeLabel(service.serviceType),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: iconMuted,
                                ),
                              ),
                              if (service.username != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  service.username!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
        onPressed: () => context.push('/company/$companyId/services/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.google:
        return Icons.g_mobiledata;
      case ServiceType.github:
        return Icons.code;
      case ServiceType.database:
        return Icons.storage;
      case ServiceType.hosting:
        return Icons.cloud_outlined;
      case ServiceType.backend:
        return Icons.dns;
      case ServiceType.email:
        return Icons.mail_outline;
      case ServiceType.domain:
        return Icons.language;
      case ServiceType.other:
        return Icons.extension_outlined;
    }
  }

  String _getServiceTypeLabel(ServiceType type) {
    switch (type) {
      case ServiceType.google:
        return 'Google';
      case ServiceType.github:
        return 'GitHub';
      case ServiceType.database:
        return 'Base de Datos';
      case ServiceType.hosting:
        return 'Hosting';
      case ServiceType.backend:
        return 'Backend';
      case ServiceType.email:
        return 'Correo';
      case ServiceType.domain:
        return 'Dominio';
      case ServiceType.other:
        return 'Otro';
    }
  }
}
