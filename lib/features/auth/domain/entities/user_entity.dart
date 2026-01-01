import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String countryCode;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [id, email, phone];
}
