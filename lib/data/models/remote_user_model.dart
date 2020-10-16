import 'package:meta/meta.dart';

class RemoteUserModel {
  final String name;
  final String profilePicture;

  RemoteUserModel({@required this.name, @required this.profilePicture});

  factory RemoteUserModel.fromJson(Map json) => RemoteUserModel(
        name: json['name'],
        profilePicture: json['profile_picture'],
      );
}
