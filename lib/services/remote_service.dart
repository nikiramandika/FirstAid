import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/first_aid_data.dart';
import '../config/remote_config.dart';

class RemoteService {
  RemoteService({String? baseUrl})
      : _baseUrl = baseUrl ?? supabaseRestUrl;

  final String _baseUrl;

  Future<List<FirstAidData>> fetchAll() async {
    // Supabase REST endpoint: /rest/v1/first_aid_data?select=*
    final uri = Uri.parse('$_baseUrl/first_aid_data?select=*');
    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(res.body) as List<dynamic>;
      return jsonList.map((e) => FirstAidData.fromMap(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch data: ${res.statusCode} ${res.body}');
    }
  }
} 