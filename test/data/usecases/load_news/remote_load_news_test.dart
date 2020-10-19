import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:microblogging/data/http/http.dart';
import 'package:microblogging/data/usecases/usecases.dart';
import 'package:microblogging/domain/entities/entities.dart';
import 'package:microblogging/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  RemoteLoadNews sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  PostExpectation mockResquest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockResquest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockResquest().thenThrow(error);
  }

  List<Map> mockValidData() => [
        {
          "user": {
            "name": faker.person.name(),
            "profile_picture": faker.internet.httpUrl()
          },
          "message": {
            "content": faker.lorem.word(),
            "created_at": faker.date.dateTime().toIso8601String()
          }
        },
        {
          "user": {
            "name": faker.person.name(),
            "profile_picture": faker.internet.httpUrl()
          },
          "message": {
            "content": faker.lorem.word(),
            "created_at": faker.date.dateTime().toIso8601String()
          }
        },
      ];

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadNews(httpClient: httpClient, url: url);
    mockHttpData(mockValidData());
  });

  test('Deve chamar HttpCliente com a url e o método correto', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Deve retornar as news em 200', () async {
    final news = await sut.load();

    expect(
        news,
        list
            .map((n) => NewsEntity(
                user: UserEntity(
                  name: n['user']['name'],
                  profilePicture: n['user']['profile_picture'],
                ),
                message: MessageEntity(
                  content: n['message']['content'],
                  createAt: DateTime.parse(n['message']['created_at']),
                )))
            .toList());
  });

  test(
      'Deve lançar um UnexpectedError se HttpClient retornar 200 com dados inválidos',
      () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve lançar um UnexpectedError se HttpCliente retornar 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve lançar um UnexpectedError se HttpCliente retornar 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve lançar um AccessDeniedError se HttpCliente retornar 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
