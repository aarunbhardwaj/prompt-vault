import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RunnerPlaceholderScreen extends StatelessWidget {
  const RunnerPlaceholderScreen({super.key, required this.promptId});

  final String promptId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run prompt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Runner placeholder for prompt id: $promptId'),
      ),
    );
  }
}
