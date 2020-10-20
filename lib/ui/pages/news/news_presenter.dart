import 'news_viewmodel.dart';

abstract class NewsPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<NewsViewModel>> get loadNewsStream;

  Future<void> loadData();
}
