# LexNova Mobile App

LexNova is a Flutter mobile app for a modern law firm experience. It helps users explore legal services, read legal insights, view the legal team, and request appointments from a single interface. The project showcases practical mobile engineering with clean architecture, Supabase-backed content, and production-minded app structure.

## Overview

This app is designed as a client-facing legal services platform with a premium mobile UI.  
It solves a common problem for service firms: turning static firm information into a guided, app-first experience with searchable content and a direct booking flow.

Primary audiences:
- Prospective clients looking for legal services and consultation
- Law firm teams managing content/admin workflows through an external admin portal

## ✨ Key Features

- Multi-tab app shell with persistent navigation (Home, Services, Insights, Team, Appointment)
- First-launch onboarding flow with persisted completion state
- Services catalog with search and detail screens
- Insights/blog feed with sorting, search, and detail pages
- Team directory with profile sheet interactions
- Global search across services, insights, and team data
- Appointment booking flow:
  - date selection
  - slot availability lookup
  - form submission with GDPR consent
- In-app settings:
  - theme mode (system/light/dark)
  - language switcher
  - legal/compliance pages
  - cache clearing
- Admin portal handoff via WebView (mobile) / external browser tab (web)
- Localized UI support (English, Lithuanian, Romanian, Spanish)
- Supabase-backed content fetch with local cache-first behavior

## 🛠 Tech Stack

- **Frontend (Mobile):**
  - Flutter (Dart)
  - Material 3 UI
- **State Management & Navigation:**
  - flutter_riverpod
  - go_router
- **Backend/Data Access:**
  - Supabase Flutter client (content tables)
  - Dio (REST calls for appointment API)
- **Local Storage & App Config:**
  - shared_preferences
  - flutter_dotenv
- **UI/Utility Libraries:**
  - webview_flutter
  - flutter_markdown
  - intl
  - url_launcher

## 🏗 Architecture Overview

The codebase follows a feature-first structure under `lib/features/*` with shared infrastructure in `lib/shared/*`.

High-level data flow:
1. UI screens read providers (Riverpod)
2. Repositories fetch data from Supabase or REST API
3. Cache-first strategy returns local data fast, then refreshes from network
4. Routing is centralized via GoRouter with a shell route for bottom navigation
5. User preferences (onboarding, locale, theme) are persisted in SharedPreferences

Notable modules:
- `features/services`, `features/insights`, `features/team`: content-driven screens backed by Supabase
- `features/appointment`: booking state/controller + API integration
- `features/settings`: app controls, legal pages, admin handoff
- `shared/config`: environment and runtime config resolution

## 📸 Demo / Screenshots

- **Live demo link:** Not provided in this repository.
- **App/repo link:** This GitHub repository.

Recommended screenshots to add:
1. Home screen (hero + quick actions)
2. Services grid + service detail
3. Insights feed + article detail
4. Team page + member bottom sheet
5. Appointment flow (date → slot → form)
6. Settings page (theme/language/legal)

Helpful GIF idea:
- A 15–25 second “book an appointment” flow showing date selection, slot selection, and successful submission confirmation.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (compatible with Dart SDK `^3.10.1`)
- A Supabase project (for content data)
- Optional: running appointment API service for booking endpoints

### Installation

```bash
git clone https://github.com/Shahadat99x/lawfirm_mobile_app.git
cd lawfirm_mobile_app
flutter pub get
Environment Variables
Create a .env file in the project root (or use --dart-define in builds).

Example:

env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
ADMIN_URL=https://your-admin-portal-url
API_BASE_URL=http://localhost:3000
Notes:

API_BASE_URL defaults to:
http://10.0.2.2:3000 on Android emulator
http://localhost:3000 on iOS simulator/web
Supabase values are required for services/insights/team data loading.
Run Locally
bash
flutter run
Build / Production
bash
# Android APK
flutter build apk --release

# iOS (macOS required)
flutter build ios --release

# Web
flutter build web --release
You can also inject config for release with --dart-define:

bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=API_BASE_URL=... \
  --dart-define=ADMIN_URL=...
📁 Project Structure
Text
lib/
  app/                    # App root + router
  features/
    appointment/          # Booking flow (UI, state, repository, models)
    home/                 # Landing/home experience
    insights/             # Blog/insights list + detail
    legal/                # Markdown legal content renderer
    onboarding/           # First-run onboarding
    search/               # Cross-feature search
    services/             # Practice areas list + detail
    settings/             # Preferences, legal links, admin handoff
    team/                 # Lawyer directory + profile sheet
  shared/
    cache/                # Local cache helper
    config/               # Env/app/contact configuration
    providers/            # Shared Riverpod providers
    storage/              # App preferences
    supabase/             # Supabase client provider
    theme/                # Theme setup + controller
    utils/                # API client wrapper
    widgets/              # Reusable UI components
  l10n/                   # Localization files and generated classes

assets/
  branding/               # App icon and splash assets
  legal/                  # Privacy/terms/GDPR markdown files

docs/handoff_to_flutter/
  supabase/migrations/    # SQL schema + policy migrations
  docs/                   # Setup and SQL recovery notes
🔄 Core Workflows / API / User Flow
Onboarding flow
First app launch redirects to onboarding.
Completion is stored in local preferences.
Future launches go directly to /home.
Content flow (Supabase)
Services, insights, and team data are fetched from Supabase.
Repositories emit cached data first, then refresh from network.
Public-read model aligns with Supabase RLS documentation in /docs.
Appointment flow (API)
User selects date → app requests availability (GET /api/appointments/availability)
User selects time and submits details (POST /api/appointments)
Successful booking shows confirmation with reference ID
Admin flow
Settings exposes an Admin Portal entry.
Mobile opens admin URL inside WebView; web opens external browser tab.
💡 Engineering Highlights
Feature-oriented Flutter architecture with clear separation of UI, domain models, and data access
Practical state management with Riverpod providers and controllers
Structured app navigation using shell routes and nested detail routes
Cache-first data loading strategy for better perceived responsiveness
Localization support across multiple languages
Config strategy supporting both .env and --dart-define
Supabase schema/RLS handoff package included for reproducible setup
⚠ Challenges / Trade-offs
Appointment backend endpoints are external to this repo, so full end-to-end local testing requires a separate API service.
Automated test coverage is currently minimal in this repository.
CI/CD workflows are not included yet.
Some documentation in handoff files references web/backend setup context alongside mobile concerns.
🗺 Roadmap
Add robust widget/integration tests for booking, routing, and repository layers
Add CI workflow for flutter analyze + tests
Replace static booking practice-area list with dynamic data source
Add screenshot and demo assets for clearer product presentation
Improve offline/error UX states with richer retry and fallback patterns
👤 Author
GitHub: https://github.com/Shahadat99x
Portfolio: https://www.dhossain.com
LinkedIn: https://linkedin.com/in/shahadat-ai
