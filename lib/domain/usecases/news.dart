import 'package:microblogging/domain/entities/news_entity.dart';

abstract class News {
  Future<List<NewsEntity>> call();
}
