#!/bin/bash

# Naver API 환경변수 설정
firebase functions:config:set naver.client_id="YOUR_CLIENT_ID" naver.client_secret="YOUR_CLIENT_SECRET"

# Flutter 웹 빌드
flutter build web

# Firebase 배포
firebase deploy