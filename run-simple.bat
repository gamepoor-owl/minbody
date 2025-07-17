@echo off
chcp 65001 > nul
title M-Inbody 데미지 미터 (간단 실행)

echo ===============================================
echo       M-Inbody 데미지 미터 (간단 실행)
echo ===============================================
echo.

REM JAR 파일 존재 확인 (최신 버전 우선)
set JAR_FILE=
if exist "m-inbody-0.0.1-SNAPSHOT.jar" (
    set JAR_FILE=m-inbody-0.0.1-SNAPSHOT.jar
) else if exist "m-inbody.jar" (
    set JAR_FILE=m-inbody.jar
) else (
    echo [ERROR] JAR 파일을 찾을 수 없습니다.
    pause
    exit /b 1
)

echo [INFO] 실행할 JAR 파일: %JAR_FILE%
echo [INFO] 웹 브라우저에서 http://localhost:5000 으로 접속하세요.
echo [INFO] 종료하려면 Ctrl+C를 누르세요.
echo.

REM 애플리케이션 실행
java -jar %JAR_FILE%

pause