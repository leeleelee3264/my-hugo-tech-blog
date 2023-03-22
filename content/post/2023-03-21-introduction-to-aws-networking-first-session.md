+++
title = "[Book] [따라하며 배우는 AWS 네트워크 입문] 노트정리 1회차"
date = "2023-03-21"
description = "김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 1장 AWS 인프라, 2장 VPC 기초, 3장 VPC 고급, 4장 인터넷 연결 을 다룬다."
tags = ["Book"]
+++


<br>
<br> 

> 김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 1장 AWS 인프라, 2장 VPC 기초, 3장 VPC 고급, 4장 인터넷 연결 을 다룬다.

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

## 2. AWS Network 소개 


### 2.1 AWS VPC - 리소스 격리 

### 2.2 AWS VPN - 가상 시설망 

### 2.3 ELB - 로그 밸런서 

### 2.4 AWS PrivateLink - 프라이빗 연결 


### 2.5 Route 53 - DNS 


### 2.6 AWS 전송 게이트웨이 

### 2.7 AWS Direct Connect - AWS 전용 연결 

### 2.8 AWS CloudFront - CDN 

### 


### 


# 2장 VPC 기초


<br> 

# 3장 VPC 고급



<br> 

# 4장 인터넷 연결 



<br> 



