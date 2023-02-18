+++
title = "[Infra] MySQL Study (4/5) - Join & Join Set"
date = "2021-07-14"
description = "MySQL join & join set에 대해서 알아본다: Inner join, left join, right join and full outer join."
tags = ["Infra"]
+++


<br>
<br> 

> MySQL join & join set에 대해서 알아본다: Inner join, left join, right join and full outer join.

<br> 


**Index**
1. [History of Join](#History_of_SQL_standard)
2. [Join Set](#Join_set)
3. [Reference](#Reference)

<br> 

##### 리뷰 후에 알게된 부분들
- 비등가 조인. 
  - Oracle에서는 지원을 하는데 Mysql이 지원을 하는지 모르겠다. 일반 조인이랑 비등가 조인 쿼리를 직접 짜서 결과를 보고 비교해야 할 것 같다 [[비등가 조인]](https://myjamong.tistory.com/174) 나중에 쿼리 추가하기.
- 테이블 조인 방식이 원래 for loop을 돌리는 건 알고있었지만 더 다양한 알고리즘이 있다. 
  - [[테이블 조인 알고리즘]](https://sparkdia.tistory.com/18)

    
<br> 
<br> 

# History of Join <a name="History_of_SQL_standard"></a>

### Join 
테이블과 테이블을 묶어서 보여주는 Join 커맨드는 관계를 핵심으로 하는 RDBMS에서는 빼놓을 수 없는 기능이다. 한 테이블에 모든 정보를 넣어놨다면 Join을 쓸 필요가 없겠지만 중복을 피하기 위해 정규화를 거치고 데이터 유지보수를 위해 테이블을 쪼개다보면 Join을 꼭 써야 한다. 서브 쿼리를 이용해서 조인을 흉내낼 수 있다고 하는데, 서브쿼리 특성상 쿼리가 더 어렵고 지저분해지지 않을까?

<br> 

> Join? Inner Join?  

*Join과 Inner Join은 동일한 기능인데, 쿼리를 읽을 때 더 명확한 느낌을 주기 위해 Inner Join이라고 쓴다고 한다. 동일하게 Left Join과 Left Outer Join, Right Join과 Right Outer Join은 동일한 기능이다.*

지금은 이렇게 필수가 되어버린 Join이 사실은 sql이 만들어졌을 때 부터 있던 기능은 아니라고 한다.

<br> 

### History of Join 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://leeleelee3264.github.io/static/img/post/sql_standard.png" >
<figcaption align = "center">[Picture 1] history of join</figcaption>

<br>

_[Picture 1]_ 에서 보는 것 처럼 Join은 1992년에 만들어진 SQL-92 standard 에서 만들어졌다. 92는 Join뿐만 아니라 DDL인 ALTER과 DROP도 포함이 되어있고, 학교에서 제일 많이 가르치고 실무에서도 제일 많이 사용되고 있다.

<br> 

#### Join이 없었을 때의 Join 방법 
이처럼 Join이 없을때도 Join을 흉내내는 방법은 있었는데 From에 여러 테이블을 써주면 된다. 

예를 들어 A와 B 테이블을 합치려고 할 때 From 에 A와 B를 써주면 두 테이블을 합칠 때 나올 수 있는 모든 경우의 수들이 다 나오고, ON에서 A.id = B.a_id 하는 것처럼 WHERE 조건에서 A.id = B.a_id를 하면 Inner Join을 한 것과 동일한 결과가 나온다.

<br> 

> from과 join 예시

{{< highlight sql  "linenos=true,hl_inline=false" >}}
# Multiple Table In From 
SELECT * 
FROM orders O, users U 
WHERE user_id = U.id

# Join 
SELECT * 
FROM orders O 
INNER JOIN users U ON O.user_id = U.id 

# 테이블 별칭을 사용했을 때 맨날 O.user_id, U.id 이런 식으로 모든 Column에 테이블 명시를 해줬는데 
# 알고보니 한 쪽 테이블에만 존재하는 Column이면 따로 명시를 안 해줘도 된다! 
# 그런데 하나하나 명시를 해주는 쪽이 쿼리를 한 눈에 파악하기 더 용이해보인다. 
{{< /highlight >}}


<br> 

Where 조건을 걸지 않아서 orders와 users를 합쳤을 때 나오는 모든 경우의 수가 다 나왔다. 이걸 Cross Join 또는 Cartesian Join이라고 한다.  Join연산은 항상 카티전 Join 과 동일하거나 작은 수의 결과를 리턴한다.

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://leeleelee3264.github.io/static/img/post/cross_join.png" >
<figcaption align = "center">[Picture 2] Cross Join</figcaption>


<br> 

> Cross Join 결과 


<details>
<summary> 더보기 </summary>

| id | user_id | cost | id | name | number | addr | active | 
| ---: | ---: | ---: | ---: | --- | --- | --- | --- | 
| 4 | 100 | 33 | 100 | Peter | 01012345678 | 대전광역시  | Y | 
| 4 | 100 | 33 | 200 | Lee | 01087654321 | 경기도 | N | 
| 4 | 100 | 33 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 
| 5 | 100 | 11 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 5 | 100 | 11 | 200 | Lee | 01087654321 | 경기도 | N | 
| 5 | 100 | 11 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 
| 6 | 200 | 2 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 6 | 200 | 2 | 200 | Lee | 01087654321 | 경기도 | N | 
| 6 | 200 | 2 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 
| 7 | 200 | 100 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 7 | 200 | 100 | 200 | Lee | 01087654321 | 경기도 | N | 
| 7 | 200 | 100 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 
| 8 | 100 | 20 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 8 | 100 | 20 | 200 | Lee | 01087654321 | 경기도 | N | 
| 8 | 100 | 20 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 
| 9 | 400 | 200 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 9 | 400 | 200 | 200 | Lee | 01087654321 | 경기도 | N | 
| 9 | 400 | 200 | 300 | Jamie | 403926999 | Calgary Alberta Canda | N |   

</details>

<br> 

> Where 조건을 건 Join과 동일한 결과 

| id | user_id | cost | id | name | number | addr | active | 
| ---: | ---: | ---: | ---: | --- | --- | --- | --- | 
| 4 | 100 | 33 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 5 | 100 | 11 | 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 6 | 200 | 2 | 200 | Lee | 01087654321 | 경기도 | N | 
| 7 | 200 | 100 | 200 | Lee | 01087654321 | 경기도 | N | 
| 8 | 100 | 20 | 100 | Peter | 01012345678 | 대전광역시 | Y | 

<br> 
<br>

#### 그럼 Join을 안 써도 되나?

사실 Join과 Multiple Table In From의 퍼포먼스는 동일하다. 하지만 요즘은 모두가 Join을 쓰는 추세이고, Join을 사용해서 기본적으로 피해지는 오류들이 있으니 가능하면 Join을 사용하도록 하자. 


##### Join의 장점 1
_Join은 테이블을 합치기 위해서 사용하는 조건과 값을 뽑아내기 위한 조건을 분리할 수 있다._

Join의 테이블 결합 조건은 ON에 들어가기 때문에 WHERE에는 정말 값을 뽑아내기 위한 조건만 써주면 되기 때문에 복잡한 WHERE 조건이 들어간다고 해도 헷갈리지 않는다.

<br>

> 여러 값을 뽑는 예시 

{{< highlight sql  "linenos=true,hl_inline=false" >}}
# 2021-07-13의 데이터를 뽑아낸다고 가정 

#Join 
SELECT * 
FROM orders O 
INNER JOIN users U ON O.user_id = U.id 
WHERE O.sold_date = '2021-07-13'

# Multiple Table In From 
SELECT * 
FROM orders O, users U 
WHERE O.user_id = U.id AND O.sold_date = '2021-07-13' 
{{< /highlight >}}


<br> 


##### Join의 장점 2
_여러개의 테이블을 합칠 때 Join이 훨씬 용이하고, Multiple Table In From은 재앙이 된다._

<br>

> 여러 개의 테이블 합치는 예시 

{{< highlight sql  "linenos=true,hl_inline=false" >}}
# Join 
SELECT * 
FROM orders O 
INNER JOIN users U ON O.user_id = U.id 
INNER JOIN point P ON O.id = P.order_id

# Multiple Table In From 
# 테이블이 합쳐질때마다 무거워지는 WHERE 조건 
SELECT * 
FROM orders O, users U , point P
WHERE O.user_id = U.id AND O.id = P.order_id
{{< /highlight >}}


<br> 

##### Join의 장점 3, 4
- Left Join, Right Join, Full Outer Join의 지원으로 내가 원하는 형태로 테이블을 합치기가 더 좋다. 
  - 기본 Join과 마찬가지로 Multiple Table In From 를 사용해서는 원하는 결과를 뽑아내기 힘들거나, 더 복잡한 쿼리를 짜야 한다.
- Join을 사용하면 자연스럽게 Cross Join 문제를 피할 수 있다. 


<br> 

# Join Set <a name="Join_Set"></a>

위에서 말한 것 처럼 Join은 여러가지 결합 형태를 지원하기 때문에 상황에 맞춰 테이블들을 조합해서 집합을 만들어 낼 수 있다. 검색을 해보니 정말 다양한 집합을 만들 수 있었는데 실무를 하면서 평소에 쓸 일이 제일 많았던 Join 형태 4개를 골라서 정리했다.

<br> 

> 예시로 사용할 데이터

##### users (사용자)

| id | name | number | addr | active | 
| ---: | --- | --- | --- | --- | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 
| 200 | Lee | 01087654321 | 경기도  | N | 
| 300 | Jamie | 403926999 | Calgary Alberta Canda | N | 


##### orders (주문)

| id | user_id | cost | 
| ---: | ---: | ---: | 
| 4 | 100 | 33 | 
| 5 | 100 | 11 | 
| 6 | 200 | 2 | 
| 7 | 200 | 100 | 
| 8 | 100 | 20 | 
| 9 | 400 | 200 | 

<br> 

위의 예시 데이터로 _[Picture 3]_ 의 Join set을 다뤄보도록 하겠다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://leeleelee3264.github.io/static/img/post/join_set.PNG" >
<figcaption align = "center">[Picture 3] Join Set</figcaption>

<br> 



### Inner Join 

_Join중에서 제일 많이 쓰는 기본형 JOIN._ 

두 테이블에서 공통적으로 가지고 있는 데이터를 꺼내올 때 사용한다. table1 을 기준으로 table2에 있는 값이라고 해도 table1에 없으면 값이 누락된다. 이런때는 공통분모만 뽑아오는 Inner join이 아니라 커버 해주는 범위가 넓은 다른 JOIN 연산들을 써야 한다.

<br> 

### Left Join

_왼쪽 테이블을 기준으로 데이터를 합치는 JOIN._ 

Join 연산에서 기준이 되는 테이블이 table1이다 보니까 쿼리를 짤 때도 데이터를 뽑아오는 중심이 되는 테이블을 table1 자리에 두는 것 같다. 그러다보니 table2의 데이터 존재 여부와 상관없이 일단 table1에 있는 데이터는 다 뽑아오는 Left Join을 Right Join 보다 많이 사용한다.

<br>

> Left Join 예시 

{{< highlight sql  "linenos=true,hl_inline=false" >}}
SELECT * 
FROM users  u
LEFT JOIN orders o ON u.id = o.user_id;
{{< /highlight >}}


<br> 

> Left Join 결과 

| id | name | number | addr | active | id | user_id | cost | 
| ---: | --- | --- | --- | --- | ---: | ---: | ---: | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 4 | 100 | 33 | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 5 | 100 | 11 | 
| 200 | Lee | 01087654321 | 경기도 | N | 6 | 200 | 2 | 
| 200 | Lee | 01087654321 | 경기도 | N | 7 | 200 | 100 | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 8 | 100 | 20 | 
| 300 | Jamie | 403926999 | Calgary Alberta Canda | N | \0 | \0 | \0 | 

Order에 300번 손님이 주문한 데이터가 없다고 해도 table1로 users 을 설정했기 때문에 결과에서도 300번을 보여준다.

<br>

### Right Join

_오른쪽 테이블을 기준으로 데이터를 합치는 JOIN._

Left Join이 있는데 Right Join이 왜 필요할까? Left Join 하나만 있고 테이블 위치만 그때그때 바꿔주면 안되나 하는 의심이 있었다. 검색을 해보니 나랑 똑같은 생각을 한 사람이 있었는데 거기에 달린 답변을 보니 테이블 2개를 사용할 경우에는 테이블 순서를 바꿔가면서 Join연산을 하면 되는데 여러개의 테이블을 사용하면 그럴 수 없었다.

<br>

> Right Join 예시

{{< highlight sql  "linenos=true,hl_inline=false" >}}
SELECT * 
FROM users  u
RIGHT JOIN orders o ON u.id = o.user_id;
{{< /highlight >}}


<br> 

> Right Join 결과 

| id | name | number | addr | active | id | user_id | cost | 
| ---: | --- | --- | --- | --- | ---: | ---: | ---: | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 4 | 100 | 33 | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 5 | 100 | 11 | 
| 200 | Lee | 01087654321 | 경기도 | N | 6 | 200 | 2 | 
| 200 | Lee | 01087654321 | 경기도 | N | 7 | 200 | 100 | 
| 100 | Peter | 01012345678 | 대전광역시 | Y | 8 | 100 | 20 | 
| \0 | \0 | \0 | \0 | \0 | 9 | 400 | 200 | 

Left Join을 했을때와는 다르게, users에서만 존재하던 300번 유저에 대한 정보는 사라졌고 orders에만 존재하는 400번 유저에 대한 구매 내역이 나왔다.

<br>

### Full Outer Join

_Full Outer Join = 1 Time of Inner Join + Left Join + Right Join_

합집함을 위한 Join이다. 테이블 1과 테이블 2를 합칠 때 생기는 중복을 처리하고 돌려준 값이라고 생각하면 된다. 아쉽게도 Mysql 에서는 Full Outer Join을 지원하지 않는데 Left Join과 Right Join을 사용해서 똑같은 결과를 만들어낼 수 있다.

<br>

> MySQL Full Outer Join 예시 

{{< highlight sql  "linenos=true,hl_inline=false" >}}
SELECT * 
FROM users U
LEFT JOIN orders O ON U.id = O.user_id 

UNION
 
SELECT * 
FROM users U 
RIGHT JOIN orders O ON U.id = O.user_id
{{< /highlight >}}


<br> 

> MySQL Full Outer Join 결과 

| id | name | number | addr | active | id | user_id | cost | 
| ---: | --- | --- | --- | --- | ---: | ---: | ---: | 
| 100 | Peter | 01012345678 | 대전광역시  | Y | 4 | 100 | 33 | 
| 100 | Peter | 01012345678 | 대전광역시  | Y | 5 | 100 | 11 | 
| 200 | Lee | 01087654321 | 경기도  | N | 6 | 200 | 2 | 
| 200 | Lee | 01087654321 | 경기도  | N | 7 | 200 | 100 | 
| 100 | Peter | 01012345678 | 대전광역시  | Y | 8 | 100 | 20 | 
| 300 | Jamie | 403926999 | Calgary Alberta Canda | N | \0 | \0 | \0 | 
| \0 | \0 | \0 | \0 | \0 | 9 | 400 | 200 | 

<br>

재미있는 점은 Left Join과 Right Join을 했을 때 각각 Inner Join을 한 것 과 같은 `교집합` 값이 생기는데 `UNION`을 해서 중복을 제거했다는 점이다!  만약 `UNION ALL`을 사용했으면 중복이 그대로 포함된다.

<br> 

# Reference <a name="Reference"></a>

- [[Difference Between Join and Inner Join]](https://stackoverflow.com/questions/565620/difference-between-join-and-inner-join)
- [[The History of SQL Standards]](https://learnsql.com/blog/history-of-sql-standards/)
- [[What's the Difference Between Having Multiple Tables in FROM and Using JOIN?]](https://learnsql.com/blog/joins-vs-multiple-tables-in-from/)
- [[Why do we have Left Join and Right Join in SQL, if we can use Left Join to get same result as of Right Join by just changing the position of tables?]](https://www.quora.com/Why-do-we-have-Left-Join-and-Right-Join-in-SQL-if-we-can-use-Left-Join-to-get-same-result-as-of-Right-Join-by-just-changing-the-position-of-tables)
