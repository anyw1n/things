# Implementation Plan - Things

Based on [PRD.md](./PRD.md), this plan outlines the step-by-step development process.
**Requirement:** For each step, tests must be written first (or alongside implementation) and verified before moving to the next step.

## Phase 1: Foundation & Core Infrastructure

### Step 1: Project Setup & Localization (Slang)

- **Goal**: Initialize project structure, setup localization, and ensure base configuration works.
- **Tasks**:
    1. Clean up `pubspec.yaml`.
    2. Configure `slang.yaml` and generate translations.
    3. Create a basic `MaterialApp` wrapping the app with localization support.
- **Tests**:
  - [x] Unit Test: Verify localization loads correctly for EN.
  - [x] Widget Test: Verify app launches and displays a localized title.

### Step 2: Database Layer (Drift)

- **Goal**: Implement the local database schema for Thoughts.
- **Tasks**:
    1. Define `Thoughts` table (id, content, createdAt, icon, title).
    2. Generate drift code (`dart run build_runner build`).
    3. Implement `AppDatabase` class.
- **Tests**:
  - [x] Integration Test (In-Memory DB): Create a thought, Read it back, Delete it.
  - [x] Integration Test: Verify thoughts are queryable.

### Step 3: Repository Layer

- **Goal**: Abstract database access from the business logic.
- **Tasks**:
    1. Create `ThoughtsRepository` interface and implementation.
    2. Implement methods:
        - `getThoughtsForDate(DateTime)`
        - `addThought(String content, String title, String emoji)`: Validate inputs (non-empty content) and handle errors.
        - `deleteThought(int id)`: Handle errors (e.g., item not found).
- **Tests**:
  - [x] Unit Test: Mock Database, verify Repository calls correct DB methods.
  - [x] Unit Test: Verify error handling propagates correctly.

## Phase 2: Business Logic (BLoC)

### Step 4: Thoughts Feature BLoC

- **Goal**: Manage state for the Daily View.
- **Tasks**:
    1. Define Events: `LoadThoughts(DateTime)`, `AddThought(String, DateTime)`, `DeleteThought(String)`.
    2. Define States: `ThoughtsLoading`, `ThoughtsLoaded(List<Thought>, DateTime)`, `ThoughtsError`.
    3. Implement `ThoughtsBloc`.
- **Tests**:
  - [ ] BLoC Test: Emits `ThoughtsLoaded` with empty list when repository returns empty.
  - [ ] BLoC Test: Emits `ThoughtsLoaded` with new thought after `AddThought` event.
  - [ ] BLoC Test: Verify date formatting/handling in state.

## Phase 3: UI & Navigation

### Step 5: Daily View UI (Components)

- **Goal**: Build the visual components for the main screen.
- **Tasks**:
    1. `DateHeaderWidget`: Displays formatted date.
    2. `ThoughtListWidget`: ListView of thoughts.
    3. `ThoughtInputWidget`: TextField for adding thoughts.
- **Tests**:
  - [ ] Widget Test: `DateHeaderWidget` renders correct date format.
  - [ ] Widget Test: `ThoughtInputWidget` calls callback on submit.
  - [ ] Widget Test: `ThoughtListWidget` renders list of items provided.

### Step 6: Daily View Page & Swiping

- **Goal**: Assemble components into a PageView for navigating days.
- **Tasks**:
    1. Implement `HomePage` with `PageView.builder`.
    2. Integrate `ThoughtsBloc` with the Page logic (each page might need its own Bloc or a scoped reference).
    3. Implement "Swipe" logic to change the current date in focus.
- **Tests**:
  - [ ] Widget Test: Swiping left/right changes the displayed date.
  - [ ] Widget Test: Verify input field adds thought to the *currently visible* date.

### Step 7: Navigation & Routing (GoRouter)

- **Goal**: Setup app routing (foundation for future expansion).
- **Tasks**:
    1. Configure `GoRouter` with `HomePage` as the initial route.
    2. Ensure Android Back button works correctly.
- **Tests**:
  - [ ] Widget Test: App starts on the Home route.

## Phase 4: Polish & Integration

### Step 8: Theming & Visuals

- **Goal**: Apply Dark Theme and fonts.
- **Tasks**:
    1. Configure `ThemeData` (Dark mode default).
    2. Apply `GoogleFonts`.
- **Tests**:
  - [ ] Visual/Goldens (Optional): Verify dark theme contrast and appearance.

### Step 9: Final Integration Testing

- **Goal**: Verify the entire flow works on a device/emulator.
- **Tasks**:
    1. Manual run on iOS/Android Simulator.
    2. Run full integration test suite.
- **Tests**:
  - [ ] Integration Test (e2e): Start app -> See today's date -> Add thought -> Swipe to yesterday -> Verify empty -> Swipe back -> Verify thought exists.
