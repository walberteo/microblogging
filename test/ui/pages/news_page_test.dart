import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

import 'package:microblogging/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class NewsPresenterSpy extends Mock implements NewsPresenter {}

void main() {
  testWidgets('deve chamar loadData no carregamento da pagina',
      (WidgetTester tester) async {
    final presenter = NewsPresenterSpy();
    final serverysPage = GetMaterialApp(
      initialRoute: '/news',
      getPages: [
        GetPage(name: '/news', page: () => NewsPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(serverysPage);

    verify(presenter.loadData()).called(1);
  });
}
