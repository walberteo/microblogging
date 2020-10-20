import 'package:microblogging/presentation/presenter/presenter.dart';
import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:microblogging/domain/entities/entities.dart';
import 'package:microblogging/domain/helpers/helpers.dart';
import 'package:microblogging/domain/usecases/usecases.dart';
import 'package:microblogging/ui/helpers/helpers.dart';
import 'package:microblogging/ui/pages/news/news.dart';

class LoadNewsSpy extends Mock implements LoadNews {}

void main() {
  GetxNewsPresenter sut;
  LoadNewsSpy loadNews;
  List<NewsEntity> newsVM;

  List<NewsEntity> mockValidData() => [
        NewsEntity(
          user: UserEntity(
            name: faker.person.name(),
            profilePicture: faker.internet.httpUrl(),
          ),
          message: MessageEntity(
            content: faker.lorem.sentence(),
            createAt: DateTime(2020, 10, 19),
          ),
        ),
        NewsEntity(
          user: UserEntity(
            name: faker.person.name(),
            profilePicture: faker.internet.httpUrl(),
          ),
          message: MessageEntity(
            content: faker.lorem.sentence(),
            createAt: DateTime(2020, 02, 01),
          ),
        )
      ];

  PostExpectation mockLoadNewsCall() => when(loadNews.load());

  void mockLoadNews(List<NewsEntity> data) {
    newsVM = data;
    mockLoadNewsCall().thenAnswer((_) async => data);
  }

  void mockLoadNewsError() {
    mockLoadNewsCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    loadNews = LoadNewsSpy();
    sut = GetxNewsPresenter(loadNews: loadNews);
    mockLoadNews(mockValidData());
  });

  test('deve chamar LoadNews no loadData', () async {
    await sut.loadData();

    verify(loadNews.load()).called(1);
  });

  test('deve emitir os eventos corretos em sucesso', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.newsStream.listen(expectAsync1((news) => expect(
          news,
          [
            NewsViewModel(
                name: newsVM[0].user.name,
                content: newsVM[0].message.content,
                createAt: '19 Oct 2020'),
            NewsViewModel(
                name: newsVM[1].user.name,
                content: newsVM[1].message.content,
                createAt: '01 Feb 2020'),
          ],
        )));
    await sut.loadData();
  });

  test('deve emitir os eventos corretos em uma falha', () async {
    mockLoadNewsError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.newsStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
