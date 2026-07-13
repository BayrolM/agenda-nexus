import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/service_repository_impl.dart';
import '../../domain/entities/company_service.dart';
import '../../domain/repositories/service_repository.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepositoryImpl();
});

final servicesByCompanyProvider = StateNotifierProvider.family<
    ServicesNotifier, AsyncValue<List<CompanyService>>, String>((ref, companyId) {
  return ServicesNotifier(ref, companyId);
});

class ServicesNotifier extends StateNotifier<AsyncValue<List<CompanyService>>> {
  final Ref _ref;
  final String companyId;

  ServicesNotifier(this._ref, this.companyId) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(serviceRepositoryProvider);
      final services = await repository.getByCompanyId(companyId);
      state = AsyncValue.data(services);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<CompanyService> create(CompanyService service) async {
    final repository = _ref.read(serviceRepositoryProvider);
    final newService = await repository.create(service);
    await load();
    return newService;
  }

  Future<void> update(CompanyService service) async {
    final repository = _ref.read(serviceRepositoryProvider);
    await repository.update(service);
    await load();
  }

  Future<void> delete(String id) async {
    final repository = _ref.read(serviceRepositoryProvider);
    await repository.delete(id);
    await load();
  }
}
