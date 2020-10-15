import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String profilePicture;

  UserEntity({@required this.name, @required this.profilePicture});

  List<Object> get props => [name, profilePicture];
}
