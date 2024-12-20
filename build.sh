#!/bin/bash
set -ex  # 에러 발생 시 스크립트 중단 및 실행 명령어 출력

# 현재 디렉토리 확인
pwd
ls -la

# Flutter SDK 다운로드
git clone https://github.com/flutter/flutter.git

# Flutter 직접 실행
./flutter/bin/flutter precache
./flutter/bin/flutter config --enable-web
./flutter/bin/flutter build web

# 빌드 결과물 확인
ls -la build/web