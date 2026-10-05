import 'package:flutter/material.dart';

import '../../../../domain/models/grounded_answer.dart';
import '../../../core/app_theme.dart';
import '../view_models/assistant_view_model.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key, required this.viewModel});

  final AssistantViewModel viewModel;

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final _questionController = TextEditingController(
    text: 'How can we automate customer support without sending data outside?',
  );

  @override
  void dispose() {
    _questionController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final overview = const ProjectOverview();
            final workspace = QuestionWorkspace(
              viewModel: widget.viewModel,
              controller: _questionController,
            );

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: EdgeInsets.all(isWide ? 32 : 18),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Expanded(flex: 4, child: ProjectOverview()),
                            const SizedBox(width: 24),
                            Expanded(flex: 6, child: workspace),
                          ],
                        )
                      : ListView(
                          children: [
                            SizedBox(height: 480, child: overview),
                            const SizedBox(height: 18),
                            SizedBox(height: 650, child: workspace),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProjectOverview extends StatelessWidget {
  const ProjectOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102A43), Color(0xFF005B57)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'FLUTTER · ENTERPRISE AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Private AI, available on every screen.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A production-shaped client for local LLMs, RAG and auditable '
            'business workflows — shared across mobile, web and desktop.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.5,
            ),
          ),
          const Spacer(),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              CapabilityChip(label: 'Local LLM'),
              CapabilityChip(label: 'RAG'),
              CapabilityChip(label: 'REST API'),
              CapabilityChip(label: 'MVVM'),
            ],
          ),
        ],
      ),
    );
  }
}

class CapabilityChip extends StatelessWidget {
  const CapabilityChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class QuestionWorkspace extends StatelessWidget {
  const QuestionWorkspace({
    super.key,
    required this.viewModel,
    required this.controller,
  });

  final AssistantViewModel viewModel;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ask your knowledge base',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Offline demo by default. Connect the FastAPI gateway with a dart-define.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Ask a business question…',
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: viewModel.status == AssistantStatus.loading
                        ? null
                        : () => viewModel.submit(controller.text),
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Generate grounded answer'),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(child: _buildResult(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    return switch (viewModel.status) {
      AssistantStatus.idle => const EmptyState(),
      AssistantStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      AssistantStatus.failure => Center(
        child: Text(
          viewModel.errorMessage ?? 'The request failed.',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
      AssistantStatus.success => AnswerCard(answer: viewModel.answer!),
    };
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hub_outlined,
            size: 42,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text('Your cited answer will appear here.'),
        ],
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  const AnswerCard({super.key, required this.answer});

  final GroundedAnswer answer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            const Icon(Icons.verified_outlined, color: AppTheme.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                answer.model,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          answer.answer,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
        ),
        const SizedBox(height: 20),
        Text('Sources', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ...answer.sources.map(
          (source) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.description_outlined),
            title: Text(source.title),
            trailing: Text('${(source.score * 100).round()}%'),
          ),
        ),
      ],
    );
  }
}
