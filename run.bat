@echo off
setlocal enabledelayedexpansion
set "CONSOLE_FONT=Consolas"
title M-Inbody 데미지 미터

echo ===============================================
echo       M-Inbody 데미지 미터 실행 중...
echo ===============================================
echo.

REM Java 17 이상이 설치되어 있는지 확인
echo [INFO] Java 버전 확인 중...
java -version 2>&1 | findstr /i "version" > temp_java_check.txt
if %errorlevel% neq 0 (
    echo [ERROR] Java가 설치되어 있지 않습니다.
    echo Java 17 이상을 설치해주세요.
    echo 다운로드: https://adoptium.net/
    echo.
    del temp_java_check.txt 2>nul
    pause
    exit /b 1
)
del temp_java_check.txt 2>nul

REM 현재 디렉토리로 이동
cd /d "%~dp0"

REM JAR 파일 존재 확인 (최신 버전 우선)
set JAR_FILE=
if exist "m-inbody-0.0.1-SNAPSHOT.jar" (
    set JAR_FILE=m-inbody-0.0.1-SNAPSHOT.jar
) else if exist "m-inbody.jar" (
    set JAR_FILE=m-inbody.jar
) else (
    echo [ERROR] JAR 파일을 찾을 수 없습니다.
    echo 현재 디렉토리에 m-inbody-0.0.1-SNAPSHOT.jar 또는 m-inbody.jar 파일이 있는지 확인해주세요.
    echo.
    pause
    exit /b 1
)

echo [INFO] 시스템 진단 중...
echo [DEBUG] 현재 디렉토리: %cd%
echo [DEBUG] 스크립트 위치: %~dp0

REM 네트워크 어댑터 확인
echo [INFO] 네트워크 어댑터 확인 중...
ipconfig /all | findstr "어댑터\|Adapter" >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] 네트워크 어댑터 정보를 가져올 수 없습니다.
)

REM Npcap 서비스 확인
echo [INFO] Npcap 서비스 확인 중...
sc query npcap >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Npcap 서비스가 실행되지 않고 있습니다.
    echo Npcap이 제대로 설치되어 있는지 확인해주세요.
)

echo [INFO] 애플리케이션 시작 중...
echo [INFO] 실행할 JAR 파일: %JAR_FILE%
echo [INFO] 웹 브라우저에서 http://localhost:5000 으로 접속하세요.
echo [INFO] 종료하려면 Ctrl+C를 누르세요.
echo.

REM 관리자 권한으로 실행 (패킷 캡처를 위해 필요)
echo [INFO] 관리자 권한 확인 중...
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] 관리자 권한이 필요합니다.
    echo 패킷 캡처를 위해 관리자 권한으로 실행해주세요.
    echo.
    echo 관리자 권한으로 재실행하려면 아무 키나 누르세요...
    pause > nul
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"\"%~dp0\"\" && \"\"%~nx0\"\"' -Verb runAs -WorkingDirectory '\"%~dp0\"'"
    exit /b
)

REM 애플리케이션 실행 (디버그 모드로 더 자세한 로그 출력)
java -Dfile.encoding=UTF-8 -Dconsole.encoding=UTF-8 -jar %JAR_FILE% --spring.profiles.active=prod --logging.level.com.hanaset.minbody=DEBUG --logging.level.org.pcap4j=DEBUG

echo.
echo [INFO] 애플리케이션이 종료되었습니다.
pause