class BibleException implements Exception {
  final String errorMessageCode;

  BibleException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
