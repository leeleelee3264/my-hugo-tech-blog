+++
title = "[General] Kasa에서 백엔드 엔지니어로서의 1년 회고하기"
date = "2023-03-01"
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

저는 2021년 12월 백엔드 엔지니어로 카사에 입사했습니다. 그때는 회사가 막 `싱가포르`로 사업을 확장하기 시작했을 때였습니다. 제가 이 회사에 입사한 이유는 두 가지입니다. 첫 번째는 `글로벌 사업`을 경험해 볼 수 있는 기회가 있다는 것이었습니다. 항상 글로벌 사업을 경험해 볼 수 있는 포지션을 선호해왔습니다. 

두 번째 이유는 `부동산 조각 투자`라는 `프롭테크 도메인`을 경험해 볼 수 있다는 것이었습니다. 일반 부동산이 아닌 부동산을 조각내서 투자하는 사업이 굉장히 흥미로웠습니다. 이에 입사한 팀은 싱가포르 버전의 프로덕트를 만들어 내는 것이 주요 역할입니다.


<details>
 <summary>부동산 조각 투자 도메인?</summary>

하나의 건물을 선택해 공모를 진행하면, 사용자들이 청약을 하고 회사는 청약금을 모아 `DABS`라고 불리는 디지털 수익 증권을 `한국투자신탁`을 통해 발행하여 사용자들에게 분배한다. 그 후, 사용자들은 DABS를 주식을 거래하는 것처럼 다른 사용자들과 거래할 수 있다 

또한 협력사인 `하나은행`과 연결하여 계좌를 개설하고 예치금을 입금하거나 출금할 수 있어, `뱅킹 도메인`의 경험을 쌓을 수 있다. 이와 함께 DABS 거래가 가능하기 때문에 `Trading-Matching 도메인`의 경험도 할 수 있다.

</details>



<br>

#### 2023년 01월, 카사 매각 소식을 듣다!

2023년 1월, 카사의 부분 매각 소식을 접했습니다. 매각 대상은 코리아 프로덕트 팀이었으며, 싱가포르 프로덕트 팀은 남았습니다. 회사는 이전에는 약 60명이 근무했지만, 매각 후 10명으로 축소되어 많은 업무를 담당해야 했습니다. 그 결과, `DevOps` 서포트 업무를 맡게 되었습니다.  
새로운 업무에 도전하게 된 것은 기쁨과 걱정이 함께하는 일이었지만, 이전 1년간 수행해온 일들을 회고해봐야 한다는 생각이 들어 긴 Intro를 작성한 끝에 회고를 시작하게 되었습니다.


<br>

# Work
## JWT를 이용한 Token Authentication 개발
`JWT`를 토큰으로 사용하는 `Token Authentication`을 구현했습니다. 이 구조에서는 `access token`으로 요청하며, 만료될 경우 `refresh token`을 사용하여 새로운 access token을 발급합니다. 이를 위해 Django rest framework의 `simplejwt` 라이브러리를 사용하여 토큰 생성, revoke 및 refresh를 구현했습니다.

처음에는 토큰의 유효 기간이나 폐기등의 토큰 정책을 고려하지 않았습니다. 하지만 `싱가포르 금융감독기관`의 인증인 `MAS Regulation`을 준수하기 위해랙 서버 보안 강화해야 했고, 이에 토큰 정책도 고려하게 되었습니다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/token.png" >
<figcaption align = "center">[Picture 1] Token Authentication 흐름</figcaption>

<br>



#### 토큰 보안 강화

처음에 access token의 만료시간은 10분, refresh token의 만료시간은 12시간으로 설정했습니다. 그러나 refresh token의 만료시간이 너무 길어서, access token을 재발급 받을 때마다 refresh token도 새롭게 발급하는 `ROTATE_REFRESH_TOKENS` 정책을 적용하여 refresh token의 수명을 10분으로 줄였습니다.

조사 결과, 링크드인의 access token의 만료시간은 1일, refresh token의 만료시간은 6일이었고, 구글 클라우드의 access token은 30분, refresh token은 200일이었습니다. refresh token의 수명을 줄이면, 사용자가 활동이 없을 때 쉽게 로그아웃 되는 단점이 있지만, 앱이 아닌 웹 서비스이기 때문에 비교적 짧은 토큰 수명을 가지도록 설정했습니다.

또한 기존의 refresh token을 내부 DB에서 블랙리스트로 등록하고, access token은 10분이 지나기 전에 새로 발급받으면 기존의 access token을 사용할 수 있기 때문에 Redis 캐시에 폐기된 access token을 관리하고 주기적으로 데이터를 지우는 방식으로 토큰 보안을 강화했습니다. 

<br>


## API 접근제한을 위한 Permission 개발 

TokenAuthentication을 사용하여 인증을 마치면 해당 사용자를 식별할 수 있습니다. 우리의 BE API에는 사용자 및 운영자 전용 API가 모두 포함되어 있습니다. 또한, 사용자는 3단계 로그인을 수행하고, 운영자는 공동 운영자 및 회원 관리 운영자 등으로 나누어져 있으므로 `Role-based access control (RBAC)` 정책을 채택했습니다.

Django Rest Framework의 Permission 시스템을 확장하여 요구 사항에 맞는 사용자 정의 Permission을 만들었습니다. 이러한 Permission은 각 API View에 permission_classes를 설정하여 API 접근을 관리합니다.

이전에는 운영자 및 사용자용 API 서버를 완전히 분리하여 접근 권한을 고민한적이 없었으나, 이번 기회를 통해 Authentication 뿐 아니라 Authorization 구조도 구축할 수 있었습니다. 




<br>

## Offering 모듈 요구사항 분석


부동산 조각 투자의 핵심인 건물, 공모/청약, DABS 할당/발행을 다루는 Offering 모듈의 요구사항을 분석하였습니다. 기획자들은 싱가폴에 상주하고 있는 싱가폴인들이라서 문서 작성과 회의 등은 모두 영어로 이루어졌습니다. 그 뒤에 팀 내에서 공유하기 위해서는 다시 한국어로 번역하여 작성하였습니다.  
처음에는 이 도메인이 생소하여 이해하는 것이 어려웠지만, 분석을 하면서 회사의 도메인에 대해 깊게 이해할 수 있었습니다.

이 작업을 통해 개발자는 코딩도 중요하지만 요구사항을 정확히 파악하고 분석하는 것이 매우 중요하며, 기획자나 다른 실무진들과 원활하게 소통하는 기술을 배웠습니다. 또한, 분석 과정에서는 모르는 부분을 정확하게 파악하기 위해 적극적으로 질문해야 한다는 것을 배웠습니다. 분석 과정에서 총 160개의 질문을 작성하면서, 정확하게 질문하는 방법에 대해 많이 고민해 보았습니다.


<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/qna.png" >
<figcaption align = "center">[Picture 2] 질문 예시</figcaption>


<br>
 



<br>

## Offering 모듈 API 명세 작성
API 명세를 작성하여 요구사항을 충족시키기 위해 필요한 API 호출 방법을 정리했습니다. 이 명세서는 백엔드 팀에서 실제 개발에 사용될 예정이기 때문에, 누락된 요구사항이나 요구사항과 불일치하는 부분이 없는지 검토해야 했습니다.

해당 모듈은 회사 도메인에서 가장 중요한 부분이었기 때문에, 다양한 요구사항을 고려하여 API 명세를 작성하는 것은 쉬운 일이 아니었습니다. 하지만 저는 셀장님, 팀원분들, 그리고 프론트엔드 담당자분들과 함께 여러 번의 논의와 검토를 거쳐, 총 113개의 API 명세서를 완성할 수 있었습니다.

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
<figcaption align = "center">[Picture 3] API 명세 예시</figcaption>

<br>

## 싱가포르 정부 Mydata API인 Myinfo 서비스 연결 


카사 싱가포르는 자산이 10억 이상일 때만 회원가입이 가능하며, 이를 증명하기 위해 통장 잔액, 세금 내역서 등의 증명서류를 까다롭게 요구할 수 밖에 없어 온보딩 과정에서 병목 현상이 발생하였습니다.

따라서 싱가포르 국민을 포함한 Finance 분야의 모든 사용자 데이터를 제공하는 Myinfo 서비스를 도입하게 되었습니다. Myinfo는 2017년부터 정부가 주도하여 디지털화된 신원확인 체계를 수립하려는 NDI (National Digital Identity) 프로젝트의 일부입니다. 도입 후, 증명서류 없이도 데이터를 불러올 수 있어 온보딩 이탈률을 50% 가까이 줄일 수 있었습니다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/req_one.png" >
<figcaption align = "center">[Picture 4] Myinfo Requirements</figcaption>

<br>

정부의 사업이다보니 API Key 와 Secret을 발급받으면 API를 사용할 수 있는 기존의 API 서비스와는 다르게 필수 사항이 많았습니다.
3, 4, 5 항목은 크게 문제가 없었지만 `Transaction Log`와 `X.509 Public Key` 부분은 작업이 필요했습니다. 

<br>

> Transaction Log 

기존에는 AWS Opensearch로 로그를 기록하고 대시보드에서 확인하고 있었는데, Myinfo에서 가져오는 데이터에는 개인정보인 NRIC(싱가포르 주민번호)와 이름 등이 포함되어 있어서 ISMS 규정에 맞춰 암호화가 필요했습니다. 이를 위해 AWS KMS 서비스를 사용하여 개인 식별 정보를 암호화하고, 암호화 키를 주기적으로 변경하도록 스케쥴러를 설정했습니다. 이렇게 함으로써 ISMS 심사의 중요 기준 중 하나인 개인정보 보호를 강화할 수 있었습니다.

<br>

> X.509 Public Key


Myinfo 서버에 데이터를 요청하고, 받기 위해서는 모든 요청과 데이터를 암호화하는 `PKI 구조`를 취해야 했습니다.
Kasa가 Myinfo에 요청을 보낼 때, 인증되었음을 확인하기 위해 Kasa의 Private key로 서명해야 했습니다. 이를 위해 Kasa는 Myinfo에서 요구하는 X.509 인증서, 즉 Public key를 제출했습니다.

그리고 Myinfo에서 보내온 응답을 확인할 때는 Myinfo에서 발급해준 Myinfo Public key로 verify를 수행하고, 이후 Kasa의 Private key로 decrypt를 해야 했습니다.   

<br>


<img class="img-zoomabㅅle medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/req_two.png" >
<figcaption align = "center">[Picture 5] Myinfo에서 허가하는 Root CA</figcaption>

<br>


Myinfo에서 인증하는 Root CA가 별도로 존재하기 때문에, digicert와 netrust에 개별적으로 문의하며 netrust에서 인증서 발급을 받게 되었습니다.

인증서에 대한 지식이 없었고, 비용 문제와 싱가포르 정부의 기업 인증 등 많은 어려움에 직면했습니다. 하지만 경영팀, 인프라 팀, 정보보안 팀의 그레이존 역할을 수행하면서, 모든 업무를 담당하면서 많은 것을 배울 수 있었고, 이 프로젝트는 Kasa에서 가장 보람있게 수행한 프로젝트 중 하나였습니다.

<br>


프로젝트를 하면서 공부했던 포스팅은 아래에서 확인이 가능합니다.
- [[[Infra] 네트워크 필수교양, 인증서 (1/2) - 쌩기초]](https://leeleelee3264.github.io/post/2022-06-15-digital-certificate-part-one/)
- [[[Infra] 네트워크 필수교양, 인증서 (2/2) - 심화학습]](https://leeleelee3264.github.io/post/2022-08-27-digital-certificate-part-final/)
- [[[Project] Django로 Myinfo oauth2 클라이언트 만들기]](https://leeleelee3264.github.io/post/2022-07-23-project-myinfo-connector-python/)


<br>

## 공모 청산 모듈 개발

공모가 끝나고 청약을 신청한 사용자들의 공모금을 Custody에 이체하고, 청약 금액만큼의 DABS를 할당/발행하는 모듈을 개발했습니다. 여기서 `Custody`란 `디지털 자산 수탁자`로, 디지털화된 자산을 보관하는 서비스입니다.

<br>

#### 공모 종료와 DABS 할당량 계산

공모가 종료되면 DABS 할당량을 계산해야합니다. 이를 위해서는 청약 금액과 DABS 수를 고려하여 안분비례 방식으로 배분해야합니다. 안분비례에서는 소수점 몇 자리를 유지할 것인지가 중요합니다. 부동산 자산이 대상이므로, 15자리까지 유지하고 Decimal로 관리했습니다.

안분비례를 적용하려면 모든 청약을 확인해야합니다. 첫 번째 계산은 전체 안분 비율을 계산하고, 청약한 DABS의 비율을 곱하여 배분합니다. 이렇게하면 남은 DABS가 발생하고, 정수부는 제외하고, 소수부가 가장 큰 DABS를 추가로 할당합니다.

이러한 형태는 많은 양의 데이터를 가져와 안분비례 방식으로 처리해야하는 문제를 발생시킬 수 있습니다. 예를 들어, 청약 데이터가 10만 건 이상인 경우, 모든 데이터를 메모리에 올리면 Out of Memory 오류가 발생할 수 있습니다. 따라서 Python의 yield 기능을 사용하여 100건씩 끊어서 청약 데이터를 처리하고, 결과를 누적하는 방식으로 연산을 수행했습니다.


<br>

#### 공모금 정산과 DABS 할당

DABS 할당 후, 공모금은 Custody의 건물 판매자 계좌로 이체됩니다. 서버는 Custody와 블록체인과 많은 소통이 필요하며, 디지털 자산의 변경 내역은 블록체인에 기록됩니다.

미할당 공모금에 대한 환불 후, 공모금은 각 투자자의 예치금 계좌에서 출금되어야 합니다. 이때 Custody와 내부 블록체인을 호출하여 이체가 이뤄지며, 이체가 모두 완료될 때까지 DABS는 발행되지 않습니다. 이러한 긴 흐름에서 예외 상황과 Rollback 방지 등을 고민하였으며, 트랜잭션 단위와 재시도 방안 등을 구현했습니다.

이 과정에서 서버가 멀티파드 환경이기 때문에 Race Condition을 방지하기 위해 Django ORM의 select_for_update 방식을 사용했습니다.


<br>

#### DABS 발행

DABS 발행은 공모의 마지막 단계입니다. 이는 투자자들의 DABS 계좌에 실제로 입금해주는 것이며, 이를 위해 Custody와 Blockchain과 소통이 필요합니다. DABS 분배 요청을 Custody에 보내고, 이를 승인받아야만 DB에 기록하고 블록체인에 기록할 수 있습니다.

처음에는 내부에서 기록 후 Custody에 마지막 승인 요청을 보내는 방식을 사용했지만, 이는 법적인 문제가 있을 수 있어 코드 수정이 필요했습니다. 초기에 코드를 함수로 추상화하고 분리해두어서, 함수를 호출하는 외부는 변경 없이 함수 내부의 수정만으로 문제를 해결할 수 있었습니다.

이를 통해 초기 구현 단계부터 읽기 쉬운 코드와 추상화를 적용하면 유지보수가 쉬워지는 것을 몸소 경험할 수 있었습니다. 1시간 이내로 수정이 되어, 프러덕트 팀의 예상과는 다르게 런칭 일정에 차질이 생기지 않았습니다.

<br>

## 대사 모듈 개발 

회사의 서비스에서는 예치금 계좌와 DABS 계좌를 회사의 DB 뿐만 아니라 블록체인과 Custody에서도 관리합니다. 이에 따라, 이 세 가지 계좌의 데이터가 서로 일치하는지 확인해야 하며, 일치하지 않는 경우 모든 로그를 조사하여 즉각적인 조치가 필요합니다. 이를 위해 매일 오후 10시에 DB, 블록체인, Custody 간의 대사(reconciliation)를 조정하는 모듈을 개발하였습니다.

<br>

> 대사의 대상 

- `DB` 예치금 계좌 <-> `블록체인` 예치금 계좌 
- `DB` DABS 계좌 <-> `블록체인` DABS 계좌 
- `DB` 예치금 계좌 <-> `Custody` 예치금 계좌 
- `DB` DABS 계좌 <-> `Custody` DABS 계좌 

<br>


리소스는 다르지만 과정은 동일하기 때문에 추상화를 통해 통일된 구조를 가져갈 수 있도록 고민했습니다. 또한 비즈니스 로직과 서비스 정책을 세밀히 이해하는 과정이 필요했습니다. 예를 들어, 장이 마감된 후 거래가 되지 않은 DABS가 원래 계좌로 돌아가는 것과, 예치금 입금이 보류 중인 상태에서 Custody에서는 해당 금액을 인정하지 않는 것 등이 있습니다.

따라서 이러한 이해 과정에서 점차 수정 작업을 수행했으며, 정책 이해 수준이 개발 볼륨에 미치는 영향을 다시 한 번 생각했습니다. 더 꼼꼼한 정책 파악 태도를 내재해야 한다는 필요성을 느꼈습니다.


<br>



## Notification 모듈 개발 
투자자에게 공모 오픈 소식, DABS 할당, Trading 내역 등 자산 관련 다양한 Notification을 제공하는 Notification 모듈을 개발했습니다. 이 모듈은 Notification 발생 시 투자자의 이메일로 알림을 보내며, 링크를 통해 홈페이지에 접속하여 Pdf 형태로 Notification을 다운로드할 수 있습니다.

이를 위해 서버에 있는 템플릿에 DB에서 가져온 데이터를 채워 PDF를 생성합니다. 이 과정에서 HTML과 CSS를 사용하여 템플릿을 구현했습니다. 또한 API에서 DB의 변경에 따라 Notification을 발송해야 하는 경우도 있어, Django의 signal 기능을 사용했습니다.



<br>

# Dev Culture 

## 사내 스터디 리드
전 직장에서 스터디를 했던 게 너무 재미있어서 이번에도 사내 스터디를 조직했습니다. 토이 프로젝트나 회사 기술 블로그를 만들고 싶었지만 일정이 여의치 않아 책 스터디로 진행했습니다.
특히 HTTP 완벽 가이드는 쌩신입일때 추천받아 읽은 책인데 3년 정도 후에 다시 읽어보니 이해할 수 있는 폭이 넓어져있어서 뿌듯했습니다. 

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
2022년 11월에 `Django에서 동시성을 다루는 방법` 이라는 제목으로 세미나를 진행했습니다.
Django로 백엔드 서버를 다루면서 마주했던 `동시성` 관련 이슈를 트러블 슈팅하면서 배운 점을 정리해 사내의 개발자들과 함께 공유하는 시간을 가졌습니다.

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

세미나 영상과 발표 자료, 회고는 [[[Seminar] Django에서 동시성을 다루는 방법으로 인생 첫 세미나 진행하기]](https://leeleelee3264.github.io/post/2022-12-26-kasa-concurrency-seminar/) 에서 더 자세하게 다루고 있습니다.   


<br>

## NHN Forward 2022 참석 
NHN Forward 2022는 처음으로 참석한 오프라인 개발자 컨퍼런스입니다.. 
듣고 싶은 세션이 너무 많아 하루 종일 빡빡한 스케쥴로 파르나스 여기저기를 옮겨다녔습니다. 참여한 기업 부스가 많아서 참석 경품을 정말 한 바가지 받아서 컨퍼런스에 참여하지 못한 동료들에게 나눠주는 등 즐거운 시간이었습니다. 

앞으로는 컨퍼런스에 <U>참석으로 그치는 것이 아닌 현장에서 열심히 듣고, 집에 와서 모르는 내용을 찾아보고 정리해야 할 필요를 느꼈습니다.</U> 그리고 시간이 넉넉하더라도 꼭 일찍 등록을 하고, 세미나실에도 미리 들어가서 자리를 확보 해야합니다. 

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/nhn.jpeg" >
<figcaption align = "center">[Picture 6] NHN Forward 초대창</figcaption>



<br>

## Naver Deview 2023 참석 
2023년 02월에 Naver 개발자 컨퍼런스인 Deview 2023에 참석했습니다.

급하게 회사로 복귀해야 해서 세션은 하나 밖에 듣지 못했지만 부스가 알찼습니다. 특히 `네이버 클로바`와 `네이버 제트`의 개발팀에게 직접 
사내 개발 문화와 분위기, 필수로 요구되는 스킬 등을 질문하고 그 분들의 답변을 들을 수 있어서 좋았습니다.

특히 네이버 제트에 계신 분이 해주신 답변이 인상 깊었습니다. 
단순히 기술을 도입하는 것이 아니라 <U>왜 이 기술을 도입해야 하며, 이 기술을 통해 해결할 수 있는 것이 무엇인지</U>를 고민하며 사내의 기술 스텍을 쌓아간다는 말씀이 좋았습니다. 
내가 도입하고 싶어하는 기술이 정말 이 Use Case에 적합해서인지, 아니면 지금 인기가 많은 기술이라 그런지 가끔씩 의구심이 들었는데 정곡을 찔린 느낌이었습니다.  


<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/IMG_5563.JPG" >
<figcaption align = "center">[Picture 7] Deview 입장 팔찌</figcaption>

<br> 