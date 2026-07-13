import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../billing/data/datasources/billing_remote_datasource.dart';
import '../../../billing/data/models/billing_model.dart';
import '../../../billing/domain/entities/billing_record.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return CompanyRepositoryImpl();
});

final companiesProvider =
    StateNotifierProvider<CompaniesNotifier, AsyncValue<List<Company>>>((ref) {
  return CompaniesNotifier(ref);
});

class CompaniesNotifier extends StateNotifier<AsyncValue<List<Company>>> {
  final Ref _ref;

  CompaniesNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(companyRepositoryProvider);
      final companies = await repository.getAll();
      state = AsyncValue.data(companies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Company> create(Company company) async {
    final repository = _ref.read(companyRepositoryProvider);
    final newCompany = await repository.create(company);

    // Auto-create billing reminders for next 12 months
    if (newCompany.billingDay != null) {
      await _createBillingReminders(newCompany);
    }

    await load();
    return newCompany;
  }

  Future<void> update(Company company) async {
    final repository = _ref.read(companyRepositoryProvider);
    await repository.update(company);
    await load();
  }

  Future<void> delete(String id) async {
    final repository = _ref.read(companyRepositoryProvider);
    await repository.delete(id);
    await load();
  }

  Future<void> _createBillingReminders(Company company) async {
    final billingDataSource = BillingRemoteDataSource();
    final now = DateTime.now();

    for (int i = 0; i < 12; i++) {
      var month = now.month + i;
      var year = now.year;
      if (month > 12) {
        month -= 12;
        year += 1;
      }

      final day = company.billingDay!;
      final lastDayOfMonth = DateTime(year, month + 1, 0).day;
      final billingDay = day > lastDayOfMonth ? lastDayOfMonth : day;
      final reminderDate = DateTime(year, month, billingDay);

      // Don't create past dates
      if (reminderDate.isBefore(DateTime(now.year, now.month, now.day))) {
        continue;
      }

      await billingDataSource.create(BillingModel(
        id: '',
        companyId: company.id,
        reminderDate: reminderDate,
        amount: company.billingAmount,
        status: BillingStatus.pending,
      ));
    }
  }
}

final companyDetailProvider =
    FutureProvider.family<Company, String>((ref, companyId) async {
  final repository = ref.read(companyRepositoryProvider);
  return repository.getById(companyId);
});
