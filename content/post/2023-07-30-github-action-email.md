+++
title = "[Project] Github Action을 이용해 server-less 하게 서버 healthcheck와 이메일 notification 보내기"
date = "2023-07-30"
description = "Github Action을 이용해 server-less 하게 서버 healthcheck와 이메일 notification 보내는 방법을 포스팅한다."
tags = ["Project"]
+++

<br>
<br> 

> Github Action을 이용해 server-less 하게 서버 healthcheck와 이메일 notification 보내는 방법을 포스팅한다.


<br> 

**Index**
1. Intro
2. Github Action 설정
3. Gmail 설정
4. 결과물

<br> 

# Intro

몇 년 전 부터 안쓰는 노트북에 우분투를 설치해, 집에서 서버로 사용하고 있다. 그런데 얼마전부터 노트북의 충전단자 부분이 오래되어서 충전기가 조금만 움직여도 충전이 안되고, 베터리가 떨어진 노트북의 전원이 꺼지는 일이 자주 발생했다. 문제는 지금 활발하게 돌리는 프로젝트가 없어서 서버가 꺼져도 한참 뒤에 알게 된다는 점이다.

노트북이 꺼지면 빠르게 알람을 받을 수 있는 방법을 고민하다가  Github Action을 생각해냈다.

<br>

> 시나리오

1. Github Action으로 주기적으로 서버 health check를 한다.
2. Github Action이 실패했을 경우, 이메일로 notification을 보낸다.
3. 노트북이 꺼진 것을 알아차리고 조치한다.

<br>

Github Action을 사용하면 health check를 하기 위해 별도의 서버를 구성할 필요가 없다. 하지만 걱정되는 부분은 Github Action에서 이메일을 보낼 수 있는 기능이 있을까? 였다. 다행히 Gmail에 특정 설정을 하면 보낼 수 있었다. 이제 설정 방법을 알아보겠다.

<br>

# Github Action 설정

서버에 health check를 하는 방법은 `jtalk/url-health-check-action@v2` 의 Action을 사용했다.

실행된 Action의 로그를 확인해보니 등록한 url로 curl을 이용해 리퀘스트를 보내는 형태로 되어있었다. nginx에 https 설정을 했기 때문애 http로 요청을 보내면 응답으로 301 Moved Permanently가 왔다. 301이 왔다는 것 자체가 서버가 떠있는 것으로 판단할 수 있기 때문에 redirection 설정은 하지 않았다.

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/curl.png" >
<figcaption align = "center">[Picture 1] curl 로그</figcaption>

<br>

이메일을 보내는 방법은 `dawidd6/action-send-mail@v3`의 Action을 사용했다. 해당 Action으로 이메일을 보내기 위해서는 꼭 Gmail을 써야 한다. 보낼 이메일의 Subject와 Body 등을 설정해주고, 계정 정보는 민감정보라서 해당 Action이 돌아가는 레포지토리의 Secret으로 등록했다.

`secrets.EMAIL_USERNAME`
- notification을 보낼 이메일 주소다.

`secrets.EMAIL_PASSWORD`
- 위 이메일 주소의 비밀번호, 앱 비밀번호가 필요해서, 아래에서 발급받는 방법을 설명하겠다.

`secrets.RECEIVER_EMAIL_USERNAME`
- notification을 받을 이메일 주소다.

<br>

> action flow


{{< highlight java  "linenos=true,hl_inline=false" >}}
name: healthcheck

on:
  schedule:
    - cron: '0 0 * * *' # Every midnight (12:00 AM) 
    
jobs:
  healthcheck:

    runs-on: ubuntu-latest

    steps:
      - name: Check the deployed service URL
        uses: jtalk/url-health-check-action@v2
        with:
          # Check the following URLs one by one sequentially
          url: http://leelee.me
          # Follow redirects, or just report success on 3xx status codes
          follow-redirect: false # Optional, defaults to "false"
          # Fail this action after this many failed attempts
          max-attempts: 3 # Optional, defaults to 1
          # Delay between retries
          retry-delay: 5s # Optional, only applicable to max-attempts > 1
          # Retry all errors, including 404. This option might trigger curl upgrade.
          retry-all: false # Optional, defaults to "false"
      - name: Send mail
        if: failure()
        uses: dawidd6/action-send-mail@v3
        with:
          secure: true
          # mail server settings
          server_address: smtp.gmail.com
          server_port: 465
          # user credentials
          username: ${{ secrets.EMAIL_USERNAME }}
          password: ${{ secrets.EMAIL_PASSWORD }}
          # email subject
          subject: 🔥 leelee.me SERVER DOWN! 🔥
          # email body as text
          body: 🔥 leelee.me SERVER DOWN! 🔥 Please check home laptop is activating. 
          # comma-separated string, send email to
          to: ${{ secrets.RECEIVER_EMAIL_USERNAME }}
          # from email name
          from: leeleelee3264-github
{{< /highlight >}}


<br>

# Gmail 설정

구글 계정은 보안을 위해서 로그인을 할 때 2차 인증을 써야 하는데, Action에서는 어떻게 구글 계정으로 로그인을 해서 이메일을 보낼까? AWS에서 프로그래밍적으로 엑세스를 해야 할 때 access key와 access key secret 을 만드는 것처럼 구글도 프로그래밍적으로 엑세스를 할 때 사용하는 비밀번호가 있다. 바로 **앱 비밀번호이다.**

<br>

**step 1: 구글 계정 만들기**

앱 비밀번호는 구글에서 보안상 권장하지 않는 설정이다. 때문에 자주 쓰는 구글 계정을 사용해 앱 비밀번호를 발급 받지 말고, 앱 비밀번호를 발급 받을 용도로 구글 계정을 하나 만들도록 한다.

<br>

**step 2: 2단계 인증 설정**

구글에서는 2단계 인증이 설정된 계정에 한해서만 앱 비밀번호를 발급받을 수 있다. 때문에 앱 비밀번호를 발급받기 위해서는 2단계 인증을 설정해야 한다.

<br>

**step 3: 보안 → 앱 비밀번호 이동**

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/app.png" >
<figcaption align = "center">[Picture 2] 앱 비밀번호 탭</figcaption>

<br>

**step 4: 앱 비밀번호 생성**

드롭 박스에 해당하는 앱이 없기 때문에 기타를 선택한다. 앱 이름을 입력해줘야 하는데 아무 이름이나 넣어도 된다.  나는 github action으로 입력했다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/etc.png" >
<figcaption align = "center">[Picture 3] 앱 비밀번호 설정</figcaption>


<br>

**step 5: 앱 비밀번호 github secret에 등록**

위의 단계를 완료하면 16자리의 앱 비밀번호가 만들어진다. 이 앱 비밀번호를 github secret에 등록한다. `EMAIL_PASSWORD` 로 등록해주면 된다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/app_pw.png" >
<figcaption align = "center">[Picture 4] 앱 비밀번호</figcaption>


<br>

여기까지 했으면 Github Action이 실패했을 때 이메일로 notification을 받기 위한 작업은 모두 끝났다! 실제 Github Action을 돌려, 실패했을 때 정말 notification 이메일이 날아오는지 확인해보자.


<br>

# 결과물

Action이 실패했을 때 이메일 notification이 발송된다. 이메일을 받았으면 빨리 서버를 복구 시키도록 하자!

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/email.png" >
<figcaption align = "center">[Picture 5] 이메일 notification</figcaption>

<br>

Github Action의 결과를 뱃지로 표현을 할 수 있다. Github의 README에 뱃지를 표시해두면 멋질 거 같아서 추가 했다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/action/action_result.png" >
<figcaption align = "center">[Picture 6] 액션 결과 뱃지</figcaption>

<br>

각 뱃지의 주소는 `<각 Action의 yaml>/badge.svg` 이다. 이 주소를 그대로 긁어와서 README에 등록해주면 된다.

<br>

> health check 뱃지 주소

```java
https://github.com/leeleelee3264/leeleelee3264/actions/workflows/leelee_me_healthcheck.yaml/badge.svg
```

> README에 등록한 health check 뱃지 주소
>

```java
![example workflow](https://github.com/leeleelee3264/leeleelee3264/actions/workflows/leelee_me_healthcheck.yaml/badge.svg)
```