import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'local_storage.dart';

class ApiService {
  static const String baseUrl = kIsWeb 
      ? 'http://localhost:8081/client/v4' 
      : 'https://api.cloudflare.com/client/v4';

  static Future<Map<String, String>> _headers() async {
    final token = await LocalStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<List<dynamic>> listZones() async {
    final response = await http.get(Uri.parse('$baseUrl/zones'), headers: await _headers());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success']) {
        return json['result'];
      }
    }
    throw Exception('Failed to load zones');
  }

  static Future<List<dynamic>> listDnsRecords(String zoneId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records?type=A,CNAME'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success']) {
        return json['result'];
      }
    }
    throw Exception('Failed to load DNS records');
  }

  static Future<void> createDnsRecord(String zoneId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) throw Exception('Failed to create record');
  }

  static Future<void> updateDnsRecord(String zoneId, String recordId, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records/$recordId'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) throw Exception('Failed to update record');
  }

  static Future<void> deleteDnsRecord(String zoneId, String recordId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records/$recordId'),
      headers: await _headers(),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) throw Exception('Failed to delete record');
  }
}
