+++
title = "Seminar by LeeLee - Handling Concurrent Request in Django"
date = "2022-12-24"
description = "2022-11-30 사내에서 진행한 세미나 - Handling Concurrent Request in Django를 다룬다."
tags = ["Project"]
+++


<br>
<br> 

> 2022-11-30 사내에서 진행한 세미나 - Handling Concurrent Request in Django를 다룬다.

<br> 

**Index**
1. Intro: 네? 저보고 세미나를 진행하라구요? 
2. 세미나 - Handling Concurrent Request in Django
3. 세미나 회고
4. 참고 자료 

<br> 

# Intro: 네? 저보고 세미나를 진행하라구요? 

TODO: 세미나 진행하기 까지의 여정   
TODO: 세미나 주제 선정 과정   
TODO: 세미나 어나운스 캡쳐   



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
TODO: PPT의 흐름을 따라가서 설명을 진행하자. 자세한 설명을 할 필요는 없다. (PPT 부가적 설명만)

<br> 

# 세미나 회고 

처음에 CTO님이 세미나를 준비하라고 하셨을 때는 많이 당황스러웠다. 부끄럽지만 퇴근 하고 발표 자료를 준비할 때는 정말 하기 싫어서 미룬 적도 많았다. 
하지만 하기 싫은 마음을 추스려 발표를 준비하고, 발표를 마치고 나니 오히려 배운 점이 많았던 것 같다. 

놀라운 사실은 내가 발표하는 걸 싫어하지 않는다는 점 이었다! 먼 미래에는 외부의 큰 세미나에서 발표를 할 기회가 왔으면 좋겠다. 



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

