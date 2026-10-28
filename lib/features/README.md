# Feature-first tree

Each feature:
```
lib/features/<name>/
├── data/
│   ├── datasources/   # retrofit clients + remote datasources
│   ├── dtos/          # JSON ↔ Dart DTOs
│   └── repositories/  # repositories_impl (implements domain contracts)
├── domain/
│   ├── entities/      # pure Dart; no Flutter imports (CI-enforced from Phase 9)
│   ├── repositories/  # abstract contracts
│   └── usecases/      # single-method callables
├── logic/             # Cubit/Bloc + state (Equatable)
├── presentation/
│   ├── pages/         # screen widgets
│   └── widgets/       # feature-local widgets
└── README.md          # one-page feature overview
```

Features: `intro`, `auth`, `home`, `search`, `doctor`, `appointment`, `offers`, `profile`, `notification`, `settings`.

Pattern reference: `docs/feature_pattern_dorak.md` (produced at the end of Phase 7).
