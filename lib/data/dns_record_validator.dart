class DnsRecordValidator {
  static bool isProxiableType(String type) {
    return {'A', 'AAAA', 'CNAME'}.contains(type.trim().toUpperCase());
  }

  static String? validateContent({
    required String type,
    required String content,
  }) {
    final normalizedType = type.trim().toUpperCase();
    final normalizedContent = content.trim();

    if (normalizedContent.isEmpty) {
      return 'O conteúdo do registro não pode ser vazio.';
    }

    switch (normalizedType) {
      case 'A':
        return _isValidIpv4(normalizedContent)
            ? null
            : 'Registro A exige um IPv4 válido.';
      case 'AAAA':
        return _isValidIpv6(normalizedContent)
            ? null
            : 'Registro AAAA exige um IPv6 válido.';
      case 'CNAME':
        return _isValidDomainName(normalizedContent)
            ? null
            : 'Registro CNAME exige um domínio válido.';
      case 'MX':
        return _isValidDomainName(normalizedContent)
            ? null
            : 'Registro MX exige um domínio válido.';
      case 'NS':
        return _isValidDomainName(normalizedContent)
            ? null
            : 'Registro NS exige um domínio válido.';
      case 'TXT':
        return null;
      case 'SRV':
        return _isValidSrvContent(normalizedContent)
            ? null
            : 'Registro SRV exige o formato: prioridade peso porta domínio.';
      default:
        return null;
    }
  }

  static bool _isValidIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      if (part.isEmpty) return false;
      if (part.length > 1 && part.startsWith('0')) return false;
      if (!RegExp(r'^\d+$').hasMatch(part)) return false;

      final octet = int.tryParse(part);
      if (octet == null || octet < 0 || octet > 255) return false;
    }

    return true;
  }

  static bool _isValidIpv6(String value) {
    try {
      Uri.parseIPv6Address(value);
      return true;
    } on FormatException {
      return false;
    }
  }

  static bool _isValidDomainName(String value) {
    var domain = value.trim().toLowerCase();
    if (domain.endsWith('.')) {
      domain = domain.substring(0, domain.length - 1);
    }

    if (domain.isEmpty || domain.length > 253 || !domain.contains('.')) {
      return false;
    }

    if (_isValidIpv4(domain) || _isValidIpv6(domain)) {
      return false;
    }

    final labels = domain.split('.');
    for (final label in labels) {
      if (label.isEmpty || label.length > 63) return false;
      if (!RegExp(r'^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$').hasMatch(label)) {
        return false;
      }
    }

    return true;
  }

  static bool _isValidSrvContent(String value) {
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length != 4) return false;

    return _isValidUint16(parts[0]) &&
        _isValidUint16(parts[1]) &&
        _isValidUint16(parts[2]) &&
        _isValidDomainName(parts[3]);
  }

  static bool _isValidUint16(String value) {
    if (!RegExp(r'^\d+$').hasMatch(value)) return false;
    final number = int.tryParse(value);
    return number != null && number >= 0 && number <= 65535;
  }
}
