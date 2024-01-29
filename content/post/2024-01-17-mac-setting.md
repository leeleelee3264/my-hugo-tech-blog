+++
title = "[General] DevOps Engineer에 최적화된 맥 설정하기"
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
3. 인텔리제이 세부 설정 
4. 맥 설정 


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

eks를 사용하고 있다면 클러스터 정보도 kube/config에 등록해줘야 한다. [Install kubectl](https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-macos/) 공식 문서를 보고 kubectl을 설치한 후 진행한다. 

```
# aws login 이후
aws --profile <profile-name> eks --region <profile-region> update-kubeconfig --name <cluster-name> --alias <cluster-alias>
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


### Iterm2
- 용도: 터미널 
- 설치 방법:

```
brew install iterm2 

# install oh-my-zsh 
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# in .zshrc 
# agnoster가 현재 checkout한 브랜치를 쉽게 알아볼 수 있게 지원해주는 테마라고 한다. 
ZSH_THEME="agnoster"
```

- 세부 설정:

폰트: [D2 Coding](https://github.com/naver/d2codingfont)  
Colors: Blue Matrix  
하단 상태바: [상태바 추가](https://danaing.github.io/etc/2022/03/28/M1-mac-iTerm2-setting.html), CPU, Mem, 시간 등을 선택해서 사용한다.   

설치가 필요한 플러그인: zsh-autosuggestions, zsh-syntax highlighter, [kubectl 자동 완성](https://interp.blog/oh-my-zsh-kubectl-autocomplete/)

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

사용하는 플러그인
```
git kubectl kube-ps1 zsh-syntax-highlighting zsh-autosuggestions aws docker docker-compose
```

사용하는 alias 
```
alias ll="ls -alht"
alias src="source ~/.zshrc"
alias gst="git status"
alias glog="git log --oneline"
alias gb="git branch | cat"
alias ab="git branch -a | cat"
alias gsw="git switch main"
alias rsw="git switch -"
alias dbranch="git branch | grep -v 'main' | xargs git branch -D"
alias shutdown="sudo shutdown -h now"
alias reboot="sudo reboot"
alias h="history"
alias hg="history | grep"
alias down="sudo pkill loginwindow"
alias e="exit"
alias tf='terraform'

# AWS
alias sso="aws sso login --profile <dev> && aws sso login --profile <staging> && aws sso login --profile <prod>"
alias ep="export AWS_PROFILE=<prod>"
alias es="export AWS_PROFILE=<staging>"
alias ed="export AWS_PROFILE=<dev>"

```

<br>



### Kubernetes support: kubectx, kubens

- 용도: kubernetes를 조금 더 편하게 사용할 수 있도록 보조해주는 command base tool. kubectx: 사용중인 클러스터 바꾸기, kubens: 사용중인 네임스페이스 바꾸기  
- 설치 방법:  
```
brew install kubectx
brew install kubens 
```

- 세부 설정: - 

<br>

### Kubernetes support: kube-ps1
- 용도: 터미널 프롬프트에 지금 사용중인 K8s 클러스터와 네임스페이스를 보여준다. 단, 이걸 쓰면 터미널이 느려진다.  
- 설치 방법: 
```
brew install kube-ps1

# .zshrc 추가  
source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
```

- 세부 설정: - 


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
- 용도: Kubernetes Management (Lens 무료 버전)
- 설치 방법: [OpenLens Download](https://formulae.brew.sh/cask/openlens)
- 세부 설정: Extension을 추가로 깔아야 Lens와 동일한 환경으로 쓸 수 있다. 아래의 Extension들을 깔자. 
  - openlens-node-pod-menu: node, pod 메뉴를 볼 수 있는 extension
  - lens-multi-pod-logs: 디플로이에 연결된 복수 개의 파드 로그를 볼 수 있는 extension 
  - kube-resource-map: k8s 리소스 관계를 그림으로 보여주는 extension. Deploy, Statefulset, Daemonset, pod, service, ingress에서 사용 가능. 


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


<br>

# 인텔리제이 세부 설정

- 사용 폰트: D2Coding (12~13) 
- 사용 테마: Atom One Dark (Material Theme 설치)
- 사용 플러그인:
  - Atom Material Icons 
  - CodeGlance Pro 
  - Key Promoter X 
  - Kubernetes 
  - Material Theme UI 
  - Pokemon Progress 
  - Rainbow Brackets Lite 
  - Terraform and HCL 
  - 그외 언어 support template은 필요할 때 마다 추가 
- 마우스 휠로 폰트 조절: Editor > General > Mouse Control > Change font size Commond+Mouse Wheel in: 

<br>

OpenLens가 있는데 인텔리제이에 쿠버네티스 플러그인을 깔 필요가 있을까 했는데 깔아보니 엄청 편하다. 
UI로 yaml을 생성하고 Describe하는 기능을 잘 쓰고 있다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/setting/ku.png" >
<figcaption align = "center">[Picture 2] Kubernetes in Intellij</figcaption>

<br>

# 맥 설정
- [세손가락 드래그](https://support.apple.com/ko-kr/102341)
- [마우스 포인터 크기 조절](https://support.apple.com/ko-kr/guide/mac-help/mchlp2920/mac) 
- [따옴표 자동변환](https://travel.plusblog.co.kr/989)
- [맥북 베터리 잔량 표시](https://jungirl.kr/entry/%EB%A7%A5%EB%B6%81-%EB%B0%B0%ED%84%B0%EB%A6%AC-%EC%9E%94%EB%9F%89-%EB%B9%84%EC%9C%A8-%ED%91%9C%EC%8B%9C/)
- [자동 대문자 해제](https://angerscroll.tistory.com/3)
- [맞춤법 검사 끄기](https://support.apple.com/ko-kr/guide/mac-help/mchlp2299/mac)
- [맥북 메모 글자 확대](https://discussionskorea.apple.com/thread/25162?sortBy=best)
- [맥북 메모 맞춤법 자동 수정 끄기](https://wakestand.tistory.com/1000)