+++
title = "[Effective Python] Betterway 6 to 10 Summary"
date = "2022-10-19"
description = "책 [Effective Python] Chapter 1 중 better way 6장부터 10장까지 요약한다."
tags = ["Book"]
+++



<br>
<br> 

> 책 [Effective Python] betterway를 6장부터 10장까지 요약한다.

<br> 

**Index**
1. Better way 6 인덱스를 사용하는 대신 대입을 사용해 데이터를 언패킹하라
2. Better way 7 range보다는 enumerate를 사용하라
3. Better way 8 여러 이터레이터에 대해 나란히 루프를 수행하려면 zip을 사용하라
4. Better way 9 for나 while 루프 뒤에 else 블록을 사용하지 말라 
5. Better way 10 대입식을 사용해 반복을 피하라

<br> 

# Better way 6 인덱스를 사용하는 대신 대입을 사용해 데이터를 언패킹하라
파이썬에서는 _언패킹_ 구문이 있다. 언패킹 구문을 사용하면 한 문장 안에서 여러 값을 대입할 수 있다. 교재에서는 
튜플을 사용할 때 인덱스 말고 언패킹을 사용하는 예제를 보여주고 있다. 언패킹은 튜플 인덱스를 사용하는 것보다 시각적인 잡음이 적다. 

<br> 

> Tuple 언패킹 예시

{{< highlight python  "linenos=true,hl_inline=false" >}}
item = ('호박', '식혜')
first, second = item 
print(first, '&', second)

>>> 호박 & 식혜 
{{< /highlight >}}

<br> 

> 언패킹을 이용해서 임시변수 없이 값 맞 바꾸기 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def bubble_sort(a): 
    for _ in range(len(a)):
        for i in range(1, len(a)):
            if a[i] < a[i-1]:
                a[i-1], a[i] = a[i], a[i-1] # 맞바꾸기
{{< /highlight >}}


#### 작동원리
1. 대입문의 오른쪽 a[i], a[i=1]이 계산된다. 
2. 그 결과값이 이름없는 새로운 tuple에 저장된다. 
3. 대입문의 왼쪽에 있는 언패킹 a[i-1], a[i]를 통해 이름없는 tuple에 있는 값이 a[i-1], a[i]에 저장된다. 
4. 이름없는 tuple이 사라진다.


<br> 

> for 루프와 같은 컴프리헨션, 제너레이터의 리스트 원소를 언패킹하는 방법 

{{< highlight python  "linenos=true,hl_inline=false" >}}
snacks = [('베이컨', 350), ('도넛', 240), ('머핀', 190)]

for name, calories in snacks: 
    print(f'{name}은 {calories} 입니다.')
{{< /highlight >}}


<br> 

# Better way 7 range보다는 enumerate를 사용하라
리스트를 이터레이션하면서 리스트의 몇 번째 원소를 처리 중인지 알아야 할 때가 있다.
`range`를 사용하면 list의 길이를 알아야 하고, 인덱스를 사용해 배열 원소에 접근해야 한다. 단계가 여러개라 결국 코드가 투박해진다. 

<br>

> range

{{< highlight python  "linenos=true,hl_inline=false" >}}
for i in range(len(flavor_list)): 
    flavor = flavor_list[i]
    print(f'{i}: {flavor})
{{< /highlight >}}

<br>



`enumerate`는 이터레이터를 제너레이터로 감싼다. 그리고 호출이 될 때 마다 루프 인덱스와 이터레이터의 다음 값으로 이뤄진 튜플 쌍을 리턴한다.
튜플 형태로 넘겨주니 _Better way 6처럼 언패킹을 이용하기도 좋다._

<br> 

> enumerate

{{< highlight python  "linenos=true,hl_inline=false" >}}
for i, flavor in enumerate(flavor_list):
    print(f'{i}: {flavor})
{{< /highlight >}}



<br> 

> enumarate에서 시작할 루프 인덱스 설정해주기

{{< highlight python  "linenos=true,hl_inline=false" >}}
for i, flavor in enumerate(flavor_list, 100):
print(f'{i}: {flavor})

>>> 
100: 바나나
101: 딸기
{{< /highlight >}}

<br>

# Better way 8 여러 이터레이터에 대해 나란히 루프를 수행하려면 zip을 사용하라

> enumarate를 사용하여 나란히 루프를 수행 

{{< highlight python  "linenos=true,hl_inline=false" >}}
for i, name in enumerate(names):
    count = counts[i]
    if count > max_count:
        longest_name = name 
        max_count = count 
{{< /highlight >}}

<br> 


> zip을 사용하여 나란히 루프를 수행 

{{< highlight python  "linenos=true,hl_inline=false" >}}
for name, count in zip(names, counts):
    if count > max_count: 
        longest_name = name 
        max_count = count 
{{< /highlight >}}

<br> 

두 리스트를 동시에 이터레이션 할 경우 내장함수 `zip`을 사용하면 훨씬 더 깔끔하다. 

#### 내장함수 zip 
- zip은 둘 이상의 이터레이터를 제너레이터를 사용해 묶어준다.
- zip 제너레이터는 각 이터레이터의 다음 값이 들어있는 `튜플`을 반환한다.
- zip은 자신이 감싼 이터레이터 원소를 하나씩 소비하기 때문에 메모리를 다 소모해서 프로그램이 중단되는 위험 없이 아주 긴 입력도 처리할 수 있다. 

<br> 

### 여러 이터레이터의 길이가 같지 않을 경우 

> 길이가 같지 않은 리스트를 zip을 사용하여 나란히 루프를 수행

{{< highlight python  "linenos=true,hl_inline=false" >}}
name = ['Cecilia', '남궁민수', '김민철', 'Rosalind']
counts = [7, 4, 3]

for name, count in zip(names, counts): 
    print(name)

>>> 
Cecilia 
남궁민수
김민철 
{{< /highlight >}}

<br> 

_zip은 자신이 감싼 이터레이터 중 어느 하나가 끝날때까지 튜플을 내놓는다_. 따라서 출력은 가장 짧은 입력의 길이와 같다.
리스트들의 길이가 같지 않을 것으로 예상한다면 `itertools` 내장모듈에 들어있는 `zip_longest` 를 사용하자.

<br> 

> 길이가 같지 않은 리스트를 zip_longest를 사용하여 나란히 루프를 수행

{{< highlight python  "linenos=true,hl_inline=false" >}}
import itertools 

for name, count in itertools.zip_longest(names, counts, fillvalue=-100): 
    print(f'{name}: {count}')

>>> 
Cecilia: 7 
남궁민수: 4 
김민철: 3 
Rosalind: -100
{{< /highlight >}}

<br> 

zip_longest를 사용했을 때 존재하지 않은 값은 `fillvalue` 를 통해 값을 설정해 줄 수 있다. 디폴트 값은 `None`이다. 

<br> 

# Better way 9 for나 while 루프 뒤에 else 블록을 사용하지 말라 

파이썬에서는 루프가 반복 수행하는 내부 블록 바로 다음에 else 블록을 추가할 수 있다. 이 `else` 블록은 루프가 `break`를 통해 빠져나가지 않고 끝까지 루프를 했다면 실행이 된다.

<br>

> 서로소 구하기: 루프 뒤에 else를 사용

{{< highlight python  "linenos=true,hl_inline=false" >}}
a = 4
b = 9

for i range(2, min(a, b) + 1):
    print('검사중', i)
    if a % i == 0 and b % i == 0:
    print('서로소 아님')
    break
else:
    print('서로소')

>>> 
검사 중 2 
검사 중 3 
검사 중 4 
서로소 
{{< /highlight >}}

<br> 

if/else문에서 else는 _이 블록 앞의 블록이 실행되지 않으면 이 블록을 싱행하라_ 인데 
루프 뒤애 오는 else는 루프가 정상적으로 완료되었다면 실행되기 때문에 마치 `and`와 같은 역할을 하고 있다. _이름과 역할이 달라 직관적이지 못하다._ 

<br> 

> 루프가 한 번도 돌지 않아도 실행되는 else 

{{< highlight python  "linenos=true,hl_inline=false" >}}
for x in []: 
    print('이 줄은 실행되지 않음')
else: 
    print('For Else block!')

>>> 
For Else block! 


while False:
    print('이 줄은 실행되지 않음')
else: 
    print('While Else block!')

>>> 
While Else block! 
{{< /highlight >}}

<br> 

또한 빈 시퀸스나 while 루프 조건이 처음부터 False인 경우에도 else 블록이 실행된다. 빈 시퀸스이거나 while 조건이 처음부터 False이면 _루프가 단 한 번도 실행되지 못하는데 말이다._

<br>

#### 서로소 구하기 리팩토링 
루프 뒤 else를 사용해서 만든 서로소 구하기는 직관적이지 못해 더 직관적이게 도우미 함수를 작성하여 서로소를 구해본다. 

<br> 

> 서로소 구하기: 원하는 조건을 찾자마자 함수를 반환 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def coprime(a, b): 
    for i in range(2, min(a, b) + 1): 
        if a % i == 0 and b % i == 0: 
            return False 
    return True 

assert coprime(4, 9)
assert not coprime(3, 6)
{{< /highlight >}}


<br> 


> 서로소 구하기: 원하는 대상을 찾았는지 나타내는 결과 변수를 도입 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def coprime_alternate(a, b): 
    is_copirme = True 
    for i in range(2, min(a, b) + 1): 
        if a % i == 0 and b % i == 0: 
            is_coprime = False 
            break 
    
    return is_coprime
{{< /highlight >}}


<br> 

#### 절대로 루프 뒤에 else 블록을 사용하지 말아야 하는 이유 
- else 블록을 사용함으로써 얻을 수 있는 `표현력`보다는 미래에 이 코드를 이해하려는 사람들이 느끼게 될 `부담감`이 더 크다. 
- 파이썬에서 루프와 같은 간단한 구성 요소는 그 자체로 `의미`가 `명확`해야 한다.

<br> 

# Better way 10 대입식을 사용해 반복을 피하라

`대입식`은 파이썬 언어에서 고질적인 코드 중복 문제를 해결하기 위해 파이썬 3.8에서 새롭게 도입된 구문으로 `왈러스 연산자` (walrus) 라고도 부른다.
연산자 기호 `:=` 이 마치 바다코끼리 (walrus)의 눈과 엄니를 닮아서 이런 별명이 생겼다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://upload.wikimedia.org/wikipedia/commons/2/22/Pacific_Walrus_-_Bull_%288247646168%29.jpg" >
<figcaption align = "center">[Picture 1] 바다코끼리</figcaption>

<br> 

왈러스 연산자의 장점은 값을 대입할 수 없어 대입문이 쓰일 수 없는 if 조건문 과 같은 위치에 사용할 수 있다는 것이다. _즉, 원래라면 값을 대입할 수 없는 자리에 왈러스 연산자를 씀으로 값을 대입할 수 있다_.

<br> 

> 왈러스 연산자가 하는 일

- Step 1: 대입 
- Step 2: 대입된 값을 평가

<br> 

> 월러스 연산자 

{{< highlight python  "linenos=true,hl_inline=false" >}}
# 대입문 
a = b 

# 왈러스 연산자 
a := b
{{< /highlight >}}

<br> 



### 왈러스 연산자 용법

<br> 

> 왈러스 연산자를 쓰지 않았을 때

{{< highlight python  "linenos=true,hl_inline=false" >}}
fresh_fruit = {
    '사과': 10, 
    '바나나': 8, 
    '레몬': 5, 
}

def make_lemonade(count): 
    ... 

def out_of_stock(): 
    ... 

count = fresh_fruit.get('레몬', 0)
if count: 
    make_lemonade(count)
else: 
    out_of_stock()
{{< /highlight >}}

<br> 

`count` 변수는 if 문의 첫 번째 블록 안에서만 쓰인다. 하지만 if 앞에서 count를 정의하면서 마치 else 블록이나 그 이후의 코드에서 count 변수에 접근을 할 필요가 있어 보인다. _따라서 실제보다 count 변수가 중요해보인다._  

파이썬에서는 이런 식으로 값을 가져와서 그 값이 0이 아닌지 검사한 후 사용하는 패턴이 많다. 왈러스 연산자를 사용해서 가독성을 높이도록 하자. 

<br> 

> 왈러스 연산자를 썼을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
if count := fresh_fruit.get('레몬', 0): 
    make_lemonade(count)
else: 
    out_of_stock()
{{< /highlight >}}

<br> 

`count`가 if문의 첫 번째 블록에서만 의미가 있다는 점이 명확하게 보여 코드가 더 읽기 쉬워졌다. 덩달아 코드도 조금 더 짧아졌다. 
 
<br> 

#### 왈러스 연산자를 이용해 더 중요한 변수에 힘 주기 
이 패턴은 더 중요한 변수에 힘을 주기에도 좋지만, _if condition에서 값을 비교하고, 해당 스코프 안에서 그 값을 함수 호출할 때 사용했다는 것을 기억하자._ 

<br> 

> 왈러스 연산자를 쓰지 않았을 때

{{< highlight python  "linenos=true,hl_inline=false" >}}
pieces = 0 
count = fresh_fruit.get('바나나', 0) 
if count >= 2: 
    pieces = slice_bananas(count)
else:
    ... 
{{< /highlight >}}

<br> 

`pieces` 가 훨씬 중요한 변수인데 if 앞에서 `count` 를 정의해서 마치 count 도 중요해보인다. 

<br> 


> 왈러스 연산자를 썼을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
pieces = 0 
if (count := fresh_fruit.get('바나나', 0)) >= 2: 
    pieces = slice_bananas(count)
else: 
    ...
{{< /highlight >}}

<br> 

#### 왈러스 연산자를 이용해 우아하게 switch/case 흉내내기 
파이썬에는 switch/case 문이 없기 때문에 일반적으로 if, elif, else 문을 사용해서 흉내를 내는 것이 일반적이다. 왈러스 연산자를 쓰지 않는다면 대입하고 평가하는 것이 나눠져있기 때문에 지져분해진다.

<br> 

> 왈러스 연산자를 쓰지 않았을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
count = fresh_fruit.get('바나나', 0)
if count >= 2: 
    pieces = slice_bananas(count)
    to_enjoy = make_smoothies(pieces)
else:      # 왜 elif를 안쓰고 else를 썼나 했더니 elif를 쓰면 값을 대입 못한다.. .
    count = fresh_fruit.get('사과', 0)
    if count >= 4: 
        to_enjoy = make_cider(count)
    else: 
        count = fresh_fruit.get('레몬', 0)
        if count: 
            to_enjoy = make_lemonade(count)
        else: 
            to_enjoy = '아무것도 없음'
{{< /highlight >}}

<br> 



> 왈러스 연산자를 썼을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
if (count := fresh_fruit.get('바나나', 0)) >= 2: 
    pieces = slice_bananas(count)
    to_enjoy = make_smoothies(pieces)
elif (count := fresh_fruit.get('사과', 0)) >= 4: 
    to_enjoy = make_cider(count)
elif count := fresh_fruit.get('레몬', 0): 
    to_enjoy = make_lemonade(count)
else: 
    to_enjoy = '아무것도 없음'
{{< /highlight >}}

<br> 

#### 왈러스 연산자를 이용해 우아하게 while문 사용하기

> 왈러스 연산자를 쓰지 않았을 때

{{< highlight python  "linenos=true,hl_inline=false" >}}
bottles = []
fresh_fruit = pick_fruit()

while fresh_fruit: 
    for fruit, count in fresh_fruit.items(): 
        batch = make_juice(fruit, count)
        bottles.extend(batch)
    fresh_fruit = pick_fruit()
{{< /highlight >}}

<br> 

이 코드는 `fresh_fruit = pick_fruit()` 호출을 두 번 하고 있기 때문에 반복적이다. 

while을 무한루프로 만들고 중간에 break를 두는 식으로 `fresh_fruit = pick_fruit()` 를 한 번 만 호출 할 수 도 있겠지만 
while 루프를 맹목적인 무한루프로 만들고, 루프 흐름 제어가 모두 break 문에 달려있어 _while 루프의 유용성이 줄어든다._ 

<br> 


> 왈러스 연산자를 썼을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
bottles = []
while fresh_fruit := pick_fruit(): 
    for fruit, count in fresh_fruit.items(): 
        batch = make_juice(fruit, count)
        bottles.extend(batch)
{{< /highlight >}}

<br> 

#### 왈러스 연산자 사용을 고려해야 할 때 
몇 줄로 이뤄진 코드 그룹에서 같은 식이나 같은 대입문을 여러 번 `되풀이`하는 부분을 발견하면 가독성을 향상시키기 위해 대입식을 도입하는 것을 고려해 봐야 한다.  

<br> 