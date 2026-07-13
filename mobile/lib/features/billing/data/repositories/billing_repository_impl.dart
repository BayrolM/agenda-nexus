import '../datasources/billing_remote_datasource.dart';
import '../models/billing_model.dart';
import '../../domain/entities/billing_record.dart';
import '../../domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  final BillingRemoteDataSource _dataSource;

  BillingRepositoryImpl({BillingRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? BillingRemoteDataSource();

  @override
  Future<List<BillingRecord>> getAll() {
    return _dataSource.getAll();
  }

  @override
  Future<List<BillingRecord>> getPending() {
    return _dataSource.getPending();
  }

  @override
  Future<List<BillingRecord>> getByDateRange(DateTime start, DateTime end) {
    return _dataSource.getByDateRange(start, end);
  }

  @override
  Future<BillingRecord> create(BillingRecord record) {
    return _dataSource.create(BillingModel(
      id: '',
      companyId: record.companyId,
      reminderDate: record.reminderDate,
      amount: record.amount,
      status: record.status,
    ));
  }

  @override
  Future<BillingRecord> update(BillingRecord record) {
    return _dataSource.update(BillingModel(
      id: record.id,
      companyId: record.companyId,
      reminderDate: record.reminderDate,
      amount: record.amount,
      status: record.status,
    ));
  }

  @override
  Future<void> delete(String id) {
    return _dataSource.delete(id);
  }
}
