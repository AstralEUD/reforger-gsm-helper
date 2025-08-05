# Reforger GSM Helper

LinuxGSM (Arma Reforger) 서버 관리를 위한 강력한 CLI 도구 모음으로, 포괄적인 모드 배치 관리 기능을 제공합니다.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20WSL-blue)](https://github.com/AstralEUD/reforger-gsm-helper)

[🇺🇸 English Version](README.md) | **🇰🇷 한국어 버전**

## 🚀 주요 기능

### Reforger 모드 매니저 CLI 도구
Arma Reforger 서버 모드를 배치 단위로 관리하는 포괄적인 CLI 도구입니다. 모드 목록을 관리 가능한 배치로 분할하여 다양한 모드 구성을 테스트할 수 있게 도와주며, 서버 문제 해결과 모드 테스트를 훨씬 쉽게 만들어줍니다.

#### ✨ 핵심 기능:
- 📦 **스마트 배치 관리**: 모드 목록을 구성 가능한 배치로 자동 분할 (배치당 10-15개 모드)
- 🔄 **쉬운 구성 전환**: 간단한 메뉴 선택으로 다양한 모드 구성 간 전환
- 💾 **자동 백업 시스템**: 원본 구성의 타임스탬프 백업 자동 생성
- 🧹 **지능형 애드온 정리**: 구성 전환 시 애드온 디렉토리 자동 정리
- ⚙️ **유연한 구성**: 구성 파일 및 애드온 디렉토리의 사용자 정의 경로
- 📅 **날짜별 구성**: 쉬운 관리를 위한 날짜별 배치 파일 구성
- 🔧 **고급 옵션**: 
  - 배치 크기 조정 (메뉴 98)
  - 배치 재생성 (메뉴 99)
  - 간편한 종료 (q)
- 🪟 **크로스 플랫폼 지원**: Linux 네이티브 + Windows WSL 호환성

## 📋 목차

- [설치 및 사용법](#-설치-및-사용법)
- [작동 원리](#-작동-원리)
- [메뉴 옵션](#-메뉴-옵션)
- [구성](#-구성)
- [디렉토리 구조](#-디렉토리-구조)
- [문제 해결](#-문제-해결)
- [기여하기](#-기여하기)
- [라이선스](#-라이선스)

## 🛠️ 설치 및 사용법

### 필수 요구사항
- Arma Reforger가 설치된 Linux 서버 (또는 Windows용 WSL)
- `jq` 패키지 설치
- Bash 셸 환경

### 빠른 설치

1. **저장소 클론:**
   ```bash
   git clone https://github.com/AstralEUD/reforger-gsm-helper.git
   cd reforger-gsm-helper
   ```

2. **의존성 설치:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update && sudo apt-get install jq
   
   # CentOS/RHEL/Rocky
   sudo yum install jq
   # 또는
   sudo dnf install jq
   ```

3. **실행 권한 부여 및 실행:**
   ```bash
   # Linux
   chmod +x reforger-mod-manager.sh
   ./reforger-mod-manager.sh
   
   # Windows (WSL 필요)
   reforger-mod-manager.bat
   ```

### 🎯 첫 실행 설정

도구를 처음 실행할 때, 설정 과정을 안내해줍니다:

1. **📁 헬퍼 디렉토리 생성**: 시스템에 `/reforger-gsm-helper/` 폴더 생성 여부 확인
2. **⚙️ 경로 구성**: 
   - 구성 파일 경로 (기본값: `/armarserver/serverfiles/armaserver_config.json`)
   - 애드온 디렉토리 경로 (기본값: `/armarserver/serverfiles/profiles/server/addons`)
   - 배치 크기 선호도 (기본값: 배치당 10개 모드)
3. **💾 설정 저장**: `settings.json`에 구성을 자동으로 저장

## 🔍 작동 원리

도구는 모드 구성을 관리하기 위해 체계적인 방식을 따릅니다:

1. **🔍 모드 감지**: `armaserver_config.json`을 스캔하고 총 모드 수를 분석
2. **📦 스마트 배치 생성**: 점진적인 모드 수를 가진 여러 진보적인 구성 파일 생성
3. **📅 일별 구성**: 쉬운 추적을 위해 모든 배치를 날짜별로 구성된 폴더에 저장
4. **🎮 인터랙티브 선택**: 구성 전환을 위한 직관적인 메뉴 시스템 제공
5. **🧹 자동 정리**: 애드온 디렉토리를 정리하고 선택된 구성을 원활하게 적용

## 🎮 메뉴 옵션

도구는 다양한 옵션을 가진 직관적인 메뉴 시스템을 제공합니다:

### 주요 메뉴 옵션:
- **0**: 🔄 원본 구성 복원 (모든 모드)
- **1-N**: 📦 배치 구성 적용 (N = 생성된 배치 수)
- **98**: ⚙️ 배치 크기 설정 변경
- **99**: 🔄 현재 설정으로 모든 배치 재생성
- **q**: 🚪 애플리케이션 종료

### 📊 사용 예시

배치 크기가 10인 40개의 모드가 있다고 가정해보겠습니다:

```
📋 원본 구성: 40개 모드
├── 📦 배치 1: 모드 1-10   (10개 모드)
├── 📦 배치 2: 모드 1-20   (20개 모드)
├── 📦 배치 3: 모드 1-30   (30개 모드)
└── 📦 배치 4: 모드 1-40   (40개 모드 - 전체)
```

**🖥️ 인터랙티브 메뉴 표시:**
```
🚀 Reforger 모드 매니저 v1.0
════════════════════════════════════════════

📅 오늘 사용 가능한 옵션 (2025-08-05):

 0) 🔄 원본 구성 복원 (40개 모드)
 1) 📦 배치 1 (10개 모드)
 2) 📦 배치 2 (20개 모드)
 3) 📦 배치 3 (30개 모드)
 4) 📦 배치 4 (40개 모드)

고급 옵션:
98) ⚙️  배치 크기 변경
99) 🔄 배치 재생성
 q) 🚪 종료

선택하세요: 2
```

`2`를 선택하면 처음 20개의 모드가 적용되고 애드온 디렉토리가 자동으로 정리됩니다.

## 📁 디렉토리 구조

도구 실행 후, 디렉토리 구조는 다음과 같이 구성됩니다:

```
📂 reforger-gsm-helper/
├── ⚙️ settings.json
├── 📅 2025-08-05/
│   ├── 💾 armaserver_config_original.json.bak
│   ├── 📦 armaserver_config_batch_1.json
│   ├── 📦 armaserver_config_batch_2.json
│   ├── 📦 armaserver_config_batch_3.json
│   └── 📦 armaserver_config_batch_4.json
├── 📅 2025-08-06/
│   └── (추가 배치 파일들...)
└── 📅 (다른 날짜들...)
```

## ⚙️ 구성

`settings.json` 파일은 개인화된 구성을 저장합니다:

```json
{
  "config_path": "/armarserver/serverfiles/armaserver_config.json",
  "addons_path": "/armarserver/serverfiles/profiles/server/addons", 
  "batch_size": 10,
  "created_date": "2025-08-05"
}
```

### 구성 옵션:
- **`config_path`**: Arma Reforger 서버 구성 파일 경로
- **`addons_path`**: 서버 애드온 디렉토리 경로
- **`batch_size`**: 배치당 모드 수 (메뉴 98을 통해 조정 가능)
- **`created_date`**: 구성이 생성된 날짜

## 🔧 문제 해결

### 일반적인 문제 및 해결책

#### 1. **`jq` 명령을 찾을 수 없음**
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install jq

# CentOS/RHEL/Rocky
sudo yum install jq
# 또는 최신 버전의 경우
sudo dnf install jq

# Arch Linux
sudo pacman -S jq
```

#### 2. **권한 거부 오류**
```bash
# 스크립트 실행 권한 부여
chmod +x reforger-mod-manager.sh

# 파일 권한 확인
ls -la reforger-mod-manager.sh
```

#### 3. **구성 파일을 찾을 수 없음**
- `settings.json`의 경로가 올바른지 확인
- Arma Reforger 서버가 제대로 설치되었는지 확인
- 구성 파일이 존재하는지 확인: `ls -la /armarserver/serverfiles/armaserver_config.json`

#### 4. **WSL 문제 (Windows 사용자)**
```powershell
# WSL이 설치되지 않은 경우 설치
wsl --install

# WSL 업데이트
wsl --update

# 기본 WSL 버전 설정
wsl --set-default-version 2
```

#### 5. **배치 생성 실패**
- 충분한 디스크 공간 확인
- 대상 디렉토리의 쓰기 권한 확인
- 원본 구성 파일의 JSON 구문 확인

### 🆘 도움 받기

위에서 다루지 않은 문제가 발생한 경우:

1. **📋 필수 요구사항 확인**: 모든 의존성이 설치되었는지 확인
2. **🔍 파일 경로 확인**: `settings.json`의 모든 경로를 다시 확인
3. **🔐 권한 확인**: 적절한 읽기/쓰기 권한이 있는지 확인
4. **🐛 이슈 생성**: [GitHub Issues](https://github.com/AstralEUD/reforger-gsm-helper/issues)에서 다음 정보와 함께 버그 신고:
   - 운영 체제 및 버전
   - 오류 메시지 (전체 출력)
   - 문제 재현 단계
   - `settings.json` 구성 (민감한 경로 제거)

## 🤝 기여하기

기여를 환영합니다! 이 프로젝트를 개선하는 방법:

### 기여 방법:
- 🐛 **버그 신고**: 재현 단계와 함께 상세한 버그 리포트 제출
- 💡 **기능 요청**: 새로운 기능이나 개선사항 제안
- 📝 **문서화**: 문서 및 예제 개선에 도움
- 💻 **코드 기여**: 버그 수정이나 새로운 기능의 풀 리퀘스트 제출
- 🌐 **번역**: 다른 언어로 문서 번역 도움

### 개발 환경 설정:
1. 저장소 포크
2. 기능 브랜치 생성: `git checkout -b feature/your-feature-name`
3. 변경사항 작성 및 철저한 테스트
4. 명확한 메시지로 커밋: `git commit -m "Add: 변경사항 설명"`
5. 포크에 푸시: `git push origin feature/your-feature-name`
6. 풀 리퀘스트 생성

### 코드 가이드라인:
- 기존 코드 스타일과 규칙을 따라주세요
- 복잡한 로직에는 주석을 추가해주세요
- Linux와 WSL 모두에서 변경사항을 테스트해주세요
- 새로운 기능에 대한 문서를 업데이트해주세요

## 📄 라이선스

이 프로젝트는 **GNU General Public License v3.0** 하에 라이선스됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

### GNU GPL v3 라이선스 요약:
- ✅ 상업적 사용 허용
- ✅ 수정 허용
- ✅ 배포 허용
- ✅ 개인적 사용 허용
- ✅ 특허 사용 허용
- ⚠️ 라이선스 및 저작권 고지 포함 필수
- ⚠️ 코드 변경사항 명시 필수
- ⚠️ 소스 코드 공개 필수
- ⚠️ 파생작업에 동일한 라이선스 사용 필수
- ❌ 보증 제공 안함
- ❌ 책임 없음

---

## 🌟 이 프로젝트에 별점 주기

이 도구가 도움이 되었다면, GitHub에서 ⭐을 눌러주세요! 다른 사람들이 프로젝트를 발견하는데 도움이 되고 지속적인 개발에 동기를 부여합니다.

**Arma Reforger 커뮤니티를 위해 ❤️로 만들어졌습니다**
