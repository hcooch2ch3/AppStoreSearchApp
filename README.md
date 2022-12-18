# AppStoreSearchApp
![Simulator Screen Recording - iPhone 14 Pro - 2022-12-18 at 11 58 08](https://user-images.githubusercontent.com/28377820/208279174-3af5f04b-c12a-4952-bf37-1d6bfe5c9e64.gif)

### 프로젝트 설명
- AppStore의 검색 탭 기능을 클론 코딩
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1)를 이용하여 구현
- 검색어 입력 전에는 최근 검색어 목록이 나타남
- 검색어 입력 중에는 현재 입력된 내용과 유사한 검색어를 나열
- 검색어 입력 완료하면 해당 검색어에 대한 결과를 나열
- 앱 검색 결과를 선택하면 해당 앱의 세부 설명, 스크린샷을 볼 수 있음

### 개발 환경
- Xcode 버전: Version 14.2 (14C18)
- Simulator 버전: Version 14.2 (986.5)
- 최소 타겟 버전: iOS 13.0

### 기술
- 아키텍처: MVVM
- 사용 기술: UIKit, StoryBoard(AutoLayout), ReactiveX, Swift Package Manager
- 의존성: Alamofire, RxSwift, RxCocoa
