+++
title = "[Infra] CORS (3/3): Cache와 CORS"
date = "2023-09-26"
description = "Cache와 CORS가 함께 동작할 때 발생할 수 있는 에러를 알아본다."
tags = ["infra"]
+++


<br>
<br> 

> Cache와 CORS가 함께 동작할 때 발생할 수 있는 에러를 알아본다.

<br> 

**Index**
1. Intro
2. Cache와 CORS

<br> 


# Intro 
[30분 투자로 CORS 전문가로 성장하기](https://leeleelee3264.github.io/post/2023-08-14-cors-seminar/) 세미나에서 사용했던 발표 자료를 정리해서 포스팅한다. 
해당 포스트에서는 발표의 마지막 꼭지 였던 Cache와 CORS가 함께 동작할 때 발생할 수 있는 에러를 알아본다.

캐시와 CORS가 만나면 동작이 조금 이상해지는 경우가 있다. 어떤 경우이며, 이럴 때는 어떻게 대처하면 좋을지 살펴보겠다.

<br>

# Cache와 CORS


### 허용하지 않은 Origin이 cloudfront 캐시를 가져가는 경우
위에서도 cloudfront 캐시를 이용해서 허용되지 않은 Origin이 리소스를 받아가는 경우를 언급했다. 왜 이런 일이 일어날까?

cloudfront에 캐시를 할 때 캐시 key의 기본값은 리소스의 url이다. 기본값을 사용하면 다른 다른 도메인들에서 요청을 하더라도 동일한 리소스를 받게 된다. 때문에 허용되지 않은 Origin이라고 해도 요청하는 리소스의 url이 같다면 cloudfront는 엣지 로케이션에 캐시 되어있는 리소스를 건내준다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/hit.png" >
<figcaption align = "center">[Picture 1] Cloudfront의 의도하지 않은 hit 시나리오</figcaption>

<br>


{{< highlight python  "linenos=true,hl_inline=false" >}}

[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "https://test-a.com"
        ],
        "ExposeHeaders": [],
    }
]
{{< /highlight >}}

CORS 정책 상, test-a.com과 test-b.com이 모두 s3 리소스에 접근을 할 수 있다면 상관이 없지만 test-b.com이 원래는 s3 리소스에 접근하지 못 하게 설정했다면? **cloudfront 캐시를 우회해서 권한 없는 리소스에 접근하게 된 것이다.** 

이럴때는 `cache key`에 `Origin 헤더`를 추가해주면 cloudfront 리소스 접근을 막을 수 있다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/cache_key.png" >
<figcaption align = "center">[Picture 2] Cache Key</figcaption>

<br>

이렇게 키를 관리하면 cloudfront가 Origin이 test-a.com인 요청에만 리소스를 건내준다. 

<br>

#### Cache key 추가해주기


**Step 1: Cache key settings에 header 값 추가 후 캐시 정책을 생성한다.**

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/cache_policy.png" >
<figcaption align = "center">[Picture 3] Cache Policy</figcaption>

<br>

**Step 2: 대상 Distribution의 Behaviors에 Cache policy 적용한다.**

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/policy2.png" >
<figcaption align = "center">[Picture 4] Cache Policy in Cloudfront Behavior</figcaption>

<br>

### 브라우저 캐시로 인한 CORS 에러


브라우저는 img, script 태그를 통해 리소스를 요청할 경우 CORS를 제한하지 않는다. 때문에 요청을 보내면 요청에 CORS를 담고 있지 않아, 응답 또한 CORS 관련 정보가 없다. 즉, Access-Control-Allow-Origin 정보가 없다. 
이 리소스가 캐시 되었다가 `fetch`나 `XMLHttpRequest를` 사용해 리소스에 다시 접근하면 CORS error가 발생한다. 이럴 때는 리소스에 대한 캐시 동작 방법을 제어해줘야 한다. 

#### cache-control 헤더 
cache-control 헤더란 서버가 브라우저에게 리소스의 cache를 어떻게 관리하는지 알려주는 값이다. 흔히 사용하는 값은 no-store과 no-cache인데 동작이 조금 다르다.

`no-store` 

- 클라이언트 및 중간 서버가 응답을 캐시에 저장하지 않아야 한다. 때문에 클라이언트는 매 응답마다 서버에 다녀와야 한다.

 

`no-cache`

- 클라이언트가 캐시를 할 수 있지만, 다시 사용할 때 마다 캐시된 응답이 유효한지 서버에 가서 확인해야 한다. no-cache가 캐시를 하지 마세요, 라는 뜻은 아니다.
- 컨텐츠가 유효한지 확인하기 때문에 헤더가 변경된 것에 대해서는 변경이라고 인식하지 않는다.

<br>

cloudfront에 no-cache를 설정해두면 브라우저가 로컬 캐시에 있는 리소스를 사용할 때나, cloudfront에 캐시된 리소스를 사용할 때 매번 오리진 서버인 s3에 가서 유효성을 검증한다. 변경이 일어나지 않았다면 304 not modified를 받아, 브라우저에서 사용한다.  


<br>


#### 성능 상 이점 

- `그냥 로컬 캐시 쓰기` > `no-cache` > `no-store`
- no-cache가 서버를 다녀와야 하기 때문에 성능 저하가 있지만, 리소스가 자주 변경되지 않고, 변경되더라도 미미하게 변경되는 경우에는 크게 성능 저하가 일어나지 않는다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/modi.png" >
<figcaption align = "center">[Picture 5] 304 Modification</figcaption>

<br>


no-cache를 사용해도 크게 성능 저하가 일어나지 않는 이유는 컨텐츠 자체를 들고 가서 변경이 있는지 확인하지 않기 때문이다. 요청 헤더만을 이용해서 서버의 컨텐츠와 캐시 된 컨텐츠가 변경이 있는지를 확인한다. `If-Modified-Since`는 이전 응답 헤더에서 받은 `last-modified` 값을 나타낸다. 서버에서는 이 날짜와 비교해서 컨텐츠가 변경이 되었는지를 판단한다.  


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/modi_flow.png" >
<figcaption align = "center">[Picture 6] 304 Modification Flow</figcaption>

<br>

#### 캐시 제어 방법

**방법 1: cloudfront 응답 헤더 정책으로 캐시 동작 제어해주기**

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/one.png" >
<figcaption align = "center">[Picture 7] Custom Header in Response Header Policy</figcaption>

<br>

**방법 2: s3의 metadata로 캐시 동작 제어해주기**

cloudfront 응답 헤더 정책은 path가 일치하면 일괄적으로 적용이 되는데, s3에서 제어를 하면 객체 하나 하나에 적용을 해줄 수 있다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/cors/meta.png" >
<figcaption align = "center">[Picture 8] Metadata in s3</figcaption>

<br>


#### no-cache와 no-store가 cors error막을 수 있을까?

만약 이전에 cors 설정을 잘못했는데 로컬 캐시가 된 경우, 다음에 사용할 때 오리진 서버에 가서 유효성을 검사한다. 그때 캐시된 리소스의 cors 정책이 유효하지 않은 것을 확인한다. 브라우저는 즉시 캐시에서 해당 리소스를 지우고 서버에서 다시 리소스를 받아와 사용한다. no-store는 캐시 자체를 하지 않기 때문에 매번 새로 받아오다보니 이전에 잘못 설정한 cors는 저장 조차 하지 않고 새로운 리소스를 사용하게 된다.

 

**결과적으로 no-cache, no-store가 캐시 한정으로 발생하는 cors error를 막을 것이다.** 하지만 cors 설정 자체를 잘못한 경우에는 캐시를 지우고 사용한다고 해도 캐시와 상관없이 cors error가 발생하기 때문에 **처음부터 cors 설정을 잘 하는 게 정말 중요하다.** 


