import 'package:meta/meta.dart';

class RemoteMessage {
  final String content;
  final String createdAt;

  RemoteMessage({@required this.content, @required this.createdAt});

  factory RemoteMessage.fromJson(Map json) {
    print(json);
    return RemoteMessage(
        content: json['content'], createdAt: json['created_at']);
  }
}
