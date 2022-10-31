+++
title = "[Effective Python] Betterway 16 to 20 Summary"
date = "2022-10-29"
description = "책 [Effective Python] Chapter 2 중 better way 16장부터 20장까지 요약한다."
tags = ["Book"]
+++



<br>
<br> 

> 책 [Effective Python] betterway를 16장부터 20장 까지 요약한다.

<br> 

**Index**
1. Better way 16 in을 사용하고 딕셔너리 키가 없을 때 KeyError를 처리하기보다는 get을 사용하라
2. Better way 17 내부 상태에서 원소가 없는 경우를 처리할 때는 setdefault 보다 defaultdict를 사용하라

<br> 

# Better way 16 in을 사용하고 딕셔너리 키가 없을 때 KeyError를 처리하기보다는 get을 사용하라

딕셔너리의 세 가지 기본 연산은 키 또는 키에 연관된 값에 접근하고, 대입하고, 삭제하는 것이다. 그런데 딕셔너리의 내용은 동적이므로 어떤 키에 접근하거나 키를 삭제할 때 그 키가 딕셔너리에 없을 수도 있다. 
이럴때 처리할 수 있는 방법이 3 가지가 있다. 

<br> 

> in을 사용 

{{< highlight python  "linenos=true,hl_inline=false" >}}
if key in counters: 
    count = counters[key]
else: 
    count = 0 

counters[key] = count + 1
{{< /highlight >}}

이렇게 처리하면 딕셔너리에서 키를 두 번 읽고, 키에 대한 값을 한 번 대입해야 한다. 

<br> 

> KeyError를 사용 

{{< highlight python  "linenos=true,hl_inline=false" >}}
try: 
    count = counters[key]
except KeyError: 
    count = 0 

counters[key] = count + 1
{{< /highlight >}}

키를 한 번만 읽고, 값을 한 번 만 대입하면 되기 때문에 `in` 을 사용할 때 보다 효율적이다.

<br> 

> get을 사용 (권장) 

{{< highlight python  "linenos=true,hl_inline=false" >}}
count = counters.get(key, 0)
counters[key] = count + 1
{{< /highlight >}}

키를 한 번만 읽고, 값을 한 번 만 대입한다. 하지만 `KeyError` 방식보다 코드가 훨씬 짧다.


in 과 KeyError 를 사용해도 코드를 줄일 수 있는 방법이 있지만 가독성이 떨어진다. _따라서 간단한 타입의 값이 들어있는 경우 get 메서드를 사용하는 방법이 가장 코드가 짧고 깔끔하다._ 

<br> 

#### 딕셔너리에 저장된 값이 리스트처럼 복잡한 값이라면? 

리스트가 들어간다고 해도 처리할 수 있는 방법은 위와 같은 3가지이다. 

> 리스트 처리 방법 

{{< highlight python  "linenos=true,hl_inline=false" >}}
votes = {
    '바게트': ['철수', '순이'], 
    '치아바타': ['하니', '유리'], 
}

## in ## 
if key in votes: 
    names = votes[key]
else: 
    votes[key] = names = []

names.append(who)


## KeyError ## 
try: 
    names = votes[key]
except KeyError: 
    votes[key] = names = []

names.append(who)


## get ## 
names = votes.get(key)
if names is None: 
    votes[key] = names = []

names.append(who)


## (심화) get 왈러스 연산자 사용하기 ## 
if (names := votes.get(key)) is None: 
    votes[key] = names = []

names.append(who)
{{< /highlight >}}

세가지 경우 모두 `참조`를 통해 딕셔너리에 넣은 빈 리스트의 내용을 변경할 수 있어 한 번 만 대입을 하면 된다.

<br> 

dict 에는 이런 연산을 간소화해주는 `setdefault` 메서드를 제공한다. _하지만 결론부터 말하자면 setdefault 사용을 권장하지 않는다._

<br> 

> setdefault 

{{< highlight python  "linenos=true,hl_inline=false" >}}
names = votes.setdefault(key, [])
names.append(who)
{{< /highlight >}}

<br> 

> setdefault 동작 방식 
- setdefault는 키를 사용해 딕셔너리의 값을 가져오려고 시도한다. 
- 키가 없으면 제공받은 디폴트 값을 딕셔너리에 대입한 다음, 키를 사용하여 딕셔러니 값을 반환한다. 
- 따라서 이 값은 새로 저장된 디폴트 값 일 수도 있고, 이미 딕셔너리에 있던 키 값일 수도 있다. 

<br> 

치명적인 단점은 메서드 이름인 `setdefault`가 _메서드의 동작을 직접적으로 드러내지 못하는 것이다_.
값을 얻는 동작도 포함이 되어있지만 이름이 set 이라서 마치 값을 넣어주는 동작만 할 것 같아 코드를 
읽자마자 무슨 역할을 하려는지 모를 수 있다. 



<br> 

# Better way 17 내부 상태에서 원소가 없는 경우를 처리할 때는 setdefault 보다 defaultdict를 사용하라

직접 만들지 않는 딕셔너리를 다룰 때 `get` 을 쓰거나 상황을 고려하여 `setdefault`를 쓰는 것이 좋다. 하지만 직접 딕셔너리 생성을 제어할 수 있다면,
예를 들어 클래스 내부에서 딕셔너리 인스턴스를 사용한다면 setdefault도 있지만 `collections` 내장 모듈에 있는 `defaultdict` 클래스 사용을 고려할 수 있다. 

_defaultdict 클래스는 키가 없을 때 자동으로 디폴트 값을 지정해준다._

<br> 

> setdefault를 사용하는 클래스 내부 딕셔너리

{{< highlight python  "linenos=true,hl_inline=false" >}}
class Visits: 
    def __init__(self): 
        self.data = {} 

    def add(self, country, city): 
        city_set = self.data.setdefault(country, set()) 
        city_set.add(city) 


## example ## 
visits = Visits()
visits.add('영국', '런던')
visits.add('캐나다', '오타와')
{{< /highlight >}}

새로 만든 클래스의 add는 setdefault의 복잡도를 제대로 감춰, 더 나은 인터페이스를 제공한다. 
하지만 여전히 setdefault의 이름은 직관적이지 못하고, _주어진 나라가 data 딕셔너리에 있든 없든 호출할 때마다 새로운 
set 인스턴스를 만들기 때문에 효율적이지 못하다._ 

<br> 

> defaultdict를 사용하는 클래스 내부 딕셔너리 

{{< highlight python  "linenos=true,hl_inline=false" >}}
from collections import defaultdict 

class Visits: 
    def __init__(self): 
        self.data = defaultdict(set)
    
    def add(self, country, city): 
        set.data[country].add(city) 


## example ## 
visits = Visits()
visits.add('영국', '런던')
visits.add('영국', '버스')

print(visits.data)

>>> 
defaultdict(<class 'set'>, {'영국': {'버스', '런던'}})
{{< /highlight >}}

이제 add 코드는 data 딕셔너리에 있는 키에 접근하면 항상 기존 set 인스턴스가 반환된다.
이전 코드에서는 add 메서드가 아주 많이 호출되면 집합 생성에 따른 비용도 커지는데, 이 구현에서는 불필요한 set이 만들어지는 경우는 없다.

<br> 



