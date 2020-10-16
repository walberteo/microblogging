import 'package:microblogging/data/models/models.dart';

import 'package:meta/meta.dart';
import 'package:microblogging/domain/entities/entities.dart';

class RemoteNewsModel {
  final RemoteUserModel user;
  final RemoteMessage message;

  RemoteNewsModel({@required this.user, @required this.message});

  factory RemoteNewsModel.fromJson(Map json) => RemoteNewsModel(
      user: RemoteUserModel.fromJson(json['user']),
      message: RemoteMessage.fromJson(json['message']));

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
