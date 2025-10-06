abstract class Failure {
  final String message;
  Failure({required this.message});
}

class FormatException extends Failure {
  FormatException({required super.message});
}

class SocketException extends Failure {
  SocketException({required super.message});
}

class UnKnownException extends Failure {
  UnKnownException({required super.message});
}

class ClientException extends Failure {
  ClientException({required super.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

