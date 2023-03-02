+++
title = "[General] Kasa에서 백엔드 엔지니어로서의 1년 회고하기"
date = "2023-02-24"
description = "Kasa에서 1년 동안 백엔드 엔지니어로서 지낸 시간을 회고합니다."
tags = ["General"]
+++


<br>
<br> 

> Kasa에서 1년 동안 백엔드 엔지니어로서 지낸 시간을 회고합니다.

<br> 

**Index**
1. Intro: 네? 회사가 매각된다구요? 그런데 부분 매각이라구요?
2. Work 
3. Dev Culture 

<br> 

# Intro: 네? 회사가 매각된다구요? 그런데 부분 매각이라구요?

#### 2021년 12월, 싱가포르 사업을 위한 신생 팀에 입사하다! 
2021년 12월 카사에 백엔드 엔지니어로 입사했다. 회사에서 막 싱가포르로 사업을 확장하기 시작했을 때였다. 
회사에 입사한 계기는 2가지였다. 하나는 `싱가포르`을 대상으로 한 `글로벌 사업`을 경험해 볼 수 있다는 것이었다. 항상 글로벌 사업을 경험하고 싶었고, 때문에 전직장에서는 글로벌 사업을
철수해서 이직을 결심하기도 했다. 

또 다른 계기는 `부동산 조각 투자`라는 `프롭테크 도메인`을 경험해 볼 수 있다는 것이었다. 언젠가 한 번 프롭테크 도메인을 경험하고 싶었는데 
일반 부동산이 아닌, 부동산을 조각내서 투자한다는 사업이 굉장히 흥미롭게 다가왔다.
<U>싱가포르 버전의 프로덕트를 만들어 내는 것이 입사한 팀의 역할이다.</U>

<details>
 <summary>부동산 조각 투자 도메인?</summary>
  
  건물을 하나 선택해 공모를 진행하면 사용자가 청약을 하고, 회사는 청약금을 모아 `한국투자신탁`을 통해 `DABS`라고 불리는 디지털 수익 증권을 발행해 사용자에게 분배한다. 그 후, 사용자는 DABS를 주식을 거래하듯 다른 `사용자들과 거래`를 할 수 있다.

  협력사인 `하나은행`과 연결해 계좌를 계설하고 예치금을 입금/출금할 수 있어 `뱅킹 도메인`도 경험을 할 수 있고 DABS 거래가 있어 `Trading-Matching 도메인`도 경험을 할 수 있다.
</details>



<br>

#### 2023년 01월, 카사 매각 소식을 듣다!
2023년 01월에 카사 매각 소식을 접하게 되었다.
부분 매각이었고, 매각의 대상은 코리아 프로덕트 팀이었다. 싱가포르 프로덕트 팀은 남아있는 것으로 결정되었다.  
`60명` 남짓했던 회사는 `10명`으로 규모가 줄었고, 규모가 줄어든 만큼 남은 인원들이 기존 인원들이 담당해왔던 업무들을 많이 가져와야 했다. 그 중 나는 `인프라 업무`를 서포트하게 되었다. 
`DevOps` 업무를 하게 된 것이다! 

DevOps 업무를 해보고 싶었기 때문에 염려도 되는 한 편, <U>새로운 업무를 하기 전에 1년 동안 내가 해왔던 일들을 회고해 둘 필요가 있음을 느꼈다.</U> 
길고 장황한 Intro였지만, 결국 이 이유로 회고를 작성하게 되었다. 


<br>

# Work
## JWT를 이용한 토큰 기반 서버 인증 개발 

## 기업형 사용자 온보딩 모듈 개발


## API 접근제한을 위한 Permission, Middleware 개발 

<br>

## Offering 모듈 요구사항 분석

부동산 조각 투자의 코어인 `건물`, `공모/청약`, `DABS 할당/발행`을 담당하는 Offering 모듈의 요구사항을 분석하게 되었다.
원래 Offering 기획을 하신 분이 내가 입사를 하기 전에 이미 퇴사를 하신 상태였고, 새로운 기획 담당자들과 함께 기획사항을 분석했다. 기획은 모두 싱가폴에 상주하고 있는 실무자들이 하기 때문에 문서 작성, 회의 등은 모두 `영어`로 이루어졌고, 
팀에 공유를 하기 위해 다시 한국어로 번역을 하는 식으로 진행했다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/qna.png" >
<figcaption align = "center">[Picture] 총 160개의 질문</figcaption>


<br>

핵심 모듈의 요구사항을 잘못 분석한 상태로 개발에 들어가면 수정할 사항이 겉잡을 수 없을 만큼 커지고, 팀의 시간을 낭비하는 것이기 때문에 하나라도 놓치지 않겠다는 마음으로 임했다. 
작업 초기에는 이 도메인이 처음인 내가 이해하기에 조금 어려웠으나 방대한 요구사항을 심층 분석하면서 회사의 도메인을 깊게 파악할 수 있는 기회였다.

이 작업을 하면서 개발자는 코딩만 잘하면 되는 것이 아니라 <U>요구사항을 파고 들어 분석을 해야 하며, 분석 과정에서 기획자나 다른 실무진들과 원활하면서도 긴밀하게 소통을 하기 위해 노력해야 한다는 것을 배웠다.</U> 

또한, `잘 질문하는 방법`에 대해서 많이 고민했다. 



<br>

## Offering 모듈 API 명세 작성
요구사항을 토대로 <U>요구사항들을 충족하기 위해 어떤 API가 호출이 되어야 하는지 명세를 작성했다.</U>
이 API 명세를 바탕으로 나를 포함한 백엔드 팀에서 실제 개발에 들어가기 때문에 누락된 요구사항은 없는지, 요구사항과 불일치 하는 것은 없는지 검토를 해야 했다.

회사 도메인에서 가장 핵심이 되는 모듈이었고, 이에 따라 요구사항도 다각화 되어있어 API 명세 정립도 쉽지 않았다.
하지만 셀장님, 팀원분들 그리고 프론트엔드 담당자분과 여러 번의 컨펌 끝에 총 `113개의 API 명세` 완성할 수 있었다.  

<br>

> API 명세 Case 

- Issuer (건물주) 관리 
  - Issuer 온보딩
  - Issuer 승인 
- Deal 관리 
  - Deal 등록
  - Deal 공개 
  - Deal 정보 수정 
- 공모/청약
  - 청약 신청/취소
  - 공모 종료
  - DABS 확인


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/script.png" >
<figcaption align = "center">[Picture] API 명세 예시</figcaption>



<br>

## 싱가포르 정부 Mydata 서비스 연결 



<br>

## 공모 종료와 DABS 할당 로직 개발 

## 공모금 이체 로직 개발

## DABS 발행 로직 개발 

## 대사 개발 

## Notification 모듈 개발 


## 싱가포르 금융관리국 MAS regulation 획득을 위한 펜테스트 지원 

<br>

# Dev Culture 

## 사내 스터디 리드
전 직장에서 스터디를 했던 게 너무 재미있어서 이번에도 사내 스터디를 조직했다. 토이 프로젝트나 회사 기술 블로그를 만들고 싶었지만 일정이 여의치 않아 책 스터디로 진행했다.
특히 HTTP 완벽 가이드는 쌩신입일때 추천받아 읽은 책인데 3년 정도 후에 다시 읽어보니 이해할 수 있는 폭이 넓어져있어서 뿌듯했다. 

<br>

> 진행한 책 
- HTTP 완벽 가이드 
- 하이퍼레저 패브릭으로 배우는 블록체인
- Kotlin in Action 

<br>

> 진행 방법

- 준비 
  - 주차별로 정해진 분량 독서 ([3색 독서법](https://brunch.co.kr/@libraryman/46))
  - 참가자 모두가 주차별로 할당된 주제에 대해 발표 준비 
- 스터디 
  - 발표 
  - 토론/회고 (좋았던 내용, 고민, 어려움, 더 찾아본 부분 공유)
- 참고 
  - [2022 우아한 스터디](https://puffy-stick-fa1.notion.site/2022-ca5f43fc259d446d81f376256d18b99b)


<br>

## Django에서 동시성을 다루는 방법 세미나 진행 
2022년 11월에 `Django에서 동시성을 다루는 방법` 이라는 제목으로 세미나를 진행했다.
Django로 백엔드 서버를 다루면서 마주했던 `동시성` 관련 이슈를 트러블 슈팅하면서 배운 점을 정리해 사내의 개발자들과 함께 공유하는 시간을 가졌다.

<br>

> 세미나에서 다룬 것 

- API 요청을 `Serialize` 하는 방법 
  - Request를 하나의 큐에 모아 Serialize 하게 처리 
  - DB의 Transaction을 Serialize 하게 처리
- Django Transaction `Atomicity` 
  - Django ORM: select_for_update
  - Django ORM: Atomic compare-and-swaps 
  - Redis Lock
- Django Transaction Test & `Durability`

<br>

세미나 영상과 발표 자료, 회고는 [[[Seminar] Django에서 동시성을 다루는 방법으로 인생 첫 세미나 진행하기]](https://leeleelee3264.github.io/post/2022-12-26-kasa-concurrency-seminar/) 에서 더 자세하게 다루고 있다.   


<br>

## Naver Deview 2023 참석 
2023년 02월에 Naver 개발자 컨퍼런스인 Deview 2023에 참석했다.
2022년에 NHN의 Forward 이후 두 번째로 참석하는 오프라인 개발자 컨퍼런스였다. 

급하게 회사로 복귀해야 해서 세션은 하나 밖에 듣지 못했지만 부스가 알찼다. 특히 `네이버 클로바`와 `네이버 제트`의 개발팀에게 직접 
사내 개발 문화와 분위기, 필수로 요구되는 스킬 등을 질문하고 그 분들의 답변을 들을 수 있어서 좋았다.

특히 네이버 제트에 계신 분이 해주신 답변이 인상 깊었다. 
단순히 기술을 도입하는 것이 아니라 <U>왜 이 기술을 도입해야 하며, 이 기술을 통해 해결할 수 있는 것이 무엇인지</U>를 고민하며 사내의 기술 스텍을 쌓아간다는 말씀이 좋았다. 
내가 도입하고 싶어하는 기술이 정말 이 Use Case에 적합해서인지, 아니면 지금 인기가 많은 기술이라 그런지 가끔씩 의구심이 들었는데 정곡을 찔린 느낌이었다.  

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/IMG_5553.JPG" >
<figcaption align = "center">[Picture] Deview 포토존</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/IMG_5563.JPG" >
<figcaption align = "center">[Picture] Deview 입장 팔찌</figcaption>

<br> 