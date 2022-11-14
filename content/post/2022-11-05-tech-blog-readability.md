+++
title = "(작성중)[Project] 블로그 리팩토링: 읽고 싶어지는 기술 블로그 만들기"
date = "2022-11-05"
description = "개인 기술 블로그 가독성 향상 프로젝트에 대해 다룬다."
tags = ["Project"]
+++



<br>
<br> 

> 2022-09-16 부터 2022-10-08 동안 진행한 블로그 리팩토링에 대해 다룬다. 
> > [[새로운 블로그]](https://leeleelee3264.github.io/)   
[[옛날 블로그]](https://leeleelee3264.github.io/old-blog/)

<br> 

**Index**
1. Intro: 기술 블로그 연대기
2. Hugo 도입과 새로운 블로그 메커니즘
3. 읽고 싶어지는 기술 블로그를 만드는 방법
4. 프로젝트 회고  

<br> 

# Intro: 기술 블로그 연대기 


기술이 아닌 기술 블로그 자체에 대해 포스팅을 하는 것이 적합한가 고민을 했으나, 개발자에게 `문서화`는 
아주 중요한 영역이고, 기술 블로그 또한 문서화의 영역이라 생각해 포스팅을 할 필요를 느꼈다. 


이제부터 2020년 1월부터 지금까지 어떤 플랫폼을 사용하여 블로그를 운영했고, 어떤 문제점이 있어 2022년 09월 16일부터 10월 08일, 약 한 달 동안 `블로그 리팩토링 프로젝트`를 진행했는지 다뤄보도록 하겠다. 

<br> 

### 2020년: 티스토리 

[[_티스토리 블로그 링크_]](https://calgaryhomeless.tistory.com/?page=1)

처음 기술 블로그를 만들 게 된 이유는 단순했다. 인턴으로 재직하고 있던 회사에서 다른 개발자 분이 기술 블로그를 운영하는 게 좋아보여서 따라 만들었다. 
그 당시에는 어떤 플랫폼을 사용할 것인지 많은 고려도 하지 않고 `티스토리`를 사용했다. 

<br> 

> 티스토리를 선택한 이유 
- 가장 익숙한 기술 블로그 플랫폼이었다.
- Github Page를 만들기가 쉽지 않아보였다.


<br> 

> 티스토리의 장점
- 블로깅 전문 플랫폼이라 포스트를 수정하기도 쉽고, 호스팅하기도 쉬워 진입장벽 없이 사용할 수 있었다.
- _글을 쓰면 구글 검색어 노출이 잘 돼, 블로그 유입률이 높다_. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/tistory_cal.png" >
<figcaption align = "center">[Picture 1] 티스토리 꾸준한 방문자 유입</figcaption>

<br> 

2021년 09월 이후로 새로운 포스팅이 없는데도 꾸준히 방문자가 유입되는 걸 보면 (한국 한정) 많은 사람들이 보게 만들기 위해서는 티스토리가 좋은 선택지인 거 같다.   


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/tistory.png" >
<figcaption align = "center">[Picture 2] 좋지 않은 가독성</figcaption>





### 2021-2022년: Jekyll Github Page 



