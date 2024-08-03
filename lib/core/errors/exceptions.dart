import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});

  // the types of the exception depend on the server we are using
  // So we need to know beforehand what the server will return
  final String message;
  final String statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException extends Equatable implements Exception {
  // status code 500 is default so we know it's a cache exception
  const CacheException({required this.message, this.statusCode = 500});
  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
