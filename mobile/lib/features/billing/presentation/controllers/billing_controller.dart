import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/billing_repository_impl.dart';
import '../../domain/entities/billing_record.dart';
import '../../domain/repositories/billing_repository.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepositoryImpl();
});

final billingCalendarProvider =
    StateNotifierProvider<BillingNotifier, AsyncValue<List<BillingRecord>>>((ref) {
  return BillingNotifier(ref);
});

class BillingNotifier extends StateNotifier<AsyncValue<List<BillingRecord>>> {
  final Ref _ref;

  BillingNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(billingRepositoryProvider);
      final records = await repository.getAll();
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadByDateRange(DateTime start, DateTime end) async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(billingRepositoryProvider);
      final records = await repository.getByDateRange(start, end);
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<BillingRecord> create(BillingRecord record) async {
    final repository = _ref.read(billingRepositoryProvider);
    final newRecord = await repository.create(record);
    await loadAll();
    return newRecord;
  }

  Future<void> markAsPaid(String id) async {
    final repository = _ref.read(billingRepositoryProvider);
    final records = state.valueOrNull ?? [];
    final record = records.firstWhere((r) => r.id == id);
    await repository.update(BillingRecord(
      id: record.id,
      companyId: record.companyId,
      reminderDate: record.reminderDate,
      amount: record.amount,
      status: BillingStatus.paid,
    ));
    await loadAll();
  }

  Future<void> delete(String id) async {
    final repository = _ref.read(billingRepositoryProvider);
    await repository.delete(id);
    await loadAll();
  }
}
