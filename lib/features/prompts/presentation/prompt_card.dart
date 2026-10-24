import 'package:flutter/material.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

class PromptCard extends StatelessWidget {
  const PromptCard({
    super.key,
    required this.prompt,
    required this.onTap,
    required this.onEdit,
  });

  final Prompt prompt;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prompt.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                prompt.isFavorite ? Icons.star : Icons.star_border,
                color: prompt.isFavorite
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
