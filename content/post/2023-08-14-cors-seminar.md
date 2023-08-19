+++
title = "[Seminar] 30분 투자로 CORS 전문가로 성장하기"
date = "2023-08-14"
description = "Kasa에서 2023-08-14에 30분 투자로 CORS 전문가로 성장하기 라는 주제로 진행한 세미나를 정리한다."
tags = ["Seminar"]
+++


<br>
<br> 

> Kasa에서 2023-08-14에 30분 투자로 CORS 전문가로 성장하기 라는 주제로 진행한 세미나를 정리한다.

<br> 

<br> 

**Index**
1. Intro
2. 발표 영상
3. 발표 자료 
4. 세미나 회고

<br> 

# Intro
오랜만에 회사에서 세미나를 진행했다. 기술 공유 시간에 자발적으로 작은 세션을 진행한 적은 왕왕있지만 자발적으로 세미나를 진행한 건 처음이었다. 
백엔드에서 devops로 부서를 바꿨다보니 어떤 주제로 세미나를 할까 고민을 했는데 마침 트러블 슈팅 때문에 `CORS`를 깊게 들여다 볼 일이 생겨서 주제를 CORS로 했다. 


발표는 아래와 같이 구성했다. 

<br>

1. Intro 
2. CORS    
   3. Cross-Origin-Resource-Sharing   
   4. Preflight   
   5. CORS 헤더   
   6. 알쓸신잡  
3. Cloudfront + S3 환경에서의 CORS   
   4. s3 CORS 정책   
   5. Cloudfront 캐시 정책   
   6. 간단한 CORS 요청을 위한 설정   
   7. CORS 요청을 위한 설정  
4. Cache와 CORS  
5. QnA 

<br>

2장에서는 <U>CORS의 전반적인 개념애 대해 설명했다.</U> CORS 절차 중 하나인 `Preflight`에 대해 설명하고, 헤더 베이스 매커니즘인 CORS에서 중요하게 작동하는 
`요청 헤더`와 `응답 헤더`에 대해 설명했다. 

3장에서는 <U>AWS에서 cloudfront를 s3와 연결해서 쓰는 경우 CORS를 어떻게 설정해야 하는지를 알아봤다.</U> 개발자보다는 오퍼레이팅을 하는 devops에 더 도움이 되는 내용이라고 예상한다. 

4장에서는 <U>캐시와 CORS가 만났을 때</U> 어떤 에러가 발생할 수 있는지, 그 에러를 어떻게 해결할 수 있는지를 다뤘다. 









<br>

# 발표 영상

<iframe width="560" height="315" src="https://www.youtube.com/embed/YymWzWscd0E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<br>

<br>

이번에도 영상을 찍어 유튜브에 올렸다. 그냥 올리는 것 보다 깔끔하게 보이는 게 좋을 거 같아 썸네일을 적용했다. 썸네일은 개발자 컨퍼런스 썸네일을 참고해서 만들었다.
그리고 생각하면 생각할 수록 아이폰과 맥북을 쓸 때 key로 발표를 하는 게 참 좋다. 포인터 이런거 필요 없이 맥북의 프레젠테이션을 아이폰으로 컨트롤 할 수 있는 게 너무 퍈하다.


QnA 에서는 긴장해서인지, 마음이 급해서인지 자꾸 실수를 한다. <U>꼭! 질문을 소상히 끝까지 잘 듣고</U>, 바로 말하지 말고 머릿속에서 문장을 만들어서 말하자. 



<br>

<br>

# 발표 자료 


<iframe src="https://www.slideshare.net/slideshow/embed_code/key/1aEhu8VGCLcHCs?hostedIn=slideshare&page=upload" width="560" height="315" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

<br>

<br>

저번 세미나 자료는 스크린 샷을 찍는 형태로 블로그에 올렸는데 찾아보니 slideshare라는 플랫폼이 있어서 이번엔는 여기에 장표를 올렸다.
하나씩 찍어서 올릴 필요가 없어서 굉장히 편리하기 때문에 앞으로도 계속 이용할 예정이다.

CORS 발표를 하면서 깨달은 점은 <U>CORS는 서버가 아닌 브라우저를 위한 보안 정책이며,
그리고 CORS를 하는 이유도 도메인이 다른 서버에서 보낸 리소스를 브라우저가 못 믿기 때문이다.</U>

<br>

# 세미나 회고

### 잘한 점 
- [x] 자발적으로 세미나를 진행했다. 
- [x] 처음 듣는 참여자를 고려하여 발표를 구성했다. (기본 개념 -> 실전 -> 확장)
- [x] 문서로 떼우지 않고 발표 자료를 만들었다. 문서를 캡쳐해서 발표 자료를 만드니 깔끔해서 보기 좋았다.
- [x] BE, FE, 인프라 모두 관련있는 주제를 선정했다. 



### 부족한 점

- [ ] 대본을 따로 작성하지 않아서 거의 화면만 쳐다보고 있었다.
- [ ] QnA에서 마음이 급해서 제대로 듣지 못 했다. 
- [ ] 서있는 자세가 조금 건들거린 거 같다. 더 똑바로 서있자. 


<br>


[Django에서 ORM과 Redis로 동시성을 다루는 방법](https://leeleelee3264.github.io/post/2022-12-26-kasa-concurrency-seminar/) 세미나를 진행한지 벌써 8개월이 지났다. 저번 세미나는 회사에서 시켜서 했는데 이번에는 자발적인 준비이다 보니 
더 열심히 준비했다. 확인해보니 저번에는 자료가 거의 50장이었는데 이번에는 70장이었다. 세미나를 준비하면서 하는 공부도 정말 중요하지만, 세미나를 진행하면 자신감이 생긴다는 게 가장 큰 장점이라고 생각한다.  

<br>

앞으로 적어도 6개월에 한 번 씩은 세미나를 하도록 노력해야겠다. 무슨 세미나를 하면 좋을지 고민중인데 내가 공부가 필요한 부분인 `도커`나 `쿠버네티스`를 하면 좋을 거 같다. 
다만 이 둘은 실습 또는 데모로 보여주는 부분이 필요해서 핸즈온으로 진행하는 게 좋아보인다. 또 다른 건 테라폼을 사용해서 깃허브 Org를 구성해보기인데 이 또한 핸즈온이 적합해보인다.  



