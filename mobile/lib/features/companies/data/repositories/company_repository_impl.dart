import '../datasources/company_remote_datasource.dart';
import '../models/company_model.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource _dataSource;

  CompanyRepositoryImpl({CompanyRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? CompanyRemoteDataSource();

  @override
  Future<List<Company>> getAll() {
    return _dataSource.getAll();
  }

  @override
  Future<Company> getById(String id) {
    return _dataSource.getById(id);
  }

  @override
  Future<Company> create(Company company) {
    return _dataSource.create(CompanyModel(
      id: '',
      userId: company.userId,
      name: company.name,
      description: company.description,
      contactEmail: company.contactEmail,
      contactPhone: company.contactPhone,
      billingDay: company.billingDay,
      billingAmount: company.billingAmount,
      currency: company.currency,
      notes: company.notes,
      isActive: company.isActive,
    ));
  }

  @override
  Future<Company> update(Company company) {
    return _dataSource.update(CompanyModel(
      id: company.id,
      userId: company.userId,
      name: company.name,
      description: company.description,
      contactEmail: company.contactEmail,
      contactPhone: company.contactPhone,
      billingDay: company.billingDay,
      billingAmount: company.billingAmount,
      currency: company.currency,
      notes: company.notes,
      isActive: company.isActive,
    ));
  }

  @override
  Future<void> delete(String id) {
    return _dataSource.delete(id);
  }
}
