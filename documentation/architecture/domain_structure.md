# Структура доменов — DailyTasks

## Обзор

Приложение разделено на несколько bounded contexts, каждый отвечает за отдельную область бизнес-логики. Контексты взаимодействуют через четко определенные интерфейсы.

## Bounded Contexts

### 1. Daily Tasks (Ежедневные задачи)

**Путь:** `app/lib/src/feature/daily_tasks`

**Ответственность:**
- Управление ежедневными задачами
- Создание, редактирование, удаление задач
- Отслеживание статуса выполнения (completed/incomplete)
- Сброс задач в начале нового дня

**Основные сущности:**
- `DailyTaskModel` — модель задачи с полями: id, title, description, weight, isCompleted, createdAt, completedAt

**Слои:**
```
daily_tasks/
├── data/
│   ├── repository/        # DailyTasksRepository
│   └── source/            # DailyTasksLocalDataSource
├── control/               # DailyTasksController
└── widget/                # DailyTasksPage, TaskCard, etc.
```

**Интерфейс Repository:**
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

**Точки входа (Ports):**
- `DailyTasksController` — управление состоянием и операции над задачами

---

### 2. Weekly Tasks (Еженедельные задачи)

**Путь:** `app/lib/src/feature/weekly_tasks`

**Ответственность:**
- Управление еженедельными задачами
- Аналогично ежедневным, но с недельным циклом
- Сброс задач в начало недели

**Основные сущности:**
- `WeeklyTaskModel` — аналогично DailyTaskModel

**Интерфейс Repository:**
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

### 3. Daily Task Rewards (Награды за ежедневные задачи)

**Путь:** `app/lib/src/feature/daily_task_rewards`

**Ответственность:**
- Вычисление наград за выполненные ежедневные задачи
- Отслеживание веса выполненных задач за день
- Проверка лимита дневного веса

**Основные сущности:**
- `DailyRewardModel` — содержит totalWeight, completedWeight, remainingWeight, date

**Зависимости:**
- **Daily Tasks** — получение списка выполненных задач и их веса

**Интерфейс Repository:**
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

### 4. Weekly Task Rewards (Награды за еженедельные задачи)

**Путь:** `app/lib/src/feature/weekly_task_rewards`

**Ответственность:**
- Вычисление наград за выполненные еженедельные задачи
- Аналогично Daily Task Rewards, но за неделю

**Основные сущности:**
- `WeeklyRewardModel` — аналогично DailyRewardModel

**Зависимости:**
- **Weekly Tasks** — получение списка выполненных задач и их веса

---

### 5. Settings (Настройки)

**Путь:** `app/lib/src/feature/settings`

**Ответственность:**
- Управление пользовательскими настройками
- Язык, тема оформления, notifications, лимиты

**Основные сущности:**
- `SettingsModel` — язык, тема, уведомления активны, лимит дневного веса, лимит еженедельного веса

**Интерфейс Repository:**
```dart
abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings(SettingsModel settings);
  Stream<SettingsModel> watchSettings();
}
```

**Точки входа:**
- `ApplicationSettingsScope` — предоставляет настройки всему приложению

---

### 6. Developer (Инструменты разработчика)

**Путь:** `app/lib/src/feature/developer`

**Ответственность:**
- Инструменты для отладки
- Логирование, инспекция БД, тестовые данные

**Доступно только в DEBUG режиме**

---

## Взаимодействие между контекстами

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

### Daily Task Rewards зависит от Daily Tasks:

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

### Settings предоставляется через ApplicationSettingsScope:

```dart
// common/widget/application_settings_scope.dart
class ApplicationSettingsScope extends StatelessWidget {
  final Widget child;
  
  const ApplicationSettingsScope({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final settingsRepository = context.read<SettingsRepository>();
    // Предоставить настройки в виде провайдера/scope
    return child;
  }
}
```

## Правила взаимодействия

1. **Минимальная связанность:** Контексты обмениваются только через Repository интерфейсы
2. **Одностороннее направление:** Daily Task Rewards → Daily Tasks (не наоборот)
3. **Обмен данными:** Только через модели (Models), не через сущности из других контекстов
4. **Нет циклических зависимостей:** Если A зависит от B, то B не должен зависеть от A

## Shared Packages

Разделяемые пакеты для использования во всех контекстах:

### database

**Путь:** `packages/database`

Слой доступа к БД (Drift ORM, DAO объекты). Содержит:
- `AppDatabase` — главная база данных
- DAO классы для каждой таблицы
- Entity модели (дублеры доменных моделей для БД)
- Маппинг между Entity и Domain моделями

### ui

**Путь:** `packages/ui`

Общие UI компоненты и стили:
- Design system компоненты
- Глобальная тема
- Переиспользуемые виджеты (AppBar, Button, Card, etc.)
- Иконы, цвета, типография

### localization

**Путь:** `packages/localization`

Многоязычность (i18n):
- ARB файлы для переводов
- Сгенерированные локализация классы
- Поддержка динамической смены языка

### analytics

**Путь:** `packages/analytics`

Сбор аналитики:
- Трекинг событий
- Интеграция с сервисом аналитики
- Функции логирования

### client

**Путь:** `packages/client`

HTTP-клиент и API интеграция (если требуется):
- API client
- Сетевые запросы
- Интеграция с backend

## Расширение структуры

При добавлении нового bounded context:

1. Создать папку в `app/lib/src/feature/{context_name}`
2. Следовать структуре: `data/` → `control/` → `widget/`
3. Определить Repository интерфейс
4. Определить точки входа (Ports) для остального приложения
5. Документировать зависимости в этом файле
6. Если требуется shared логика — добавить в `packages/`
