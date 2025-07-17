@echo off
chcp 65001 > nul
title M-Inbody 시스템 진단

echo ===============================================
echo           M-Inbody 시스템 진단
echo ===============================================
echo.

echo [1] Java 버전 확인
echo ----------------------------------------
java -version
echo.

echo [2] 네트워크 어댑터 확인
echo ----------------------------------------
echo 모든 네트워크 어댑터:
ipconfig /all | findstr /i "어댑터\|Adapter\|이더넷\|Ethernet\|Wi-Fi\|무선"
echo.
echo 활성 네트워크 연결:
netsh interface show interface
echo.

echo [3] Npcap 설치 확인
echo ----------------------------------------
if exist "C:\Windows\System32\Npcap" (
    echo [OK] Npcap 폴더가 존재합니다.
    dir "C:\Windows\System32\Npcap\*.dll" 2>nul | findstr /i "npcap"
) else (
    echo [ERROR] Npcap 폴더가 존재하지 않습니다.
)
echo.

echo [4] Npcap 서비스 상태 확인
echo ----------------------------------------
sc query npcap 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Npcap 서비스를 찾을 수 없습니다.
) else (
    echo [OK] Npcap 서비스가 확인되었습니다.
)
echo.

echo [5] 관리자 권한 확인
echo ----------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 관리자 권한이 아닙니다.
    echo 패킷 캡처를 위해 관리자 권한으로 실행해주세요.
) else (
    echo [OK] 관리자 권한으로 실행 중입니다.
)
echo.

echo [6] 방화벽 규칙 확인
echo ----------------------------------------
netsh advfirewall firewall show rule name="M-Inbody" >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] M-Inbody 방화벽 규칙이 없습니다.
    echo install.bat를 실행하여 방화벽 규칙을 추가하세요.
) else (
    echo [OK] M-Inbody 방화벽 규칙이 존재합니다.
)
echo.

echo [7] JAR 파일 확인
echo ----------------------------------------
if exist "m-inbody.jar" (
    echo [OK] m-inbody.jar 파일이 존재합니다.
    for %%A in (m-inbody.jar) do echo 파일 크기: %%~zA bytes
) else (
    echo [ERROR] m-inbody.jar 파일을 찾을 수 없습니다.
)
echo.

echo [8] 포트 5000 사용 확인
echo ----------------------------------------
netstat -an | findstr :5000 >nul 2>&1
if %errorlevel% equ 0 (
    echo [WARNING] 포트 5000이 이미 사용 중입니다.
    netstat -an | findstr :5000
) else (
    echo [OK] 포트 5000이 사용 가능합니다.
)
echo.

echo [9] 게임 서버 연결 확인
echo ----------------------------------------
netstat -an | findstr :16000 >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] 포트 16000 연결이 확인됩니다.
    netstat -an | findstr :16000
) else (
    echo [WARNING] 포트 16000 연결이 없습니다. 게임이 실행 중인지 확인하세요.
)
echo.

echo [10] 네트워크 활동 테스트
echo ----------------------------------------
echo 5초간 네트워크 활동을 모니터링합니다...
ping -n 1 google.com >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] 인터넷 연결이 정상입니다.
) else (
    echo [WARNING] 인터넷 연결에 문제가 있을 수 있습니다.
)
echo.

echo ===============================================
echo                진단 완료
echo ===============================================
echo.

REM 간단한 패킷 캡처 테스트
echo [9] 패킷 캡처 테스트 (선택사항)
echo ----------------------------------------
set /p test="패킷 캡처 테스트를 실행하시겠습니까? (y/N): "
if /i "%test%"=="y" (
    echo 패킷 캡처 테스트 시작... (5초 후 자동 종료)
    java -jar m-inbody.jar --spring.profiles.active=prod --logging.level.com.hanaset.minbody=DEBUG --server.port=5001 & 
    timeout /t 5 >nul
    taskkill /f /im java.exe >nul 2>&1
    echo 패킷 캡처 테스트 완료.
)

echo.
echo 문제가 발생한 경우:
echo 1. 관리자 권한으로 실행했는지 확인
echo 2. Npcap이 정상 설치되었는지 확인
echo 3. 안티바이러스 소프트웨어가 차단하지 않는지 확인
echo 4. 게임이 패킷 분석을 차단하지 않는지 확인
echo.
pause