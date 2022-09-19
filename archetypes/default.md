+++
title: ""
date: "YYYY-mm-dd"
description = ""
tags = [""]
+++

===
규칙
1. 포스트 앞에는 항상 summary와 index를 작성한다. 
2. big title과 middle title 사이에는 br이 없다. 
3. middle title, small title, image, example 사이에는 br이 있다. 
4. image 전에 설명을 써두도록 한다. 
5. image caption은 [Picture 1] 설명설명 식으로 작성한다. 
6. image 사이즈는 height 400 width 500
7. 여러 줄의 코드를 쓸 때에는 highlight를 사용한다. 넘버링이 default로 되어있다. 
8. 한 줄의 코드를 쓰거나 코드가 아닐 경우에 (url 등) markdown code block을 사용한다.
9. link 를 할 때에는 [링크] 로 해두어, 링크임을 식별할 수 있도록 한다. 
10. 정렬을 할 때는 1,2,3,4 보다는 - 으로 dot 정렬을 사용한다. 
=== 

<br>
<br> 

> Summary of post 

<br> 

**Index**
1. index1
2. index2 

<br> 

# Big title

[[링크]]()

### Middle title 

<br> 

### Middle title

- 설명 1 
- 설명 2
- 설명 3

{{< figure height="400" width="500" src="/static/img/post/certificate/attachments/4565565736/4669997094.png" caption="[Picture 2] sample image" >}}

<br> 


#### Small title 

<br> 

> example 

<br> 


{{< highlight shell  "linenos=true,hl_inline=false" >}}
server {

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name www.test.me test.me;

        location / {
                try_files $uri $uri/ =404;
        }

    listen [::]:443 ssl http2; # managed by Certbot
    listen 443 ssl http2; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/test.me/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/test.me/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
{{< /highlight >}}

설명 설명 설명 

<br> 
