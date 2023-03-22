+++
title = "[Book] [따라하며 배우는 AWS 네트워크 입문] 노트정리 1회차"
date = "2023-03-21"
description = "김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 1장 AWS 인프라, 2장 VPC 기초, 3장 VPC 고급, 4장 인터넷 연결 을 다룬다."
tags = ["Book"]
+++


<br>
<br> 


<br> 

**Index**
1. 1장 AWS 인프라
2. 2장 VPC 기초 
3. 3장 VPC 고급 
4. 4장 인터넷 연결 

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


#### 서브넷 마스크 

<br>

#### CIDR의 이점 
전통적인 `IP Class`가 `CIDR`로 많이 교체되고 있다. CIDR은 IP 주소의 더욱 효율적인 사용과 주소 할당 및 라우팅의 더 큰 유연성, 그리고 네트워크 관리의 간소화를 제공하기 
때문에 일반적으로 기존의 IP 주소 클래스보다 더욱 좋은 방법으로 간주되고 있다. 


<br>


## 03. VPC 리소스 소개 

<br> 

# 3장 VPC 고급



<br> 

# 4장 인터넷 연결 



<br> 



