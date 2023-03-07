class StreamingException implements Exception {
  final String errorMessageCode;

  StreamingException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
