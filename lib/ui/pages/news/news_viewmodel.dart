import 'package:meta/meta.dart';

class NewsViewModel {
  final String name;
  final String content;
  final String createAt;

  NewsViewModel({
    @required this.name,
    @required this.content,
    @required this.createAt,
  });
}
