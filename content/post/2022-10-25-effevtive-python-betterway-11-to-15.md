+++
title = "[Effective Python] Betterway 11 to 15 Summary"
date = "2022-10-19"
description = "책 [Effective Python] Chapter 2 중 better way 11장부터 15장까지 요약한다."
tags = ["Book"]
+++



<br>
<br> 

> 책 [Effective Python] betterway를 11장부터 15장까지 요약한다.

<br> 

**Index**
1. Better way 11 시퀸스를 슬라이싱하는 방법을 익혀라
2. index2 

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

