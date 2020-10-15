import 'package:meta/meta.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadNews {
  final HttpClient httpClient;
  final String url;

  RemoteLoadNews({@required this.httpClient, @required this.url});

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

abstract class HttpClient {
  Future<void> request({@required String url, @required String method});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadNews sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadNews(httpClient: httpClient, url: url);
  });

  test('Deve chamar HttpCliente com a url e método correta', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}
