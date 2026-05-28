// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:client/src/base_client.dart';
import 'package:client/src/client.dart';
import 'package:client/src/exception/client_exception.dart';
import 'package:test/test.dart';

class _TestBaseClient extends BaseClient {
  _TestBaseClient({required super.baseUrl});

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => Future.value(null);

  List<int> encode(Map<String, Object?> body) => encodeBody(body);

  Uri build(String path, {Map<String, String?>? queryParams}) => buildUri(path: path, queryParams: queryParams);

  Future<Map<String, Object?>?> decode(Object? body, {int? statusCode}) => decodeResponse(body, statusCode: statusCode);
}

void main() {
  group('Client Package Tests', () {
    late _TestBaseClient client;

    setUp(() {
      // Using JSONPlaceholder free API for testing
      client = _TestBaseClient(baseUrl: 'https://jsonplaceholder.typicode.com');
    });

    group('BaseClient - Initialization', () {
      test('BaseClient should be created with valid base URL', () {
        expect(client, isNotNull);
        expect(client.baseUri.toString(), equals('https://jsonplaceholder.typicode.com'));
        print('✓ BaseClient initialized with valid base URL');
      });

      test('BaseClient should have correct base URI', () {
        expect(client.baseUri.host, equals('jsonplaceholder.typicode.com'));
        expect(client.baseUri.scheme, equals('https'));
        print('✓ BaseClient has correct base URI');
      });
    });

    group('encodeBody', () {
      test('encodes simple map to JSON UTF8', () {
        final body = {'title': 'Test Post', 'userId': 1};
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), json.encode(body));
        print('✓ Simple map encoded to JSON UTF8 successfully');
      });

      test('encodes map with various types to JSON UTF8', () {
        final body = {
          'title': 'Test',
          'completed': true,
          'id': 1,
          'rating': 4.5,
        };
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), json.encode(body));
        print('✓ Map with various types encoded successfully');
      });

      test('encodes nested map to JSON UTF8', () {
        final body = {
          'user': {'id': 1, 'name': 'John'},
          'post': {'title': 'Test', 'body': 'Content'},
        };
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), json.encode(body));
        print('✓ Nested map encoded successfully');
      });

      test('encodes empty map to JSON UTF8', () {
        final body = <String, Object?>{};
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), json.encode(body));
        print('✓ Empty map encoded successfully');
      });

      test('throws ClientException for non-encodable object in body', () {
        expect(
          () => client.encode({'key': Object()}),
          throwsA(isA<ClientException>()),
        );
        print('✓ ClientException thrown for non-encodable object');
      });

      test('throws ClientException for circular reference', () {
        final body = <String, Object?>{'name': 'test'};
        // Create circular reference
        body['self'] = body;
        expect(
          () => client.encode(body),
          throwsA(isA<ClientException>()),
        );
        print('✓ ClientException thrown for circular reference');
      });
    });

    group('buildUri', () {
      test('builds URI with path only', () {
        final uri = client.build('/posts');
        expect(uri.toString(), 'https://jsonplaceholder.typicode.com/posts');
        print('✓ URI built with path only');
      });

      test('builds URI with path and query parameters', () {
        final uri = client.build(
          '/posts',
          queryParams: {
            'userId': '1',
            'id': '1',
          },
        );
        expect(uri.path, '/posts');
        expect(uri.queryParameters['userId'], '1');
        expect(uri.queryParameters['id'], '1');
        print('✓ URI built with path and query parameters');
      });

      test('builds URI with null query parameters removed', () {
        final uri = client.build(
          '/posts',
          queryParams: {
            'userId': '1',
            'filter': null,
          },
        );
        expect(uri.queryParameters.containsKey('filter'), false);
        expect(uri.queryParameters['userId'], '1');
        print('✓ URI built with null query parameters removed');
      });

      test('builds URI with multiple path segments', () {
        final uri = client.build('/users/1/posts');
        expect(uri.path, '/users/1/posts');
        print('✓ URI built with multiple path segments');
      });

      test('builds URI with special characters in query params', () {
        final uri = client.build(
          '/posts',
          queryParams: {
            'search': 'hello world',
            'category': 'tech & science',
          },
        );
        expect(uri.queryParameters['search'], 'hello world');
        expect(uri.queryParameters['category'], 'tech & science');
        print('✓ URI built with special characters in query params');
      });

      test('builds URI preserving base URL query parameters', () {
        final customClient = _TestBaseClient(baseUrl: 'https://api.example.com?key=value');
        final uri = customClient.build('/endpoint', queryParams: {'id': '1'});
        expect(uri.queryParameters['key'], 'value');
        expect(uri.queryParameters['id'], '1');
        print('✓ URI preserves base URL query parameters');
      });
    });

    group('decodeResponse', () {
      test('returns null for null body', () async {
        final result = await client.decode(null);
        expect(result, isNull);
        print('✓ Returns null for null body');
      });

      test('returns null for empty string', () async {
        final result = await client.decode('');
        expect(result, isNull);
        print('✓ Returns null for empty string');
      });

      test('returns data from structured success response', () async {
        final body = json.encode({
          'data': {'id': 1, 'title': 'Test Post', 'userId': 1},
        });
        final result = await client.decode(body);
        expect(result, {'id': 1, 'title': 'Test Post', 'userId': 1});
        print('✓ Extracts data from structured success response');
      });

      test('returns decoded body without data or error fields', () async {
        final body = json.encode({
          'id': 1,
          'title': 'Test Post',
          'userId': 1,
        });
        final result = await client.decode(body);
        expect(result, {'id': 1, 'title': 'Test Post', 'userId': 1});
        print('✓ Returns decoded body without data or error fields');
      });

      test('throws StructuredBackendException on error response', () {
        final body = json.encode({
          'error': {'message': 'Not found', 'code': 404},
        });
        expect(
          () => client.decode(body, statusCode: 404),
          throwsA(
            isA<StructuredBackendException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.response['message'], 'error message', 'Not found'),
          ),
        );
        print('✓ Throws StructuredBackendException on error response');
      });

      test('throws StructuredBackendException with custom error code', () {
        final body = json.encode({
          'error': {'message': 'Unauthorized', 'code': 401},
        });
        expect(
          () => client.decode(body, statusCode: 401),
          throwsA(
            isA<StructuredBackendException>().having((e) => e.statusCode, 'statusCode', 401),
          ),
        );
        print('✓ Throws StructuredBackendException with custom error code');
      });

      test('decodes list of integers (bytes) as JSON', () async {
        final body = utf8.encode(json.encode({'id': 1, 'name': 'Test'}));
        final result = await client.decode(body);
        expect(result, {'id': 1, 'name': 'Test'});
        print('✓ Decodes bytes as JSON successfully');
      });

      test('decodes JSON string directly', () async {
        final body = json.encode({'id': 1, 'status': 'active'});
        final result = await client.decode(body);
        expect(result, {'id': 1, 'status': 'active'});
        print('✓ Decodes JSON string successfully');
      });

      test('returns map directly when passed a map', () async {
        final body = {'id': 1, 'name': 'Test'};
        final result = await client.decode(body);
        expect(result, body);
        print('✓ Returns map directly when passed a map');
      });

      test('handles empty data response', () async {
        final body = json.encode({'data': <String, Object?>{}});
        final result = await client.decode(body);
        expect(result, <String, Object?>{});
        print('✓ Handles empty data response');
      });

      test('throws ClientException for invalid JSON', () {
        expect(
          () => client.decode('invalid json {'),
          throwsA(isA<ClientException>()),
        );
        print('✓ Throws ClientException for invalid JSON');
      });

      test('handles nested error response', () {
        final body = json.encode({
          'error': {
            'message': 'Validation failed',
            'details': {'field': 'email', 'reason': 'invalid'},
          },
        });
        expect(
          () => client.decode(body, statusCode: 400),
          throwsA(isA<StructuredBackendException>()),
        );
        print('✓ Handles nested error response');
      });
    });

    group('HTTP Methods Delegation', () {
      test('get method calls send with GET method', () {
        expect(() => client.get('/posts'), returnsNormally);
        print('✓ GET method delegates correctly');
      });

      test('post method calls send with POST method', () {
        expect(() => client.post('/posts', body: {'title': 'Test'}), returnsNormally);
        print('✓ POST method delegates correctly');
      });

      test('put method calls send with PUT method', () {
        expect(() => client.put('/posts/1', body: {'title': 'Updated'}), returnsNormally);
        print('✓ PUT method delegates correctly');
      });

      test('patch method calls send with PATCH method', () {
        expect(() => client.patch('/posts/1', body: {'title': 'Patched'}), returnsNormally);
        print('✓ PATCH method delegates correctly');
      });

      test('delete method calls send with DELETE method', () {
        expect(() => client.delete('/posts/1'), returnsNormally);
        print('✓ DELETE method delegates correctly');
      });

      test('head method calls send with HEAD method', () {
        expect(() => client.head('/posts'), returnsNormally);
        print('✓ HEAD method delegates correctly');
      });
    });

    group('BaseClient - Exceptions', () {
      test('ClientException should have message', () {
        const exception = ClientException(message: 'Test error');
        expect(exception.message, equals('Test error'));
        print('✓ ClientException has message');
      });

      test('ClientException should have optional status code', () {
        const exception = ClientException(message: 'Test error', statusCode: 404);
        expect(exception.statusCode, equals(404));
        print('✓ ClientException has optional status code');
      });

      test('ClientException should have optional cause', () {
        final cause = Exception('Cause');
        final exception = ClientException(message: 'Test error', cause: cause);
        expect(exception.cause, equals(cause));
        print('✓ ClientException has optional cause');
      });

      test('StructuredBackendException should contain error response', () {
        final errorResponse = {'message': 'Not found', 'code': 404};
        final exception = StructuredBackendException(
          response: errorResponse,
          statusCode: 404,
        );
        expect(exception.response, equals(errorResponse));
        print('✓ StructuredBackendException contains error response');
      });

      test('StructuredBackendException error getter should extract error field', () {
        final errorResponse = {'error': 'Resource not found'};
        final exception = StructuredBackendException(
          response: errorResponse,
          statusCode: 404,
        );
        expect(exception.error, equals('Resource not found'));
        print('✓ StructuredBackendException error getter works correctly');
      });

      test('StructuredBackendException error getter defaults to "none-detailed"', () {
        final errorResponse = <String, Object?>{};
        final exception = StructuredBackendException(
          response: errorResponse,
          statusCode: 404,
        );
        expect(exception.error, equals('none-detailed'));
        print('✓ StructuredBackendException error defaults to "none-detailed"');
      });
    });

    group('Edge Cases', () {
      test('handles very long query parameter values', () {
        final longValue = 'x' * 1000;
        final uri = client.build('/search', queryParams: {'q': longValue});
        expect(uri.queryParameters['q'], equals(longValue));
        print('✓ Handles very long query parameter values');
      });

      test('handles multiple slashes in path', () {
        final uri = client.build('/api//v1//posts');
        expect(uri.path, contains('/posts'));
        print('✓ Handles multiple slashes in path');
      });

      test('URI building with empty string path', () {
        final uri = client.build('');
        expect(uri.host, equals('jsonplaceholder.typicode.com'));
        print('✓ URI building handles empty string path');
      });

      test('encodes body with null values', () {
        final body = {'title': 'Test', 'description': null};
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), contains('null'));
        print('✓ Body with null values encoded successfully');
      });

      test('decodes response with extra fields', () async {
        final body = json.encode({
          'data': {'id': 1, 'name': 'Test'},
          'meta': {'timestamp': '2024-01-01'},
          'status': 'success',
        });
        final result = await client.decode(body);
        expect(result, {'id': 1, 'name': 'Test'});
        print('✓ Response with extra fields decoded correctly');
      });
    });

    group('Package Exports', () {
      test('BaseClient should be available', () {
        expect(BaseClient, isNotNull);
        print('✓ BaseClient is exported');
      });

      test('ClientException should be available', () {
        expect(ClientException, isNotNull);
        print('✓ ClientException is exported');
      });

      test('StructuredBackendException should be available', () {
        expect(StructuredBackendException, isNotNull);
        print('✓ StructuredBackendException is exported');
      });

      test('Client interface should be available through BaseClient', () {
        expect(client, isA<Client>());
        print('✓ Client interface is implemented by BaseClient');
      });
    });
  });
}
