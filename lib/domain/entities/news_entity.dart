import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

import 'message_entity.dart';
import 'user_entity.dart';

class NewsEntity extends Equatable {
  final UserEntity user;
  final MessageEntity message;

  NewsEntity({@required this.user, @required this.message});

  List<Object> get props => [user.props, message.props];
}
