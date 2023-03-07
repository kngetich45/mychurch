class DevotionalsException implements Exception {
  final String errorMessageCode;

 DevotionalsException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
