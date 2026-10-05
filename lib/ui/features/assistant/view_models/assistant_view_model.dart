import 'package:flutter/foundation.dart';

import '../../../../data/repositories/assistant_repository.dart';
import '../../../../domain/models/grounded_answer.dart';

enum AssistantStatus { idle, loading, success, failure }

class AssistantViewModel extends ChangeNotifier {
  AssistantViewModel({required this.repository});

  final AssistantRepository repository;
  AssistantStatus _status = AssistantStatus.idle;
  GroundedAnswer? _answer;
  String? _errorMessage;
  final List<String> _history = [];

  AssistantStatus get status => _status;
  GroundedAnswer? get answer => _answer;
  String? get errorMessage => _errorMessage;
  List<String> get history => List.unmodifiable(_history);

  Future<void> submit(String question) async {
    final normalized = question.trim();
    if (normalized.isEmpty || _status == AssistantStatus.loading) return;

    _status = AssistantStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _answer = await repository.ask(normalized);
      _history.insert(0, normalized);
      _status = AssistantStatus.success;
    } catch (error) {
      _errorMessage = error.toString();
      _status = AssistantStatus.failure;
    }
    notifyListeners();
  }
}
