import 'dart:convert';

import 'package:enterprise_ai_flutter_client/data/services/enterprise_ai_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('posts a question and parses a typed response', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/v1/ask');
      expect(jsonDecode(request.body), {'question': 'What changed?'});
      return http.Response(
        jsonEncode({
          'answer': 'The release is ready.',
          'model': 'llama3.2',
          'sources': [
            {'title': 'Release notes', 'score': 0.96},
          ],
        }),
        200,
      );
    });
    final service = EnterpriseAiApiService(
      baseUrl: Uri.parse('https://ai.example.com'),
      client: client,
    );

    final response = await service.ask('What changed?');

    expect(response.answer, 'The release is ready.');
    expect(response.sources.single.title, 'Release notes');
  });

  test('throws a clear exception for a failing gateway', () async {
    final service = EnterpriseAiApiService(
      baseUrl: Uri.parse('https://ai.example.com'),
      client: MockClient((_) async => http.Response('unavailable', 503)),
    );

    await expectLater(
      service.ask('Health check'),
      throwsA(isA<EnterpriseAiApiException>()),
    );
  });
}
