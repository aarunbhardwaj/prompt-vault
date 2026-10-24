import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditorPlaceholderScreen extends StatelessWidget {
  const EditorPlaceholderScreen({super.key, this.promptId});

  final String? promptId;

  bool get isEdit => promptId != null;

  @override
  Widget build(BuildContext context) {
    final title = isEdit ? 'Edit prompt' : 'New prompt';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          isEdit
              ? 'Editor placeholder for prompt id: $promptId'
              : 'Editor placeholder (create mode)',
        ),
      ),
    );
  }
}
