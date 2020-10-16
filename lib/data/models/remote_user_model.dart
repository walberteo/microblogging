import 'package:meta/meta.dart';
import 'package:microblogging/data/http/http.dart';

class RemoteUserModel {
  final String name;
  final String profilePicture;

  RemoteUserModel({@required this.name, @required this.profilePicture});

  factory RemoteUserModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll({'name', 'profile_picture'})) {
      throw HttpError.invalidData;
    }
    return RemoteUserModel(
      name: json['name'],
      profilePicture: json['profile_picture'],
    );
  }
}
