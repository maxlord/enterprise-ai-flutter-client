# Enterprise AI Flutter Client

A production-shaped Flutter client for private enterprise AI: local LLMs, RAG, auditable answers and business workflow automation across Android, iOS, web and macOS.

This repository demonstrates the client side of a complete AI delivery cycle. It works in offline demo mode immediately and can connect to the companion [Enterprise AI Platform Showcase](https://github.com/maxlord/enterprise-ai-platform-showcase) through its FastAPI gateway.

## What it demonstrates

- one responsive Flutter interface for mobile, web and desktop;
- feature-first MVVM with separate UI, data and domain layers;
- typed REST integration through `package:http`;
- repository abstraction for offline demos and real infrastructure;
- grounded answers with source confidence scores;
- local/private inference readiness via the companion Ollama stack;
- unit tests for state management and API boundaries;
- an opt-in GitHub Actions workflow for pull requests and manual runs.

## Run the offline demo

```bash
flutter pub get
flutter run -d chrome
```

## Connect a real API

Start the [platform showcase](https://github.com/maxlord/enterprise-ai-platform-showcase), then provide its base URL at build time:

```bash
flutter run -d chrome \
  --dart-define=ENTERPRISE_AI_API_URL=http://localhost:8080
```

For an Android emulator use the host address appropriate to your environment, commonly `http://10.0.2.2:8080`.

## Architecture

```text
lib/
├── data/
│   ├── models/          # typed API DTOs
│   ├── repositories/    # demo/network implementations
│   └── services/        # HTTP boundary
├── domain/models/       # app-facing entities
└── ui/
    ├── core/            # theme
    └── features/assistant/
        ├── view_models/ # state and orchestration
        └── views/       # responsive UI
```

The UI depends on `AssistantRepository`, not on HTTP. That keeps the app testable and makes it straightforward to replace the REST gateway with GraphQL, gRPC or an embedded inference adapter.

## Verify locally

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release
```

The workflow in `.github/workflows/ci.yml` does not run on every push. It runs only for pull requests or when started manually, keeping hosted runner usage under your control and remaining compatible with self-hosted runners.

## Related showcase

- [Enterprise AI Platform Showcase](https://github.com/maxlord/enterprise-ai-platform-showcase) — FastAPI, local LLM, RAG, Telegram, observability and delivery.
- [Enterprise AI KMP Client](https://github.com/maxlord/enterprise-ai-kmp-client) — shared Kotlin/Compose client for iOS and desktop.

## License

MIT
