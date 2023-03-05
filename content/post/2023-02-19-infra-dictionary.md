+++
title = "[Infra] 인프라 벼락치기 백과사전"
date = "2099-02-19"
description = "인프라를 공부하면서 들었던 용어들을 정리한다."
tags = ["Infra"]
+++

<br>
<br>

> 인프라를 공부하면서 들었던 용어들을 정리한다.

<br>

**Index**

1. Intro: 이 백과사전의 용도는 무엇인가?
2. General 
3. AWS

<br>

# Intro: 이 백과사전의 용도는 무엇인가?

#### 내가 알던 인프라는 새 발의 피!

회사에서 모종의 이유로 인프라 팀의 서브 업무를 진행하게 되었다. 여태까지 인프라 환경이 회사의 규모에 비해 잘 구성되어있다는 얘기는 몇 번 들었는데 이제 내 업무가 되어서 조금 살펴보니
모르는 게 너무 많아 어디서 시작할지 엄두가 나지 않았다. 동시에 내가 여태까지 알던 인프라 지식은 새 발의 피 라는 생각이 절로 들었다. 벼락치기가 필요한 시점이었다. 

일단은 모르는 단어의 개념부터 찾는 게 가장 필요할 거 같아, <U>단어를 찾으며 기록했던 내용을 인프라 벼락치기 백과사전</U>에 정리해보려 한다.

<br>

# General 

### 스펙 조정 

#### Scale-up <-> Scale-down 
- Scale-up: 서버의 하드웨어 스펙을 올린다. (RAM 4G -> 8G)
- Scale-down: 서버의 하드웨어 스펙을 내린다. (RAM 8G -> 4G)


#### Scale-out <-> Scale-in
- Scale-out: 서버의 머신 수를 늘린다. (1대 -> 4대) 
- Scale-in: 서버의 머신 수를 줄인다. (4대 -> 1대)

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/scale.png" >
<figcaption align = "center">[그림 2] 스펙 조정</figcaption>

<br>


### TimescaleDB 
#### 시계열 데이터베이스 
- 시계열 데이터를 처리하기 위해 최적화된 데이터베이스이다. 
- 실시간으로 쌓이는 대규모 데이터를 처리하기 위해 고안되었다. (ex. 로그, 메트릭, 주식)
- 예시 
  - influxDB, Prometheus 

#### TimescaleDB
- `PostgreSQL` + `시계열` = TimescaleDB
- PostgreSQL이 `RDBMS`라서 TimescaleDB도 RDBMS다.
  - 시계열 데이터베이스는 `NoSQL`이 많아, 차별성이 있다. 

<br> 

### Provisioning
프로비저닝은 사용자의 요구에 맞게 시스템 자원을 할당/배치/배포해 두었다가 필요시 시스템을 <U>즉시 사용할 수 있는 상태로 미리 준비해두는 것을 뜻한다.</U> 제공하는 것 까지도
프로비저닝으로 보기도 하는 것 같다. 

<br> 

### VPN 
Virtual Private Network, 즉 가설 사설망을 뜻한다. VPN은 `물리적`으로는 같은 네트워크에 있지만, `논리적`으로는 다른 네트워크에 있는 것처럼 동작하게 해준다. 

<br> 

# AWS

## AWS General Concept

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/cloud.png" >
<figcaption align = "center">[그림 2] AWS Cloud</figcaption>

- AWS Cloud 안에 있음을 뜻한다.

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/vpc.png" >
<figcaption align = "center">[그림 2] VPC Cloud</figcaption>

- VPC 안에 있음을 뜩한다.
- `Virtual network`이며 네트워크 리소스가 `논리적`으로 고립되어있다.


<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/tg.png" >
<figcaption align = "center">[그림 3] Transit Gateway Icon</figcaption>

- Cloud Router 처럼 작동한다. 
- `Amazon VPC`, `AWS Account`, `온프레미스` 네트워크에 연결할 때 사용된다.


<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/cg.png" >
<figcaption align = "center">[그림 4] Custom Gateway Icon</figcaption>

- 밖으로 나가는 모양을 하고 있다.

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/router.png" >
<figcaption align = "center">[그림 5] Router Icon</figcaption>

- 안으로 들어오는 모양을 하고 있다.

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/vpc_connect.png" >
<figcaption align = "center">[그림 6] VPC Connection Icon</figcaption>

- VPN이 연결되어야 쓸 수 있다. 

<br> 

### OU 
Organization Unit, 즉 조직단위를 뜻한다. 

- OU를 사용하면 <U>계정을 그룹으로 만들어 단일 유닛으로 관리할 수 있어, 계정 관리가 굉장히 간편해진다.</U> 
  - 예를 들어 프라이빗 서브넷에 접근 가능한 OU를 만들면, OU 안의 모든 계정들이 프라이빗 서브넷 접근 가능 정책을 자동 상속한다. 
- 단일 조직에서 여러 OU를 생성하고, OU 안에 OU를 만들 수 있으며 OU 이동도 가능하다. 

<br> 






## AWS Service

### VPC 및 관련 개념
Virtual Private Cloud의 약자이다. 가상화로 공간을 나누고, 네트워크도 나눌 수 있어 하나의 `독립적인 공간`을 만든다.
VPC가 없다면 EC2 인스턴스들 (서로)과 인터넷이 복잡하게 연결된다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/no_vpc.png" >
<figcaption align = "center">[그림 2] VPC를 구성했을 때</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/yes_vpc.png" >
<figcaption align = "center">[그림 2] VPC를 구성하지 않았을 때</figcaption>


<br> 

#### VPC 구축 
VPC에서 사용할 IP를 사설 IP 대역에 맞춰 선택한다. <U>한 번 설정된 IP는 변경할 수 없고, VPC는 하나의 리전에 종속된다.</U> 
VPC 끼리 연결을 하기 위해서는 `VPC 피어링`을 해야 하며, VPC와 온프레미스를 연결하려면 `AWS Direct Connect` 또는 `Site-to-Site VPN` 작업을 해야 한다. 

<br> 

#### 서브넷 
- VPC를 쪼갠다. 서브넷으로 쪼개는 이유는 더 많은 네트워크망을 만들기 위해서다. 
- `프라이빗 서브넷`: 공개되어 있지 않은 (인터넷과 연결이 안 된) 서브넷
- `퍼블릭 서브넷`: 공개되어 있는 서브넷

<br> 

#### 서브넷 라우팅 & 라우팅 테이블 
처음에 요청이 들어오면 `라우터`로 향하게 된다. 라우터는 `라우팅 테이블`을 보고 요청을 보내야 할 곳으로 보낸다.
서브넷에서 사용하는 라우터는 <U>로컬에서 사용이 되기 때문에 외부로 통하는 트래픽을 처리할 수 없다.</U> `(from: Local, to: Local)`

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/subnet_route.png" >
<figcaption align = "center">[그림 2] 서브넷 라우팅 아키텍처 다이어그램</figcaption>

<br> 

#### 인터넷 게이트웨이 
<U>VPC와 인터넷을 연결해주는 관문이다.</U> 예제에 나오는 `0.0.0.0`은 모든 `Ipv4`를 뜻한다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/dic/internet_gw.png" >
<figcaption align = "center">[그림 2] 인터넷 게이트웨이 아키텍처 다이어그램</figcaption>

<br> 

#### 보안 
##### 네트워크 ACL
  - `서브넷` 레벨에서 운영한다.
  - 따라서 VPC 접근관리에 제일 먼저 영향을 미치는 것은 ACL이다.
  - 

##### 보안 그룹 
- `인스턴스` 레벨에서 운영한다. 




<br> 

### EC2 Instance의 종류 
#### 범용 
- `T`, `M`
- <U>균형이 있는 컴퓨팅, 메모리 및 네트워킹 리소스를 제공한다.</U> 
- 트래픽이 적은 웹 사이트 또는 중소형 데이터 베이스에 사용된다.
- 사용처
  - T: api, 샐러리 서버 
  - M: EKS 시스템 관련 Pod (Argo CD, Cert-Manager, alb-loadbalancer)

<br> 

> T와 M의 차이는? 

- T: `burstable performance`를 지원한다.
  - 기본 수준의 CPU 성능을 제공하다가 CPU spike가 일어나면 기본 수준 이상의 성능을 제공하고, 이때 Credit이 사용된다.
- M: 기본 수준의 CPU 성능을 제공한다.
- 통상적으로 T가 M보다 저렴하다. 
  - T는 <U>low-cost, general-purpose 용도</U>로 디자인 되었다. 
  - M은 <U>CPU 집약적인 어플리케이션 최적화 용도</U>로 디자인 되었다.

<br> 

#### 컴퓨팅 최적화 
- `C`
- 고성능 웹서버, 비디오 인코딩에 사용된다. 
- 사용처
  - 블록체인, CI/CD

<br> 

#### 메모리 최적화 
- `X`, `R`
- 고성능 데이터베이스, 분산 메모리 캐싱에 사용된다.
- 사용처 
  - Observability 와 관련된 시스템 로그 수집 Pod 

<br> 

#### 스토리지 최적화
- `H`, `I`, `D`
- 데이터 웨어하우징, 로그 또는 데이터 처리 어플리케이션에 사용된다. 

<br> 

> 데이터 웨어하우징이란? 

- 다양한 소스에서 오는 대용량 데이터를 수집/저장/관리하는 것을 뜻한다. 
- 수집된 대용량 데이터는 의사결정을 위해 리포팅/분석된다. 

<br> 

#### 가속 컴퓨팅 
- `P`, `G`, `F`
- 가상화 및 기계 학습에 사용된다.

<br> 

### MSK 
Amazon Managed Streaming for Apache Kafka, 즉 AWS에서 `Sass` 형태로 제공되는 `카프카` 서비스다.

#### Kafka 
- Publish-subscribe messaging system -> <U>분산 메세징 시스템이다.</U>
- `Producer`가 특정 topic으로 메세지를 발행하고, `Consumer`는 topic의 메세지를 읽어간다. 
- 카프카 브로커 클러스터링을 할 때 쓰는 게 `Zoo Keeper`이다.

<br> 



