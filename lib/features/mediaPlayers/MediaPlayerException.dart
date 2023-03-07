class MediaPlayerException implements Exception {
  final String errorMessageCode;

 MediaPlayerException({required this.errorMessageCode, errorMessageKey});

  @override
  String toString() => errorMessageCode;
}
