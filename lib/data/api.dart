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

    while (hasMore) {
      final response = await http.get(
        Uri.parse('$baseUrl/zones/$zoneId/dns_records?type=A,CNAME&per_page=100&page=$page'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success']) {
          allRecords.addAll(json['result']);
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
        throw Exception('Failed to load DNS records. HTTP ${response.statusCode}');
      }
    }
    return allRecords;
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
