import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:microblogging/ui/helpers/helpers.dart';

import 'package:microblogging/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class NewsPresenterSpy extends Mock implements NewsPresenter {}

void main() {
  NewsPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<NewsViewModel>> loadNewsController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadNewsController = StreamController<List<NewsViewModel>>();
  }

  void closeStreams() {
    isLoadingController.close();
    loadNewsController.close();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.loadNewsStream).thenAnswer((_) => loadNewsController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = NewsPresenterSpy();
    initStreams();
    mockStreams();
    final serverysPage = GetMaterialApp(
      initialRoute: '/news',
      getPages: [
        GetPage(name: '/news', page: () => NewsPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(serverysPage);
  }

  List<NewsViewModel> makeNews() => [
        NewsViewModel(
            name: 'O Boticário', content: 'any_content', createAt: 'any_date')
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('deve chamar loadData no carregamento da pagina',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('deve mostrar loading corretamente', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('deve mostrar o erro se loadNewsStream falhar',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadNewsController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo de errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('O Boticário'), findsNothing);
  });

  testWidgets('deve mostrar a lista se loadNewsStream tiver sucesso',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadNewsController.add(makeNews());
    await tester.pump();

    expect(find.text('Algo de errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('O Boticário'), findsOneWidget);
  });
}
