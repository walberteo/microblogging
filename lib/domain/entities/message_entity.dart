import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String content;
  final DateTime createAt;

  MessageEntity({@required this.content, @required this.createAt});

  List<Object> get props => [content, createAt];
}
