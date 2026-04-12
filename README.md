# LexNova Mobile App

LexNova is a Flutter mobile app delivering a modern, client-facing law firm experience — helping users explore legal services, read insights, meet the team, and book appointments from a single polished interface.

---

## Overview

LexNova solves a common problem for service firms: transforming static firm information into a guided, app-first experience with searchable content and a direct booking flow.

**Primary audiences:**
- Prospective clients seeking legal services and consultations
- Law firm staff managing content via an external admin portal

---

## Features

- Multi-tab shell with persistent bottom navigation (Home, Services, Insights, Team, Appointment)
- First-launch onboarding flow with persisted completion state
- Services catalog with search and detail screens
- Insights/blog feed with sorting, search, and article detail pages
- Team directory with profile bottom sheet interactions
- Global search across services, insights, and team data
- Appointment booking flow: date selection → slot availability → form submission with GDPR consent
- In-app settings: theme mode (system/light/dark), language switcher, legal/compliance pages, cache clearing
- Admin portal handoff via WebView (mobile) or external browser tab (web)
- Localized UI: English, Lithuanian, Romanian, Spanish
- Supabase-backed content with local cache-first loading

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart), Material 3 |
| State / Navigation | flutter_riverpod, go_router |
| Backend | Supabase (content), Dio (appointments API) |
| Local Storage | shared_preferences, flutter_dotenv |
| UI Utilities | webview_flutter, flutter_markdown, intl, url_launcher |

---

## Architecture

The codebase follows a **feature-first structure** under `lib/features/` with shared infrastructure in `lib/shared/`.

**Data flow:**
1. UI screens consume Riverpod providers
2. Repositories fetch from Supabase or a REST API
3. Cache-first strategy returns local data immediately, then refreshes from the network
4. Routing is centralized via GoRouter with a shell route for bottom navigation
5. User preferences (onboarding state, locale, theme) persist in SharedPreferences

---

## Project Structure
lib/
app/                    # App root and router
features/
appointment/          # Booking flow — UI, state, repository, models
home/                 # Landing/home screen
insights/             # Blog feed and article detail
legal/                # Markdown legal content renderer
onboarding/           # First-run onboarding flow
search/               # Cross-feature global search
services/             # Practice areas list and detail
settings/             # Preferences, legal links, admin handoff
team/                 # Lawyer directory and profile sheet
shared/
cache/                # Local cache helper
config/               # Env and runtime config resolution
providers/            # Shared Riverpod providers
storage/              # App preferences wrapper
supabase/             # Supabase client provider
theme/                # Theme setup and controller
utils/                # API client wrapper
widgets/              # Reusable UI components
l10n/                   # Localization files and generated classes
assets/
branding/               # App icon and splash assets
legal/                  # Privacy policy, terms, GDPR markdown files
docs/handoff_to_flutter/
supabase/migrations/    # SQL schema and RLS policy migrations
docs/                   # Setup notes and SQL recovery documentation

---

## Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.10.1`)
- A Supabase project (for services, insights, and team content)
- Optional: a running appointment API service for booking endpoints

### Installation

```bash
git clone https://github.com/Shahadat99x/lawfirm_mobile_app.git
cd lawfirm_mobile_app
flutter pub get
```

### Environment Variables

Create a `.env` file in the project root:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
ADMIN_URL=https://your-admin-portal-url
API_BASE_URL=http://localhost:3000
```

> **Note:** `API_BASE_URL` defaults to `http://10.0.2.2:3000` on Android emulator and `http://localhost:3000` on iOS simulator/web. Supabase values are required for content loading.

### Run Locally

```bash
flutter run
```

### Production Builds

```bash
# Android APK
flutter build apk --release

# iOS (macOS required)
flutter build ios --release

# Web
flutter build web --release
```

You can also inject config at build time using `--dart-define`:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=API_BASE_URL=... \
  --dart-define=ADMIN_URL=...
```

---

## Core Workflows

### Onboarding
1. First launch redirects to the onboarding flow
2. Completion is written to local preferences
3. Subsequent launches go directly to `/home`

### Content (Supabase)
- Services, insights, and team data are fetched from Supabase
- Repositories emit cached data first, then refresh from the network
- Public-read RLS model is documented in `/docs`

### Appointment Booking
1. User selects a date → app requests slot availability (`GET /api/appointments/availability`)
2. User picks a time slot and submits their details (`POST /api/appointments`)
3. Successful submission returns a confirmation with a reference ID

### Admin Portal
- Settings exposes an **Admin Portal** entry
- Mobile opens the admin URL in a WebView; web opens an external browser tab

---

## Engineering Highlights

- Feature-oriented architecture with clear separation of UI, domain models, and data access
- Riverpod providers and controllers for structured, testable state management
- Shell routes and nested detail routes for predictable navigation
- Cache-first loading strategy for strong perceived performance
- Multi-language localization (4 languages)
- Config strategy supporting both `.env` files and `--dart-define` flags
- Supabase schema and RLS handoff package included for reproducible backend setup

---

## Known Trade-offs

- The appointment API is external to this repo — full end-to-end local testing requires a separately running API service
- Automated test coverage is currently minimal
- CI/CD workflows are not yet included
- Some handoff documentation mixes web/backend context alongside mobile setup notes

---


---

## Author

- **GitHub:** [github.com/Shahadat99x](https://github.com/Shahadat99x)
- **Portfolio:** [dhossain.com](https://www.dhossain.com)
- **LinkedIn:** [linkedin.com/in/shahadat-ai](https://linkedin.com/in/shahadat-ai)
