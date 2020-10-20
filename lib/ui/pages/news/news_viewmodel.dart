import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NewsViewModel extends Equatable {
  final String name;
  final String content;
  final String createAt;

  NewsViewModel({
    @required this.name,
    @required this.content,
    @required this.createAt,
  });

  List<Object> get props => [name, content, createAt];
}
