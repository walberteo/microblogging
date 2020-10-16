import 'package:meta/meta.dart';

import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:microblogging/data/http/http.dart';

class RemoteLoadNews {
  final HttpClient httpClient;
  final String url;

  RemoteLoadNews({@required this.httpClient, @required this.url});

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadNews sut;
  HttpClientSpy httpClient;
  String url;

  List<Map> mockValidData() => [
        {
          "user": {
            "name": "O Boticário",
            "profile_picture":
                "https://pbs.twimg.com/profile_images/1240676323913347074/Gg09hEPx_400x400.jpg"
          },
          "message": {
            "content":
                "Além disso, nossos funcionários e familiares receberão kits de proteção. Afinal, o cuidado começa aqui dentro, né?",
            "created_at": "2020-02-02T16:10:33Z"
          }
        },
      ];

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadNews(httpClient: httpClient, url: url);
  });

  test('Deve chamar HttpCliente com a url e método correta', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Deve retornar as news em 200', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => mockValidData());

    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}
