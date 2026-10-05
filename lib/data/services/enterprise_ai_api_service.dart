import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ask_response_model.dart';

class EnterpriseAiApiException implements Exception {
  const EnterpriseAiApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class EnterpriseAiApiService {
  EnterpriseAiApiService({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final Uri baseUrl;
  final http.Client _client;

  Future<AskResponseApiModel> ask(String question) async {
    final endpoint = baseUrl.resolve('/v1/ask');
    final response = await _client.post(
      endpoint,
      headers: const {'content-type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw EnterpriseAiApiException(
        'AI gateway returned HTTP ${response.statusCode}',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, Object?>) {
      throw const EnterpriseAiApiException('AI gateway returned invalid JSON');
    }
    return AskResponseApiModel.fromJson(body);
  }
}
