import '../../domain/models/grounded_answer.dart';
import '../services/enterprise_ai_api_service.dart';

abstract interface class AssistantRepository {
  Future<GroundedAnswer> ask(String question);
}

class NetworkAssistantRepository implements AssistantRepository {
  const NetworkAssistantRepository(this._service);

  final EnterpriseAiApiService _service;

  @override
  Future<GroundedAnswer> ask(String question) async {
    final response = await _service.ask(question);
    return GroundedAnswer(
      answer: response.answer,
      model: response.model,
      sources: response.sources
          .map(
            (source) =>
                KnowledgeSource(title: source.title, score: source.score),
          )
          .toList(growable: false),
    );
  }
}

class DemoAssistantRepository implements AssistantRepository {
  @override
  Future<GroundedAnswer> ask(String question) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return GroundedAnswer(
      answer:
          'A private AI workflow can ground “${question.trim()}” in approved '
          'company data, execute auditable tools, and keep inference inside '
          'your infrastructure.',
      model: 'local-demo / Ollama-ready',
      sources: const [
        KnowledgeSource(title: 'Operations handbook', score: 0.94),
        KnowledgeSource(title: 'Delivery playbook', score: 0.89),
      ],
    );
  }
}
