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

- **Goal**: Implement the local database schema for Notes.
- **Tasks**:
    1. Define `Notes` table (id, content, date, createdAt).
    2. Generate drift code (`dart run build_runner build`).
    3. Implement `AppDatabase` class.
- **Tests**:
  - [ ] Integration Test (In-Memory DB): Create a note, Read it back, Delete it.
  - [ ] Integration Test: Verify notes are queryable by date range/specific date.

### Step 3: Repository Layer

- **Goal**: Abstract database access from the business logic.
- **Tasks**:
    1. Create `NotesRepository` interface and implementation.
    2. Implement methods: `getNotesForDate(DateTime)`, `addNote(String content, DateTime date)`, `deleteNote(String id)`.
- **Tests**:
  - [ ] Unit Test: Mock Database, verify Repository calls correct DB methods.
  - [ ] Unit Test: Verify date transformation logic (if any).

## Phase 2: Business Logic (BLoC)

### Step 4: Notes Feature BLoC

- **Goal**: Manage state for the Daily View.
- **Tasks**:
    1. Define Events: `LoadNotes(DateTime)`, `AddNote(String, DateTime)`, `DeleteNote(String)`.
    2. Define States: `NotesLoading`, `NotesLoaded(List<Note>, DateTime)`, `NotesError`.
    3. Implement `NotesBloc`.
- **Tests**:
  - [ ] BLoC Test: Emits `NotesLoaded` with empty list when repository returns empty.
  - [ ] BLoC Test: Emits `NotesLoaded` with new note after `AddNote` event.
  - [ ] BLoC Test: Verify date formatting/handling in state.

## Phase 3: UI & Navigation

### Step 5: Daily View UI (Components)

- **Goal**: Build the visual components for the main screen.
- **Tasks**:
    1. `DateHeaderWidget`: Displays formatted date.
    2. `NoteListWidget`: ListView of notes.
    3. `NoteInputWidget`: TextField for adding notes.
- **Tests**:
  - [ ] Widget Test: `DateHeaderWidget` renders correct date format.
  - [ ] Widget Test: `NoteInputWidget` calls callback on submit.
  - [ ] Widget Test: `NoteListWidget` renders list of items provided.

### Step 6: Daily View Page & Swiping

- **Goal**: Assemble components into a PageView for navigating days.
- **Tasks**:
    1. Implement `HomePage` with `PageView.builder`.
    2. Integrate `NotesBloc` with the Page logic (each page might need its own Bloc or a scoped reference).
    3. Implement "Swipe" logic to change the current date in focus.
- **Tests**:
  - [ ] Widget Test: Swiping left/right changes the displayed date.
  - [ ] Widget Test: Verify input field adds note to the *currently visible* date.

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
  - [ ] Integration Test (e2e): Start app -> See today's date -> Add note -> Swipe to yesterday -> Verify empty -> Swipe back -> Verify note exists.
