# 🎓 NCS Vita

**NCS 국가직무능력표준 수학 게임 학습 앱**

분수 비교, 덧셈/뺄셈, 곱셈 비교 등 수학 개념을 게임화하여 학습하는 Flutter 기반 모바일 앱입니다.

---

## 📋 프로젝트 개요

| 항목 | 설명 |
|------|------|
| **프로젝트명** | NCS Vita 1.0 |
| **개발 기간** | 2025-12-01 ~ ing |
| **개발 방식** | 단독 개발 |
| **기술 스택** | Flutter + Dart |
| **지원 플랫폼** | Android, iOS, Windows, Linux, Web |
| **상태** | 개발 중 (미출시) |

---

## 🎮 주요 기능

### 1. **연습 모드**
- 3가지 게임 타입 선택 가능
- 난이도 (레벨 1~10) 조절
- 문제 개수 설정 (10~30개)
- 타이머 기반 게임 진행

### 2. **게임 타입**
- **분수 비교**: $\frac{a}{b}$ vs $\frac{c}{d}$ 크기 비교
- **덧셈/뺄셈**: 수열의 합 또는 빈칸 값 계산
- **곱셈 비교**: $a \times b$ vs $c \times d$ 크기 비교

### 3. **검정 모드**
- 실전 시험 형식의 문제 풀이

### 4. **내 정보**
- 학습 통계 및 진행도 확인

### 5. **설정**
- 다크 모드 토글
- 글꼴 크기 조절

---

## 📂 프로젝트 구조

```
lib/
├── main.dart                           # 앱 진입점
├── features/                           # 기능별 모듈화
│   ├── game/                          # 게임 로직
│   │   ├── game_screen.dart           # 게임 메인 화면
│   │   ├── controllers/
│   │   │   ├── game_controller.dart   # 게임 상태 관리
│   │   │   └── timer_controller.dart  # 타이머 관리
│   │   ├── models/
│   │   │   ├── game_config.dart       # 게임 설정 (타입, 레벨 등)
│   │   │   ├── game_question.dart     # 문제 타입 (분수, 덧셈, 곱셈)
│   │   │   ├── game_result.dart       # 게임 결과
│   │   │   ├── level_config.dart      # 레벨별 난이도 설정
│   │   │   ├── table_schema.dart      # 표 스키마
│   │   │   └── table_data.dart        # 표 데이터
│   │   ├── services/
│   │   │   ├── game_service.dart      # 문제 생성 로직
│   │   │   └── table_service.dart     # 표 데이터 관리
│   │   └── widgets/
│   │       ├── addition_widget.dart    # 덧셈 문제 UI
│   │       ├── fraction_widget.dart    # 분수 비교 UI
│   │       ├── multiple_widget.dart    # 곱셈 비교 UI
│   │       ├── number_pad.dart         # 숫자 입력 패드
│   │       ├── pause_modal.dart        # 일시정지 모달
│   │       └── table_widget.dart       # 표 렌더링
│   ├── home/                          # 홈 화면 (탭 네비게이션)
│   │   ├── home_screen.dart           # 홈 메인 (4개 탭)
│   │   └── tabs/
│   │       ├── practice_tab.dart       # 연습 모드 탭
│   │       ├── sample_tab.dart         # 내 정보 탭
│   │       └── setting_tab.dart        # 설정 탭
│   └── result/
│       └── result_screen.dart          # 게임 결과 화면
├── models/
│   └── settings.dart                   # 앱 전역 설정 (다크모드, 폰트 등)
├── theme/
│   ├── theme.dart                      # Material 3 테마 (라이트/다크)
│   ├── colors.dart                     # 색상 정의
│   ├── font.dart                       # 폰트 설정
│   └── components/                     # 재사용 UI 컴포넌트
└── utils/                              # 유틸리티 함수 (예정)
```

---

## 🏗️ 아키텍처 패턴

### **State Management**
- `ChangeNotifier` + `ListenableBuilder` 사용
- 필요한 부분만 선택적 재렌더링
- 타이머와 게임 상태 분리 관리

### **Feature-Based 구조**
- 각 기능(game, home, result)을 독립적 모듈로 관리
- models, controllers, services, widgets 분리
- 스케일링 및 테스트 용이

### **게임 흐름**
```
Home Screen (탭 네비게이션)
    ↓
PracticeTab (게임 설정)
    ↓
Game Screen (게임 진행)
    ├── AdditionWidget / FractionWidget / MultipleWidget
    └── GameController (상태 관리)
    ↓
Result Screen (결과 확인)
    ↓
Home로 복귀
```

---

## 🔧 의존성

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.3      # 로컬 데이터 저장
  uuid: ^4.4.0                    # 고유 ID 생성
  cupertino_icons: ^1.0.8         # iOS 아이콘
```

---

## 🚀 시작하기

### 설치 및 실행

```bash
# 1. 프로젝트 클론
git clone https://github.com/qomm9701/ncs_vita.git
cd ncs_vita

# 2. 의존성 설치
flutter pub get

# 3. 앱 실행 (기본: Android)
flutter run

# 4. 특정 플랫폼 지정
flutter run -d windows    # Windows
flutter run -d ios        # iOS
flutter run -d macos      # macOS
flutter run -d chrome     # Web
```

---

## 📊 게임 설정

### **GameConfig 구조**

```dart
GameConfig(
  type: GameType.fraction,    // 게임 타입 (calculation, fraction, multiple)
  level: 5,                    // 난이도 (1~10)
  count: 15,                   // 문제 개수 (10~30)
  timer: 30,                   // 시간 제한 (초)
)
```

### **게임 타입**

| 타입 | 설명 | 예시 |
|------|------|------|
| `calculation` | 덧셈/뺄셈 | 1 + 2 + 3 = **?** |
| `fraction` | 분수 비교 | **1/2** vs 2/3 (작음/같음/큼) |
| `multiple` | 곱셈 비교 | 5 × 7 vs 6 × 6 (작음/같음/큼) |

---

## 🎨 테마 및 UI

### **Material 3 적용**
- 라이트/다크 모드 자동 전환
- 커스텀 색상 팔레트
  - Primary: `#3B82F6` (파란색)
  - Secondary: `#FACC15` (노란색)
  - Error: `#F87171` (빨간색)

### **컴포넌트**
- AppCard: 카드형 UI 컴포넌트
- NumberPad: 숫자 입력 패드
- PauseModal: 일시정지 모달 (블러 효과)

---

## 🔍 주요 클래스 및 함수

### **GameController**
```dart
class GameController extends ChangeNotifier {
  int currentIdx;              // 현재 문제 번호
  int correctCnt;              // 정답 개수
  TimerController timer;       // 타이머
  
  void handleAnswer(bool correct);  // 답변 처리
  void pause() / void resume();     // 일시정지/재개
}
```

### **GameService**
```dart
class GameService {
  // 문제 생성 함수들
  static FractionPair generateFractionPair({...});
  static MultiplicationPair generateMultiplicationPair({...});
  static AdditionSet generateAddProblem({...});
  static TableProblem generateTableProblem({...});
}
```

---

## 📱 플랫폼별 지원 상황

| 플랫폼 | 상태 | 비고 |
|--------|------|------|
| Android | ✅ 지원 | APK 빌드 가능 |
| iOS | ✅ 지원 | IPA 빌드 가능 |
| Windows | ✅ 지원 | 데스크톱 앱 |
| Linux | ✅ 지원 | 데스크톱 앱 |
| Web | ✅ 지원 | 웹 브라우저 |

---

## 🔜 향후 계획

- [ ] 로컬 저장소 기능 (`shared_preferences` 활용)
- [ ] 학습 통계 대시보드
- [ ] 광고 통합
- [ ] 리더보드 (온라인 점수)
- [ ] 추가 게임 타입 (확률, 기하 등)
- [ ] 애니메이션 효과 추가
- [ ] 사운드 효과

---

## 📚 리소스 및 참고

- [Flutter 공식 문서](https://flutter.dev)
- [Dart 공식 문서](https://dart.dev)
- [Material Design 3](https://m3.material.io)

---

## 📝 라이선스

개인 프로젝트 (배포 예정)

---

## 👤 개발자

**박재훈** (qomm9701@gmail.com)

GitHub: [github.com/qomm9701/ncs_vita](https://github.com/qomm9701/ncs_vita)
