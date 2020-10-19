import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:microblogging/infra/infra.dart';
import 'package:microblogging/data/http/http.dart';

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

    void mockError() {
      mockResquest().thenThrow(Exception());
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

    test('deve lançar BadResquesError se o get retornar 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('deve lançar BadResquesError se o get retornar 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('deve lançar UnauthorizedError se o get retornar 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('deve lançar ForbiddenError se get retornar 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('deve lançar NotFoundError se get retornar 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });

    test('deve lançar ServerError se o get retornar 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });

    test('deve lançar ServerError se o get falhar', () async {
      mockError();

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
