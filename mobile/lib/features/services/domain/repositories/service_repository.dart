import '../entities/company_service.dart';

abstract class ServiceRepository {
  Future<List<CompanyService>> getByCompanyId(String companyId);
  Future<CompanyService> getById(String id);
  Future<CompanyService> create(CompanyService service);
  Future<CompanyService> update(CompanyService service);
  Future<void> delete(String id);
}
