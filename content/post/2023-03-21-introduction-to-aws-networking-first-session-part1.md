+++
title = "[Book] [따라하며 배우는 AWS 네트워크 입문] 노트정리 1회차 (1/2)"
date = "2023-03-21"
description = "김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 1장 AWS 인프라, 2장 VPC 기초를 다룬다."
tags = ["Book"]
+++


<br>
<br> 

> 김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 1장 AWS 인프라, 2장 VPC 기초를 다룬다.

<br> 

**Index**
1. 1장 AWS 인프라
2. 2장 VPC 기초 


<br> 

# 1장 AWS 인프라

## 01. AWS 소개 

### 1.1 클라우드 란? 
인터넷을 통해 원하는 만큼의 IT 리소스를 손쉽게 사용할 수 있는 서비스를 뜻한다. AWS, Azure, GCP 등 이다.  

<br> 
  

#### 클라우드 서비스 종류

- IaaS 
  - 사업자: 서버, 네트워크, 스토리지 등 자원을 제공 
  - 사용자: 가상 서버에 필요한 프로그램을 설치하여 사용 및 운영 
  - 예시: `E2C`, `VPC`, `EBS` 
- PasS 
  - 사업자: IaaS + Runtime + Middleware 제공 → 앱을 개발하기 위한 build, test, deploy 플랫폼과 환경을 제공 
  - 사용자: Application 개발 
  - 예시: `Elastic Beanstalk`
- SaaS 
  - 사업자: 서비스 사용에 필요한 모든 것을 제공 
  - 사용자: 서비스를 사용 
  - 예시: `MSK`, `EFS`

<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/cloud.png" >
<figcaption align = "center">[Picture 1] 클라우드 서비스 종류</figcaption>



<br> 


### 1.2 AWS 클라우드 소개 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/infra.png" >
<figcaption align = "center">[Picture 2] 인프라 논리적 규모</figcaption>


<br> 


**데이터 센터** 
- 서버, 네트워크, 스토리지, 로드 밸런서, 라우터 등 일반적인 IT 인프라 디바이스를 모아둔 곳을 말한다. 

 

**가용 영역**
- 한 개 이상의 데이터 센터들의 모음을 말한다. 
- 각 데이터 센터는 분산 되어 있으며 전용망으로 연결되어있다. 

 

**리전**
- 지리적인 영역 내에서 격리되어 있는(물리적으로 분리) 여러 개의 가용 영역을 말한다.
- 리전은 최소 2개의 가용 영역으로 구성되어있다.
- 재난과 재해로 인한 서비스 장애를 막기 위해 가용 영역을 분산하여 구성하는 것을 권장하고 있다. 

 

**엣지**
- 외부 인터넷과 AWS 글로벌 네트워크망을 연결하는 곳을 말한다.
- `CloudFront`, `Direct Connect`, `Route 53`, `AWS Shield`, `AWS Global Accelerator`, `API Gateway`가 동작한다. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/edge.png" >
<figcaption align = "center">[Picture 3] Edge</figcaption>




- <U>엣지 pop이 무엇인가?</U>
  - 전 세계적으로 분산된 AWS infra에서 가장자리 지역에서 실행되는 캐싱서버이다. 
  - AWS 성능 최적화하는데 중요한 역할을 한다. 
    - 클라이언트와 가장 가까운 위치에 있어, CDN을 통한 전송 로드 시간을 최소화한다. 


- <U>가장자리 지역이 무엇인가?</U>
  - Region과 Availability Zone 이외의 지역으로, 데이터센터와 물리적으로 떨어져있다. 
  - 가장자리 지역은 세계 곳곳에 위치하며, 사용자와의 지리적 거리가 멀어질 수록 네트워크 대기 시간이 증가하는 문제를 해결하기 위해 도입되었다. 

<br> 


### 1.3 AWS 제품 

| Name               | Desc                                       | 
|--------------------|--------------------------------------------|
| EC2                | 컴퓨팅 리소스를 제공하는 가상 머신 서비스로, 인스턴스라고 부른다.      |
| EBS                | 가용 영역 내의 EC2 인스턴스에 연결해 사용할 수 있는 블록 스토리지이다. |
| S3                 | 객체 기반의 파일을 저장할 수 있는 스토리지이다.                |
| AWS CloudFormation | yaml 등의 파일을 사용해 AWS 리소스를 자동으로 배포하는 서비스이다.  |


<br> 

## 02. AWS Network 소개 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/network.png" >
<figcaption align = "center">[Picture 4] AWS Network 서비스</figcaption>



#### AWS VPC 
- Virtual Private Cloud 
- AWS 클라우드 내 논리적으로 독립된 섹션을 제공한다. 


#### AWS VPN 
- Virtual Private Network 
- 가상의 사설 네트워크를 구성하여 프라이빗 통신을 제공한다. 
- AWS에서는 `Site-to-Site VPN`과 `Client VPN`을 제공한다. 


#### ELB 
- Elastic Load Balancing 
- AWS에서 제공하는 로드 밸런싱 기술, E2C의 health checking를 더불어 트래픽을 분산하여 전달한다.
- 종류 
  - ALB: Application (HTTP, HTTPS) 분산 처리한다. -> Application 계층에서 사용
  - NLB:  TCP, UDP (IP, Port) 분산 처리한다. -> Transport 계층에서 사용
  - CLB: Classic Load Balancer, VPC의 전신인 EC2-Classic 에서 사용했다. 

#### AWS PrivateLink 
- 내부 네트워크를 통해 AWS 서비스를 비공개 연결하는 기능을 제공한다. 

#### Route 53
- 관리형 DNS 서비스이다. 
- 제공하는 서비스 
  - 도메인 구매 대행 
  - DNS 역할 
  - 라우팅 정책 설정하여 트래픽 흐름 제어

#### AWS Transit 게이트웨어 
- VPC나 온프레미스 네트워크를 단일 지점으로 연결할 수 있는 라우팅 서비스이다.
- 다른 네트워크에 연결할 필요없이 Transit Gateway에만 연결하면 되어 관리가 쉽다.  
  - 다수의 VPC, VPN 등이 있을 때 복잡하게 개별 연결할 필요 없이 Transit 게이트웨어를 연결해 중앙집중형으로 관리한다.  


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/transit.png" >
<figcaption align = "center">[Picture 5] Transit Gateway</figcaption>



#### AWS Direct Connect 
- Direct Connect = 전용선 
  - 물리적이거나 논리적일 수 있다. 
- 사용 이유
  - 안정적
  - 높은 보안성
  - Low Latency 

#### AWS CloudFront 
- AWS의 CDN (Contents Delivery Network) 서비스이다. 
- 물리적 한계를 극복하기 위해 사용자와 가까운 곳에 캐시 서버를 두고 Contents를 분배한다. 
  - 엣지 pop을 두고  콘텐츠를 캐싱해 서비스를 제공한다. 

#### AWS Global Accelerator 
- 트래픽 경로를 최적화 해준다.
  - 싱가포르 서버를 한국이 접속하려면 많은 네트워크 망을 거치며 Latency와 Packet Loss가 증가하는데 이를 방지해준다. 


#### 네트워크 보안 

네트워크 접근 제어로 `IP`, `Port`, `Protocal` 기반으로 접근제어를 한다. 

- ACL 
  - 서브넷에 적용한다. 
  - 허용/거부 규칙을 만들 수 있다. 
- 보안 그룹 (SG)
  - 인스턴스에 적용한다. 
  - 허용 규칙만 만들 수 있다. 

<br>

# 2장 VPC 기초

## 01. VPC
VPC는 <U>독립된 가상의 클라우드 네트워크</U>다. 리전별로 기본 VPC가 1개씩 제공되고, 사용자 커스텀 VPC는 리전 별 5개씩 만들 수 있다. 사용자는 VPC에 생성하고 제어할 수 있는 것들은 아래와 같다. 

- IP 대역 
- 인터페이스 
- 서브넷
- 라우팅 테이블
- 인터넷 게이트웨이
- 보안그룹/ACL 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/vpc.png" >
<figcaption align = "center">[Picture 6] VPC</figcaption>

<br>


## 02. 기본 네트워크 개념 이해 

### 2.1 OSI 7 레이어 모델 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/attachments/4590043141/4701585561.png" >
<figcaption align = "center">[Picture 7] OSI 7 레이어</figcaption>

3 Layer인 Network 계층에서 라우팅을 하며, 최적 경로를 찾는다는 점을 집중해서 봐야 한다. 

<br>


### 2.2 IP와 서브넷 마스크

#### Public IP, Private IP 
<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/ip.png" >
<figcaption align = "center">[Picture 8] Public & Private IP</figcaption>

<br>

- Private IP는 NAT를 사용해 Public IP로 변환해야만 외부 인터넷과 통신할 수 있다. 
- Docker: 각 컨테이너에 `Class B`에 해당하는 Private IP를 할당한다. 
- K8s: 각 Pod에 Private IP를 할당하는데 `CNI (Container Network Interface)`에 따라 사용하는 대역이 다르다. 

<br>

#### 서브넷

> IP = `네트워크 ID` + `호스트 ID`  

서브넷은 네트워크를 `작은 네트워크`로 나누는 기술이다.  

<br>

> 예시

- 네트워크 ID가 `192.168.0.0/16` 서브넷이 존재한다.
  - 하위에 `192.168.0.0/24`, `192.168.1.0/24` 서브넷으로 분리한다. 
  - 위의 2개의 서브넷은 `192.168.0.0/16` 이라는 같은 네트워크 ID를 가진다. 

<br>


동일한 서브넷에 속해있다면 같은 네트워크 ID를 가지기 때문에 호스트 ID를 통해 구분한다.  이렇게 서브넷을 구분하기 위해 네트워크 ID와 호스트 ID를 분리하는 것을 `서브넷 마스크`라고 한다. 

<br>

#### 서브넷 마스크 


| Class 대역                       | 서브넷 마스크       | 
|--------------------------------|---------------|
| A  0.0.0.0 ~ 127.255.255.255   | 255.0.0.0     |
| B  128.0.0.0 ~ 191.255.255.255 | 255.255.0.0   |
| C  192.0.0.0 ~ 223.255.255.255 | 255.255.255.0 |

<br>


> 예시 `210.77.8.3`


Class C 범위에 속하므로 사용하는 서브넷 마스크는 `255.255.255.0`이다.  
C 서브넷 마스크 2진수 표현은 `1111 1111`. `1111 1111`. `1111 1111`. `0000 0000` 이다. 


  - 1이 사용된 지점은 네트워크 ID 이며, 0이 사용된 지점이 호스트 ID이다. 
  - 0의 개수로 하나의 네트워크가 최대 사용할 수 있는 호스트 개수를 유추할 수 있다. 
    - 0의 갯수 8개 -> (2^8) -2 = 254 -> 4 옥텟만 호스트로 사용할 수 있다. 
      - 두 개를 빼는 이유는 맨 앞 은 `네트워크 주소`, 맨 뒤는 `브로드캐스트 주소`가  되기 때문이다.
        - 네트워크 주소: `210.77.8.0`
        - 브로드캐스트 수조: `210.77.8.255`
        - 사용 가능 범위: `210.77.8.1` ~ `210.77.8.254`



#### CIDR 
Class 기반 IP 체계를 사용하면 IP를 A,B,C 세 블록으로 나눠야 하는데, CIDR를 사용하면 블록을 더 작게 나눠 할당할 수 있다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/cidr.png" >
<figcaption align = "center">[Picture 9] CIDR</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/subnet_mask.png" >
<figcaption align = "center">[Picture 10] Subnet Mask</figcaption>

<br>

CIDR는 /8, /16 이런식으로 표기하는데 `/` 뒤에 나오는 숫자는 `네트워크 ID의 길이`이다. 즉 /8 이라면 `1111 1111`. `0000 0000`. `0000 0000`. `0000 0000` 으로, 사용가능한 호스트 ID가 32-8 = 24로 (2^24) -2가 된다. 

IP를 보는 입장에서는 `/24` 이렇게 되어있으면 2진수로 풀었을 때 얖의 `24자리 까지 같다면 같은 서브넷`에 있다고 생각하면 된다. 예를 들어 `192.168.1.1` 와 `192.168.1.254`는 같은 서브넷에 있다는 뜻이다. (24자리인 1,2,3 옥텟의 숫자가 같다) 

<br>

> 예시 210.77.8.3/25 

`/25`의 서브넷 마스크는 `255.255.255.128` 이다.

- 2진수로 풀었을 때 앞에서 25자리까지 같아야 한다. 
- 사용할 수 있는 호스트의 갯수는 32 - 25 = 7 -> (2^7) - 2 = `126`개가 된다. 
- 네트워크 주소: `210.77.8.0`
- 브로드캐스트 주소: `210.77.8.127`
- 사용 가능 점위: `210.77.8.1` ~ `210.77.8.126`




<br>

#### CIDR의 이점 
Class 기반의 IP 주소 체계를 `Classful` 이라고 부르고, Class의 한계를 극복하고자 나온 것이 `Classless`한 주소 체계인 CIDR (Classess Inter-Domain Routing) 이다. 
CIDR은 IP 주소의 더욱 효율적인 사용과 주소 할당 및 라우팅의 더 큰 유연성, 그리고 네트워크 관리의 간소화를 제공하기 
때문에 일반적으로 기존의 IP 주소 클래스보다 더욱 좋은 방법으로 간주되고 있다. 




<br>

### 2.3 TCP와 UDP 그리고 포트 번호 

TCP 사용 서비스 
- HTTP 
- SSH 
- FTP


UDP 사용 서비스
- DNS 
- DHCP 

<br>


#### 2.3.2 포트 번호 
IANA 라는 단체에서 TCP와 UDP의 포트 번호 범위를 정하고 있으며, 범위에 따라 크게 3가지로 구분한다. 

| 포트       | 범위            | 
|----------|---------------|
| 잘 알려진 포트 | 0 ~ 1023      |
| 등록된 포트   | 1024 ~ 49151  |
| 동적 포트    | 49152 ~ 65535 |


<br>

### 2.4 DHCP 
동적으로 IPv4 주소를 일정 기간 임대하는 프로토콜로, 임대 시간이 만료되면 반환하거나 갱신을 해야 한다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/dhcp.png" >
<figcaption align = "center">[Picture 11] DHCP</figcaption>


<br>

### 2.6 라우팅 
- 최적의 경로를 잡아 통신하는 것이 라우팅이다. 
- 라우터: 라우팅을 수행하는 장비
- 라우팅 테이블: 라우터가 테이블을 통해 경로를 파악하고 데이터 전달할 수 있게 함 

<br>


## 03. VPC 리소스 소개

### 3.1 서브넷 
VPC도 서브넷을 통해 네트워크를 분리할 수 있는데, 서브넷 IP 대역은 VPC IP 대역에 속해있어야 한다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/sub.png" >
<figcaption align = "center">[Picture 12] VPC 서브넷</figcaption>

<br>


> 예역된 서브넷 IP 

예시: `10.0.2.0/24`

- 네트워크 주소: `10.0.2.0` 
- AWS VPC 가상 라우터 주소: `10.0.2.1` 
- AWS DNS 서버 주소: `10.0.2.2`
- AWS 예약: `10.0.2.3`
- 브로드캐스트 주소: `10.0.2.225`



<br>


#### 3.1.2 Public 서브넷과 Private 서브넷

- Public 서브넷: 외부 인터넷 구간과 통신 가능 -> `Public IP` 존재
- Private 서브넷: 사설 네트워크로, 내부만 통신 가능 -> NAT 게이트웨이를 사용하면 외부와 통신 가능

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/private_subnet.png" >
<figcaption align = "center">[Picture 12] Public & Private 서브넷</figcaption>

<br>


### 3.2 가상 라우터와 라우팅 테이블 

가상 라우터? 
- VPC의 각 서브넷에 대한 라우팅 관리한다.
- VPC를 생성하면 자동으로 생성된다. 
- Custom 라우터를 추가할 수 있다. 
- 서브넷별로 라우팅 테이블을 매핑할 수 있다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/v_router.png" >
<figcaption align = "center">[Picture 13] 서브넷 당 라우팅 테이블 매핑</figcaption>


<br>

### 3.3 인터넷 게이트웨이 
- VPC에서 인터넷 구간으로 나가는 관문 
- VPC 당 1개만 연결 가능 
- 대상: 퍼블릭 IP를 사용하는 `퍼블릭 서브넷` 내의 자원
- `양방향` 연결 지원 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/i_g.png" >
<figcaption align = "center">[Picture 14] 인터넷 게이트웨이</figcaption>

<br>

### 3.4 NAT 게이트웨이 
- Network Address Translation 
- `프라이빗 IP`를 `퍼블릭 IP` 로 변환
  - 프라이빗 IP는 인터넷 구간으로 넘어올 수 없기 때문
- `단방향` 지원 
  - 외부에서 프라이빗 네트워크 접근 불가

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/ig_route.png" >
<figcaption align = "center">[Picture 15] NAT 게이트웨이</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/flow.png" >
<figcaption align = "center">[Picture 16] IG & NAT 게이트웨이 통신 흐름</figcaption>

<br>

### 3.5 보안 그룹과 네트워크 ACL 
- 인스턴스 보안: 보안 그룹 
- 서브넷 보안: ACL


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/acl.png" >
<figcaption align = "center">[Picture 17] 보안그룹과 ACL</figcaption>


