+++
title = "[General] DevOps Engineer에 최적화된 맥 설정하기 (1/2): APP"
date = "2024-01-17"
description = "DevOps Engineer에 최적화된 맥을 설정하는 방법을 알아본다. - APP 편"
tags = ["General"]
+++


<br>
<br> 

> DevOps Engineer에 최적화된 맥을 설정하는 방법을 알아본다. - APP 편

<br> 

**Index**
1. Intro 
2. 설치하는 앱 
3. 맥 설정
4. Jetbrains 제품군 세부 설정 

<br> 

# Intro 
직장에서 사용하는 컴퓨터를 포맷해야 하거나 교체되거나 해서 
다시 설정을 해줘야 할 일이 요즘들어 왕왕 있었다. 맥에서 맥으로 설정을 마이그레이션 하는 기능도 지원하는 걸로 알고 있는데 
해당 설정을 사용할 수 있는 환경이 아니라서 하나씩 설정해야 했다.

이것도 여러 번 하다보니 일이 되는 거 같아서 이번 기회에 사용하는 설정을 블로그에 백업해두고, 다음 번에 설정할 일이 있으면 
이 포스팅을 보고 빨리 설정을 해야겠다. 

<br> 

# 설치하는 앱 

### Raycast 
- 용도: 맥에서 나만의 단축키를 만들 수 있다. app이나 특정 링크로 바로 접근할 수 있는 단축키를 등록해 두면 시간을 많이 절약할 수 있다. 
- 설치 방법: - 
- 세부 설정: - 

설치 방법과 세부 설정은 블로그 포스팅 중 [[General] 이것만 있으면 나도 슈퍼 개발자? 생산성 앱 Raycast](https://leeleelee3264.github.io/post/2023-09-02-general-raycast/) 에서 이미 다루고 있기 때문에 여기를 참고해서 진행하도록 한다.

**참고**   
포스팅에서는 ChatGPT를 `shift+option+C` 로 해놨는데 쓰다보니 `shift+option+G`가 더 직관적이었다. shift+option+G는 원래 깃허브의 단축키였는데 중요성을 강조하기 위해 `shift+option+0` 으로 변경했다. 


<br>

### Notion 
- 용도: 노트로도 사용이 가능하고 문서 데이터베이스로도 사용이 가능한 만능 생산성 앱이다.  
- 설치 방법: [Notion Download](https://www.notion.so/ko-kr/desktop) 방문하여 다운로드 한다. 
- 세부 설정: 회사에서 사내 문서로 노션을 쓸 때 브라우저로는 사내 노션을, 설치한 앱으로는 개인 노션을 설정했다.

<br>

### IntelliJ 
- 용도: IDEA
- 설치 방법: [IntelliJ Download](https://www.jetbrains.com/ko-kr/idea/download/?section=mac)
- 세부 설정: 해당 포스팅 아래에서 단독 목차로 IntelliJ의 세부 설정인 plugins 등을 다룬다. 

**참고**    
DevOps로 일을 하기 시작하면서 Java 개발을 안 하다보니 테라폼이나 k8s의 yaml을 수정할 때 IntelliJ가 너무 무겁게 느껴진다.
Jetbrains에서 재작년에 경량화된 IDEA가 나왔던 거 같은데 한 번 써봐야겠다. 아니면 이번 기회에 VSCode로 넘어가야 하나 고민도 된다. 하지만 단축키가 달라지다보니 망설이고 있다. 


<br>

### VSCode
- 용도: IDEA
- 설치 방법: [VSCode Download](https://code.visualstudio.com/download)
- 세부 설정: - 

**참고**   
IDEA인데 코드 편집보다는 코드 Viewer 또는 코드 메모장처럼 쓰고 있다. 복붙해야 하는 커맨드나 코드가 있을 때 여기에 메모장처럼 적어두고 보면 작업하기 정말 편하다. 


<br>


### Docker Desktop 
- 용도: 로컬 컴퓨터에서 Docker, K8s 구동하기 
- 설치 방법: [Docker Desktop Download](https://www.docker.com/products/docker-desktop/)
- 세부 설정: K8s 추가 설치 
 
**참고**   
로컬 컴퓨터에서 Docker, K8s를 구동할 수 있는데 K8s 연습용으로 쓰면 좋다. 클릭 몇 번이면 로컬에 노드 1개 짜리 K8s를 설치할 수 있다. 
대신 Docker Desktop 설정 메뉴에서 K8s의 리소스를 적당히 잡아줘야 한다. 너무 많이 할당했다가는 Docker Desktop에서 RAM을 7G 넘게 쓰는 걸 볼 수 있다. 

<br>


### Git (Command Base)
- 용도: - 
- 설치 방법: [Git Download](https://git-scm.com/download/mac)
- 세부 설정: alias를 걸어서 사용하는데, 그 부분은 Iterm2 부분에서 다루겠다. 

**참고**

설치 후 내 git 계정을 등록해주자. 
```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

<br>


### AWS (Command Base)
- 용도: - 
- 설치 방법:
```
----- aws cli version2 설치 -----
$ curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
$ sudo installer -pkg AWSCLIV2.pkg -target /
```

- 세부 설정: alias를 걸어서 사용하는데, 그 부분은 Iterm2 부분에서 다루겠다.

<br>

**참고**   
aws sso을 사용하는 회사라면 aws sso 설정을 해줘야 한다.
버전에 따라서 session-name을 설정하라고 하는데 이거 설정하면 terraform에서 계정 인증할 때 문제가 난다. 공란으로 넣어줘야 한다. 

```
$ aws configure sso

SSO start URL [None]:
SSO region [None]:
There are 5 AWS accounts available to you. 
... 

CLI default client Region [None]: 
CLI default output format [None]:                 
CLI profile name [Admin-***]: 


# login  
$ aws sso login --profile my-profile
```


<br>


### Terraform (Command Base)
- 용도: - 
- 설치 방법: terraform 자체를 설치하는 것보다 terraform 버전 관리 툴을 설치해서 테라폼을 설치하는 게 편하다. tfenv 라는 버전 관리 툴을 사용중이다. 

```
brew install tfenv

# Install 
tfenv install {Version}

# Change 
tfenv use {Version}

# Show installed versions 
tfenv list 
```

- 세부 설정: - 

<br>

### Kubernetes 보조 툴 (Command Base)

- 용도:
- 설치 방법:
- 세부 설정:

(클러스터 설정하는 방법도 쓰자)

<br>


### Iterm2
- 용도:
- 설치 방법:
- 세부 설정:

<br>


### Scroll Reverser
- 용도: 마우스 휠 반전 
- 설치 방법: [Scroll Reverser Download](https://pilotmoon.com/scrollreverser/)
- 세부 설정: 로그인 시 Scroll Reverser가 런치될 수 있도록 설정한다. 마우스 설정 반전은 다운로드 페이지를 참고해서 설정한다. 

**참고**
맥북에 마우스를 연결해서 사용하면 스크롤 방향이 원래와 반대 방향이다. 그래서 맥북 트랙패드 쓸 때는 정방향, 마우스를 연결해서 쓸 때는 역방향이 되도록 해당 앱으로 조작해야 한다. 

<br>


### Spectacle 
- 용도: 화면 분할
- 설치 방법: [Spectacle Download](https://spectacle.en.softonic.com/mac)
- 세부 설정: 로그인 시 Spectacle이 런치될 수 있도록 설정한다.

**참고**
복잡한 화면 분할은 잘 사용하지 않고, 오른쪽/왼쪽 양면 분할을 가장 많이 사용한다. 
오른쪽: `Alt + Cmd + ->` 
왼쪽:  `Alt + Cmd + <-`

<br>

### Dozer
- 용도: 메뉴 막대 숨기기
- 설치 방법: [Dozer Download](https://github.com/Mortennn/Dozer)
- 세부 설정: 로그인 시 Dozer가 런치될 수 있도록 설정한다.

**참고**
날짜, 시간 같은 기본 정보와 이것 저것 앱을 깔아서 사용하다보면 오른쪽 상단의 메뉴 막대가 여러 아이콘으로 가득 차 복잡해진다. Dozer를 사용하면 꼭 필요한 메뉴 아이콘 말고 모두 숨길 수 있어서 깔끔하다. 


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/setting/bar2.png" >
<figcaption align = "center">[Picture 1] Dozer를 도입한 메뉴 막대</figcaption>

<br>

설치하면 메뉴 막대 영역에 2개의 점이 생긴다. 2개의 점 기준으로 왼쪽은 숨길 아이콘, 오른쪽은 노출할 아이콘이다. 
숨길 아이콘은 Cmd를 누른 상태로 마우스로 드래그 해 왼쪽 점 옆으로 옮기면 된다.  
보통은 배터리 잔량, 와이파이 상태, 날짜/시간만 노출한다. 


<br>

### Karabiner 
- 용도: 키 매핑 
- 설치 방법: [Karabiner Download](https://karabiner-elements.pqrs.org/)
- 세부 설정: 간혹 외장 키보드가 윈도우로 설정이 되어있어 배열이 맞지 않는 경우가 있다. 그때는 `left_command -> left_option`, `left_option -> left_command` 룰을 추가해주자. 

<br>

### GoodNotes
- 용도: PDF 파일 Viewer 
- 설치 방법: App Store > GoodNotes 5 (legacy version)
- 세부 설정: - 

**참고**  
기본 메모장을 메모로 쓰고 있어, GoodNotes를 메모장으로 쓰지는 않는다. 대신 PDF 스캔한 책을 보는 용도로 많이 쓴다. 형광팬칠, 메모 등을 할 수 있어서 좋다. 

<br>

### OpenLens 
- 용도: Kubernetes Management 
- 설치 방법: []()
- 세부 설정: 


<br>

### (Chrome Extension) Authenticator Extension
- 용도: OTP Authenticator 앱의 크롬 익스텐션 버전이다. 
- 설치 방법: [Authenticator - Two-factor authentication in your browser](https://authenticator.cc/)
- 세부 설정: 익스텐션을 설치하고 OTP 생성 시 나오는 QR 코드를 스캔해주면 된다. 

**참고**  
Github 등 2차로 OTP 인증이 필요한 곳이 많은데 그때마다 핸드폰으로 손이 가면 흐름이 깨져서 최대한 PC에서 이용할 수 있는 OTP 앱을 찾다가 설치했다.

<br>

> 여기 밑에는 쓰고 싶은 앱이다. 

<br>

### 1Password 
- 용도: Password Management 
- 설치 방법: Appstore > 1Password 
- 세부 설정: - 

**참고**  
전 직장에서 사용했는데 DevOps가 사내 솔루션, 3rd-party 솔루션에 접속할 일이 많다보니 다양한 계정의 계정 정보를 따로 관리할 필요가 없어서 정말 편리하게 사용했다. 
개인으로 라도 사용하고 싶었는데 개인도 유로인 솔루션이라서 고민하다가 구매하지 않았다. 



# Jetbrains 제품군 세부 설정 



