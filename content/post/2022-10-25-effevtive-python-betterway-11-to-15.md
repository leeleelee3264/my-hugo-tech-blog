+++
title = "[Effective Python] Betterway 11 to 15 Summary"
date = "2022-10-25"
description = "책 [Effective Python] Chapter 2 중 better way 11장부터 15장까지 요약한다."
tags = ["Book"]
+++



<br>
<br> 

> 책 [Effective Python] betterway를 11장부터 15장까지 요약한다.

<br> 

**Index**
1. Better way 11 시퀸스를 슬라이싱하는 방법을 익혀라
2. Better way 12 스트라이드와 슬라이스를 한 식에 함께 사용하지 말라 
3. Better way 13 슬라이싱보다는 나머지를 모두 잡아내는 언패킹을 사용하라 
4. Better way 14 복잡한 기준을 사용해 정렬할 때는 key 파라메터를 사용하라
5. Better way 15 딕셔너리 삽입 순서에 의존할 때는 조심하라

<br> 

# Better way 11 시퀸스를 슬라이싱하는 방법을 익혀라

슬라이싱을 사용하면 최소한의 노력으로 시퀸스에 들어있는 아이템의 부분집합에 쉽게 접근할 수 있다. 모든 파이썬 클래스는 `__getitem__` `__setitem__` 을 구현해서 슬라이싱을 사용할 수 있다. 

슬라이싱 구문의 기본 형태는 `리스트[시작:끝]` 인데 끝 인덱스에 있는 원소는 _포함되지 않는 걸_ 꼭 기억하자. 또한 슬라이싱을 할 때 _리스트의 인덱스 범위를 넘어가면 Exception을 발생시키지 않고_, 인덱스 범위 내의 리스트로 잘려진다. 

<br> 

> 슬라이싱 예제

{{< highlight python  "linenos=true,hl_inline=false" >}}
a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

a[:] 
a[:5]
a[:-1]      # ['a', 'b', 'c', 'd', 'e', 'f', 'g']
a[-3:]      # ['f', 'g', 'h']
a[2:-1]     # ['c', 'd', 'e', 'f', 'g']
a[-3:-1]    # ['f', 'g']
{{< /highlight >}}

<br> 

> 음수 인덱스 사용시 주의할 점 

- 리스트가 0보다 클 때에는 잘 작동한다. 
- 리스트가 0이면 `somelist[-n:]`이 결국 `somelist[:]` 와 같아져 전체 리스트가 복사된다. 

<br> 

> 슬라이싱 컨벤션

- 리스트의 맨 앞부터 슬라이싱 할 떄에는 0을 생략하라. `a[:5]`
- 리스트의 끝까지 슬라이싱 할 때는 끝 인덱스를 생략하라. `a[5:]`

<br> 

#### 슬라이싱으로 대입 했을 때 

_슬라이스 대입에서는 슬라이스와 대입이 되는 리스트의 길이가 같을 필요가 없다._ 슬라이스가 리스트보다 길면 리스트가 늘어나고, 슬라이스가 리스트보다 짧으면 리스트가 짧아진다. 

<br> 

> 슬라이싱이 리스트보다 길 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
a[2:3] = [47, 11]   # 슬라이싱은 2 자리 하나 뿐인데 값은 2개가 있다. 
print(a)

>>> 
['a', 'b', 47, 11, 'd', 'e', 'f', 'g']
{{< /highlight >}}


<br> 


> 슬라이싱이 리스트보다 짧을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
a[2:7] = [99, 22, 14]   # 슬라이싱은 2,3,4,5,6 자리인데 값은 3개 밖에 없다. 
print(a)

>>> 
['a', 'b', 99, 22, 14, 'h']

{{< /highlight >}}

<br> 

#### 리스트 복사 

> 슬라이싱으로 대입해서 call-by-value 로 복사가 될 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
b = a[:]
assert b == a and b is not a    # 값은 같지만 같은 객체는 아니다.
{{< /highlight >}}


원본에 변경이 있어도 복사본에는 변경이 없다.

<br>

> 원본을 대입해서 call-by-reference 로 복사가 될 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
b = a 
assert a is b   # 같은 객체다. 
{{< /highlight >}}

원본에 변경이 있으면 그걸 참조하는 복사본에도 변경이 적용된다. 

<br> 

# Better way 12 스트라이드와 슬라이스를 한 식에 함께 사용하지 말라 
`리스트[시작:끝:중간값]` 으로 일정한 간격을 두고 슬라이싱을 할 수 있는 것을 `스트라이드`라고 한다.
스트라이드를 사용하면 시퀸스를 슬라이싱하면서 매 n 번째 원소만 가져올 수 있다. 

<br> 

> 스트라이드 예제 

{{< highlight python  "linenos=true,hl_inline=false" >}}
x = [1, 2, 3, 4, 5, 6]
odds = x[::2]
evens = x[1::2]

print(odds)
print(evens)

>>> 
[1, 3, 5]
[2, 4, 6]
{{< /highlight >}}

<br>

> 혼란스러운 스트라이드 

{{< highlight python  "linenos=true,hl_inline=false" >}}
x[2::2]
x[-2::-2]
x[-1:2:-2]
{{< /highlight >}}


_중요한 점은 슬라이싱 구문에 스트라이딩까지 들어가면 아주 혼란스럽다는 것이다._ 각괄호 안에 수가 세 개나 들어 있으면 코드 밀도가 너무 높아서 읽기 어렵다. 
특히 증가값이 `음수`인 경우는 더 그렇다.

이런 혼란스러움을 방지하기 위해 시작값이나 끝값을 증가값과 함께 사용하지 말 것을 권한다. _즉, 스트라이드와 슬라이스를 한 식에 두지 않는 것이 좋다._

<br> 

#### 스트라이드 권장 사항 

- 증가값을 사용해야 하는 경우에는 `양수`값으로 만들고, `시작`과 `끝` 인덱스를 `생략`하라. 
- 시작이나 끝 인덱스와 함께 증가값을 사용해야 한다면 `스트라이딩`한 결과를 변수에 `대입`한 다음 `슬라이싱`하라.

<br> 

> 스트라이드 권장 사항 예제 

{{< highlight python  "linenos=true,hl_inline=false" >}}
y = x[::2]      # 스트라이드
z = y[1:-1]     # 슬라이드 
{{< /highlight >}}

<br> 

# Better way 13 슬라이싱보다는 나머지를 모두 잡아내는 언패킹을 사용하라

> 인덱스와 슬라이싱으로 목표한 원소 & 나머지 원소 처리하기

{{< highlight python  "linenos=true,hl_inline=false" >}}
oldest = car[0]
second_oldest = car[1]
others = car[2:]
{{< /highlight >}}


파이썬을 처음 사용하는 사람은 목표한 원소와 나머지 원소를 가져올 때 슬라이싱을 자주 사용한다. 하지만 이런 방법은 인덱스와 슬라이스로 인해 시각적 잡음이 많다.
또한 인덱스 관련 오류를 낼 확률도 높아진다.

<br> 

> 별표 식과 언패킹으로 목표한 원소 & 나머지 원소 처리하기 

{{< highlight python  "linenos=true,hl_inline=false" >}}
oldest, second_oldest, *others = car 
print(oldest, second_oldest, others)

>>> 
20 19 [15, 9, 8]
{{< /highlight >}}


`별표 식`을 사용하면 언패킹 패턴의 다른 부분에 들어가지 못하는 모든 값을 `별`이 붙은 부분에 다 담을 수 있다.
별표는 여러 위치에서 사용이 가능하다. _단, 단독으로 사용하는 것은 안된다._ 

<br> 

> 여러 위치에서 사용하는 별표 식 

{{< highlight python  "linenos=true,hl_inline=false" >}}
oldest, *others, youngest = car 

*others, second_youngest, youngest = car
{{< /highlight >}}


별표 식은 항상 `list` 인스턴스가 된다. 언패킹하는 시퀸스에 남는 원소가 없으면 별표 식 부분은 `빈 리스트`가 된다. 
이런 특징은 원소가 최소 `N`개 들어 있다는 사실을 미리 아는 시퀸스를 처리할 때 유용하다. 

<br> 

#### 별표 식 활용

별표 식의 장점은 언패킹할 리스트를 깔끔하게 가져올 수 있다는 것이다.

> 인덱스와 슬라이스를 쓸 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
csv = list(csv_file)

header = csv[0]
rows = csv[1:]

{{< /highlight >}}

<br> 

> 별표 식을 쓸 때

{{< highlight python  "linenos=true,hl_inline=false" >}}
csv = list(csv_file)

header, *rows = csv_file
{{< /highlight >}}

<br> 

#### 별표 식 주의점
별표 식은 항상 `리스트`를 만들어내기 때문에 별표 식을 사용해서 언패킹을 하고 _리스트 연산을 할 경우 메모리를 다 사용해서 프로그램이 멈출 수 있다_. 
꼭 결과 데이터가 모두 메모리에 들어갈 수 있다고 확신할 때만 별표 식을 사용하도록 해야 한다. 

<br> 

# Better way 14 복잡한 기준을 사용해 정렬할 때는 key 파라메터를 사용하라

정렬에 사용하고 싶은 애트리뷰트가 객체에 들어있는 경우가 많다. 이런 상황을 지원하기 위헤 `sort()` 는 `key` 라는 파라메터가 있다.
key 함수에는 정렬 중인 리스트의 원소가 전달된다. key는 함수이기 때문에 `lambda`와 함께 사용한다. 

<br> 

> lambda로 key 사용하기 

{{< highlight python  "linenos=true,hl_inline=false" >}}
tools.sort(key=lambda x:x.name)
{{< /highlight >}}

<br> 

#### 여러 기준을 사용해 정렬해야 할 때 

`튜플`은 기본적으로 비교가 가능하며 자연스러운 순서가 정해져있다. 이는 sort에 필요한 `__lt__` 정의가 들어있다는 뜻이다. __lt__는 튜플의 각 
위치를 이터레이션하면서 각 인덱스에 해당하는 원서를 한 번에 하나씩 비교한다. 

<br> 

> 튜플 정렬

{{< highlight python  "linenos=true,hl_inline=false" >}}
drill = (4, '드릴')
sander = (4, '연마기')

assert drill[0] === sander[0]   # 무게가 같다 
assert drill[1] < sander[1]     # o 보다 ㄷ 이 더 먼저와서 drill이 더 작다
assert drill < sander           # 그러므로 드릴이 더 먼저다 
{{< /highlight >}}

비교하는 두 튜플의 첫 번째 위치에 있는 값이 서로 같으면 두 번째 위치에 있는 값을 비교하고, 또 같으면 세 번째 위치 값을 비교하고 결정이 날 때까지 이 과정을 반복한다. 

<br> 

> 튜플 정렬을 활용한 애트리뷰트 비교 

{{< highlight python  "linenos=true,hl_inline=false" >}}
tools.sort(key=lambda x : (x.weight, x.name))
{{< /highlight >}}

<br>

> 튜플 정렬을 활용한 애트리뷰트 비교 내림차순 ver 

{{< highlight python  "linenos=true,hl_inline=false" >}}
tools.sort(key=lambda x : (x.weight, x.name), reverse=True)
{{< /highlight >}}


<br> 

#### 여러 기준 사용할 때 정렬에 내림차순, 오름차순 모두 사용하기 

> `-` 연산자로 무게는 내림차순하고 이름은 오름차순 하기 

{{< highlight python  "linenos=true,hl_inline=false" >}}
tools.sort(key=lambda x: (-x.weight, x.name))
{{< /highlight >}}

튜플을 활용한 여러 기준 정렬의 제약 사항은 _모든 비교 기준의 정렬 순서가 같아야 한다_. 예를들어 무게가 오름차순 정렬이라면 이름도 오름차순 정렬이어야 한다.
But 만약 `숫자` 값일 경우 `-` 연산자를 사용해서 내림차순 정렬을 해, 정렬 방향을 혼합할 수 있다. 오직 숫자 값 일때만 가능하다.

<br> 

> `-` 연산자가 통하지 않을 때

{{< highlight python  "linenos=true,hl_inline=false" >}}
tools.sort(key=lambda x: x.name)                    # name 기준 오름차순 
tools.sort(key=lambda x: x.weight, reverse=True)    # weight 기준 내림차순  
{{< /highlight >}}

_최종적으로 리스트에서 얻어내고 싶은 정렬 기준 역순으로 정렬을 수행해야 한다._
즉 예제에서는 weight으로 내림차순 후 name으로 오름차순을 하고 싶었기 때문에 name으로 오름차순을 먼저 해주고 weight 내림차순을 해줬다. 

이러듯 제약사항이 있기 때문에 평소에는 `튜플 + - 연산자`를 사용하고, sort를 여러 번 호출하는 방법은 꼭 필요한 때에만 사용해야 한다. 


<br> 

# Better way 15 딕셔너리 삽입 순서에 의존할 때는 조심하라

_파이썬 3.5 이전에는 딕셔너리로 이터레이션을 수행할 때 삽입 순서에 상관 없이 키를 임의의 순서로 돌려줬다._

딕셔너리 구현이 내장 hash 함수와 파이썬 인터프리터가
`시작할 때 초기화되는 난수의 seed`를 사용하는 해시 테이블 알고리즘을 사용했고, 그래서 인터프리터 실행 시마다 난수의 seed가 달라져 임의의 순서로 돌려줄 수 밖에 없었다.

`파이썬 3.6` 부터는 딕셔너리가 삽입 순서를 보존하도록 변경 되었고, 3,7 부터는 아예 명세에 포함시켜 두었다.

<br> 

> 3.6 이후 부터 삽입 순서를 보장하는 딕셔너리

{{< highlight python  "linenos=true,hl_inline=false" >}}
baby_names = {
'cat': 'kitten',
'dog': 'puppy',
}

print(baby_names)

>>>
{'cat': 'kitten', 'dog': 'puppy'}
{{< /highlight >}}

<br> 

> 3.6 이후 부터 삽입 순서를 보장하는 딕셔너리 built-in 메서드

{{< highlight python  "linenos=true,hl_inline=false" >}}
baby_names.keys()
baby_names.values()
baby_names.items()
baby_names.popitem()    # 마지막에 삽입된 원소를 리턴하는 메서드
{{< /highlight >}}


삽입 순서를 보장하면서 부터 딕셔너리에 빌트인 되어있는 메서드들 또한 삽입 순서가 보장이 된다.

<br> 

> 3.6 이후부터 삽입 순서를 보장하는 키워드 인자

{{< highlight python  "linenos=true,hl_inline=false" >}}
def my_func(**kwargs):
for key, value in kwargs.items():
print(f'{key} = {value}')

my func(goose='gosling', kangaroo='joey')

>>>
goose = gosling
kangaroo = joey
{{< /highlight >}}

3.6의 변경은 dict 타입과 이 타입의 특정 구현에 의존하는 여러 다른 파이썬 기능에 영향을 미쳤고, dict 형식으로 인자를 전달하는 `키워드 인자` **kwargs 도 순서를 보장하게 되었다.

<br> 

> 딕셔너리가 삽입 순러를 유지하는 방식은 파이썬 언어 명세의 일부가 되었기 떄문에 앞에 예제로 나왔던 기능은 코드에서 항상 이런 식으로 동작한다고 가정해도 안전하다.

<br> 

#### 딕셔너리가 삽입 순서를 보장하지 않을 때

파이썬은 정적 타입 지정 언어가 아니고, 대부분의 경우 엄격한 클래스 계층보다는 `객체의 동작`이 `객체의 실질적인 타입`을 결정하는 `덕 타이핑`에 의존한다.

> 덕 타이핑이란 객체가 실행 시점에 어떻게 행동하는지를 기준으로 객체의 타입을 판단하는 타입 지정방식이다. 하지만 실제 행동을 모두 검증하기는 어렵다. 때문에 실질적으로 이 말은 _아무런 타이핑을 하지 않고, 런타임에 객체가 제공하는 애트리뷰트와 메서드가 없는 경우에는 그냥 오류를 내겠다는 말이다_.

<br> 

파이썬에서는 list, dict 등의 `표준 프로토콜`을 흉내 내는 커스텀 컨테이너 타입을 쉽게 정의할 수 있고, 이럴 때 덕 타이핑으로 인해 문제가 야기될 수 있다. 딕셔너리가 삽입 순서를 보장하지 않는 문제도 이것의 일종이다.  
_즉, dict 를 인자로 넣었을 때 순서를 보장했던 함수가 이 커스텀 컨테이너를 넣었을 때에도 순서를 보장한다고 생각하면 안된다._ 덕 타이핑으로 타입 검사를 넘어갔을 뿐이지 이 컨테이너가 dict 이라는 말은 아니다.



<br> 

##### 커스텀 컨테이너의 삽입 순서 미보장 예제

> dict을 넣었을 떄 삽입 순서를 보장하는 함수

{{< highlight python  "linenos=true,hl_inline=false" >}}

def populate_ranks(votes, ranks):
names = list(votes.keys())
names.sort(key=votes.get, reverse=True)
for i, name in enumerate(names, 1):
ranks[name] = i

def get_winner(ranks):
return next(iter(ranks))

{{< /highlight >}}

populate_ranks는 dict을 순환하며 득표가 많은 순으로 삽입을 하고 있다. 따라서 get_winner 에서 제일 먼저 삽입된 원소를 뽑아옴으로 최다 득표 원소를 리턴할 수 있다.

<br> 

> 알파벳 순으로 순서를 보장하게 구현된 SortedDict

{{< highlight python  "linenos=true,hl_inline=false" >}}
class SortedDict(MutableMapping)
def __init__(self):
self.data = {}

    def __getitem__(self, key): 
        return self.data[key]

    def __setitem__(self, key, value): 
        return self.data[key] = value 

    def __iter__(self):                 # 이터레이션을 할 때 알파벳 순서로 돌려주는 함수  
        keys = list(self.data.keys())
        keys.sort() 
        for key in keys: 
            yield key 
    ... 
{{< /highlight >}}

MutableMapping을 사용한 SortedDict는 `__getitem__`, `__setitem__` 등을 구현하여 dict의 프로토콜을 지키므로 dict을 파라메터로 받는 populate_ranks와 get_winner를 사용할 수 있다.

<br> 

> 실제로 함수를 호출 했을 때

{{< highlight python  "linenos=true,hl_inline=false" >}}

votes = {
'otter': 1281,
'polar bear': 587,
'fox': 863,
}

# 일반 dict를 사용할 때
ranks = {}
populate_ranks(votes, ranks)
winner = get_winner(ranks)
print(winner)


# sortedDict를 사용할 때
sorted_ranks = sortedDict()
winner = get_winner(sorted_ranks)
print(winner)

{{< /highlight >}}

이렇게 해도 덕 타이핑으로 무사히 넘어가기 때문에 아무런 오류가 발생하지 않는다. 다만 원했던 결과가 나오지 않을 뿐이다. get_winner 에서 `next(iter(ranks))` 로 값을 뽑아 올 때 SortedDict 내부에 구현된 `__iter__` 때문에 득표와는 관련없이 알파벳 순으로 원소를 돌려주기 때문이다.

<br> 

##### 해결방법


###### 방법1: get_winner를 특정 순서가 보장되지 않는 형태로 변경하기

기존에는 get_winner가 득표수가 많은 순서대로 삽입을 진행했다고, 순서가 보장되었다고 판단을 하고 구현을 했다면 이제는 순서가 보장되지 않는 형태로 변경한다. _가장 보수적이고 가장 튼튼한 해법이다._

> 예제

{{< highlight python  "linenos=true,hl_inline=false" >}}
def get_winner(ranks):
for name, rank in ranks.item():
if rank == 1:
return name
{{< /highlight >}}

<br> 

###### 방법2: get_winner에서 ranks 타입 검사 넣기

get_winner가 우리의 예상에 맞게 동작하려면 ranks가 꼭 dict 타입으로 구현되어 있어야 한다. 그래서 ranks가 dict 타입이 맞는지 검사를 넣는다. _보수적인 접근 방법보다 실행 성능이 더 좋다._


> 예제

{{< highlight python  "linenos=true,hl_inline=false" >}}
def get_winner(ranks):
if not isinstance(ranks, dict):
raise TypeError('dict 인스턴스가 필요합니다.')
return next(iter(ranks))
{{< /highlight >}}

<br> 

###### 방법3: typing으로 타입을 명시하고 mypy로 검사

이렇게 타입을 명시 했는데 SortedDict() 타입을 넣으면 mypy에서 에러를 보내줘, 함수에 명시된 타입 이외의 타입으로 함수 호출하는 것을 예방할 수 있다. (mypy 에러가 나면 수정을 해야 하니까.) _정적 타입 안정성과 런타임 성능을 가장 잘 조합한 해법이다._

{{< highlight python  "linenos=true,hl_inline=false" >}}
def populate_ranks(votes: Dict[str, int], ranks: Dict[str, int]) -> None:
...

def get_winner(ranks: Dict[str, int]) -> str:
...
{{< /highlight >}}


<br>

