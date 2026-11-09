# Workflow — DailyTasks

## Feature Development Phases

### 1. Planning and Discussion

Before implementation, clarify the requirements:
- Identify the feature's bounded context
- Identify dependencies on other contexts
- Discuss changes to the domain model
- Propose one concrete solution with explicit boundaries of responsibility

**Outcome:** the solution is agreed upon or needs further work.

### 2. Architectural Design

If the feature requires significant architectural changes:
- Record the decision in `documentation/adr/{date}-{name}.md`
- Describe the problem, the solution options, the chosen option, and the consequences

If refactoring is planned as part of the implementation:
- Record it in `documentation/refactoring/{name}.md`
- Do not start implementation without approval

### 3. Implementation

**Layered separation of responsibilities:**

Create layers in this order:

1. **Model** — the feature's domain models (if needed)
2. **Data** — Repository, DataSource, DAO
3. **Control** — state management, business logic
4. **Widget** — UI components and pages

**Strict adherence to the layered chain:**
```
Widget → Control → Repository → DataSource → DAO → Drift
```

Layers are never skipped. Direct calls across layers are forbidden.

### 4. Testing

Cover with tests in order of priority:
1. **Control** — business logic (unit tests)
2. **Data** — Repository, DataSource (unit tests)
3. **Widget** — critical UI scenarios (widget tests)

### 5. Code Review

Review criteria:
- Compliance with the architecture (layering, DDD principles)
- Compliance with `conventions.md` (naming, structure, imports)
- Tests for critical logic
- Error handling (try-catch, null checks)
- Performance and memory leaks
- Documentation of non-trivial logic

### 6. Merging

After approval:
- Make sure CI passes (tests, analysis)
- Update `application/CHANGELOG.md`
- Merge into the main branch

## Updating Documentation

### When the architecture changes

1. Update `documentation/vision.md` if the tech stack or strategy has changed
2. Add an ADR to `documentation/adr/`
3. Update `documentation/architecture/domain_structure.md` if the domain structure has changed

### When the workflow changes

Update `documentation/workflow.md` and `documentation/conventions.md`

### When adding new terms

Add them to `documentation/fmcg_terms.md`

## Branching

**Branch naming:**
- `feature/{feature-name}` — new features
- `fix/{issue-name}` — bugs
- `refactor/{refactor-name}` — refactoring
- `docs/{doc-name}` — documentation

**Examples:**
- `feature/daily-tasks-reset`
- `fix/notification-timing`
- `refactor/database-layer`
- `docs/api-documentation`

## Commits

**Commit message format:**

```
<type>: <subject>

<body>
```

**Types:**
- `feat` — new feature
- `fix` — bug fix
- `refactor` — refactoring without changing functionality
- `docs` — documentation changes
- `test` — adding/changing tests
- `style` — formatting changes (no logic changes)
- `chore` — build, dependency, or configuration changes

**Subject:**
- Written in English (for consistency with the code)
- Start with a verb in the imperative mood
- 50 characters maximum
- No trailing period

**Examples:**
```
feat: add daily task completion toggle
fix: resolve null pointer in task weight calculation
refactor: extract task filtering logic into separate method
docs: update workflow documentation
```

## Releases

**Semantic versioning:** `MAJOR.MINOR.PATCH`

- `MAJOR` — incompatible changes
- `MINOR` — new features (backward compatible)
- `PATCH` — bug fixes

**Release process:**
1. Update the version in `app/pubspec.yaml`
2. Update `application/CHANGELOG.md` with new features and fixes
3. Create a git tag: `v1.2.3`
4. Merge into main
5. Build artifacts for each platform

## Localization

When adding new UI strings:
1. Add the key to `packages/localization/lib/src/l10n/ru.json`
2. Run the localization generator:
   ```bash
   dart pub global run sheety_localization:generate --credentials=credentials.json \
     --sheet=1rAo4H65psLdapV0D8TSAI6aepMgj8oAA2Cvz2HHdZRU \
     --lib=lib \
     --arb=src/l10n \
     --gen=src/generated \
     --prefix=app \
     --format
   ```
3. Commit the generated files

## Code Analysis

Before committing, run:
```bash
dart analyze
```

All errors and warnings must be fixed.

## Formatting

Use the built-in Dart formatter:
```bash
dart format .
```

It runs automatically before each commit (if a pre-commit hook is configured).
