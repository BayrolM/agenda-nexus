import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/company_model.dart';

class CompanyRemoteDataSource {
  final SupabaseClient _client;

  CompanyRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<CompanyModel>> getAll() async {
    final response = await _client
        .from('companies')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => CompanyModel.fromJson(json))
        .toList();
  }

  Future<CompanyModel> getById(String id) async {
    final response = await _client
        .from('companies')
        .select()
        .eq('id', id)
        .single();

    return CompanyModel.fromJson(response);
  }

  Future<CompanyModel> create(CompanyModel company) async {
    final response = await _client
        .from('companies')
        .insert(company.toJson()..remove('id'))
        .select()
        .single();

    return CompanyModel.fromJson(response);
  }

  Future<CompanyModel> update(CompanyModel company) async {
    final response = await _client
        .from('companies')
        .update(company.toJson())
        .eq('id', company.id)
        .select()
        .single();

    return CompanyModel.fromJson(response);
  }

  Future<void> delete(String id) async {
    await _client.from('companies').delete().eq('id', id);
  }
}
