import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String password;

  const UserEntity({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [userid, name, email, phone, password];
}
