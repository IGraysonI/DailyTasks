# Domain Structure — DailyTasks

## Overview

The application is divided into several bounded contexts, each responsible for a separate area of business logic. Contexts interact through clearly defined interfaces.

## Bounded Contexts

### 1. Daily Tasks

**Path:** `app/lib/src/feature/daily_tasks`

**Responsibilities:**
- Managing daily tasks
- Creating, editing, and deleting tasks
- Tracking completion status (completed/incomplete)
- Resetting tasks at the start of a new day

**Core entities:**
- `DailyTaskModel` — task model with fields: id, title, description, weight, isCompleted, createdAt, completedAt

**Layers:**
```
daily_tasks/
├── data/
│   ├── repository/        # DailyTasksRepository
│   └── source/            # DailyTasksLocalDataSource
├── control/               # DailyTasksController
└── widget/                # DailyTasksPage, TaskCard, etc.
```

**Repository interface:**
```dart
abstract class DailyTasksRepository {
  Future<List<DailyTaskModel>> getDailyTasks();
  Future<DailyTaskModel?> getDailyTaskById(int id);
  Future<void> createDailyTask(DailyTaskModel task);
  Future<void> updateDailyTask(DailyTaskModel task);
  Future<void> deleteDailyTask(int id);
  Future<void> deleteAllDailyTasks();
  Future<void> toggleTaskCompletetion(int id);
  Future<void> resetDailyTasks();
}
```

**Entry points (Ports):**
- `DailyTasksController` — state management and task operations

---

### 2. Weekly Tasks

**Path:** `app/lib/src/feature/weekly_tasks`

**Responsibilities:**
- Managing weekly tasks
- Same as daily tasks, but with a weekly cycle
- Resetting tasks at the start of the week

**Core entities:**
- `WeeklyTaskModel` — analogous to DailyTaskModel

**Repository interface:**
```dart
abstract class WeeklyTasksRepository {
  Future<List<WeeklyTaskModel>> getWeeklyTasks();
  Future<WeeklyTaskModel?> getWeeklyTaskById(int id);
  Future<void> createWeeklyTask(WeeklyTaskModel task);
  Future<void> updateWeeklyTask(WeeklyTaskModel task);
  Future<void> deleteWeeklyTask(int id);
  Future<void> deleteAllWeeklyTasks();
  Future<void> toggleTaskCompletetion(int id);
  Future<void> resetWeeklyTasks();
}
```

---

### 3. Daily Task Rewards

**Path:** `app/lib/src/feature/daily_task_rewards`

**Responsibilities:**
- Calculating rewards for completed daily tasks
- Tracking the weight of tasks completed during the day
- Checking the daily weight limit

**Core entities:**
- `DailyRewardModel` — contains totalWeight, completedWeight, remainingWeight, date

**Dependencies:**
- **Daily Tasks** — getting the list of completed tasks and their weight

**Repository interface:**
```dart
abstract class DailyTaskRewardsRepository {
  Future<DailyRewardModel> getDailyReward();
  Future<int> getTotalWeight(DateTime date);
  Future<int> getCompletedWeight(DateTime date);
  Future<int> getRemainingWeight(DateTime date);
  Future<bool> canCompleteTask(int taskWeight);
}
```

---

### 4. Weekly Task Rewards

**Path:** `app/lib/src/feature/weekly_task_rewards`

**Responsibilities:**
- Calculating rewards for completed weekly tasks
- Same as Daily Task Rewards, but per week

**Core entities:**
- `WeeklyRewardModel` — analogous to DailyRewardModel

**Dependencies:**
- **Weekly Tasks** — getting the list of completed tasks and their weight

---

### 5. Settings

**Path:** `app/lib/src/feature/settings`

**Responsibilities:**
- Managing user settings
- Language, theme, notifications, limits

**Core entities:**
- `SettingsModel` — language, theme, notifications enabled, daily weight limit, weekly weight limit

**Repository interface:**
```dart
abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings(SettingsModel settings);
  Stream<SettingsModel> watchSettings();
}
```

**Entry points:**
- `ApplicationSettingsScope` — provides settings to the entire application

---

### 6. Developer (Developer Tools)

**Path:** `app/lib/src/feature/developer`

**Responsibilities:**
- Debugging tools
- Logging, database inspection, test data

**Available only in DEBUG mode**

---

## Interaction Between Contexts

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation (Widget)                │
├─────────────────────────────────────────────────────────┤
│  Daily Tasks   │  Weekly Tasks  │  Settings  │ Developer│
├─────────────────────────────────────────────────────────┤
│         Control / State Management Layer                 │
├─────────────────────────────────────────────────────────┤
│  Daily Task         Weekly Task       Daily Task         │
│  Rewards Repo  +  Rewards Repo   +    Settings Repo      │
├─────────────────────────────────────────────────────────┤
│         Repository / Business Logic Layer                │
├─────────────────────────────────────────────────────────┤
│  Daily Task    │  Weekly Task   │  Settings   │ Database │
│  Data Source   │  Data Source   │ Data Source │  Source  │
├─────────────────────────────────────────────────────────┤
│                  Database (Drift)                        │
└─────────────────────────────────────────────────────────┘
```

### Daily Task Rewards depends on Daily Tasks:

```dart
// daily_task_rewards/data/source/daily_task_rewards_source.dart
class DailyTaskRewardsLocalDataSource {
  final DailyTasksRepository _dailyTasksRepository;
  
  Future<int> getCompletedWeight() async {
    final tasks = await _dailyTasksRepository.getDailyTasks();
    return tasks
        .where((t) => t.isCompleted)
        .fold<int>(0, (sum, t) => sum + t.weight);
  }
}
```

### Settings are provided through ApplicationSettingsScope:

```dart
// common/widget/application_settings_scope.dart
class ApplicationSettingsScope extends StatelessWidget {
  final Widget child;
  
  const ApplicationSettingsScope({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final settingsRepository = context.read<SettingsRepository>();
    // Provide settings as a provider/scope
    return child;
  }
}
```

## Interaction Rules

1. **Minimal coupling:** contexts communicate only through Repository interfaces
2. **One-way direction:** Daily Task Rewards → Daily Tasks (not the other way around)
3. **Data exchange:** only through models, not through entities from other contexts
4. **No circular dependencies:** if A depends on B, then B must not depend on A

## Shared Packages

Shared packages for use across all contexts:

### database

**Path:** `packages/database`

Database access layer (Drift ORM, DAO objects). Contains:
- `AppDatabase` — the main database
- DAO classes for each table
- Entity models (database counterparts of domain models)
- Mapping between Entity and Domain models

### ui

**Path:** `packages/ui`

Shared UI components and styles:
- Design system components
- Global theme
- Reusable widgets (AppBar, Button, Card, etc.)
- Icons, colors, typography

### localization

**Path:** `packages/localization`

Multi-language support (i18n):
- ARB files for translations
- Generated localization classes
- Support for switching language at runtime

### analytics

**Path:** `packages/analytics`

Analytics collection:
- Event tracking
- Integration with an analytics service
- Logging functions

### client

**Path:** `packages/client`

HTTP client and API integration (if needed):
- API client
- Network requests
- Backend integration

## Extending the Structure

When adding a new bounded context:

1. Create a folder in `app/lib/src/feature/{context_name}`
2. Follow the structure: `data/` → `control/` → `widget/`
3. Define the Repository interface
4. Define the entry points (Ports) for the rest of the application
5. Document its dependencies in this file
6. If shared logic is needed, add it to `packages/`
