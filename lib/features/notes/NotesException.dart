class NotesException implements Exception {
  final String errorMessageCode;

  NotesException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
