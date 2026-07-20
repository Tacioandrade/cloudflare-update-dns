import 'package:cloudflare_dns/data/dns_record_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final records = <Map<String, dynamic>>[
    {
      'name': 'site.example.com',
      'content': '192.0.2.1',
      'type': 'A',
      'proxied': true,
    },
    {
      'name': 'mail.example.com',
      'content': 'mail.provider.example',
      'type': 'CNAME',
      'proxied': false,
    },
    {
      'name': 'example.com',
      'content': 'mail.example.com',
      'type': 'MX',
      'proxied': false,
    },
  ];

  test('filters records by all selected DNS types', () {
    final result = DnsRecordFilter.apply(
      records: records,
      selectedTypes: {'A', 'MX'},
    );

    expect(result.map((record) => record['type']), ['A', 'MX']);
  });

  test('filters records by enabled or disabled proxy state', () {
    final proxied = DnsRecordFilter.apply(
      records: records,
      selectedProxyStates: {true},
    );
    final dnsOnly = DnsRecordFilter.apply(
      records: records,
      selectedProxyStates: {false},
    );

    expect(proxied.map((record) => record['name']), ['site.example.com']);
    expect(
      dnsOnly.map((record) => record['name']),
      ['mail.example.com', 'example.com'],
    );
  });

  test('combines DNS type, proxy state, and text search', () {
    final result = DnsRecordFilter.apply(
      records: records,
      searchQuery: 'SITE',
      selectedTypes: {'A', 'CNAME'},
      selectedProxyStates: {true},
    );

    expect(result, [records.first]);
  });

  test('empty selections preserve the complete record list', () {
    final result = DnsRecordFilter.apply(records: records);

    expect(result, records);
  });
}
