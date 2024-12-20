#!/bin/bash
set -ex  # 에러 발생 시 스크립트 중단 및 실행 명령어 출력

# 현재 디렉토리 확인
pwd
ls -la

# Flutter SDK 다운로드 (안정 버전으로 지정)
git clone https://github.com/flutter/flutter.git -b stable

# Flutter 직접 실행
./flutter/bin/flutter --version
./flutter/bin/flutter clean
./flutter/bin/flutter pub get
./flutter/bin/flutter config --enable-web
./flutter/bin/flutter build web --release --web-renderer html

# 빌드 결과물 확인
ls -la build/web