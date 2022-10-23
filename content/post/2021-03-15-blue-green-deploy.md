+++
title = "Implement Shell Script which works like Blue Green Deployment"
date = "2021-03-15"
description = "Shell Script로 무중단 서버 배포하는 방법을 다룬다."
tags = ["Infra"]
+++


<br>
<br> 

> Shell Script로 무중단 서버 배포하는 방법을 다룬다. 

<br> 

**Index**
1. 무중단 배포란? 
2. 무중단 배포 구현하기 
3. 결론 

<br> 

# 무중단 배포란? 

무중단 배포란 업데이트를 위해 배포를 할 때 어플리케이션이 멈추지 않는 것이다. 즉 배포를 할 때 서비스가 중단되는 다운타임이 발생하지 않는다. 

<br> 

> 무중단 배포 방식

- Blue Green Deployment 
- Rolling Deployment 
- Canary Deployment 

<br>


### Blue Green Deployment 
- Blue와 Green 이라는 동일한 배포 환경을 준비한다.
- `Green` 은 live 되고 있는 환경을 의미한다. 
- `Blue`는 새로운 버전을 가지고 있는 환경을 의미한다. 
- `Blue`에서 새로운 버전을 테스트하고, 테스트 중에는 로드밸런서기 `Green`에 리퀘스트를 보낸다. 
- 테스트가 완료되면 `Blue`로 리퀘스트를 보낸다. 
- 만약 문제가 발생한다면 `Green`으로 롤백한다. 

#### 장점 
- 롤백 하기가 쉽다. 
- 다운타임이 없다. 

#### 단점 
- 리소스가 두 배로 든다. 이는 두 배의 비용으로 이어질 수 있다. 
- 두 개의 환경을 up-to-date 상태로 싱크하기 번거롭다.

<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://www.koyeb.com/static/images/blog/blue-green-deployment-schema.png" >
<figcaption align = "center">[Picture 1] Blue Green Deployment</figcaption>

<br> 

### Rolling Deployment
- 점진적으로 running 중인 인스턴스를 새로운 버전으로 교체한다. 
- `기존 버전`과 `새로운 버전`이 함께 live 된다.
- 최소 `N+1` 개의 인스턴스가 필요하고, 이 한 개의 추가 인스턴스는 새로운 버전을 실행할 노드이다.
- 새로운 버전을 담은 인스턴스가 무사히 배포되면 다른 인스턴스들을 돌아가면서 새로운 버전으로 배포한다. 
- 모든 인스턴스가 새로운 버전이 될 때 까지 반복한다. 
- `쿠버네티스`에서 사용하는 default 배포방식이다. 

#### 장점 
- 기존 버전이 live 되어 있어, 최소한의 다운 타임만 존재한다.
- 최소 하나의 추가 인스턴스만 있으면 가능한 배포 방식이다. 
  - 반면 Blue Green은 하나의 infrastructure 가 있어야 한다. 
- 롤백을 해야 한다면 기존 버전으로 트레픽을 돌리는 것이 가능하다. 

#### 단점
- 인스턴스의 개수에 따라 배포 시작과 live 사이에 상당한 지연이 있을 수 있다. 
- 배포가 중간에 실패하면 롤백하는 것에 많은 시간이 소요될 수 있다. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://www.koyeb.com/static/images/blog/rolling-deployments-schema.png" >
<figcaption align = "center">[Picture 2] Rolling Deployment</figcaption>


<br>

### Canary Deployment
- `서버 극히 일부`를 새로운 버전으로 배포하여 `지정된 유저`들에게 서비스한다. 
- `퍼포먼스`, `이슈` 등을 테스트와 모니터링하기에 좋은 배포 방식이다. 
- 테스트를 할 유저들을 먼저 지정해야 한다. (베타 유저 등)
- 서비스의 앞단에 있는 `로드밸런서`, `API 게이트웨이`, `서비스 프록시`등을 재설정하거나 feature 플래그를 두는 방식으로 구현할 수 있다.
- 문제가 없다면 기존 버전을 모두 새로운 버전으로 릴리즈한다. 

#### 장점 
- 일부의 실 사용자들에게 테스트를 할 수 있다. 
- 실패하더라도 일부의 사용자들에게만 영향이 미친다.
- feature flag를 사용한다면 최소한의 infrastructure 가 필요하다. 
- 롤백이 간단하고 빠르다. 


#### 단점
- 일부의 유저들에게만 새 버전을 라우트 하는 것이 기술적으로 어렵다.
  - feature flag는 cost-effective 한 방식이다. 
- 옵저빌리티와 메트릭스, 분석 환경이 특히나 미리 잘 갖춰있어야 한다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://www.koyeb.com/static/images/blog/canary-deployments.png" >
<figcaption align = "center">[Picture 3] Canary Deployment</figcaption>


<br> 

# 무중단 배포 구현하기

### 구현 환경

백업 서버를 따로 두지 않아서 맨날 서버를 업데이트할 때 서비스가 죽는다. 사내에서 소규모로 사용되는 서비스이지만 업데이트가 좀 잦은 편인데 계속 배포를 할 때 마다 서비스가 죽어버리면 사용하기가 힘들 것 같아 무중단 배포를 구현해보리고 했다. 

그런데 EC2 리소스가 좀 타이트 해서 평상시에 서버 두대를 띄우기는 힘들어 보였다. EC2 안에 앱서버가 두 대 뜨면 로드밸런스에서 하나가 업데이트 하느라 죽어도 다른 쪽으로 보내줄텐데 이런 형태는 지금 상황에서는 불가능했다. 그래서 평소에는 앱서버를 한 대 만 띄워두고 업데이트를 할 때 만 한 대 를 더 띄워 무중단 배포를 하기로 했다. 

<br> 

#### 구현할 무중단 배포 시나리오 

##### 업데이트 이전 상태 
- 로드 밸런서인 `nginx`는 계속 `두 포트`(A: 4000, B: 4001) 모두를 바라본다. 
- nginx가 날려준 리퀘스트를 실제로 처리하는 머신에서는 하나의 서버 A만 운영이 되고 있고, 서버 B는 다운 상태이다.

##### 업데이트 진행 
- 업데이트시에는 A보다 이전 버전인 B를 업데이트 된다.
- 서버 B를 가동한다.
- B가 완전히 뜨기 전까지 nginx는 A,B 둘 다 바라보니 리퀘스트 처리가 가능한 A가 받아서 처리한다
- B서버가 올라간 걸 확인하면 A 서버를 죽인다.

##### 업데이트 후 
- 그럼 이제 요청이 띄워져있는 서버 인 B로 올라간다.
- 다음번에 업데이트를 해야 한다면 B보다 옛날 버전인 A가 업데이트 된다.

##### 배포 시나리오 플로우 차트 

<details>
 <summary>플로우 차트 더보기</summary>
   <img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blue_green_chart.png" >
   <figcaption align = "center">[Picture 4] 무중단 배포 시나리오 flow chart</figcaption>
</details>


<br> 


#### Nginx  

작업을 하면서 nginx 는 어떻게 로드밸런싱을 할까 궁금해서 찾아봤다. 내가 하는 것처럼 앱서버를 두 개 두면 nginx는 필수적으로 요청을 분산하게 되어있다. [[nginx로-로드밸런싱-하기]](https://kamang-it.tistory.com/entry/WebServernginxnginx%EB%A1%9C-%EB%A1%9C%EB%93%9C%EB%B0%B8%EB%9F%B0%EC%8B%B1-%ED%95%98%EA%B8%B0)


그리고 이 작업을 하다가 알게 되었는데 항상 nginx에서 설정이 바뀌면 nginx 서비스를 `재시작(restart)` 했는데 이것보다는 `새로고침(reload)` 하는게 좋다고 한다. _restart는 말 그대로 재시작이라서 nginx를 한번 shutdown 하고 다시 시작한다_. 반면 reload는 서버가 돌아가는 상태에서 설정 파일만 다시 불러와서 적용을 해준다. 서버 중단이 없다는 것 때문에 reload가 더 적합하다!

<br>

> Nginx reload, restart 커맨드

{{< highlight bash  "linenos=true,hl_inline=false" >}}
// reload, restart 등을 할 때 config 파일이 문법에 맞는지 꼭 먼저 점검을 한다. 
nginx -t 

// reload 
sudo systemctl reload nginx 

// restart 
sudo systemctl restart nginx
{{< /highlight >}}


<br>

목표로 하고 있는 client - 로드 밸런서 - 앱서버 까지의 모식도를 그려봤다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blue_green_nginx.png" >
<figcaption align = "center">[Picture 5] Nginx flow</figcaption>

<br>

#### 무중단 배포 구현하기

> 무중단 배포를 위한 디렉터리 구조 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
tc-admin
├── blue_green_deploy.sh
├── blue_green_deploy.txt
├── dnx-touchcare-admin-0.1-SNAPSHOT.jar
├── gc.log
├── log_rotate.sh
├── server.log
└── start.sh
tc-admin-prod
├── blue_green_deploy.sh
├── dnx-touchcare-admin-0.1-SNAPSHOT.jar
├── gc.log
├── hs_err_pid29917.log
├── hs_err_pid29917.txt
├── log_rotate.sh
├── server.log
└── start.sh
backup-tc-admin
├── api
│   └── dnx-touchcare-admin-0.1-SNAPSHOT.jar
└── tpi
    └── dnx-touchcare-admin-0.1-SNAPSHOT.jar
{{< /highlight >}}



<br> 

> 배포 스크립트 

이 스크립트에서 사용하는 환경은 tpi로, tc-admin을 이용한다. 백업 jar가 올라가는 곳은 backup-tc-admin 으로 tpi/api 로 디렉터리를 분리했다.

`profile` 은 jar 를 실행하는 환경의 정보인데 `prod`와 백업용 `back-prod`를 두었고 포트는 각각 `4000` 과 `4001`로 할당했다.

<br>

{{< highlight bash  "linenos=true,hl_inline=false" >}}
#! /bin/sh

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Blue Green Deployment"
echo "Author: Seungmin Lee"
echo "Date: 2021-02-26"
echo "This script is only for blue green deploy, not for back up server."
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""

# have to change for api and tpi 
SETTING=tpi
PROFILE=prod
PROFILE_BACKUP=back-prod

PORT=4000
PORT_BACKUP=4001

CURRENT_PATH=/opt/tc-admin
BACKUP_PATH=/opt/backup-tc-admin/${SETTING}

SUB_URL=/tcadmin/api/test/profile
CHECK_URL=https://${SETTING}.example.kr${SUB_URL}

echo ">Check which profile is active..."
PROFILE_CURRENT=$(curl -s $CHECK_URL)

echo ">$PROFILE_CURRENT"

if [ $PROFILE_CURRENT = $PROFILE ]
then 
	IDLE_PROFILE=$PROFILE_BACKUP
	IDLE_PORT=$PORT_BACKUP
	IDLE_DIR=$BACKUP_PATH
elif [ $PROFILE_CURRENT = $PROFILE_BACKUP ]
then
	IDLE_PROFILE=$PROFILE
	IDLE_PORT=$PORT
	IDLE_DIR=$CURRENT_PATH
else 
	echo ">Current profile is not matching with any of them..."
	echo ">Will use default $PROFILE for profile"
	IDLE_PROFILE=$PROFILE
	IDLE_PORT=$PORT
	IDLE_DIR=$CURRENT_PATH
fi

# update idle one and run 
# planed to seperate starting shell, but I have to copy/run first and kill the current one
echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Update JAR file to new one and Run"
echo "target dir is ${IDLE_DIR}"
echo "target property is ${IDLE_PROFILE}"
echo "target port is ${IDLE_PORT}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""

cp -f ~/admin-0.1-SNAPSHOT.jar ${IDLE_DIR}/.

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Now Deploy New Server...." 
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""

DATE=`date +'%Y%m%d'`
ETC_JAVA_OPTS=-XX:+UseStringDeduplication
 
nohup java -Xms128m -Xmx128m -XX:NewRatio=1 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -Xloggc:./gc.log -Dspring.profiles.active=${IDLE_PROFILE}  $* -jar ${IDLE_DIR}/dnx-touchcare-admin-0.1-SNAPSHOT.jar >> ./server.log & 

UP_CHECK=""

while [ -z "$UP_CHECK" ]
do 
	UP_CHECK=$(curl -s http://localhost:${IDLE_PORT}/tcadmin/api/test/profile)
done 

echo ""
echo "Now killed old server..."
echo ""

KILL_PROCESS_PID=$(pgrep -f "profiles.active=${PROFILE_CURRENT} -jar") 

echo "> kill process ${KILL_PROCESS_PID}"
if [ -z $KILL_PROCESS_PID ]
then 
	echo ">There are no pid..."
else
	echo ">kill -9 $KILL_PROCESS_PID"
	kill -9 ${KILL_PROCESS_PID}
	
fi

tail -f server.log
{{< /highlight >}}


<br>


##### 스크립트 상세


1. 초반에 환경과 프로파일들, 포트와 jar가 있는 path들을 정해준다.
2. curl 을 이용해서 현재 띄워져있는 서버의 프로파일을 알아낸다. 
   - 이때는 `도메인`을 이용해서 외부에서 서버로 요청을 보내는 것처럼 동작한다.
3. 서버의 `profile`에 따라서 업데이트를 할 `Idle` 프로파일과 포트, 패스를 지정한다.
   - 현재 프로파일이 prod면 back-prod로, back-prod면 prod 로 Idle이 설정된다.
4. Idle profile 로 설정된 프로파일이 업데이트가 되면 해당 jar 파일을 띄운다. 
   - prod와 back-prod 2개의 서버가 떠있는 상태이다. 
5. curl 을 이용해서 Idle jar 가 완전히 구동하고 있다는 응답을 받을 때까지 요청을 보낸다. 
   - 이때는 `localhost 와 Idle port` 를 이용해서 내부에서 서버로 요청을 보낸다.
6. 확인이 되면 이전버전으로 돌아가고 있는 jar의 프로세스를 종료시킨다.

<br>

##### 앱서버가 완전히 뜬 것을 확인하는 방법

5을 구현하기 위해 많은 고민을 했다. 어떻게 해야 단순히 서버가 뜨는 것이 아닌 서비스 요청을 받아서 처리하는 수준의 완전히 구동된 서버의 상태를 알 수 있을까?

<br>

> 앱서버 구동 확인 시도들

{{< highlight bash  "linenos=true,hl_inline=false" >}}
// 1 try : 임의의 sleep 을 주기 
sleep(10000) 

// 2 try : 해당 프로세스로 확인하기 
pgrep -f "pfofiles.active=${IDLE_PROFLE} -jar" 

// 3 try : 해당 포트로 확인하기 
ss -tlp | grep ${IDLE_PORT}

// 4 try : 내부로 요청을 보내기
curl http://localhost/{IDLE_PORT} 
{{< /highlight >}}


<br>

###### 1 try : 임의의 sleep 을 주기

처음에는 서버가 완전히 뜰 수 있게 임의의 sleep 값을 주었는데 제일 나쁜 방법이었다. 서버가 뜨는 속도가 일정하지 않기 때문에 sleep을 초과하고도 뜨지 않아서 서비스가 멈출 수 있었다.

###### 2 try : 해당 프로세스로 확인하기

두번째로는 프로세스가 떠있는 것으로 확인을 했는데 프로세스는 jar를 실행하자마자 뜨는 것이기 때문에 서버가 완전히 뜨는 것보다 훨씬 더 빠른 시점이다. 프로세스가 떠있다고 과거의 프로세스를 죽인다면 실상 서버는 완전히 뜬게 아니라서 서비스가 멈춘다.

###### 3 try : 해당 포트로 확인하기 

세번째로는 포트가 열려있는 것으로 확인을 했다. jar를 실행시키자마자 생기는 프로세스보다는 포트가 뒤늦게 열리지만 포트 또한 서버가 완전히 뜨는 여부와는 상관이 없이 일찍 열리기 때문에, 포트만 믿고 과거의 프로세스를 죽이면 서비스가 멈춘다.

###### 4 try : 내부로 요청을 보내기

어쩌지 고민을 하다가 외부로 요청을 보내면 이전에 떠있는 A서버가 처리를 했는지 B서버가 처리를 했는지 몰라서 무용지물이었다. 

그런데 알고보니 `curl`은 외부에 있는 nginx를 거쳐서 내부의 서버에 요청을 하는 것 뿐만 아니라 `localhost`와 `port` 로 내부에서 내부의 서버에 요청이 가능했다!! 이 방법으로   

(1) 내가 원하는 포트로   
(2) 응답이 올때까지 요청을 보내고   
(3) 응답이 오면 이전의 서버를 죽일 수 있었다.  

<br>

# 결론

이런식으로 쉘스크립트를 이용해서 업데이트 배포를 하면서 서비스는 죽지 않게 무중단으로 운영될 수 있는 환경을 만들었다. 한국에서는 무중단 배포라고 하지만 영어로는 blue green deploy 라고 한다.

그리고 팀장님이 spring의 context event를 써보면 어떻겠냐고 하셨는데 무중단 배포를 위한 기능은 아닌 것 처럼 보였다. 그래도 spring event가 굉장히 유용한 기능이기에 링크를 남겨 나중에 보기로 했다.

- [[Spring Event]](https://www.baeldung.com/spring-context-events)

<br>

### Update in 2022 
해당 포스팅은 AWS ec2를 하나를 사용하고 그 안에서 앱 서버를 여러 개 띄워서 무중단 배포를 하는 형식이었다. 


하지만 ec2를 하나만 사용하는 경우는 거의 없고, AWS `EKS`를 사용하여 `오케스트레이션`을 사용하여 무중단 배포를 하는 형식이 대다수이다. 
EKS는 AWS에서 제공하는 `쿠버네티스`로, 평소에 쿠버네티스의 제일 작은 단위인 `파드`를 여러 개 띄워두고 순차적으로 배포하는 형태이다.  
