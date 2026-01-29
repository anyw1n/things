# Product Requirements Document (PRD) - Things

## Project Overview

**Things** is a cross-platform application designed for quick and efficient text-based note-taking. The app focuses on a chronological organization of notes, providing a seamless experience for capturing thoughts throughout the day.

## Core Value Proposition

- **Privacy First**: All data is stored locally on the device.
- **Chronological Focus**: Intuitive navigation through days to review or add notes.
- **Simplicity**: A clean, distraction-free interface with a dark theme by default.

## Functional Requirements

### 1. Note Management

- Users can create text-based notes.
- Notes are automatically associated with the currently selected date.
- Notes are displayed in a list for the selected day.

### 2. Navigation & UX

- **Daily View**: The main screen shows notes for a specific date.
- **Date Header**: The current date is clearly displayed at the top.
- **Swipe Navigation**: Users can swipe left or right to move between previous and future dates.
- **Quick Entry**: A text input field is always available at the bottom of the screen for rapid note creation.

### 3. Visual Design

- **Dark Theme**: The application uses a dark background as the default aesthetic.
- **Minimalist UI**: Focused on content and ease of use.

## Technical Specifications

### 1. Architecture & State Management

- **State Management**: `flutter_bloc` for predictable state transitions and separation of concerns.
- **Navigation**: `go_router` and `go_router_builder` for type-safe routing.
- **Localization**: `slang` for robust, type-safe internationalization.

### 2. Data Persistence

- **Database**: `drift` (SQLite) for high-performance local storage, supporting structured data and reactive queries.

### 3. Target Platforms

- Multi-platform support: iOS, Android, Web, macOS, Windows, Linux.

## Future Scope (V2+)

- Full-text search across all notes.
- Tagging and categorization.
- Media attachments (images, audio).
- Cloud synchronization (optional/opt-in).
