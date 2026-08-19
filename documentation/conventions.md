# Соглашения по коду — DailyTasks

## Общие принципы

**SOLID** — принципы проектирования, способствующие созданию гибкого и поддерживаемого кода.

**YAGNI** — "You Aren't Gonna Need It". Не добавляйте функциональность, пока она не станет необходимой.

**KISS** — простое решение предпочтительнее изощрённого. Понятность кода важнее его краткости. Нет преждевременной оптимизации.

**Без Freezed** — используются обычные Dart-классы с @immutable аннотацией, где требуется.

**Без Use Cases** — бизнес-логика сосредоточена исключительно в Control слое.

## Структура фичи в application

Каждая фича в `app/lib/src/feature/{feature_name}` имеет структуру:

```
{feature_name}/
├── data/
│   ├── repository  # Repository реализация
│   ├── source      # DataSource (локальная БД, API)
├── control/        # Control (бизнес-логика, state management)
└── widget/         # UI компоненты и страницы
```

### Repository

Фасад доступа к данным фичи. Объединяет несколько DataSource, скрывает инфраструктурные детали.

```dart
class TaskRepository {
  final TaskLocalDataSource _localDataSource;
  
  TaskRepository(this._localDataSource);
  
  Future<List<Task>> getTasks() => _localDataSource.fetchTasks();
  
  Future<void> createTask(Task task) => _localDataSource.insertTask(task);
}
```

### DataSource

Источник данных — локальная БД, API, кэш. Работает с DAO.

```dart
class TaskLocalDataSource {
  final SqlDatabaseSource _sqlDatabaseSource;

  TaskLocalDataSource(this._sqlDatabaseSource);

  Future<List<TaskModel>> fetchTasks() async =>  _sqlDatabaseSource.dao<TasksDao>().getAllTasks();
}
```

### Control

Управление состоянием и бизнес-логика фичи. Наследует `StateController<T>` из пакета `control`, где `T` — состояние фичи. Использует `handle()` для выполнения асинхронных операций с автоматической обработкой ошибок.

**Структура состояния:**

```dart
part 'tasks_state.dart';

sealed class TasksState {
  const TasksState({
    required this.tasks,
    required this.message,
    this.error,
  });

  final List<TaskModel> tasks;
  final String message;
  final String? error;

  const factory TasksState.idle({
    required List<TaskModel> tasks,
    required String message,
    String? error,
  }) = _Idle;

  const factory TasksState.processing({
    required List<TaskModel> tasks,
    required String message,
  }) = _Processing;
}
```

**Реализация контроллера:**

```dart
final class TasksController extends StateController<TasksState> 
    with DroppableControllerHandler {
  TasksController({
    required TasksRepository tasksRepository,
    super.initialState = const TasksState.idle(
      tasks: [],
      message: 'Initializing tasks',
    ),
  }) : _tasksRepository = tasksRepository;

  final TasksRepository _tasksRepository;

  /// Получить список задач
  void fetchTasks() => handle(
    () async {
      setState(TasksState.processing(
        tasks: state.tasks,
        message: 'Fetching tasks',
      ));
      final tasks = await _tasksRepository.getTasks();
      setState(TasksState.idle(
        tasks: tasks,
        message: 'Tasks retrieved',
      ));
    },
    error: (error, _) async => setState(
      TasksState.idle(
        tasks: state.tasks,
        error: 'Error fetching tasks',
        message: 'Failed to get tasks',
      ),
    ),
  );
}
```

**Ключевые особенности:**
- `StateController<T>` управляет состоянием через `setState()`
- `handle()` оборачивает асинхронные операции с автоматической обработкой ошибок и состояния processing
- `DroppableControllerHandler` отменяет предыдущие операции при новых запросах (FIFO)
- Методы работают с репозиторием и обновляют состояние при успехе или ошибке
- Состояние имеет два основных типа: `idle` (готовый) и `processing` (выполнение)

### Widget

UI компоненты и страницы. Получают контроллер InheritedWidget, слушают изменения состояния через `StateConsumer`. Отображают данные на основе текущего состояния.

```dart
class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TasksController>().fetchTasks();
            },
          ),
        ],
      ),
      body: StateConsumer<TasksController, TasksState>(
        controller: Dependencies.of(context).tasksController,
        builder: (context, state, child) {
          return Column(
            children: [
              if (state.error != null)
                Container(
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.error!)),
                    ],
                  ),
                ),
              if (state.tasks.isEmpty)
                const Center(
                  child: Text('No tasks yet'),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Weight: ${task.weight}'),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {},
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
```

**Взаимодействие с контроллером:**
- Получение: `Dependencies.of(context).tasksController`
- Слушание состояния: `StateConsumer<TasksController, TasksState>`
- Вызов методов: `controller.fetchTasks()`, `controller.toggleTaskCompletion(id)`

## Именование

- **Классы:** PascalCase (`Task`, `TaskControl`, `TaskRepository`)
- **Переменные, методы:** camelCase (`getTasks`, `taskList`, `isCompleted`)
- **Константы:** camelCase (`maxDailyWeight`, `defaultTaskTimeout`)
- **Приватные члены:** `_privateMember`
- **Файлы:** snake_case (`task_control.dart`, `task_repository.dart`)

## Комментарии

Минимум комментариев. Код должен быть самоописывающимся. Комментарии только для:
- Нетривиальной бизнес-логики
- Почему сделано так, а не иначе (не что)
- TODO, FIXME, NOTE

```dart
// Вес пересчитывается с учётом выполненных задач за день
int calculateRemainingWeight() {
  return maxDailyWeight - completedWeight;
}
```

## Импорты

Порядок импортов:

1. `dart:` (стандартная библиотека)
2. `package:flutter` (Flutter)
3. Остальные `package:` (в алфавитном порядке)
4. Относительные импорты (`../`, `./`)

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tasks/src/common/util/error_util.dart';
import 'package:tasks/src/feature/tasks/model/task.dart';

import '../data/repository/task_repository.dart';
```

## Null Safety

Полный Null Safety. Использовать `?` и `!` только когда это логически обоснованно. Избегать `!` в production коде.

```dart
String? taskName; // может быть null
String taskId;    // никогда не null
final result = taskName ?? 'Unknown'; // безопасная обработка
```

## Тестирование

Тесты находятся в `test/` папке с той же структурой, что и `lib/src`. Покрывать тестами:
- Бизнес-логику (Control)
- Repository и DataSource
- Критические UI сценарии

```
test/
├── feature/
│   └── daily_tasks/
│       ├── control/
│       │   └── task_control_test.dart
│       └── data/
│           ├── repository/
│           │   └── task_repository_test.dart
│           └── source/
│               └── task_local_data_source_test.dart
```
