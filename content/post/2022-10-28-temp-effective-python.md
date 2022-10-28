+++
title = "[TEMP] 임시로 사용하는 Effective python 요약, 파일 취합 필요"
date = "2022-10-28"
description = "[TEMP] 임시로 사용하는 Effective python 요약, 파일 취합 필요"
tags = ["Book"]
+++

<br>
<br> 

> [TEMP] 임시로 사용하는 Effective python 요약, 파일 취합 필요 

<br> 

**Index**
1. Better way 15 딕셔너리 삽입 순서에 의존할 때는 조심하라 
2. index2 

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

