# M-Inbody 데미지 미터

Spring Boot 기반 게임 패킷 분석 데미지 미터입니다.

## 시스템 요구사항

- **Java 17 이상** (필수)
- **Windows 10/11** (패킷 캡처를 위한 관리자 권한 필요)
- **Npcap** (패킷 캡처 라이브러리) - 설치 필요

## 설치 방법

### 1. Java 17 설치
- [Eclipse Temurin JDK 17 Windows x64 설치 파일](https://adoptium.net/temurin/releases/windows-x64/jdk-17/) 다운로드
- 또는 직접 다운로드: [OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.msi](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.msi)
- 설치 시 "Add to PATH" 옵션을 반드시 체크하세요

### 2. Npcap 설치
- [Npcap 공식 사이트](https://npcap.com/#download)에서 다운로드 및 설치
- 많은 게임에서 Npcap 실행을 감지하여 차단할 수 있으니 주의하세요

## 실행 방법

### 자동 실행 (권장)
```bash
run.bat
```

### 수동 실행
```bash
java -jar m-inbody.jar
```

## 사용 방법

1. `run.bat` 파일을 **관리자 권한으로** 실행
2. 웹 브라우저에서 `http://localhost:5000` 접속
3. 게임 실행 후 자동으로 패킷 분석 시작

## 주요 기능

- **실시간 데미지 통계**: 실시간으로 데미지 통계 표시
- **스킬별 분석**: 각 스킬별 데미지 상세 분석
- **DPS 계산**: 시간당 데미지 계산
- **데이터 저장/불러오기**: 분석 결과 저장 및 불러오기
- **다양한 집계 모드**: 전체/보스/허수아비 모드 지원

## 설정

### 포트 변경
기본적으로 5000번 포트를 사용합니다. 변경하려면:
```bash
java -jar m-inbody.jar --server.port=8080
```

### 네트워크 인터페이스 변경
```bash
java -jar m-inbody.jar --packet.capture.interface=eth0
```

## 문제 해결

### Java 관련 문제
- `'java'는 내부 또는 외부 명령이 아닙니다`: Java PATH 설정 확인
- `UnsupportedClassVersionError`: Java 17 이상 버전 설치 필요

### 패킷 캡처 관련 문제
- `No network interface found`: Npcap 설치 여부 확인
- `Access denied`: 관리자 권한으로 실행 필요

### 게임 관련 문제
- 일부 게임에서 Npcap 감지 시 실행 차단 가능
- 게임 실행 전에 패킷 캡처 프로그램 종료 권장

## 기술 스택

- **Spring Boot 3.3.4**
- **Kotlin 1.9.22**
- **pcap4j** (패킷 캡처)
- **WebSocket** (실시간 통신)
- **Jackson** (JSON 처리)

## 라이센스

본 프로젝트는 개인 사용 목적으로 제작되었습니다.

## 주의사항

⚠️ **중요**: 이 프로그램은 네트워크 패킷을 분석하는 도구입니다. 
- 게임 데이터를 수정하지 않으며 읽기 전용입니다
- 일부 게임에서는 패킷 분석 프로그램 사용을 금지할 수 있습니다
- 사용 전 해당 게임의 이용약관을 확인하세요