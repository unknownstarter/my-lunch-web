#!/bin/bash
set -ex

# Flutter SDK 다운로드 (3.27.1 버전)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz -o flutter.tar.xz
tar xf flutter.tar.xz
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