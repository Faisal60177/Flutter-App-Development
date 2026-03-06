# flutter_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## BLoC Form Demo

This app demonstrates a minimalist form powered by `flutter_bloc`, using a `Cubit` to control text input, validation, and asynchronous submission.

### Project Structure

- `lib/form_cubit.dart`: Defines `FormCubit` and `FormViewState`, encapsulating form fields and submission lifecycle.
- `lib/home_screen.dart`: Builds the UI, listens to Cubit state changes, and reacts with inline validation and toast feedback.
- `lib/main.dart`: Bootstraps the app with a top-level `BlocProvider` so the Cubit is accessible throughout the widget tree.

### Cubit Walkthrough

1. **State modeling**  
   `FormViewState` contains the minimal data needed for the form (`name`, `email`, `status`, `errorMessage`). A `copyWith` constructor allows immutable updates.

2. **Inputs and validation**  
   `nameChanged` and `emailChanged` update the state on every keystroke and reset any previous errors. A derived `isValid` getter ensures both fields are non-empty.

3. **Submission flow**  
   `submitForm()` performs synchronous validation, emits a `submitting` status, waits for a simulated async call (`Future.delayed`), then emits `success` or `failure`. The `resetStatus()` helper returns the Cubit to the neutral `initial` state after feedback is shown.

4. **UI integration**  
   `BlocBuilder` rebuilds the form fields whenever the Cubit state changes, while `BlocListener` watches for status transitions to show snackbars and clear controllers. This separation keeps UI code declarative and free from manual `setState()` calls.

### Why Use Cubit?

- **Simplicity**: Cubit suits straightforward flows where a single stream of states originates from method calls—like forms, toggles, and lightweight feature modules.
- **Minimal boilerplate**: With only a state class and Cubit methods, it stays readable and easy to test.
- **Fine-grained control**: Each function emits exactly one state transition, making intent explicit.

### When to Choose Bloc Over Cubit

| Prefer Cubit | Prefer Bloc |
| --- | --- |
| Single user action maps directly to one state change | One action can yield multiple state transitions |
| Only synchronous or UI-driven triggers | Events can come from timers, streams, sockets, or platform channels |
| Local component responsibility | Cross-feature orchestration or complex workflows |

#### Best Use Cases for Bloc Events

- **Debounced search**: A `SearchRequested` event debounces user input before emitting results.
- **Pagination or infinite scroll**: `PageRequested` events can fetch and merge data incrementally.
- **Reactive data sources**: Events triggered by background services (push notifications, WebSockets, BLE scans) map to state updates independent of UI input.
- **Undo/redo flows**: Events allow explicit `ActionCommitted` and `ActionReverted` handling with history management.

In short, reach for Cubit when the UI drives state in a direct, controllable manner. Choose Bloc when you need a richer event/state graph that coordinates multiple asynchronous inputs or enforces complex business rules.

