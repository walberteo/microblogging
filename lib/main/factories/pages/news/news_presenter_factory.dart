import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/pages.dart';
import 'load_news_factory.dart';

NewsPresenter makeGetxNewsPresenter() {
  return GetxNewsPresenter(
    loadNews: makeRemoteLoadNews(),
  );
}
