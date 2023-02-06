+++
title = "[Backend] Handling concurrency in Django"
date = "2022-12-26"
description = "Seminar for handling concurrent request in Django in Kasa 2022-11-30."
tags = ["Project"]
+++


<br>
<br> 

> Seminar for handling concurrent request in Django in Kasa 2022-11-30.

<br> 

**Index**
1. Intro: 네? 저보고 세미나를 진행하라구요? 
2. 세미나 - Handling Concurrent Request in Django
3. 세미나 회고
4. 참고 자료 

<br> 

# Intro: 네? 저보고 세미나를 진행하라구요? 



얼마 전부터 회사에서 주니어들이 돌아가면서 세미나를 진행하고 있었다. 내 차례가 올 것이라 의심조차 하지 않고 즐거운 마음으로 세미나를 참석하기를 여러 번, 결국 CTO님께 다음 세미나 발표자는 나라는 슬랙을 받았다.
그렇게 나는 20명 정도 되는 사내 엔지니어들 앞에서 세미나를 진행하게 되었다. 


<br> 


### 주제 선정

주제를 선정할 때는 <u>내가 실무를 하면서 마주했던 경험</u>일 것과 <u>백엔드 개발자가 General하게 마주할 수 있는 경험</u>일 것을 중심으로 고려했다. 이렇게 추려보니 총 5개 정도의 후보가 나왔다. 

<br> 

> 후보 

1. API에 동시 요청이 왔을 경우 처리 방법   
2. Kasa Singapore에서 청약이 종료되고, 안분비례를 이용하여 DABS를 분배/발행/상장 하는 과정 
3. PKI와 Digital Certificate 
4. Oauth Client 만들기 with Singpass 
5. 데이터 마이그레이션 

<br> 

모두 다 좋은 주제였지만 가장 최근에 만난 문제가 `API에 동시 요청이 왔을 경우 처리 방법` 이고, 다른 발표 주제들은 조금 더 구체적인 만큼 백엔드에 General하지 못한 거 같아 1번을 주제로 디벨롭 하기로 했다. 
주제를 어나운스 하기 위해 멋진 타이틀을 만들었어야 했는데 결국 고심 끝에 `Handling Concurrent Request in Django`로 결정했다. in Django 인 이유는 회사에서 쓰고 있는 백엔드 프레임워크가 Django이기 때문이다. 



<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/anno.png" >
<figcaption align = "center">[Picture 1] 슬랙 어나운스</figcaption>

<br> 


### 발표 흐름

주제 선정 후, 어떻게 자연스러우면서 일관성이 있는 발표를 할 수 있을까 고민을 하다가 아래의 흐름과 같이 발표를 진행하기로 했다.

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/order.png" >
<figcaption align = "center">[Picture 2] 발표 순서</figcaption>


<br>

관련 자료를 수집하면서 주제 선정과 발표 흐름을 정하는 게 시간이 오래 걸렸는데 앞의 두 개가 정해지니 준비에 속도가 붙어 발표 자료를 만드는 것과 대본 작성은 비교적 빠른 시간 안에 끝낼 수 있었다. 앞으로는 실제로 어떤 내용으로, 어떻게 발표를 했는지 다뤄보겠다. 

<br> 

# 세미나 - Handling Concurrent Request in Django 

### 발표 영상 
<iframe width="560" height="315" src="https://www.youtube.com/embed/OpgttdqX1N8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<br> 
<br> 


세미나에 참석한 동료분이 감사하게도 발표 영상을 찍어주셨다. 발표 중에는 앞을 보려고 엄청 많이 노력을 했다고 생각했는데, 막상 영상을 보니 
생각보다 앞을 보는 시간이 짧았다. 아마도 긴장을 해서 대본을 까먹을지도 모른다는 마음에 나도 모르게 PPT 화면을 더 많이 본 거 같다.

테크 회사에서 외부의 큰 세미나를 주최할 때 발표자들의 세션 영상이 올라오는 걸 봤었는데, 큰 세미나는 아니지만 나도 발표자로 참석한 세션 영상이 
생겨 낯설기도 하면서 뿌듯하다. 

<br> 


### Handling Concurrent Request in Django 

발표 떄 한 말들을 상세하게 블로그에 정리할까 싶었지만, 이미 PPT에 많은 말을 써두었기 때문에 블로그에는 PPT를 올리고, 간략하게 몇 가지 코멘트를 추가하기만 하겠다.

#### 목차 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_2.png" >
<figcaption align = "center">[Picture 3] 목차</figcaption>

<br> 


#### 서론 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_4.png" >
<figcaption align = "center">[Picture 4] Concurrent Request란?</figcaption>


<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_5.png" >
<figcaption align = "center">[Picture 5] Race Condition</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_6.png" >
<figcaption align = "center">[Picture 6] Race Condition 예시</figcaption>


<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_7.png" >
<figcaption align = "center">[Picture 7] 내가 만난 이슈</figcaption>



<br> 

#### API 요청을 Serialize 하는 방법 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_9.png" >
<figcaption align = "center">[Picture 8] 이번 장에서 다룰 것들</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_10.png" >
<figcaption align = "center">[Picture 9] 하나의 큐에 모아서 처리</figcaption>

<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_11.png" >
<figcaption align = "center">[Picture 10] 지금 API 환경</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_12.png" >
<figcaption align = "center">[Picture 11] Transaction이란?</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_13.png" >
<figcaption align = "center">[Picture 12] DB lock approach</figcaption>

<br> 


#### Django Transaction Atomicity 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_15.png" >
<figcaption align = "center">[Picture 13] Django ORM</figcaption>

<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_16.png" >
<figcaption align = "center">[Picture 14] DB lock</figcaption>

<br>

##### Deal Finalize 오류 해결 방법 with select_for_update

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_18.png" >
<figcaption align = "center">[Picture 15] 기존 코드</figcaption>

<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_20.png" >
<figcaption align = "center">[Picture 16] select_for_update 1차 시도</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_21.png" >
<figcaption align = "center">[Picture 17] select_for_update 2차 시도</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_22.png" >
<figcaption align = "center">[Picture 18] select_for_update 3차 시도: 성공</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_23.png" >
<figcaption align = "center">[Picture 19] select_for_update 주의점: dead lock</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_24.png" >
<figcaption align = "center">[Picture 20] select_for_update 주의점: lazy loading</figcaption>

<br>

##### Deal Finalize 오류 해결 방법 with Compare-and-swaps

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_26.png" >
<figcaption align = "center">[Picture 21] Compare-and-swaps</figcaption>

<br>


##### 청약 최대 갯수 검증 오동작 오류 해결 방법 with select_for_update

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_28.png" >
<figcaption align = "center">[Picture 22] 이력 관리 구조</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_29.png" >
<figcaption align = "center">[Picture 23] DB lock 없이 Exception Rasing으로 해결</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_31.png" >
<figcaption align = "center">[Picture 24] 이력 관리 구조에서 select_for_update 쓰기 위한 선 작업</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_32.png" >
<figcaption align = "center">[Picture 25] select_for_update</figcaption>

<br>


##### 청약 최대 갯수 검증 오동작 오류 해결 방법 with redis lock

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_34.png" >
<figcaption align = "center">[Picture 26] redis lock</figcaption>

<br>


#### Django Transaction Test & Durability 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_36.png" >
<figcaption align = "center">[Picture 27] Django Transaction Test</figcaption>

<br>

##### Django Durability 

Atomicity를 다루다가 Durability 를 언급하여 주제가 조금 튀면 어쩌지 고민을 했지만, 이번 발표를 준비하면서 Durability 도 비즈니스 로직에서 충분히 쓸 여지가 많아보여 추가했다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_37.png" >
<figcaption align = "center">[Picture 28] ACID</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_38.png" >
<figcaption align = "center">[Picture 29] Transaction 단위를 잘 묶었을 경우</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_39.png" >
<figcaption align = "center">[Picture 30] Transaction 단위를 잘못 묶었을 경우</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_40.png" >
<figcaption align = "center">[Picture 31] Django Durability를 사용해서 해결</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_41.png" >
<figcaption align = "center">[Picture 32] 3.2 미만에서는 어떻게 하나...?</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_42.png" >
<figcaption align = "center">[Picture 33] Transaction 단위 잘못 묶는 것을 방지하는 방법</figcaption>

<br>

#### 결론 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_44.png" >
<figcaption align = "center">[Picture 34] 장고의 고수</figcaption>

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/seminar/ppt/s_45.png" >
<figcaption align = "center">[Picture 35] 결론</figcaption>

<br>




#### Q&A
결국 Handling Concurrent Request in Django는 3가지 방법이 있음을 발표 중에 다뤘다. 

1) Message Queue를 사용하기 
2) Exception Rasing 해서 Rollback 하기
3) DB lock 사용하기 

질문이 들어왔던 부분은 1번이었다. 발표에서는 지금의 멀티 파드 구조에서 하나의 큐를 사용하면 멀티 파드의 이점을 살릴 수 없어서 선택하지 않았다고 말씀드렸으나, 사실은 아직 
카프카 등의 메세지 큐에 대해 자세히 알지 못한 부분도 있었기에 바로 질문이 들어왔던 거 같다. <u>앞으로 메세지 큐에 대해서 공부를 해야 함을 느꼈다.</u> 

또 Exception Rasing Rollback과 DB lock 사용에서 어떤 것을 선택하는 것이 더 이점인지에 대해 질문이 들어왔다. 실제로 문제를 해결한 방안은 Exception Rasing Rollback
방식이라고 답변을 드렸었는데 <u>정확히 언제 Exception Rasing Rollback을 사용하고, 언제 DB lock을 사용하는 게 이점인지 뚜렷하게 알았다면 더 좋은 답변을 드렸을 거 같다.</u> 

<br> 


# 세미나 회고 

처음에 CTO님이 세미나를 준비하라고 하셨을 때는 많이 당황스러웠다. 부끄럽지만 퇴근 하고 발표 자료를 준비할 때는 정말 하기 싫어서 미룬 적도 많았다. 
하지만 하기 싫은 마음을 추스려 발표를 준비하고, 발표를 마치고 나니 오히려 배운 점이 많았던 것 같다. 



### 잘한 점 

- [x] 발표 순서를 선정할 때 흐름이 자연스러울 수 있도록 단계적으로 배치를 했다.
- [x] 중간에 집중력이 흐트러 지는 것을 방지하기 위해 앞으로 다룰 내용을 정리하는 페이지들을 넣었다. 
- [x] 주제를 선정할 때, 내가 경험했던 문제를 선택했다. 자연스럽게 다른 사람들의 해결 방법을 들을 수 있었다.
- [x] 애플의 Keynote 기능을 사용해 맥북과 아이패드를 연결해 스크린을 조작했다. 때문에 흐름이 끊기지 않게 스크린을 조작했다. 


### 부족한 점 

이번 발표에서 부족하다 생각하는 부분을 추려봤다. 처음으로 진행하는 세미나에, 20명 정도 되는 엔지니어들이 참석한다고 하니 긴장을 많이 했는데
<u>긴장한 것에 비해서 준비를 조금 모자라게 한 것 같아 아쉬운 마음이 많이 든다</u>. 다음 번에 더 잘하자!

- [ ] PPT 화면이 아니라 앞을 보도록 의식적으로 노력하자. 
- [ ] 대본을 2일 정도 전에 작성해서, 숙지하는 시간을 더 가지도록 하자.
- [ ] Q&A에서 당황하지 말자. 질문이 들어올 부분을 미리 예상해 준비하자.
- [ ] <u>발표 내용에서 내가 확신이 없는 부분은 없어야 한다</u>, 충분히 준비했다고 만족하지 말고 거듭 준비하자! 




<br> 

# 참고 자료 


### Main 자료 
- [[Django 공식 문서 - Database transactions]](https://docs.djangoproject.com/en/4.1/topics/db/transactions/)
- [[The trouble with transaction.atomic]](https://seddonym.me/2020/11/19/trouble-atomic/)
- [[PYCON UK 2017: Handling Database Concurrency With Django]](https://www.youtube.com/watch?v=5g9fwYcF3r8&ab_channel=PyConUK)
- [[How I Learned to Stop Worrying and Love atomic Banking Blunders and Concurrency Challenges]](https://www.youtube.com/watch?v=VJSznZMvA1M&ab_channel=PyGotham2018)


<br> 

### Sub 자료
- [[Difference Between Pessimistic Approach and Optimistic Approach in DBMS]](https://www.geeksforgeeks.org/difference-between-pessimistic-approach-and-optimistic-approach-in-dbms/)
- [[MySQL 공식 문서 - Transaction Levels]](https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html)
- [[Handling Race Conditions with the Django ORM]](https://www.maurizi.org/django-orm-race-conditions/)
- [[레디스와 분산 락(1/2) - 레디스를 활용한 분산 락과 안전하고 빠른 락의 구현]](https://hyperconnect.github.io/2019/11/15/redis-distributed-lock-1.html)

