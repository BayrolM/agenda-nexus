import '../entities/billing_record.dart';

abstract class BillingRepository {
  Future<List<BillingRecord>> getAll();
  Future<List<BillingRecord>> getPending();
  Future<List<BillingRecord>> getByDateRange(DateTime start, DateTime end);
  Future<BillingRecord> create(BillingRecord record);
  Future<BillingRecord> update(BillingRecord record);
  Future<void> delete(String id);
}
