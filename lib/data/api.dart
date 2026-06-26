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
    List<dynamic> allZones = [];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await http.get(
        Uri.parse('$baseUrl/zones?per_page=50&page=$page'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success']) {
          allZones.addAll(json['result']);
          final resultInfo = json['result_info'];
          if (resultInfo != null && resultInfo['total_pages'] != null) {
            final int totalPages = resultInfo['total_pages'];
            if (page >= totalPages) {
              hasMore = false;
            } else {
              page++;
            }
          } else {
            hasMore = false;
          }
        } else {
          throw Exception("Failed to load zones: ${json['errors']}");
        }
      } else {
        throw Exception('Failed to load zones. HTTP ${response.statusCode}');
      }
    }
    return allZones;
  }

  static Future<List<dynamic>> listDnsRecords(String zoneId) async {
    List<dynamic> allRecords = [];
    int page = 1;
    bool hasMore = true;
    final allowedTypes = await LocalStorage.getDnsTypes();

    while (hasMore) {
      final response = await http.get(
        Uri.parse('$baseUrl/zones/$zoneId/dns_records?per_page=100&page=$page'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success']) {
          final List<dynamic> result = json['result'];
          allRecords
              .addAll(result.where((r) => allowedTypes.contains(r['type'])));
          final resultInfo = json['result_info'];
          if (resultInfo != null && resultInfo['total_pages'] != null) {
            final int totalPages = resultInfo['total_pages'];
            if (page >= totalPages) {
              hasMore = false;
            } else {
              page++;
            }
          } else {
            hasMore = false;
          }
        } else {
          throw Exception("Failed to load DNS records: ${json['errors']}");
        }
      } else {
        throw Exception(
            'Failed to load DNS records. HTTP ${response.statusCode}');
      }
    }
    return allRecords;
  }

  static Future<void> createDnsRecord(
      String zoneId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(
        'Falha ao criar registro: ${_formatCloudflareErrors(json)}',
      );
    }
  }

  static Future<void> updateDnsRecord(
      String zoneId, String recordId, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records/$recordId'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(
        'Falha ao atualizar registro: ${_formatCloudflareErrors(json)}',
      );
    }
  }

  static Future<void> deleteDnsRecord(String zoneId, String recordId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/zones/$zoneId/dns_records/$recordId'),
      headers: await _headers(),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) throw Exception('Failed to delete record');
  }

  static Future<void> purgeCache(String zoneId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/zones/$zoneId/purge_cache'),
      headers: await _headers(),
      body: jsonEncode({'purge_everything': true}),
    );
    final json = jsonDecode(response.body);
    if (!json['success']) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception(
          'Token sem permissão para limpar cache. Adicione a permissão Cache Purge ao token da Cloudflare.',
        );
      }
      throw Exception('Failed to purge cache: ${json['errors']}');
    }
  }

  static String _formatCloudflareErrors(Map<String, dynamic> json) {
    final errors = json['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.map((error) {
        if (error is Map<String, dynamic>) {
          final code = error['code'];
          final message = error['message'];
          if (code != null && message != null) {
            return '$message (código $code)';
          }
          if (message != null) return message.toString();
        }
        return error.toString();
      }).join('; ');
    }
    return 'erro desconhecido da API Cloudflare';
  }
}
