import 'package:meta/meta.dart';

import 'package:microblogging/data/http/http.dart';

class RemoteMessage {
  final String content;
  final String createdAt;

  RemoteMessage({@required this.content, @required this.createdAt});

  factory RemoteMessage.fromJson(Map json) {
    if (!json.keys.toSet().containsAll({'content', 'created_at'})) {
      throw HttpError.invalidData;
    }
    return RemoteMessage(
        content: json['content'], createdAt: json['created_at']);
  }
}
