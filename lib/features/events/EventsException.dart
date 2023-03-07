class EventsException implements Exception {
  final String errorMessageCode;

 EventsException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
