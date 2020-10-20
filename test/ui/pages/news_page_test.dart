import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

import 'package:microblogging/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class NewsPresenterSpy extends Mock implements NewsPresenter {}

void main() {
  NewsPresenterSpy presenter;
  StreamController<bool> isLoadingController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
  }

  void closeStreams() {
    isLoadingController.close();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
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

  tearDown(() {
    closeStreams();
  });

  testWidgets('deve chamar loadData no carregamento da pagina',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Deve mostrar loading corretamente', (WidgetTester tester) async {
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
}
