# PEEK-A-BOOK
친구의 책장을 구경하거나, 친구에게 책을 추천할 수 있는 책장 공유 서비스

> 31st IN SOPT APP JAM <br>
>
> 프로젝트 기간 : 2022.12.11 ~ 진행중

<br>

![아요소개](https://user-images.githubusercontent.com/80062632/210297833-e66fd992-74af-4290-99eb-053a75080a2d.png)

<br>
<br>

## iOS Developers


| 윤수빈 | 김인영 | 고두영 |
| :---------:|:----------:|:---------:|
|<img width="300" alt="image" src="https://user-images.githubusercontent.com/80062632/210304286-697c18d5-ae36-45b5-a242-0ff62e387486.png"> | <img width="300" alt="image" src="https://user-images.githubusercontent.com/80062632/210303866-01f08884-968a-481d-ac8f-a7763a974263.png"> | <img width="300" alt="image" src="https://user-images.githubusercontent.com/80062632/210306055-c2b5b862-4076-42f0-a355-8ad67b71d6c4.png"> |
| [devxsby](https://github.com/devxsby) | [6uohul](https://github.com/6uohul) | [duyeong-ko](https://github.com/duyeong-ko) |

<br>
<br>

## Development Environment and Using Library
- Development Environment
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.7-orange?logo=swift">
<img src ="https://img.shields.io/badge/Xcode-14.2-blue?logo=xcode">
<img src ="https://img.shields.io/badge/iOS-13.0-green.svg">

<br>
<br>

- Library

라이브러리 | 사용 목적 | Version | Management Tool
:---------:|:----------:|:---------: |:---------:
 Moya | 서버 통신 | 15.0.0 | SPM
 SnapKit | UI Layout | 5.6.0 | SPM
 Then | UI 선언 | 3.0.0 | SPM
 Kingfisher  | 이미지 캐싱 | 7.4.1 | SPM
 BarcodeScanner | 바코드 스캔 | 5.0.1 | SPM
 
 <br>

- framework

프레임워크 | 사용 목적 
:---------:|:----------:
 UIKit | UI 구현

<br>
<br>

## Coding Convention
<details>
 <summary> 📓 Git Branch Convention </summary>
 <div markdown="1">       

 ---
 
 - **Branch Naming Rule**
    - Issue 작성 후 생성되는 번호와 Issue의 간략한 설명 등을 조합하여 Branch 이름 결정
    - `<Prefix>/<#IssueNumber>-<Description>`
- **Commit Message Rule**
    - `[Prefix] : <Description>`
- **Code Review Rule**
    - 코드 리뷰는 최대한 빨리 한다.
    - 코드 리뷰는 최대한 정성껏 한다.
   
 <br>

 </div>
 </details>

 <details>
 <summary> 📓 Git Flow </summary>
 <div markdown="1">       

 ---
 
 ```
1. 작업 단위별 Issue 생성 : 담당자, 라벨, 프로젝트 연결 

2. Fork 받은 로컬 레포에서 develop 브랜치 최신화 : git pull (origin develop) 

3. Branch 생성 : git switch -c Prefix/#IssueNumber-description 
   > 예시) feat/#10-메인뷰레이아웃구

4. 로컬 환경에서 작업 후 Add -> Commit -> Push -> Pull Request의 과정을 거친다.
   
   Prefix의 의미
   > [Feat] : 새로운 기능 구현
   > [Chore] : 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
   > [Add] : 코드 변경 없는 단순 파일 추가, 에셋 및 라이브러리 추가
   > [Fix] : 버그, 오류 해결, 코드 수정
   > [Style] : 코드 포맷팅, 코드 변경이 없는 경우, 주석 수정
   > [Docs] : README나 WIKI 등의 문서 개정
   > [Refactor] : 전면 수정이 있을 때 사용합니다
   > [Test] : 테스트 모드, 리펙토링 테스트 코드 추가

5. Pull Request 작성 
   - closed : #IssueNumber로 이슈 연결, 리뷰어 지정

6. Code Review 완료 후 Pull Request 작성자가 develop Branch로 merge하기
   - Develop Branch protection rules : Merge 전 최소 1 Approve 필요

7. 종료된 Issue와 Pull Request의 Label과 Project를 관리
```
   
 <br>

 </div>
 </details>

<details>
 <summary> 📓 Naming & Code Convention </summary>
 <div markdown="1">       

 ---
 
- 함수, 메서드 : **lowerCamelCase** 사용하고, 동사로 시작한다.
- 변수, 상수 : **lowerCamelCase** 사용한다.
- 클래스, 구조체, enum, extension 등 :  **UpperCamelCase** 사용한다.
- 기본 MVC 폴더링 구조에 따라 파일을 구분하여 사용한다.
- 파일, 메서드, 클래스 명 약어 사용 지양한다.
- 상속받지 않는 클래스는 **final 키워드**를 붙인다.
- 단일 정의 내에서만 사용되는 특정 기능 구현은 **private 접근 제한자**를 적극 사용한다.
- 퀵헬프기능을 활용한 마크업 문법을 활용한 주석을 적극 사용한다.
- 이외 기본 명명규칙은 [Swift Style Guide](https://google.github.io/swift/), [API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/), [Swift Style Guide](https://github.com/StyleShare/swift-style-guide)를 참고하고, 커스텀한 SwiftLint Rule을 적용한다.
   
   
 <br>

 </div>
 </details>

<details>
 <summary> 📓 Project Foldering </summary>
 <div markdown="1">       

 ---
   <aside>   
   <img width="298" alt="스크린샷 2023-01-09 08 07 45" src="https://user-images.githubusercontent.com/80062632/211223645-4536a5b6-790e-4968-9656-8dea280180e3.png">

     
</aside>
   
 <br>

 </div>
 </details>

<br>

---
   
### TEAM PEEK-A-BOOK
   
<img src="https://user-images.githubusercontent.com/80062632/210301655-95ec5d68-8255-447e-b9d7-96c4b7d79921.png" width="100px">
   

