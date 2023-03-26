+++
title = "[Book] [따라하며 배우는 AWS 네트워크 입문] 노트정리 1회차 (2/2)" 
date = "2023-03-27"
description = "김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 3장 VPC 고급, 4장 인터넷 연결을 다룬다."
tags = ["Book"]
+++


<br>
<br> 

> 김원일, 서종호의 저서 [따라하며 배우는 AWS 네트워크 입문]을 요약한다. 이 포스트에서는 3장 VPC 고급, 4장 인터넷 연결을 다룬다.

<br> 

**Index**
1. 3장 VPC 고급 
2. 4장 인터넷 연결 


<br> 


# 3장 VPC 고급 

## 01. VPC 엔드포인트 


<U>VPC 엔드포인트</U> 

VPC 엔드포인트는 AWS의 퍼블릭 서비스나 직접적으로 생성한 AWS 서비스에 대해 외부 인터넷 구간을 통한 접근이 아닌 직접적으로 접근할 수 있는 `프라이빗 엑세스` 기능이다. 



<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/endpoint.png" >
<figcaption align = "center">[Picture 1] VPC 엔드포인트 종류</figcaption>

<br>


인터페이스 엔드포인트와 엔드포인트 서비스를 통한 연결을 `프라이빗 링크`라고 부른다.

<br>

<U>주된 특징</U>
- 연결 대상 서비스가 동일 리전으로 제한 
- 하나의 VPC에만 연결 가능

<br>

<U>예시</U>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/endpoint_flow.png" >
<figcaption align = "center">[Picture 2] VPC 엔드포인트 적용했을 때의 흐름</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/gw_endpoint_flow.png" >
<figcaption align = "center">[Picture 3] VPC 게이트웨이 엔드포인트 적용했을 때의 흐름</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/if_endpoint_flow.png" >
<figcaption align = "center">[Picture 4] VPC 인터페이스 엔드포인트 적용했을 때의 흐름</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/endpoint_service_flow.png" >
<figcaption align = "center">[Picture 5] VPC 엔드포인트 서비스 적용했을 때의 흐름</figcaption>

<br>

`엔드포인트 서비스`를 사용할 때 `인터페이스 엔드포인트`도 함께 구성해야한다는 점이 인상깊었다.
-> 인터페이스 엔드포인트로 데이터를 전달하고, 프라이빗 링크로 엔드포인트 서비스가 생성된 CustomVPC의 NLB로 전달된다. 


<br>


### 04. 배치 그룹 

<U>배치 그룹</U>
- 배치 그룹은 그룹 내 인스턴스의 배치를 조정하는 기능이다. 즉, 하드웨어적으로 어디에 인스턴스를 배치할 것인지 조정하는 기능이다.
- 물리 호스트의 장애에 대해 영향도를 최소화하기 위해 기본 설정으로 `분산 배치`된다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/placement.png" >
<figcaption align = "center">[Picture 6] 기본적인 인스턴스 배치</figcaption>


<br>

<U>종류</U>

클러스터 배치 그룹 
- 단일 가용 영역 내에 인스턴스를 배치한다.
- 짧은 네트워크 지연시간, 높은 네트워크 처리량이 필요한 어플리케이션에 적합하다. 
- 한 랙에 문제가 생기면 모든 인스턴스들에 문제가 생길 수 있다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/cluster.png" >
<figcaption align = "center">[Picture 7] 클러스터 배치 그룹</figcaption>


<br>

파티션 배치 그룹 
- 동일한 파티션(랙) 안에 인스턴스를 배치하지만, 여러 AZ에 파티션을 분산하는 배치이다. 
- 파티션이 나눠져있어, 장애 분산이 안된다. 
- `Hadoop`, `Cassandra`, `Kafkka` 등 대규모 분산 및 복제 워크로드를 별개의 렉으로 분산해 배포하는데 적합하다. 


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/partition.png" >
<figcaption align = "center">[Picture 8] 파티션 배치 그룹</figcaption>

<br>

분산형 배치 그룹
- 각각 고유한 하드웨어에 인스턴스를 배치한다. 
- 여러 가용 영역에 인스턴스를 분산 배치 했기 떄문에 처리량을 높일 수 있다.

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/dist.png" >
<figcaption align = "center">[Picture 9] 분산형 배치 그룹</figcaption>



<br>


### 05. 메타데이터 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/meta.png" >
<figcaption align = "center">[Picture 10] 메타데이터 카테고리</figcaption>

<br>

EC2 인스턴스는 인스턴스에 대한 메타데이터를 가지고 있고, `169.254.169.254`라는 빌트인 주소에 요청하면 HTTP 응답으로 확인할 수 있다. `v1`은 인스턴스에 접속한 누구나 메타 정보를 볼 수 있어 보안상 좋지 못했기 떄문에 토큰 방식이 추가된 `v2`가 만들어졌다.



<br>

{{< highlight bash  "linenos=true,hl_inline=false" >}}
curl http://169.254.169.254/latest/meta-data 

# 예시1: 퍼블릭 주소 
curl http://169.254.169.254/latest/meta-data/public-ipv4
{{< /highlight >}}

<br>



<br>

# 4장 인터넷 연결 


<U>AWS VPC <-> 인터넷 연결 조건</U>

- 인터넷 게이트웨이
- 라우팅 테이블 
- 공인 IP 
- 보안 그룹과 ACL 

<br>

<U>인터넷 연결 방안</U>
- 인터넷 게이트웨이 
- NAT 디바이스 
- Proxy 인스턴스 

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/way.png" >
<figcaption align = "center">[Picture 11] 인터넷 연결 방안</figcaption>


<br>


<U>인터넷 게이트웨이</U>
- Public IP와 Private IP `1:1 NAT`한다.
  - 1:1 연결이기 때문에 해당 IP를 독점적으로 사용하는 것과 유사하다. 
  - 외부에서 Public IP를 통해 내부 VPC 인스턴스 (Private IP)에 접근 가능하다. 
- `하나의 VPC`는 `하나의 인터넷 게이트웨이`만 사용할 수 있다. 

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/ig_nat.png" >
<figcaption align = "center">[Picture 12] 인터넷 게이트웨이를 통한 외부 접속</figcaption>



<br>

<U>NAT 디바이스</U>

> NAT 인스턴스와 NAT 게이트웨이를 통칭해 NAT 디바이스라고 한다.

<br>


- Public IP와 Private IP `1:N NAT` 한다.
- 프라이빗 서브넷에서 외부 인터넷으로 통신하기 위한 방식이다.
  - 프라이빗 서브넷 -> 외부 인터넷만 가능하다.
- NAT 디바이스는 `Public 서브넷`에 유치하며 `인터넷 게이트웨이`와 연동한다. 


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/nat_nat.png" >
<figcaption align = "center">[Picture 13] NAT 디바이스를 통한 외부 접속</figcaption>

<br>

<U>NAT 게이트웨이 vs. NAT 인스턴스</U>
1. 성능: 고성능 vs. 인스턴스 유형에 따라 
2. 가용성: 고가용성 vs. 수동 HA
3. 관리: AWS vs. 사용자 
4. 비용: 전송량 vs. 인스턴스 요금 + 네트워크 요금

<br>

<U>NAT 인스턴스 시나리오</U>

> NAT 인스턴스와 NAT 게이트웨이 흐름은 유사하다. 


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/nat_instance.png" >
<figcaption align = "center">[Picture 14] NAT 인스턴스 흐름</figcaption>

<br>

이 예시에서는 나오지 않았지만 NAT 인스턴스는 `IP masquerading`을 통해서 `내부 인스턴스의 IP와 포트`를 `NAT 인스턴스의 IP와 포트`로 변환한다. 


<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/mul_nat.png" >
<figcaption align = "center">[Picture 15] 다수의 인스턴스에서의 NAT 인스턴스 흐름</figcaption>

<br>

다수의 인스턴스의 출발지 IP들이 1개의 NAT IP를 공유해서 사용하기 때문에 포트 번호 정보를 기준으로 내부 인스턴스의 트래픽을 구별할 수 있다. 이를 `PAT` 이라 한다.


예시에는 나오지 않았지만, 원본 포트가 같을 경우 PAT을 할 때 포트를 다르게 할당한다. 이를 `포트 오버로딩`이라 한다.

<br>

| 원본 IP - Port        | 변경 IP - Port        |
|---------------------|---------------------|
| 10.40.2.101 - 40001 | 10.20.1.100 - 40001 |
| 10.40.2.201 - 40001 | 10.20.1.100 - `50001` |

<br>


<U>Proxy 인스턴스</U>

- 서버의 대리자이다.
- 목적지 IP가 Proxy 인스턴스로 향하도록 되어있다.

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/network/proxy.png" >
<figcaption align = "center">[Picture 16] Proxy를 통한 외부 접속</figcaption>