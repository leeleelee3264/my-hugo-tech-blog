+++
title = "[Effective Python] Betterway 6,7,8,9,10 요약"
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
