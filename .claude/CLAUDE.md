# Claude Instructions - DailyTasks Project

## Communication Style
Strict, analytical tone without unnecessary emotion. Statements are clear and unambiguous. Ask clarifying questions only when the task cannot be solved without them. Name inconsistencies and errors directly. Answers should be logical, concise, and informative with minimal length.

Where possible, avoid bulleted lists — coherent prose is preferred. Use abbreviations sparingly. Do not explain every option in detail — only the essence.

## About the Project
DailyTasks is a project aimed at optimizing and automating users' daily and weekly tasks and habits.

## Working with Documentation
Before starting any work, review the contents of the `documentation/` folder. It contains the rules, architectural decisions, and process descriptions. Key files: `idea.md` (product essence), `vision.md` (technical vision of the system), `conventions.md` (code conventions), `workflow.md` (workflow). The changelog format is defined by `CHANGELOG.md` in the repository root.

Before formulating any architectural proposal, always read in this order: `documentation/idea.md` → `documentation/vision.md` → `documentation/conventions.md` → `documentation/workflow.md`.

Check the structure of a domain package against `documentation/architecture/domain_structure.md`. Take domain terminology from `documentation/fmcg_terms.md`.

## Task Execution Order
When receiving a task, first check it against the context in `documentation/idea.md`, then against the technical vision in `documentation/vision.md`, then verify compliance with the requirements in `documentation/conventions.md`, and follow the process in `documentation/workflow.md`. Sequence: propose a solution with code examples, implement after confirmation, await feedback.

Before implementation, propose one concrete solution with explicit boundaries of responsibility and dependencies. Do not build hypotheses that lead to bloated monoliths along the lines of "one feature — half the application".

## Architectural Principles
Strictly follow the layered call chain: Widget → Control → Repository → DataSource → DAO → Drift. Do not skip layers; direct calls across layers are forbidden. Business logic lives exclusively in Control; Use Cases are not used. Do not use Freezed. Follow KISS: a simple solution is preferable to a sophisticated one.

Apply DDD without excessive fragmentation: high cohesion within a bounded context, minimal coupling between contexts.

Shared repositories are justified only for stable and truly application-wide contracts. If a piece of logic has its own lifecycle, its own write commands, or specific invariants, it is a separate bounded context, not a shared reference.

For documents, apply a common domain contract for lifecycle and content, and encapsulate infrastructure details (cascade deletion, file operations, transport layer) in the data/source implementations.

Do not start implementation during architectural discussions without explicit agreement from the user.

Architectural decisions may be discussed when needed, but the outcome is recorded in `documentation/adr/`. Refactoring plans are recorded in `documentation/refactoring/`.

## Response Format

Brief and to the point. Propose one solution, not the full range of possibilities. When alternatives exist, state the preferred one with a concise justification. Do not repeat the obvious or add unnecessary explanations.
