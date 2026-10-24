/// Parses `{{variable}}` placeholders in prompt bodies.
///
/// Variable names: letters, digits, underscore (`[A-Za-z0-9_]+`).
/// Invalid or partial braces (e.g. `{{ bad }}`) are ignored.
library;

final RegExp _variablePattern = RegExp(r'\{\{([A-Za-z0-9_]+)\}\}');

/// Returns unique variable names in first-seen order.
List<String> extractVariables(String template) {
  final seen = <String>{};
  final ordered = <String>[];
  for (final match in _variablePattern.allMatches(template)) {
    final name = match.group(1)!;
    if (seen.add(name)) {
      ordered.add(name);
    }
  }
  return ordered;
}

/// Replaces `{{name}}` with [values][name] when present.
///
/// Keys not in [values] leave the original placeholder text unchanged.
String substitute(String template, Map<String, String> values) {
  return template.replaceAllMapped(_variablePattern, (match) {
    final name = match.group(1)!;
    return values.containsKey(name) ? values[name]! : match.group(0)!;
  });
}
