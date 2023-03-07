class GivingException implements Exception {
  final String errorMessageCode;

  GivingException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
