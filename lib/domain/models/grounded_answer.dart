class KnowledgeSource {
  const KnowledgeSource({required this.title, required this.score});

  final String title;
  final double score;
}

class GroundedAnswer {
  const GroundedAnswer({
    required this.answer,
    required this.model,
    required this.sources,
  });

  final String answer;
  final String model;
  final List<KnowledgeSource> sources;
}
