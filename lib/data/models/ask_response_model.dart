class SourceApiModel {
  const SourceApiModel({required this.title, required this.score});

  factory SourceApiModel.fromJson(Map<String, Object?> json) {
    return SourceApiModel(
      title: json['title'] as String? ?? 'Internal knowledge',
      score: (json['score'] as num?)?.toDouble() ?? 0,
    );
  }

  final String title;
  final double score;
}

class AskResponseApiModel {
  const AskResponseApiModel({
    required this.answer,
    required this.model,
    required this.sources,
  });

  factory AskResponseApiModel.fromJson(Map<String, Object?> json) {
    final rawSources = json['sources'] as List<Object?>? ?? const [];
    return AskResponseApiModel(
      answer: json['answer'] as String? ?? '',
      model: json['model'] as String? ?? 'unknown',
      sources: rawSources
          .whereType<Map<String, Object?>>()
          .map(SourceApiModel.fromJson)
          .toList(growable: false),
    );
  }

  final String answer;
  final String model;
  final List<SourceApiModel> sources;
}
