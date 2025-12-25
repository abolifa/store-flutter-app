class ApiException implements Exception {
  final String message;
  final bool isTimeout;
  final bool isNetwork;

  ApiException(this.message, {this.isTimeout = false, this.isNetwork = false});

  @override
  String toString() => message;
}
