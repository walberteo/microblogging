import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

import 'package:microblogging/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class NewsPresenterSpy extends Mock implements NewsPresenter {}

void main() {
  NewsPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = NewsPresenterSpy();
    final serverysPage = GetMaterialApp(
      initialRoute: '/news',
      getPages: [
        GetPage(name: '/news', page: () => NewsPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(serverysPage);
  }

  testWidgets('deve chamar loadData no carregamento da pagina',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
