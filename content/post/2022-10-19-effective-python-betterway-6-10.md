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
1. 인덱스를 사용하는 대신 대입을 사용해 데이터를 언패킹하라
2. index2 

<br> 

# 인덱스를 사용하는 대신 대입을 사용해 데이터를 언패킹하라
파이썬에서는 _언패킹_ 구문이 있다. 언패킹 구문을 사용하면 한 문장 안에서 여러 값을 대입할 수 있다. 교재에서는 
튜플을 사용할 때 인덱스 말고 언패킹을 사용하는 예제를 보여주고 있다. 언패킹은 튜플 인덱스를 사용하는 것보다 시각적인 잡음이 적다. 

> Tuple 언패킹 예시

{{< highlight python  "linenos=true,hl_inline=false" >}}
item = ('호박', '식혜')
first, second = item 
print(first, '&', second)

>>> 호박 & 식혜 
{{< /highlight >}}

<br> 

### 언패킹을 이용해서 임시변수 없이 값 맞 바꾸기 
{{< highlight python  "linenos=true,hl_inline=false" >}}
def bubble_sort(a): 
    for _ in range(len(a)):
        for i in range(1, len(a)):
            if a[i] < a[i-1]:
                a[i-1], a[i] = a[i], a[i-1] # 맞바꾸기
{{< /highlight >}}

<br> 

> 작동원리
1. 대입문의 오른쪽 a[i], a[i=1]이 계산된다. 
2. 그 결과값이 이름없는 새로운 tuple에 저장된다. 
3. 대입문의 왼쪽에 있는 언패킹 a[i-1], a[i]를 통해 이름없는 tuple에 있는 값이 a[i-1], a[i]에 저장된다. 
4. 이름없는 tuple이 사라진다.


<br> 

### for 루프와 같은 컴프리헨션, 제너레이터의 리스트 원소를 언패킹하는 방법 

{{< highlight python  "linenos=true,hl_inline=false" >}}
snacks = [('베이컨', 350), ('도넛', 240), ('머핀', 190)]

for name, calories in snacks: 
    print(f'{name}은 {calories} 입니다.')
{{< /highlight >}}


<br> 
