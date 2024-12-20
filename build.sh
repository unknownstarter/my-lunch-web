#!/bin/bash
set -ex

# Flutter SDK 다운로드
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$PWD/flutter/bin"

# Flutter 설정 및 빌드
flutter precache
flutter config --enable-web
flutter pub get
flutter build web --release

# Netlify Functions 설정
cd netlify/functions
npm install
cd ../..