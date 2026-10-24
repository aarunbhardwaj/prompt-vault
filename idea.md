Perfect! Flutter is an excellent choice for PromptVault. You can build a polished Android app with a consistent UI, local-first architecture, and no backend dependency. We can keep the initial release simple and leave room for iOS later.

## PromptVault — Flutter technology stack

| Component        | Recommendation                              |
| ---------------- | ------------------------------------------- |
| Framework        | Flutter                                     |
| Language         | Dart                                        |
| State management | Riverpod                                    |
| Local database   | SQLite using `sqflite`                      |
| Navigation       | `go_router`                                 |
| Data models      | `freezed` + `json_serializable`             |
| Clipboard        | `clipboard` via `flutter/services.dart`     |
| Import/export    | JSON with `file_picker` and `path_provider` |
| Testing          | `flutter_test`                              |
| Backend          | None for v1                                 |

## Suggested project structure

```
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── database/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── prompts/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── categories/
│   ├── favorites/
│   └── settings/
└── main.dart
```

## MVP screens

[FurAI - AI Generate Prompt App by Dipa Product for Dipa Inhouse on Dribbble](https://images.openai.com/static-rsc-4/83LncaUKoRMbKYfxFkkusPpWfNyFJ68TMLGrKrjUUj_3NFDME_-0kSTWzbRpPtznG7fDflaykT0g6npHbtanBwzrUulmCVjLfNSkLHoAV6iLrL3BdepdmxgPxKPhanivSblfh3eWpHl9Hw9NwJ_N00WpuiClH_gjZBQAd48RqSQ?purpose=inline)

1\. Home / Library

Search, category filters, prompt cards, favorites and a floating add button.

[Ollama Mobile. Native Ollama Client for iPhone & Android](https://images.openai.com/static-rsc-4/6JLIjdz33bMaTDxhlIgfUs3H6dnFQSel_RucUJEWIROsTbPgTqKOIjG8peGIoJTmJ6nQgLLh__iodfnHGdAiUACnVFW2WhakNDJEW7t0Lh2BKr9uFUY0TAYnwgjYj5xz_419yc0PkpB7_yVz5Xa_r9Fd1cE-0HkFOTnXfmBeMSA?purpose=inline)

2\. Prompt editor

Title, prompt body, category, tags and variable placeholders such as `{{topic}}`.

[Ai Prompt App Ui Light & Dart by MD Samim on Dribbble](https://images.openai.com/static-rsc-4/a96GNN_6ApfB-LIftAT7s9QCqNV1W4YdgfkNynUXkPaMwkKGew7YgoERoNrRqJUSoCG40KfVO4sG5BJR1cPGx8PrvCFDVLAjVjtH-CuZrtnoiRRajUS73QZ3zJ-aZphCF-txEv3ouXYhVQZZJZOq6wS82HzQCmyLM_QehTFtfDI?purpose=inline)

3\. Prompt runner

Fill variables, preview the completed prompt and copy it to the clipboard.

## Build order

1. Create the Flutter project and establish the theme and navigation.
2. Implement the SQLite schema and prompt CRUD operations.
3. Add search, categories, tags and favorites.
4. Implement variable substitution and clipboard copying.
5. Add JSON import/export and bundled starter prompts.
6. Test offline behavior and prepare the Play Store release.

One architectural recommendation: keep prompt processing independent of Flutter widgets. That will make it easier to add prompt versioning, evaluation, reusable templates and AI integrations in later releases without rewriting the core.

I'd start with the database schema and core data models, then build the screens around them.