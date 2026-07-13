import '../entities/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> getAll();
  Future<Company> getById(String id);
  Future<Company> create(Company company);
  Future<Company> update(Company company);
  Future<void> delete(String id);
}
