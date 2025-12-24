# LexNova Mobile App

Premium mobile application for LexNova Law Firm.

## Getting Started

### Prerequisites

1.  **Flutter SDK**: Ensure you have the latest stable Flutter installed.
2.  **Environment Variables**:
    *   Copy `.env` from a secure source (or creating one `ADMIN_URL=...`).
    *   This project depends on `flutter_dotenv`.

### Installation

1.  Get dependencies:
    ```bash
    flutter pub get
    ```

2.  Run the app:
    ```bash
    flutter run
    ```

### Architecture

- **State Management**: flutter_riverpod
- **Navigation**: go_router (ShellRoute for bottom nav)
- **Theme**: Material 3 with Premium custom colors (lib/shared/theme)
- **Features**: Vertical slice architecture (lib/features/...)

### Phase 1 Features
- Premium App Shell & UI
- Bottom Navigation (Home, Services, Insights, Appointment)
- Settings with Theme Toggle (Light/Dark/System)
- Admin Portal access via WebView
