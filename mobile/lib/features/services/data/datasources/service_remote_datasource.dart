import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/service_model.dart';

class ServiceRemoteDataSource {
  final SupabaseClient _client;

  ServiceRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<ServiceModel>> getByCompanyId(String companyId) async {
    final response = await _client
        .from('company_services')
        .select()
        .eq('company_id', companyId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ServiceModel.fromJson(json))
        .toList();
  }

  Future<ServiceModel> getById(String id) async {
    final response = await _client
        .from('company_services')
        .select()
        .eq('id', id)
        .single();

    return ServiceModel.fromJson(response);
  }

  Future<ServiceModel> create(ServiceModel service) async {
    final response = await _client
        .from('company_services')
        .insert(service.toJson()..remove('id'))
        .select()
        .single();

    return ServiceModel.fromJson(response);
  }

  Future<ServiceModel> update(ServiceModel service) async {
    final response = await _client
        .from('company_services')
        .update(service.toJson())
        .eq('id', service.id)
        .select()
        .single();

    return ServiceModel.fromJson(response);
  }

  Future<void> delete(String id) async {
    await _client.from('company_services').delete().eq('id', id);
  }
}
