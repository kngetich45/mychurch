class CommentsException implements Exception {
  final String errorMessageCode;

 CommentsException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
