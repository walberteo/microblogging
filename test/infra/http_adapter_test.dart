import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:microblogging/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({String url, String method}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    var response = Response('', 500);
    try {
      if (method == 'get') {
        response = await client.get(url, headers: headers);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw HttpError.serverError;
    }
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('deve emitir ServerError se um method inválido for informado',
        () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    PostExpectation mockResquest() =>
        when(client.get(any, headers: anyNamed('headers')));

    void mockResponse(int statusCode, {body: '{"any_key":"any_value"}'}) {
      mockResquest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('deve chamar o get com os valores corretos', () async {
      await sut.request(url: url, method: 'get');

      verify(client.get(url, headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      }));
    });

    test('deve devolver os dados se o get retornar 200', () async {
      final response = await sut.request(url: url, method: 'get');

      expect(response, {'any_key': 'any_value'});
    });

    test('deve devolver null se o get retonar 200 mas sem dados', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('deve devolver null se get retornar 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('deve devolver null se get retornar 204 ', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });
  });
}
