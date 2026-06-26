import 'package:cloudflare_dns/data/dns_record_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DnsRecordValidator', () {
    test('identifies proxiable record types', () {
      expect(DnsRecordValidator.isProxiableType('A'), isTrue);
      expect(DnsRecordValidator.isProxiableType('AAAA'), isTrue);
      expect(DnsRecordValidator.isProxiableType('CNAME'), isTrue);
      expect(DnsRecordValidator.isProxiableType('TXT'), isFalse);
      expect(DnsRecordValidator.isProxiableType('MX'), isFalse);
      expect(DnsRecordValidator.isProxiableType('NS'), isFalse);
      expect(DnsRecordValidator.isProxiableType('SRV'), isFalse);
    });

    test('validates A record content as IPv4', () {
      expect(
        DnsRecordValidator.validateContent(type: 'A', content: '192.168.0.1'),
        isNull,
      );
      expect(
        DnsRecordValidator.validateContent(type: 'A', content: '999.1.1.1'),
        isNotNull,
      );
      expect(
        DnsRecordValidator.validateContent(type: 'A', content: '2001:db8::1'),
        isNotNull,
      );
    });

    test('validates AAAA record content as IPv6', () {
      expect(
        DnsRecordValidator.validateContent(
            type: 'AAAA', content: '2001:db8::1'),
        isNull,
      );
      expect(
        DnsRecordValidator.validateContent(
            type: 'AAAA', content: '192.168.0.1'),
        isNotNull,
      );
    });

    test('validates CNAME, MX, and NS record content as domain names', () {
      for (final type in ['CNAME', 'MX', 'NS']) {
        expect(
          DnsRecordValidator.validateContent(
            type: type,
            content: 'target.example',
          ),
          isNull,
        );
        expect(
          DnsRecordValidator.validateContent(
            type: type,
            content: 'target.example.',
          ),
          isNull,
        );
        expect(
          DnsRecordValidator.validateContent(
            type: type,
            content: '-invalid.example',
          ),
          isNotNull,
        );
        expect(
          DnsRecordValidator.validateContent(type: type, content: 'localhost'),
          isNotNull,
        );
        expect(
          DnsRecordValidator.validateContent(
            type: type,
            content: '192.168.0.1',
          ),
          isNotNull,
        );
        expect(
          DnsRecordValidator.validateContent(
            type: type,
            content: '2001:db8::1',
          ),
          isNotNull,
        );
      }
    });

    test('accepts non-empty TXT record content', () {
      expect(
        DnsRecordValidator.validateContent(
          type: 'TXT',
          content: 'v=spf1 include:example.com ~all',
        ),
        isNull,
      );
      expect(
        DnsRecordValidator.validateContent(type: 'TXT', content: '   '),
        isNotNull,
      );
    });

    test('validates SRV record content', () {
      expect(
        DnsRecordValidator.validateContent(
          type: 'SRV',
          content: '10 20 443 service.example',
        ),
        isNull,
      );
      expect(
        DnsRecordValidator.validateContent(
          type: 'SRV',
          content: '10 20 70000 service.example',
        ),
        isNotNull,
      );
      expect(
        DnsRecordValidator.validateContent(
          type: 'SRV',
          content: 'service.example',
        ),
        isNotNull,
      );
    });
  });
}
