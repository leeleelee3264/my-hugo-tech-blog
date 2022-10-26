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