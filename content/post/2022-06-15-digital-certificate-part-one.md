+++
title = "[Infra] 인증서 (1/2): Certificate, PKI, X.509란 무엇인가?"
date = "2022-06-15"
description = "이 포스트에서는 인증서의 기본 개념을 다룬다: CSR, SSL certificate, code signing certificate, FQDN, PKI, X.509"
tags = ["Infra"]
+++


<br>
<br> 

> 이 포스트에서는 인증서의 기본 개념을 다룬다: CSR, SSL certificate, code signing certificate, FQDN, PKI, X.509

<br> 

**Index**
1. 인증서에 대해 잘못 알고 있던 점들 
2. 인증서의 종류 
3. 인증서와 관련된 개념 

<br> 

# 인증서에 대해 잘못 알고 있던 점들

### 인증서의 종류

#### 적절하지 않은 인증서 분류 
- web에서 HTTPS 통신을 하기 위해 사용하는 web secure용 SSL 인증서
- digital signature(디지털 서명) 를 하기 위한 code signing 인증서

디지털 서명을 해야 했기 때문에 code signing 인증서를 발급받으려 했다. 하지만 **SSL 인증서도 디지털 서명을 할 수 있었고**, 목표인 server to server 커뮤니케이션에서 사용하는 **신원 보장용 디지털 서명을 하기 위해서는 SSL 인증서를 발급해야 했다.** 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/hand_drawing_certificate_simple.png" >
<figcaption align = "center">[Picture 1] 적절하지 않은 인증서 분류</figcaption>

<br>

#### 적절한 인증서 분류 
SSL 인증서는 웹사이트, 정확히 말하면 브라우저에 한정해서 사용한다고 생각했는데 이는 너무 한정적인 생각이었다. SSL 인증서는 client와 server가 (browser to server / server to server) 데이터를 주고 받을 때 암호화를 하기 위해 쓰이기 때문에 브라우저에 한정적이지 않다.

결국 인증서는 _[Picture 2]_ 처럼 분류를 해야 한다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/hand_drawing_certificate.png" >
<figcaption align = "center">[Picture 2] 적절한 인증서 분류</figcaption>

<br>

#### Code Signing 인증서 
발급받으려 했던 code signing 인증서는 어플리케이션에 서명을 해서 해당 어플리케이션 publisher의 신원을 보장하는데 사용하기 때문에 내가 필요했던 server to server 커뮤니케이션에서 사용되는 인증서가 아니다.

code signing 인증서로 어플리케이션에 서명을 하게 되면 _[Picture 3]_ 와 같이 사용자에게 어플리케이션 publisher 에 대한 정보가 추가로 제공이 된다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/code_signing_certificate.png" >
<figcaption align = "center">[Picture 3] code signing 인증서로 서명한 application</figcaption>

<br>



### CSR 생성하기

모든 SSL 인증서는 domain validation을 한다. 이 생각에 사로잡혀서 Root CA가 서명한 인증서를 발급받기 위해 제출해야 하는 CSR는 인증서가 사용이 될 서버에서 만들어야 한다고 생각했다.

예를 들어 leelee.me 이라는 루트 도메인에서 사용하는 인증서라고 했을 때 leelee.me 도메인을 호스팅하는 서버에서 CSR을 생성해야 한다고 생각한 것이다. 하지만 CSR을 다른 서버에서 생성했다면, CSR을 생성할 때 함께 만든 private key를 인증서를 사용할 서버로 옮기면 된다.  

<br>



# 인증서의 종류

### SSL Certificate VS Code Signing Certificate

> 공통점

- X.509 형태의 디지털 인증서다.
- PKI 형식을 사용한다.
- 두 인증서가 없다면 사용자에게 보안 경고가 띄워진다. 
- 발급하기 전에 CA에서 발급요청자를 검증한다. 
- end user들이 해킹등의 사이버 범죄에 노출되는 것을 방지하기 위해 사용된다.

<br>

> 차이점

- SSL Certificate은 두 시스템에서 오고가는 data를 암호화한다.
- Code Signing Certificate은 소프트웨어 자체를 hash & sign 한다. 
  - 모든 코드에 디지털 서명을 한 것과 마찬가지이며 만약 중간에서 누가 코드를 수정한다면 해시값이 변경이 되어 end user가 코드를 다운받기 전에 alert를 띄워 사전에 설치를 못 하도록 막는다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/certificate_difference.png" >
<figcaption align = "center">[Picture 4] 인증서 다이어그램</figcaption>

<br>

### SSL Certificate 

SSL Certificate는 크게 2가지 기준으로 분류할 수 있다. 
- 검증히려는 대상
- 커버하는 도메인의 개수

<br>

#### 검증하려는 대상

검증 대상에 따라서 암호화하는 방식이 달라지거나 하지 않는다. 따라서 저렴하게 발급받은 DV와 비싸게 발급받은 EV가 결국 보안의 관점에서는 큰 차이가 없다.

하지만 검증받은 대상의 identiy가 다르기 때문에 DV는 작은 서비스에서 사용하기가 용이하고 그 외에 e-commerce나 중요한 정보를 주고 받아야 하는 서비스의 경우에는 다른 인증서를 써야 한다.


##### Domain Validation
- 도메인 소유권을 확인한다. 
- 손쉽게 발급받을 수 있다. (최대 1일)
- 가장 많이 사용되는 SSL Certificate의 형태다. 
- Let’s encrypt에서 발급하는 인증서도 DV로, OV나 EV 처럼 다른 인증을 받을 때는 사용할 수 없다.

##### Organization Validation
- 도메인 소유권 + Organization 존재를 확인한다.
- 회사 같은 경우, 실제로 존재하는 회사인지를 확인하기 위해 관련 서류를 제출하기도 한다.
- 발급하는데 몇 시간 또는 며칠 정도가 소요된다.

##### Extended Validation
- 도메인 소유권 + Organization 존재 확인 + 물리적인 추가 절차를 확인한다. 
- SSL certification industry’s governing consortium 가이드라인을 준수해야 하는 등 발급 절차가 복잡하다.

<br>

#### 커버하는 도메인의 개수

인증서에는 도메인이라는 말이 자주 등장하게 된다. 하지만 도메인이라는 단어 자체가 뜻하는 의미가 모호할 수 있기 때문에 혼선방지 차원에서 인증서에서는 **FQDN** 이라는 단어를 더 선호한다.

FQDN은 Fully-Qualified Domain Name 의 약자로 도메인 전체 이름을 표기하는 방식을 뜻한다.

<br>

> FQDN 예시
```java
# 아래는 서로 동일한 도메인이다.
www.leelee.co.kr
leelee.co.kr
www.sub.leelee.co.kr

# 아래는 서로 다른 FQDN 이다.
www.leelee.co.kr
leelee.co.kr
```

<br>

##### Single Domain
- 단 하나의 FQDN을 커버한다.

##### Multiple Domain
- 여러개의 FQDN을 커버한다.
- 인증서를 등록할 때 SAN (Subject Alternative Name) 항목에 다수의 도메인을 입력한다.

##### Wildcard Domain
- 하나의 Root Domain과 무제한의 서브도메인을 커버한다. 
  - wildcard는 하나의 전체도메인을 입력하지 않기 때문에 FQDN이라 하지 않았다.
- CA 업체에서는 비용에 따라서 커버하는 서브도메인 개수에 제한을 두기도 한다.
- `*` 을 사용해서 도메인을 커버한다.

<br>

> 커버하는 도메인 예시 
```java
# Singple Certificate
www.leelee.co.kr

# Multi-Domain Certificate
www.leelee.co.kr
leelee.co.kr
www.sub.leelee.co.kr

# Wildcard Certificate
*.leelee.co.kr
```


<br>

# 인증서와 관련된 개념

### PKI

PKI는 `Public Key Infrastructure` 의 약자로 공개키 기반구조라고 하며 디지털 인증서를 생성, 관리, 배포, 사용, 저장 및 파기, 공개키 암호화의 관리에 필요한 정책 등을 뜻한다. PKI는 아래의 항목을 전체로 하고 있다.

- 비대칭 키 알고리즘을 이용한다.
- Private key, Public key pair 를 생성한다.
- Private key는 개인만 소유하며 밖으로 공개해서는 안된다.
- Public key는 공개하는 키로, 누구에게든 공개해도 된다.

<br>

#### 비대칭 키 알고리즘 

Private key, Public key 두 개의 키를 사용한다. 이처럼 Encryption(암호화)와 Decryption(복호화)에 두 개의 다른 키를 쓰기 때문에 비대칭 키라고 한다. 대표적인 알고리즘으로는 RSA가 있다.

<br>

#### 적용 시나리오

##### Public key를 이용해 암호화 : 데이터 보안
- 사용자 B가 사전에 공유받은 사용자 A의 `public key`를 이용하여 데이터를 암호화한다.
- 사용자 A의 `public key`로 암호화된 데이터는 오직 사용자 A의 `private key`로 복호화 할 수 있다.
- 사용자 A의 `private key`는 사용자 A만 소유하고 있기 때문에 사용자 B는 사용자 A만 볼 수 있는 데이터를 전송하게 된 것이다.



<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/public_key_example.png" >
<figcaption align = "center">[Picture 5] Public key를 이용한 암호화</figcaption>

<br>

##### Private key를 이용해 암호화 : 신원인증
- 사용자 A의 `private key`로 암호화 된 데이터는 사용자 A의 `public key`를 이용해야만 복호화를 할 수 있다.
- 데이터가 사용자 A의 `public key`로 복호화가 안된다면 사용자A가 보냈다는 것을 인증할 수 없다. 
- 사용자 A의 `public key`로 데이터를 복호화할 수 있다면 사용자 A가 보냈다는 것을 인증할 수 있다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/private_key_example.png" >
<figcaption align = "center">[Picture 6] Private key를 이용한 암호화</figcaption>

<br>

##### 해커가 암호화된 데이터를 도청할 경우
- 사용자 A의 private key가 없기 때문에 해커가 중간에서 데이터를 복호화ㅊ할 수 없다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/haker_example.png" >
<figcaption align = "center">[Picture 7] 해킹 시도</figcaption>

<br>

##### PKI에서 가능한 두 가지 방식의 네트워크 보안
- `public key`를 이용해 암호화 하면 원하는 상대방에게만 데이터를 공개할 수 있다. 
  - from 사용자 B → to 사용자 A
- `private key`를 이용해 암호화 하면 신원 인증을 할 수 있다. 
  - from 사용자 A → to 사용자 B

<br>



### X.509

X.509는 디지털 인증서 생성 관련 국제 표준을(format)을 의미한다. X.509를 사용하는 네트워크 노드들은 전세계적으로 약속된 x.509 국제 표준을 방식으로 디지털 ID를 생성해 서로의 신원을 증명할 수 있다.

X.509는 인터넷의 다양한 분야에서 신원 확인을 위해 광범위하게 사용되고 있는 가장 유명한 디지털 신원 증명 방식이다.

<br>

#### X.509 version 3 인증서 양식


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/certificate_format.png" >
<figcaption align = "center">[Picture 8] X.509 인증서 양식</figcaption>

<br>

##### Key usage extension

인증서에 포함되어있는 `public key`의 목적을 나타낸다. Key usage extension을 설정해 `public key`의 사용처를 제한할 수 있다.

<br>

> Key usage extension 예시

- 인증서가 서명을 하거나 signature를 검증하기 위해 사용된다면 Key usage extension으로 Digital signature와 Non-repudication 를 설정한다. 
- 인증서가 key 관리를 위해서만 사용이 된다면 key encipherment를 설정한다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/key_usage.png" >
<figcaption align = "center">[Picture 9] Key usage extension 종류</figcaption>

<br>


##### Extended key usage

Key usage extension이 기본적인 인증서의 사용 목적(purpose)를 나타내는 것이라면 Extended key usage는 인증서의 additional한 사용 목적을 나타낸다. 보통 Extended key usage는 end entity의 인증서에만 표시가 된다.

<br>

> Extended key usage 예시

- `critical`이라면 인증서는 설정되어있는 용도로만 사용을 해야 한다. 해당 인증서를 다른 용도로 사용 했을 경우에는 CA 정책에 위반된다.
- `non-critical` 이라면 설정되어있는 용도 외의 다른 용도로 사용 했을 경우에도 CA의 제한에 걸리지 않는다. 또한 다수의 kye/certificate을 가지고 있는 entity라면 맞는 key/certificate를 찾는데에도 사용이 될 수 있다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/certificate/extend_key_usage.png" >
<figcaption align = "center">[Picture 10] Extend key usage extension 종류</figcaption>

<br>


### CSR

- Certificate Signing Request의 약자이다. 
- CA에 인증서를 서명해달라고 요청할 때 사용이 된다.
- 인증서 발급할 때만 사용이 되고, 인증서가 발급된 후에는 별도로 사용 되지 않는다.

<br>

### Private Key

- PKI의 핵심이 되는 비밀키이다.
- 만료 기간이 별도로 존재하지 않는다.

<br>

### Public Key

- PKI의 또 다른 핵심이 되는 공개키이다.
- **Public Key라고 따로 파일이 존재하기 보다는 Certificate에 포함이 되어있다.**
  - 때문에 `public key`와 `certificate`을 혼용해서 쓴다.  
- 만료 기간이 별도로 존재하지 않는다.

<br>

### Certificate

- `public key`와 각종 정보를 담고 있는 인증서로, x.509 형식으로 되어있다.
- **만료 기간이 존재한다.**
  - 때문에 인증서가 만료되면 새로운 인증서를 발급받아야 한다. 

<br>

### PKI File Extension

PEM (Privacy Enhanced Mail) 형식 은 가장 흔하게 사용되는 X.509 인증서 형식인데 .crt, .pem, .cer, .key 확장자 모두가 PEM 형식이다. -----BEGIN CERTIFICATE----- 로 시작한다.


##### .cert *.crt

- Certificate를 위한 확장자다.
- Base64 encoded X.509 certificate
- DER encoded X.509 certificate
- 해당 확장자들은 Private key를 지원하지 않는다.

##### .key

- Private key 확장장다.

##### .pem

- Certificate를 위한 확장자다.

##### .crl

- Certificate Revoke List를 위한 확장자다.
- Certificate Revoke List는 폐기된 인증서의 목록이며, CA는 CRL을 통해 폐기된 인증서를 관리한다.

##### .csr

- Certificate Singing Request를 위한 확장자다.

##### .der

- Certificate을 위한 인증서 확장자인데, DER encoded X.509 Certificate에 한정된다.
- 해당 확장자는 Private key를 지원하지 않는다.
- 보통의 인증서들과 달리 `----BEGIN CERTIFICATE-----` 로 시작하지 않는다.
- Java contexts에서 자주 사용이 된다.

> .der 인증서 예시 
```java
3082 07fd 3082 05e5 a003 0201 0202 1068
1604 dff3 34f1 71d8 0a73 5599 c141 7230
0d06 092a 8648 86f7 0d01 010b 0500 3072
310b 3009 0603 5504 0613 0255 5331 0e30
0c06 0355 0408 0c05 5465 7861 7331 1030
0e06 0355 0407 0c07 486f 7573 746f 6e31
1130 0f06 0355 040a 0c08 5353 4c20 436f
7270 312e 302c 0603 5504 030c 2553 534c
2e63 6f6d 2045 5620 5353 4c20 496e 7465
726d 6564 6961 7465 2043 4120 5253 4120
```

