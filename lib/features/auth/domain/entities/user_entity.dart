import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? profilePic;
  final String? token;

  const UserEntity({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.profilePic,
    this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
