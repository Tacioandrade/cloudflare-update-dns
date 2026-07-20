class DnsRecordFilter {
  const DnsRecordFilter._();

  static List<dynamic> apply({
    required Iterable<dynamic> records,
    String searchQuery = '',
    Set<String> selectedTypes = const {},
    Set<bool> selectedProxyStates = const {},
  }) {
    final normalizedSearch = searchQuery.toLowerCase();
    final normalizedTypes =
        selectedTypes.map((type) => type.toUpperCase()).toSet();

    return records.where((record) {
      final type = record['type'].toString();
      if (normalizedTypes.isNotEmpty &&
          !normalizedTypes.contains(type.toUpperCase())) {
        return false;
      }

      final isProxied = record['proxied'] == true;
      if (selectedProxyStates.isNotEmpty &&
          !selectedProxyStates.contains(isProxied)) {
        return false;
      }

      return record['name']
              .toString()
              .toLowerCase()
              .contains(normalizedSearch) ||
          record['content']
              .toString()
              .toLowerCase()
              .contains(normalizedSearch) ||
          type.toLowerCase().contains(normalizedSearch);
    }).toList();
  }
}
