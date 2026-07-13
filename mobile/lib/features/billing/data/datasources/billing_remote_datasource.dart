import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/billing_model.dart';

class BillingRemoteDataSource {
  final SupabaseClient _client;

  BillingRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<BillingModel>> getAll() async {
    final response = await _client
        .from('billing_reminders')
        .select()
        .order('reminder_date', ascending: true);

    return (response as List)
        .map((json) => BillingModel.fromJson(json))
        .toList();
  }

  Future<List<BillingModel>> getPending() async {
    final response = await _client
        .from('billing_reminders')
        .select()
        .eq('status', 'pending')
        .order('reminder_date', ascending: true);

    return (response as List)
        .map((json) => BillingModel.fromJson(json))
        .toList();
  }

  Future<List<BillingModel>> getByDateRange(
      DateTime start, DateTime end) async {
    final response = await _client
        .from('billing_reminders')
        .select()
        .gte('reminder_date', start.toIso8601String().split('T')[0])
        .lte('reminder_date', end.toIso8601String().split('T')[0])
        .order('reminder_date', ascending: true);

    return (response as List)
        .map((json) => BillingModel.fromJson(json))
        .toList();
  }

  Future<BillingModel> create(BillingModel record) async {
    final response = await _client
        .from('billing_reminders')
        .insert(record.toJson()..remove('id'))
        .select()
        .single();

    return BillingModel.fromJson(response);
  }

  Future<BillingModel> update(BillingModel record) async {
    final response = await _client
        .from('billing_reminders')
        .update(record.toJson())
        .eq('id', record.id)
        .select()
        .single();

    return BillingModel.fromJson(response);
  }

  Future<void> delete(String id) async {
    await _client.from('billing_reminders').delete().eq('id', id);
  }
}
