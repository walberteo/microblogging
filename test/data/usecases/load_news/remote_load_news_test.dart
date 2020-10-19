import 'package:meta/meta.dart';
import 'package:microblogging/domain/helpers/helpers.dart';

import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:microblogging/data/models/models.dart';
import 'package:microblogging/data/http/http.dart';
import 'package:microblogging/domain/entities/entities.dart';

class RemoteLoadNews {
  final HttpClient<List<Map>> httpClient;
  final String url;

  RemoteLoadNews({@required this.httpClient, @required this.url});

  Future<List<NewsEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse
          .map((json) => RemoteNewsModel.fromJson(json).toEntity())
          .toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

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
}
