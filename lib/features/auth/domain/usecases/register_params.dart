import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? profilePic;
  final String? token;
  final String? role;

  const RegisterParams({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.profilePic,
    this.token,
    this.role,
  });

  @override
  List<Object?> get props => [
    userid,
    name,
    email,
    phone,
    password,
    profilePic,
    token,
    role,
  ];
}
