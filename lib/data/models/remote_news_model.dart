import 'package:meta/meta.dart';

import 'package:microblogging/data/http/http.dart';
import 'package:microblogging/data/models/models.dart';
import 'package:microblogging/domain/entities/entities.dart';

class RemoteNewsModel {
  final RemoteUserModel user;
  final RemoteMessage message;

  RemoteNewsModel({@required this.user, @required this.message});

  factory RemoteNewsModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll({'user', 'message'})) {
      throw HttpError.invalidData;
    }
    return RemoteNewsModel(
        user: RemoteUserModel.fromJson(json['user']),
        message: RemoteMessage.fromJson(json['message']));
  }

  NewsEntity toEntity() => NewsEntity(
      user: UserEntity(
        name: user.name,
        profilePicture: user.profilePicture,
      ),
      message: MessageEntity(
        content: message.content,
        createAt: DateTime.parse(message.createdAt),
      ));
}
