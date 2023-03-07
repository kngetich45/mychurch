class HymnsException implements Exception {
  final String errorMessageCode;

  HymnsException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
