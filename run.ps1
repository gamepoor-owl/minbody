# M-Inbody 데미지 미터 실행 스크립트
# UTF-8 인코딩 설정
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# 콘솔 타이틀 설정
$host.UI.RawUI.WindowTitle = "M-Inbody 데미지 미터"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "      M-Inbody 데미지 미터 실행 중..." -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Java 확인
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "[INFO] Java 버전: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Java가 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host "Java 17 이상을 설치해주세요." -ForegroundColor Red
    Write-Host "다운로드: https://adoptium.net/" -ForegroundColor Yellow
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

# 현재 디렉토리로 이동
Set-Location $PSScriptRoot

# JAR 파일 확인
$jarFile = $null
if (Test-Path "m-inbody-0.0.1-SNAPSHOT.jar") {
    $jarFile = "m-inbody-0.0.1-SNAPSHOT.jar"
} elseif (Test-Path "m-inbody.jar") {
    $jarFile = "m-inbody.jar"
} else {
    Write-Host "[ERROR] JAR 파일을 찾을 수 없습니다." -ForegroundColor Red
    Write-Host "현재 디렉토리에 m-inbody-0.0.1-SNAPSHOT.jar 또는 m-inbody.jar 파일이 있는지 확인해주세요." -ForegroundColor Red
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

Write-Host "[INFO] 시스템 진단 중..." -ForegroundColor Green

# Npcap 서비스 확인
try {
    $npcapService = Get-Service -Name "npcap" -ErrorAction SilentlyContinue
    if ($npcapService) {
        Write-Host "[INFO] Npcap 서비스 상태: $($npcapService.Status)" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Npcap 서비스가 설치되지 않았습니다." -ForegroundColor Yellow
        Write-Host "패킷 캡처를 위해 Npcap 설치가 필요합니다." -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARNING] Npcap 서비스 확인 실패" -ForegroundColor Yellow
}

# 관리자 권한 확인
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "[WARNING] 관리자 권한이 필요합니다." -ForegroundColor Yellow
    Write-Host "패킷 캡처를 위해 관리자 권한으로 다시 실행합니다..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Write-Host "[INFO] 애플리케이션 시작 중..." -ForegroundColor Green
Write-Host "[INFO] 실행할 JAR 파일: $jarFile" -ForegroundColor Green
Write-Host "[INFO] 웹 브라우저에서 http://localhost:5000 으로 접속하세요." -ForegroundColor Cyan
Write-Host "[INFO] 종료하려면 Ctrl+C를 누르세요." -ForegroundColor Yellow
Write-Host ""

# 인코딩 환경 변수 설정
$env:JAVA_TOOL_OPTIONS = "-Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8"

# 애플리케이션 실행
$javaArgs = @(
    "-Dfile.encoding=UTF-8",
    "-Dconsole.encoding=UTF-8",
    "-Dsun.stdout.encoding=UTF-8",
    "-Dsun.stderr.encoding=UTF-8",
    "-Duser.language=ko",
    "-Duser.country=KR",
    "-jar", $jarFile,
    "--spring.profiles.active=prod",
    "--logging.level.com.hanaset.minbody=DEBUG",
    "--logging.level.org.pcap4j=DEBUG"
)

& java $javaArgs

Write-Host ""
Write-Host "[INFO] 애플리케이션이 종료되었습니다." -ForegroundColor Green
Read-Host "계속하려면 Enter를 누르세요"