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
회사에 입사한 계기는 2가지였다. 하나는 `싱가포르`를 대상으로 한 `글로벌 사업`을 경험해 볼 수 있다는 것이었다. 항상 글로벌 사업을 경험하고 싶었고, 때문에 전직장에서는 글로벌 사업을
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

FE가 API를 호출할 때 토큰 기반으로 인증을 할 수 있도록 `JWT`를 이용해 `토큰 기반 서버 인증`을 개발했다. 평소 요청은 `access token` 으로 하고, 만료되면 `refresh token`을 사용해 새로운 access token을 
발급하는 구조를 선택했다. `rest_framework_simplejwt` 라이브러리를 사용해서 `토큰 생성`, `revoke`, `refresh`를 구현했다.

회사에서는 3단계의 로그인 절차가 필요하다. `ID/PW 로그인`, `OTP 로그인`, `투자 계좌 로그인`의 절차로, 투자 계좌 로그인까지 해야 정식으로 서비스를 사용할 수 있다.
단계마다 토큰을 발급했다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/token.png" >
<figcaption align = "center">[Picture] 질문 예시</figcaption>

<br>


처음에는 토큰의 유효 기간이나 폐기등의 토큰 정책을 유념하지 않았다. 하지만 `싱가포르 금융감독기관`의 인증인 `MAS Regulation`을 받기 위해서는 `서버 보안 강화`해야 했고, 토큰 정책도 포함이 되어있었다. 


#### 토큰 보안 강화

access의 만료시간은 `10분`, refresh의 만료시간은 `12시간`이었는데, refresh의 만료시간이 너무 길어, access token을 재발급 받을 때마다 refresh token도 재발급하는 `ROTATE_REFRESH_TOKENS`을 적용해 <U>refresh token의 수명을 10분으로 줄였다.</U> 

조사 결과 `링크드인`의 accsss 만료시간은 1일, refresh 만료시간은 6일이었고, `구글 클라우드`의 access 만료시간은 30분, refresh는 200일이었다. 
refresh 수명이 짧아지면, 사용자가 활동이 없을 때 쉽게 로그아웃 되는 단점이 있지만, 앱이 아닌 `웹 서비스`이고, 싱가포르 금융 규제상 비교적 짧은 token 수명을 가지게 되었다. 

또한 기존 refresh token을 `블랙리스트로 등록`하고, access token은 10분이 지나기 전에 새로 발급받으면 기존의 access token을 사용할 수 있기 때문에 `Redis 캐시`에 폐기된 access token을 관리하고 주기적으로 데이터를 지워주며 토큰의 보안을 강화했다.

토큰 구조는 Statue를 관리하지 않아 편리하지만 <U>만료가 되기 전까지는 사용이 가능하기 때문에 폐기 정책을 까다롭게 관리</U>해야 한다는 걸 깨달았다. 

<br>


## API 접근제한을 위한 Permission, Middleware 개발 

<br>

## Offering 모듈 요구사항 분석

부동산 조각 투자의 코어인 `건물`, `공모/청약`, `DABS 할당/발행`을 담당하는 Offering 모듈의 요구사항을 분석하게 되었다.
원래 Offering 기획을 하신 분이 내가 입사를 하기 전에 이미 퇴사를 하신 상태였고, 새로운 기획 담당자들과 함께 기획사항을 분석했다. 기획은 모두 싱가폴에 상주하고 있는 실무자들이 하기 때문에 문서 작성, 회의 등은 모두 `영어`로 이루어졌고, 
팀에 공유를 하기 위해 다시 한국어로 번역을 하는 식으로 진행했다. 

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/qna.png" >
<figcaption align = "center">[Picture] 질문 예시</figcaption>


<br>

핵심 모듈의 요구사항을 잘못 분석한 상태로 개발에 들어가면 수정할 사항이 겉잡을 수 없을 만큼 커지고, 팀의 시간을 낭비하는 것이기 때문에 하나라도 놓치지 않겠다는 마음으로 임했다. 
작업 초기에는 이 도메인이 처음인 내가 이해하기에 조금 어려웠으나 방대한 요구사항을 심층 분석하면서 회사의 도메인을 깊게 파악할 수 있는 기회였다.

이 작업을 하면서 개발자는 코딩만 잘하면 되는 것이 아니라 <U>요구사항을 파고 들어 분석을 해야 하며, 분석 과정에서 기획자나 다른 실무진들과 원활하면서도 긴밀하게 소통을 하기 위해 노력해야 한다는 것을 배웠다.</U> 

분석을 하면서 `총 160개의 질문`을 작성하며 `잘 질문하는 방법`에 대해서 어떻게 해야 내가 모르는 부분을 정확이 질문하는지 많이 고민했다. 



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

## 싱가포르 정부 Mydata API인 Myinfo 서비스 연결 
`Myinfo`는 2017년부터 정부 주도하에 디지털화된 신원확인 체계를 수립하려는 `NDI` (National Digital Identity) 프로젝트의 일부이다.
<U>카사 싱가포르는 자산이 10억 이상일때만 회원가입을 할 수 있는데</U> 이를 증명하기 위한 통장 잔액, 세금 내역서 등의 `증명서류`를 까다롭게 요구할 수 밖에 없었고, 이는 `온보딩의 병목`이 되었다. 

때문에 Finance를 포함한 싱가포르 국민의 모든 데이터를 제공하는 Myinfo 서비스를 도입하게 되었다. Myinfo의 데이터는 정부가 제공하는 리소스이기 때문에 믿을 수 있었고, 사용자도 증명서류 없이 데이터를 불러오기만 하면 
되니 `온보딩 이탈률을 50% 가까이 줄일 수 있었다`. 

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/req_one.png" >
<figcaption align = "center">[Picture] Myinfo Requirements</figcaption>

<br>

정부의 사업이다보니 API Key 와 Secret을 발급받으면 API를 사용할 수 있는 기존의 API 서비스와는 다르게 조건 사항이 많았다. 
3, 4, 5 항목은 크게 문제가 없었지만 `Transaction Log`와 `X.509 Public Key` 부분이 까다로웠다. 

<br>

> Transaction Log 

기존에 로그를 `AWS Opensearch`로 남기고, `AWS Opensearch Dashboard`로 보고 있던 터라, 동일한 방식으로 로그를 남겼다.


Myinfo에서 가져오는 데이터를 로깅해야 했는데 여기에는 `NRIC`(싱가포르 주민번호)와 이름 등의 개인정보가 포함이 되어있었다. 당시에 코리아 프로덕트가 `ISMS` 심사를 준비하고 있었기 때문에 
싱가포르 프로덕트 또한 ISMS 규정에 맞춰 <U>개인 식별 정보인 NRIC를 암호화 해서 로그를 남겨야 했다.</U> 

암호화 뿐 만 아니라,  암호화 키 또한 주기적으로 변경해야 했다. 따라서 `AWS KMS` 서비스를 사용해서 개인 식별 정보를 암호화하고, `스케쥴러`로 주기적으로 기존 암호화 키를 폐기하고 새로운 암호화 키를 발급받았다. 


<br>

> X.509 Public Key

Myinfo 서버에 데이터를 요청하고, 받기 위해서는 모든 요청과 데이터를 암호화하는 `PKI 구조`를 취해야 했다. 

##### PKI 사용 시나리오

Myinfo로 보내는 요청이 Kasa에서 온 것임을 확인하기 위해 Kasa의 `Private key`로 서명을 해야 했고, Myinfod에 Kasa의 Private key로 만든 `X.509 인증서`, 즉 `Public key`를 제출해야 했다.  

또한 Myinfo에서 온 데이터를 확인할 때는 이 응답이 Myinfo에서 온 것을 확인하기 위해 Myinfo에서 발급해준 Myinfo Public key로 `verify`를 하고, 한 번 더 Kasa의 Private key로 `decrypt`를 해야 했다.     

<br>


<img class="img-zoomabㅅle medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kasa/req_two.png" >
<figcaption align = "center">[Picture] Myinfo에서 허가하는 Root CA</figcaption>

<br>


Myinfo에서 허가하는 `Root CA`가 별도로 있기 때문에 `digicert`와 `netrust`에 하나 하나 직접 문의를 하다가 결국 netrust에서 발급을 했다.


인증서 자체에 대한 지식이 전무했고 비용과 싱가포르 정부의 기업 인증 등 많은 어려움에 봉착했다. 또한 <U>경영팀, 인프라 팀과 정보보안 팀의 그레이존에 있는 부분이 많았지만 팀의 업무를 가리지 않고 모두 담당을 하니 많은 것을 배울 수 있었고,</U> 
실제로 Kasa에서 했던 `가장 보람있는 프로젝트` 였다.

<br>


프로젝트를 하면서 공부했던 포스팅은 아래에서 확인이 가능하다.
- [[[Infra] 네트워크 필수교양, 인증서 (1/2) - 쌩기초]](https://leeleelee3264.github.io/post/2022-06-15-digital-certificate-part-one/)
- [[[Infra] 네트워크 필수교양, 인증서 (2/2) - 심화학습]](https://leeleelee3264.github.io/post/2022-08-27-digital-certificate-part-final/)
- [[[Project] Django로 Myinfo oauth2 클라이언트 만들기]](https://leeleelee3264.github.io/post/2022-07-23-project-myinfo-connector-python/)


<br>

## 공모 청산 모듈 개발

공모가 끝나고 청약을 신청한 사용자들의 공모금을 Custody에 이체하고, 청약 금액만큼의 DABS를 할당/발행하는 모듈을 개발했다.

##### Custody? 
여기서 `Custody`란 `디지털 자산 수탁자`로, 디지털화된 자산을 보관하는 서비스이다. 싱가포르에서는 디지털 자산을 직접적으로 보관할 수 있는 라이센스가 없다면 Custody 서비스를 통해 자산을 보관해야 한다. 
따라서 예치금을 관리하는 `예치금 계좌`도, DABS를 보유하는 `DABS 계좌`도 Custody를 사용하여 관리가 된다. 

<br>

#### 공모 종료와 DABS 할당량 계산

공모를 종료하는 날이 오면 공모에 청약한 투자자들에게 분배가 될 `DABS 할당량`을 계산한다. 계산 방식은 청약 금액과 DABS 수를 비례하여 나누어 배정하는 `안분비례` 방식이다. 안분비례에서는 안분비율의 `소수점을 몇 자리 까지 유지`할 것인지가 중요하다. 부동산 자산이 대상이기 떄문에 처음의 공모금액 자체가 클 것 같아서 15자리까지 유지를 했고, `Decimal`로 관리를 했다. 

구현상 고민을 했던 점은 안분비례를 적용하면 <U>신청된 청약을 모두 탐색해야 한다는 점이었다.</U> 두 번의 계산이 들어가는데 처음은 전체의 안분 비율을 구해서 청약한 DABS 만큼 곱해서 주면 되었다. 
이렇게 하면 남는 DABS가 발생하고 정수부는 빼고, 소수부가 큰 순서대로 남는 DABS를 추가 할당한다. 

`청약 데이터`가 DB에서 한 투자자당 하나의 row로 관리되는 것이 아닌, 청약을 할 떄마다 row가 쌓이는 `Log structed` 형태라 꽤 많은 데이터를 가져와 안분비례 공정을 해야 했다. 
정말 청약이 몰려서 10만건 정도 된다면 그 청약 데이터를 메모리에 모두 올리면 `Out of Memory`가 날 수 도 있다고 생각했다. 때문에 Python에서 제공하는 `yield` 기능을 사용해서 청약 데이터를 100건씩 끊어서 가져와 결과를 누적하는 식으로 연산을 했다. 




<br>

#### 공모금 이체와 DABS 할당
DABS를 할당하는 날이 오면  할당이 이뤄지고, `공모금`을 Custody의 `건물 판매자 계좌`에 이체해야 한다. 모아진 공모금으로 건물을 사기 때문이다. 
DABS 할당부터는 `Custody`, `블록체인`과 많은 소통을 해야 한다. 디지털 자산이 오고 가기 때문에 Custody를 통해야 하고, 블록체인에 디지털 자산의 모든 변경 내역을 기록해야 한다. 

미할당 공모금에 대해 `환불`이 이뤄진 후에 공모금을 `이체`한다. 이때 각 투자자의 예치금 계좌에서 돈이 나가도록 Custody를 호출하고, 내부 블록체인을 호출한다. 공모금이 모두 이체가 되기 전까지는 실제 DABS를 발행하지 못했다가 이체 완료가 되면 DABS를 발행할 수 있도록 Custody에 `Mint`를 요청한다. 

실제 고객의 계좌에서 큰 액수의 돈이 빠져나가고, 외부의 API들을 호출하면서 길고 복잡한 흐름을 가지고 있다 보니 각 단계에서 일어날 수 있는 `예외 상황`과 이에 대한 `대처 방법`을 많이 고민했다. 
중간에 실패하더라도 이전의 이체 내역이 Rollback 되지 않도록 `Durability`를 살리도록 고려하여 `트랜잭션`의 단위를 묶었다. 또한 단계 별로 `재시도`를 하는 방안을 구현했다. 

이때 API 서버가 실제로는 여러 개 띄워져있는 `멀티파드`의 환경이기 때문에 `Race Condition`을 방지하도록 Django ORM의 `select_for_update` 방식을 채택했다. 


<br>

#### DABS 발행
DABS를 발행하는 것이 공모의 마지막 흐름이다. DABS를 투자자들의 `DABS 계좌`에 실제로 입고해주는 것인데 이 또한 디지털 자산이 오고 가기 떄문에 Custody와 Blockchain과 소통이 필요하다. 
<U>중요한 것은 DABS 분배 요청을 Custody에 보내고, 이 모든 요청을 Custody가 callback으로 승인을 해줘야 실제 분배된 것으로 인정되어 DB에 쓰이고 블록체인에 기록할 수 있다는 점이다.</U> 

처음에는 내부에 기록을 한 다음에 Custody에 마지막으로 승인 요청을 보냈는데 이럴 경우 싱가포르의 디지털 자산 관리 법에 걸리기 때문에 코드에 많은 수정을 해야 할 수 도 있었다. 
하지만 첫 구현에서 `함수를 최대한 분리`하고, 이 함수를 `추상화` 했기 때문에 함수를 호출하는 외부는 아무런 변경이 필요 없었고, 함수 내부 또한 내부 함수의 호출 순서 정도를 바꾸는 것으로 수정을 했다. 

프러덕트 팀에서는 법적인 사항으로 `런칭에 병목이 걸릴 거라 예상`했지만 1시간도 안 걸려 수정하고 배포까지 끝냈기 떄문에 런칭 일정에 차질이 생기지 않았다. 이 경험으로 초기에 구현을 할 떄 왜 많은 개발자들이 유지보수에 용이하도록 읽기 쉬운 코드를 짜고, 추상화를 하라고 했는지 몸소 이해할 수 있었다. 


<br>

## 대사 모듈 개발 
서비스에서 사용되는 <U>예치금 계좌와 DABS 계좌는 회사의 DB 말고도 회사의 블록체인과 Custody에서도 관리가 되고 있다.</U> 때문에 셋의 계좌들 데이터가 동일한 것을 확인해야 하고, 동일하지 않다면 로그를 모두 탐색해서 긴급하게 조치를 취해야한다. 
따라서 매일 오후 10시에 DB, 블록체인, Custody 사이의 `대사(reconciliation)`를 맞추는 모듈을 개발했다.

<br>

> 대사의 대상 

- `DB` 예치금 계좌 <-> `블록체인` 예치금 계좌 
- `DB` DABS 계좌 <-> `블록체인` DABS 계좌 
- `DB` 예치금 계좌 <-> `Custody` 예치금 계좌 
- `DB` DABS 계좌 <-> `Custody` DABS 계좌 

<br>

사용되는 데이터의 리소스는 다르지만 과정은 모두 동일하기 때문에 어떻게 `추상화`를 해서 `통일된 구조`를 가져갈 수 있을지 고민을 많이 했다. 
또한 구현 보다는 `비즈니스 로직`과 `서비스의 정책`을 섬세하게 이해하는 과정이 필요했다. 예를 들어 오후 6시에 장이 마감되면 거래가 안 된 DABS가 원래 계좌로 돌아가는 것이나, 예치금 입금이 pending 상태면 Custody에서는 없는 금액으로 취급하는 것 등. 

때문에 개발을 하면서 점점 이해가 깊어지면서 수정 작업을 10번도 넘게 진행했다. ₩ 정도가 개발 볼륨에 얼마나 영향을 미치는지 다시 한 번 생각했고, 정책을 더 꼼꼼하게 파악하는 태도를 늘 내제해야 할 필요를 느꼈다. 

<br>



## Notification 모듈 개발 
공모 오픈 소식이나 DABS 할당, Trading 내역 등 다양한 자산 관련 Notification을 투자자에게 제공하는 Notification 모듈을 개발했다. 
Notification 발생 소식을 투자자의 이메일로 알리고, 매직 링크를 타고 홈페이지에 들어오면 해당 Notification을 Pdf로 다운 받을 수 있는 형태였다. 

서버에 있는 템플릿에 DB에서 가져온 컨텍스트를 채워서 pdf를 생성하기 때문에 `HTML`과 `css`를 사용해서 템플릿을 구현했다. 개중 API에서 일으키는 DB의 변경에 의해 Notification을 발송해야 하는 부분이 있어
`Spring의 Event handler`와 유사한 `Django의 signal` 기능을 사용했다. 



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