+++
title = "[Infra] Nginx에 서브도메인 연결하기 with Https"
date = "2023-03-25"
description = "Nginx에서 서브도메인을 사용할 수 있도록 설정하는 방법을 알아본다."
tags = ["infra"]
+++



<br>
<br> 

> Nginx에서 서브도메인을 사용할 수 있도록 설정하는 방법을 알아본다.

<br> 

**Index**
1. Intro
2. Wildcard 적용한 Let's encrypt 인증서 발급 
3. 서브도메인 CNAME 등록
4. Nginx에 서브도메인 연결

<br> 

# Intro
`leelee.me` 라는 도메인을 사서 쓰고 있었는데 `jenkins`를 설치하면서 jenkins를 위한 별도의 url를 만들고 싶었다. 이전까지는 `leelee.me/jenkins` 이런 식으로 path로 분기를 했는데 이번에는 `jenkins.leelee.me` 라는 jenkins 전용 `서브도메인`을 하나 만들어보기로 했다.

서브도메인 설정을 처음 해봐서, 다음에 서브도메인 설정을 할 때 참고할 수 있도록 블로그로 문서화를 해둔다. 해당 문서를 따라하면 아래와 같은 결과물이 나온다. 

<br>

> 결과물 

- Nginx에 서브도메인 연결 
- 서브도메인 https 적용


<br>

# Wildcard 적용한 Let's encrypt 인증서 발급

<U>다음에 서브도메인을 설정할 때 이 단계는 하지 않아도 된다.</U> 

<br>

처음에 Nginx를 세팅할 때 `https` 연결을 하기 위해 `Let's encrypt`에서 무료로 인증서를 발급받았었다. 그때는 leelee.me만을 위한 인증서였기 때문에 leelee.me만 https 연결이 가능하게 되어있다. 
앞으로 생성할 모든 서브도메인들도 https 연결을 할 수 있도록 `Wildcard`를 적용한 Let's encrypt 인증서를 발급 받는 작업을 했다. 

<br>


> 인증서 발급 받기

{{< highlight bash  "linenos=true,hl_inline=false" >}}
certbot certonly --manual -d *.leelee.me -d leelee.me --preferred-challenges dns
{{< /highlight >}}

<br>


Wildcard에서는 leelee.me가 커버가 안되기 때문에 위의 커맨드에서 leelee.me는 따로 명시해뒀다.
커맨드를 입력하면 도메인 소유권을 인증하기 위해 특정 값을 `TXT`로 설정해달라는 안내문이 나온다. 


{{< highlight bash  "linenos=true,hl_inline=false" >}}
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for jenkins.leelee.me and leelee.me

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.leelee.me.

with the following value:

y8vZt4fm0cGviPNmAUAsHz9zST6vjBbBbQTgkvZMoewewaGs

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.jenkins.leelee.me.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
{{< /highlight >}}

<br>


도메인을 가비아라는 호스팅 서비스에서 사용하고 있기 때문에 DNS 설정도 가비아에서 하면 된다.
처음에 레코드 수정을 잘못해서 시간이 좀 소요되었는데, 호스트 부분에 `_acme-challenge.leelee.me` 가 아니라 `_acme-challenge` 만 입력하면 된다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/subdomain/txt.png" >
<figcaption align = "center">[Picture 1] TXT 등록</figcaption>


<br>



> TXT 등록 확인 

TXT가 가비아의 DNS에 잘 등록이 되었나 아래의 커맨드로 확인한다. 


{{< highlight bash  "linenos=true,hl_inline=false" >}}
dig _acme-challenge.leelee.me TXT
{{< /highlight >}}

<br>

`ANSWER SECTION`에 TXT가 등록이 된 것을 확인할 수 있다. 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
; <<>> DiG 9.16.1-Ubuntu <<>> _acme-challenge.leelee.me TXT
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56685
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;_acme-challenge.leelee.me.	IN	TXT

;; ANSWER SECTION:
_acme-challenge.leelee.me. 600	IN	TXT	"Yr39uLJh-4QeLs4W2HV5F2JNxL8RqF8qrEbS6DWtpgo"
_acme-challenge.leelee.me. 600	IN	TXT	"SGzb5ZwSW1kI_bCjylmfvCkGNlML8Q0uUFJCtcoOxgQ"

;; Query time: 75 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sun Mar 26 12:00:36 KST 2023
;; MSG SIZE  rcvd: 166

{{< /highlight >}}






<br>

> Wildcard 인증서 Nginx 적용

새로 발급받은 wildcard 인증서 `leelee.me-0001/fullchain.pem` 를 Nginx 설정에 적용한다.  

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# HTTPS server block to serve all HTTPS traffic
server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
server_name www.leelee.me, leelee.me;

    # SSL/TLS configuration using Let's Encrypt certificate
    ssl_certificate /etc/letsencrypt/live/leelee.me-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/leelee.me-0001/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Root location block to serve static content
    location / {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        try_files $uri $uri/ =404;
    }
}
{{< /highlight >}}

<br>

Nginx 설정을 바꿨다면 잊지 말고 꼭 Nginx를 reload 해주자. 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
systemctl reload nginx 
{{< /highlight >}}


<br>

Nginx를 reload 하고 브라우저로 leelee.me에 접속해 wildcard 인증서가 적용되었나 확인한다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/subdomain/apply.png" >
<figcaption align = "center">[Picture 3] Wildcard 인증서 적용 확인</figcaption>



<br>

# 서브도메인 CNAME 등록

가비아에서 TXT를 등록해준 것 처럼 서브도메인의 `CNAME`도 등록해준다. 처음에는 `*`를 사용해서 wildcard로 CNAME을 등록했는데 이렇게 하면 <U>내가 의도하지 않은 모든 leelee.me의 서브도메인을 사용해서 
서버로 들어올 수 있어, jenkins만을 위한 CNAME을 등록해줬다.</U>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/subdomain/cname.png" >
<figcaption align = "center">[Picture 4] CNAME 등록</figcaption>


<br>

# Nginx에 서브도메인 연결

Nginx에서 jenkins.leelee.me 로 들어오는 요청을 jenkins 서버가 떠 있는 localhost의 `8081 포트`로 보내주도록 설정했다.
기존에는 `/etc/nginx/sites-available` 에 있는 `leelee.me` 설정 파일 하나만 존재했는데 서브도메인별로 설정 파일이 있는 게 관리하기 편할 것 같아서 `jenkins.leelee.me` 설정 파일을 만들었다. 

<br>


> 설정 파일 구성도 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
sites-available/
├── default
├── jenkins.leelee.me
└── leelee.me
{{< /highlight >}}

<br>


> leelee.me

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# HTTP server block to redirect all HTTP traffic to HTTPS
server {
listen 80;
listen [::]:80;
server_name www.leelee.me, leelee.me;

    return 301 https://$host$request_uri;
}

# HTTPS server block to serve all HTTPS traffic
server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
server_name www.leelee.me, leelee.me;

    # SSL/TLS configuration using Let's Encrypt certificate
    ssl_certificate /etc/letsencrypt/live/leelee.me-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/leelee.me-0001/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Root location block to serve static content
    location / {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        try_files $uri $uri/ =404;
    }
}
{{< /highlight >}}

<br>

원래 `server_name *leelee.me` 라고 했다가 leelee.me로 들어가도 jenkins가 나왔다. 
뭔가 jenkins의 conf를 덮어쓰는 거 같아서 아스테리크를 쓰지 않고 도메인을 `server_name www.leelee.me leelee.me` 로 명시했다.

<U>앞으로 서브도메인을 추가할 때마다 site-avaliable에 서브도메인.leelee.me 설정 파일을 만들고, server_name 서브도메인.leelee.me 를 명시하는 작업을 해야 한다.</U> 

<br>



> jenkins.leelee.me 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# Jenkins server block to proxy requests to Jenkins running on port 8081
server {
listen 80;
server_name jenkins.leelee.me;
return 301 https://$host$request_uri;
}

server {

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name jenkins.leelee.me;

    # SSL/TLS configuration using Let's Encrypt certificate
    ssl_certificate /etc/letsencrypt/live/leelee.me-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/leelee.me-0001/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {

      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      # Fix the "It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://127.0.0.1:8081;
      proxy_read_timeout  90;
    }
}
{{< /highlight >}}


<br>

80 포트 리다이렉트 설정은 leelee.me에 이미 해두어서 jenkins.leelee.me를 https 연결 하게 해주는 설정만 추가해준다. `leelee.me-0001` 디렉터리에 들어있는 
인증서가 wildcard용 인증서이기 때문에 jenkins.leelee.me 에서도 동일한 인증서를 사용해준다. 

<br>

Nginx에 적용하고, 적용이 잘 되었는지 브라우저에서 jenkins.leelee.me로 접속해 확인한다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/subdomain/jenkins.png" >
<figcaption align = "center">[Picture 6] 브라우저 접속 확인</figcaption>
