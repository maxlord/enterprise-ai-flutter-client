import 'package:enterprise_ai_flutter_client/data/repositories/assistant_repository.dart';
import 'package:enterprise_ai_flutter_client/ui/features/assistant/view_models/assistant_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('blank questions are rejected without changing state', () async {
    final viewModel = AssistantViewModel(repository: DemoAssistantRepository());

    await viewModel.submit('   ');

    expect(viewModel.status, AssistantStatus.idle);
    expect(viewModel.history, isEmpty);
  });

  test(
    'demo repository returns a grounded answer and records history',
    () async {
      final viewModel = AssistantViewModel(
        repository: DemoAssistantRepository(),
      );

      await viewModel.submit('Automate invoice review');

      expect(viewModel.status, AssistantStatus.success);
      expect(viewModel.answer?.sources, hasLength(2));
      expect(viewModel.history, ['Automate invoice review']);
    },
  );
}
