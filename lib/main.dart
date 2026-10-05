import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/assistant_repository.dart';
import 'data/services/enterprise_ai_api_service.dart';
import 'ui/features/assistant/view_models/assistant_view_model.dart';

void main() {
  const apiUrl = String.fromEnvironment('ENTERPRISE_AI_API_URL');
  final AssistantRepository repository = apiUrl.isEmpty
      ? DemoAssistantRepository()
      : NetworkAssistantRepository(
          EnterpriseAiApiService(baseUrl: Uri.parse(apiUrl)),
        );

  runApp(
    EnterpriseAiApp(viewModel: AssistantViewModel(repository: repository)),
  );
}
