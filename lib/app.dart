import 'package:flutter/material.dart';

import 'ui/core/app_theme.dart';
import 'ui/features/assistant/view_models/assistant_view_model.dart';
import 'ui/features/assistant/views/assistant_page.dart';

class EnterpriseAiApp extends StatelessWidget {
  const EnterpriseAiApp({super.key, required this.viewModel});

  final AssistantViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enterprise AI Workspace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AssistantPage(viewModel: viewModel),
    );
  }
}
