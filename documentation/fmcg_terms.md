# Domain Terminology — DailyTasks

## Core Terms

### Task

A unit of work the user wants to complete. A task has:
- **Title** — the task name
- **Description** — a description (optional)
- **Weight** — the task's "cost" in arbitrary units
- **Status** — completed or not
- **Cycle** — daily or weekly

**Synonyms:** Item, Activity, Chore, Assignment

**Examples:**
- "Do morning exercises" (Daily Task, weight: 5)
- "Read 20 pages of a book" (Daily Task, weight: 10)
- "Finish project X" (Weekly Task, weight: 50)

---

### Weight

A numeric value indicating the "difficulty" or "effort" required to complete a task. Used to control workload.

**Unit:** arbitrary units (points)

**Range:** a positive integer (usually 1-100)

**Purpose:** keep the amount of work per day/week balanced

**Weight examples:**
- Simple task: 1-5
- Medium task: 5-20
- Hard task: 20+

---

### Daily Task

A task that repeats every day or can be completed within a single day.

**Cycle:** day (24 hours)

**Reset:** at 00:00 (midnight) — all tasks return to the "not completed" status

**Examples:**
- Morning workout
- Write the daily report
- Drink 2 liters of water

---

### Weekly Task

A task that is done or can be done within a single week.

**Cycle:** week (7 days)

**Reset:** at the start of the week (usually Monday, 00:00)

**Examples:**
- Finish the weekly report
- Go to the gym
- Clean the apartment

---

### Cycle / Period

The time interval in which a task is active.

**Types:**
- **Daily Cycle** — 24 hours (a day)
- **Weekly Cycle** — 7 days (a week)

**Cycle properties:**
- Cycle start (when tasks are reset)
- Duration (number of hours/days)
- Recurrence type (how often the cycle repeats)

---

### Weight Limit / Daily Limit / Weekly Limit

The maximum amount of weight the user can/should complete in a day or week.

**Purpose:** prevent overload and ensure a sustainable pace of work

**Value:** configured by the user

**Examples:**
- Daily Limit: 50 (the user plans to complete no more than 50 points per day)
- Weekly Limit: 200 (no more than 200 per week)

---

### Completed Weight / Done Weight

The total weight of all tasks completed in the current cycle.

**Calculation:**
```
CompletedWeight = Σ(weight of completed tasks in current cycle)
```

**Usage:** for tracking progress

---

### Remaining Weight

The remaining available weight the user can complete in the current cycle.

**Formula:**
```
RemainingWeight = WeightLimit - CompletedWeight
```

**Purpose:** show the user how many more tasks they can take on

**Property:** can be negative if the user has exceeded the limit

---

### Reward

An incentive or result for completing tasks. In the current version, this is progress tracking.

**Reward types:**
- **Progress** — a visual representation of the completed weight
- **Achievement** — badges for achievements (planned)
- **Currency** — in-app currency (planned)

**Examples:**
- "45 of 50 points completed today"
- A progress bar filled to 90%

---

### Completion Status

A task's completion status — whether it is finished or not.

**Values:**
- **Completed / Done** — the task is completed
- **Incomplete / Pending** — the task is not completed

**Additional fields:**
- `completedAt` — completion timestamp
- `isCompleted` — boolean flag

---

### Progress / Progression

A visual display of task completion progress for the current cycle.

**Metrics:**
- Completion percentage: `(CompletedWeight / WeightLimit) * 100`
- Absolute values: `CompletedWeight / WeightLimit`
- Examples: "45/50", "90%", a progress bar

---

### Reset

The operation of clearing the status of all tasks in a cycle. Tasks return to the "not completed" status.

**Types:**
- **Daily Reset** — at midnight (automatic)
- **Weekly Reset** — at the start of the week (automatic)
- **Manual Reset** — initiated by the user (optional)

**Behavior:**
- All tasks in the cycle return to `isCompleted = false`
- The history of completed tasks is kept in the database (for statistics)
- CompletedWeight is reset to zero

---

### Settings / Preferences

User settings of the application.

**Categories:**
- **General** — language, theme
- **Notifications** — enable/disable notifications, reminder times
- **Limits** — daily/weekly weight limits
- **Appearance** — color scheme, font size

---

### Notification

An alert to the user about an event in the application.

**Types:**
- **Reminder** — a reminder about an incomplete task
- **Daily Start** — a notification at the start of the day
- **Weekly Start** — a notification at the start of the week
- **Milestone** — reaching a certain level of progress (planned)

---

### State / Application State

The current state of the application and its layers.

**State types:**
- **Idle** — the application is ready
- **Processing / Loading** — an asynchronous operation is in progress
- **Error** — an error has occurred

**Example:**
```dart
sealed class DailyTasksState {
  final List<DailyTaskModel> dailyTasks;
  final String message;
  final String? error;
  
  factory DailyTasksState.idle(...) = _Idle;
  factory DailyTasksState.processing(...) = _Processing;
}
```

---

## Abbreviations

| Abbreviation | Meaning |
|-----------|-----------|
| UI | User Interface |
| UX | User Experience |
| DB | Database |
| DAO | Data Access Object |
| DDD | Domain Driven Design |
| SOLID | Architectural design principles |
| KISS | Keep It Simple, Stupid (simplicity principle) |
| YAGNI | You Aren't Gonna Need It |
| API | Application Programming Interface |
| JSON | JavaScript Object Notation |
| ORM | Object-Relational Mapping |

---

## Usage Examples in Code

### Daily Task with a weight

```dart
DailyTaskModel(
  id: 1,
  title: 'Morning Jog',
  description: '30 minutes run',
  weight: 10,
  isCompleted: false,
  createdAt: DateTime.now(),
  completedAt: null,
)
```

### Calculating the remaining weight

```dart
// Daily limit: 50 points
// Completed: 3 tasks worth 10, 8, 15 points = 33
// Remaining: 50 - 33 = 17 points

int remainingWeight(int dailyLimit, List<DailyTaskModel> tasks) {
  final completedWeight = tasks
      .where((t) => t.isCompleted)
      .fold<int>(0, (sum, t) => sum + t.weight);
  return dailyLimit - completedWeight;
}
```

### Checking whether a task can be added

```dart
bool canAddTask(int taskWeight, int remainingWeight) {
  return taskWeight <= remainingWeight;
}
```

---

## FMCG (Fast-Moving Consumer Goods) Context — Adaptation

DailyTasks adapts concepts from FMCG:

- **Stock / Inventory** → **Daily Limit / Weekly Limit** (the available "stock" of time/energy)
- **SKU (Stock Keeping Unit)** → **Task** (a unit of work)
- **Turnover / Velocity** → **Completion Rate** (speed of completion)
- **Demand** → **Task Priority / Weight** (the need for completion)
- **Supply Chain** → **Workflow** (the task processing chain)

This helps apply logistics management principles to managing personal tasks.

---

## Extending the Terminology

When adding new features, update this file with new terms and examples.

**Template:**
```markdown
### New Term

A 2-3 line description.

**Related:** other terms
**Examples:** usage examples
```
