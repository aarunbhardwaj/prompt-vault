import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/core/utils/prompt_template.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';

/// Display label for a `{{variable}}` name in the runner.
String humanizeVariableName(String name) {
  final parts = name.split('_').where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) {
    return name;
  }
  return parts
      .asMap()
      .entries
      .map((entry) {
        final lower = entry.value.toLowerCase();
        if (entry.key == 0) {
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        }
        return lower;
      })
      .join(' ');
}

class PromptRunnerScreen extends ConsumerStatefulWidget {
  const PromptRunnerScreen({super.key, required this.promptId});

  final String promptId;

  @override
  ConsumerState<PromptRunnerScreen> createState() => _PromptRunnerScreenState();
}

class _PromptRunnerScreenState extends ConsumerState<PromptRunnerScreen> {
  final _values = <String, String>{};

  @override
  Widget build(BuildContext context) {
    final asyncPrompt = ref.watch(promptByIdProvider(widget.promptId));

    return asyncPrompt.when(
      data: (prompt) {
        if (prompt == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Run prompt')),
            body: const Center(child: Text('Prompt not found')),
          );
        }

        final variables = extractVariables(prompt.body);
        final preview = substitute(prompt.body, _values);

        return Scaffold(
          appBar: AppBar(
            title: Text(prompt.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (variables.isNotEmpty) ...[
                Text(
                  'Variables',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final name in variables) ...[
                  TextField(
                    key: ValueKey(name),
                    decoration: InputDecoration(
                      labelText: humanizeVariableName(name),
                    ),
                    onChanged: (value) {
                      setState(() => _values[name] = value);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ],
              const SizedBox(height: 8),
              Text('Preview', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SelectableText(
                preview,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Run prompt')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Run prompt')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
