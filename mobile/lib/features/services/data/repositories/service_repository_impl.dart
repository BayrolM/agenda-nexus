import '../datasources/service_remote_datasource.dart';
import '../models/service_model.dart';
import '../../domain/entities/company_service.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource _dataSource;

  ServiceRepositoryImpl({ServiceRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? ServiceRemoteDataSource();

  @override
  Future<List<CompanyService>> getByCompanyId(String companyId) {
    return _dataSource.getByCompanyId(companyId);
  }

  @override
  Future<CompanyService> getById(String id) {
    return _dataSource.getById(id);
  }

  @override
  Future<CompanyService> create(CompanyService service) {
    return _dataSource.create(ServiceModel(
      id: '',
      companyId: service.companyId,
      serviceType: service.serviceType,
      name: service.name,
      url: service.url,
      username: service.username,
      password: service.password,
      apiKey: service.apiKey,
      expirationDate: service.expirationDate,
      monthlyCost: service.monthlyCost,
      notes: service.notes,
    ));
  }

  @override
  Future<CompanyService> update(CompanyService service) {
    return _dataSource.update(ServiceModel(
      id: service.id,
      companyId: service.companyId,
      serviceType: service.serviceType,
      name: service.name,
      url: service.url,
      username: service.username,
      password: service.password,
      apiKey: service.apiKey,
      expirationDate: service.expirationDate,
      monthlyCost: service.monthlyCost,
      notes: service.notes,
    ));
  }

  @override
  Future<void> delete(String id) {
    return _dataSource.delete(id);
  }
}
