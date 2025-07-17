@echo off
chcp 65001 > nul
title M-Inbody 데미지 미터 설치

echo ===============================================
echo       M-Inbody 데미지 미터 설치 마법사
echo ===============================================
echo.

REM 관리자 권한 확인
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] 관리자 권한이 필요합니다.
    echo 설치를 위해 관리자 권한으로 실행해주세요.
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb runAs"
    exit /b
)

echo [1단계] Java 17 설치 여부 확인...
java -version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java가 설치되어 있지 않습니다.
    echo.
    echo Java 17 다운로드 페이지를 열겠습니다...
    start https://adoptium.net/
    echo.
    echo Java 17을 설치한 후 다시 실행해주세요.
    pause
    exit /b 1
) else (
    echo [OK] Java가 설치되어 있습니다.
)

echo.
echo [2단계] Npcap 설치 여부 확인...
if exist "C:\Windows\System32\Npcap" (
    echo [OK] Npcap이 설치되어 있습니다.
) else (
    echo [WARNING] Npcap이 설치되어 있지 않습니다.
    echo.
    echo Npcap은 패킷 캡처를 위해 필요합니다.
    echo Npcap 다운로드 페이지를 열겠습니다...
    start https://npcap.com/#download
    echo.
    echo Npcap을 설치한 후 다시 실행해주세요.
    pause
    exit /b 1
)

echo.
echo [3단계] 방화벽 설정...
echo 방화벽에서 Java 애플리케이션 허용 규칙을 추가합니다.
netsh advfirewall firewall show rule name="M-Inbody" > nul 2>&1
if %errorlevel% neq 0 (
    netsh advfirewall firewall add rule name="M-Inbody" dir=in action=allow protocol=TCP localport=5000
    echo [OK] 방화벽 규칙이 추가되었습니다.
) else (
    echo [OK] 방화벽 규칙이 이미 존재합니다.
)

echo.
echo [4단계] 설치 완료 확인...
if exist "m-inbody.jar" (
    echo [OK] m-inbody.jar 파일이 존재합니다.
) else (
    echo [ERROR] m-inbody.jar 파일을 찾을 수 없습니다.
    echo 파일을 현재 디렉토리에 복사해주세요.
    pause
    exit /b 1
)

echo.
echo ===============================================
echo           설치가 완료되었습니다!
echo ===============================================
echo.
echo 이제 run.bat 파일을 실행하여 프로그램을 시작할 수 있습니다.
echo 웹 브라우저에서 http://localhost:5000 으로 접속하세요.
echo.
echo 주의사항:
echo - 패킷 캡처를 위해 관리자 권한으로 실행해야 합니다
echo - 일부 게임에서는 Npcap 감지 시 실행이 차단될 수 있습니다
echo - 게임 이용약관을 확인하고 사용하세요
echo.
pause