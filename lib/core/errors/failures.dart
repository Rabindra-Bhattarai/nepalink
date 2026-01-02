import 'package:equatable/equatable.dart';

/// Base Failure class for handling errors across the app
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure related to local Hive database operations
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({String message = "Local Database Failure"})
    : super(message);
}

/// Failure related to API/network operations
class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({String message = "API Failure", this.statusCode})
    : super(message);

  @override
  List<Object> get props => [message, statusCode ?? -1];
}
