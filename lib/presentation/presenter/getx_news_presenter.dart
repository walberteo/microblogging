import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxNewsPresenter implements NewsPresenter {
  final LoadNews loadNews;

  final _isLoading = true.obs;
  final _news = Rx<List<NewsViewModel>>();

  GetxNewsPresenter({@required this.loadNews});

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<NewsViewModel>> get newsStream => _news.stream;

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final news = await loadNews.load();
      _news.value = news
          .map((n) => NewsViewModel(
                name: n.user.name,
                content: n.message.content,
                createAt: DateFormat('dd MMM yyyy').format(n.message.createAt),
              ))
          .toList();
    } on DomainError {
      _news.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
