FROM ghcr.io/cirruslabs/flutter:3.10.1

WORKDIR /app

# Switch to the correct channel if needed, or just use the pre-installed version.
# 3.10.1 is usually on stable.
# Ensuring licenses are accepted is good practice, though cirruslabs image usually has them.
RUN yes | flutter doctor --android-licenses || true

# Copy pubspec files first to leverage Docker cache
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy the rest of the app source code
COPY . .

# Build the Android App Bundle
RUN flutter build appbundle --release

# Build the Android APK (for direct installation)
RUN flutter build apk --release

# Instructions:
# 1. Build: docker build -t lexnova-build .
# 2. Extract: 
#    - Create container: docker create --name temp-container lexnova-build
#    - Copy: docker cp temp-container:/app/build/app/outputs/bundle/release/app-release.aab .
#    - Cleanup: docker rm temp-container
