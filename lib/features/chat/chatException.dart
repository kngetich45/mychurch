class ChatException implements Exception {
  final String errorMessageCode;

  ChatException({required this.errorMessageCode});
  @override
  String toString() => errorMessageCode;
}
