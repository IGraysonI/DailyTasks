# Code Conventions — DailyTasks

## Dart rules

- Follow the official Dart style guide: https://dart.dev/guides/language/effective-dart.
- Make sure that dart editor ruler is set appropriately for line length of 120.

## General Principles

**SOLID** — design principles that help create flexible and maintainable code.

**YAGNI** — "You Aren't Gonna Need It". Don't add functionality until it becomes necessary.

**KISS** — a simple solution is preferable to a sophisticated one. Code clarity matters more than brevity. No premature optimization.

**No Freezed** — plain Dart classes are used, with the @immutable annotation where needed.

**No Use Cases** — business logic lives exclusively in the Control layer.

## Feature Structure in the Application

Each feature in `app/lib/src/feature/{feature_name}` has the following structure:

```
{feature_name}/
├── data/
│   ├── repository  # Repository implementation
│   ├── source      # DataSource (local DB, API)
├── control/        # Control (business logic, state management)
└── widget/         # UI components and pages
```

### Repository

The feature's data access facade. Combines several DataSources and hides infrastructure details.

```dart
class TaskRepository {
  final TaskLocalDataSource _localDataSource;
  
  TaskRepository(this._localDataSource);
  
  Future<List<Task>> getTasks() => _localDataSource.fetchTasks();
  
  Future<void> createTask(Task task) => _localDataSource.insertTask(task);
}
```

### DataSource

A data source — local DB, API, cache. Works with DAOs.

```dart
class TaskLocalDataSource {
  final SqlDatabaseSource _sqlDatabaseSource;

  TaskLocalDataSource(this._sqlDatabaseSource);

  Future<List<TaskModel>> fetchTasks() async =>  _sqlDatabaseSource.dao<TasksDao>().getAllTasks();
}
```

### Control

State management and business logic of the feature. Extends `StateController<T>` from the `control` package, where `T` is the feature state. Uses `handle()` to run asynchronous operations with automatic error handling.

**State structure:**

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

**Controller implementation:**

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

  /// Fetch the list of tasks
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

**Key points:**
- `StateController<T>` manages state via `setState()`
- `handle()` wraps asynchronous operations with automatic error and processing-state handling
- `DroppableControllerHandler` cancels previous operations when new requests arrive (FIFO)
- Methods work with the repository and update the state on success or error
- The state has two main types: `idle` (ready) and `processing` (in progress)

### Widget

UI components and pages. They get the controller from an InheritedWidget and listen to state changes via `StateConsumer`. They render data based on the current state.

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

**Interacting with the controller:**
- Obtaining: `Dependencies.of(context).tasksController`
- Listening to state: `StateConsumer<TasksController, TasksState>`
- Calling methods: `controller.fetchTasks()`, `controller.toggleTaskCompletion(id)`

## Naming

- **Classes:** PascalCase (`Task`, `TaskControl`, `TaskRepository`)
- **Variables, methods:** camelCase (`getTasks`, `taskList`, `isCompleted`)
- **Constants:** camelCase (`maxDailyWeight`, `defaultTaskTimeout`)
- **Private members:** `_privateMember`
- **Files:** snake_case (`task_control.dart`, `task_repository.dart`)

## Comments

Keep comments to a minimum. Code should be self-documenting. Comments only for:
- Non-trivial business logic
- Why something is done this way and not another (not what)
- TODO, FIXME, NOTE

```dart
// Weight is recalculated taking into account the tasks completed today
int calculateRemainingWeight() {
  return maxDailyWeight - completedWeight;
}
```

## Imports

Import order:

1. `dart:` (standard library)
2. `package:flutter` (Flutter)
3. Other `package:` imports (alphabetically)
4. Relative imports (`../`, `./`)

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tasks/src/common/util/error_util.dart';
import 'package:tasks/src/feature/tasks/model/task.dart';

import '../data/repository/task_repository.dart';
```

## Null Safety

Full null safety. Use `?` and `!` only when logically justified. Avoid `!` in production code.

```dart
String? taskName; // may be null
String taskId;    // never null
final result = taskName ?? 'Unknown'; // safe handling
```

## Testing

Tests live in the `test/` folder with the same structure as `lib/src`. Cover with tests:
- Business logic (Control)
- Repository and DataSource
- Critical UI scenarios

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
