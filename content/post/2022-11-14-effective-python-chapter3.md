+++
title = "[Book] Effective Python (3/10) - 함수"
date = "2022-11-14"
description = "책 [Effective Python] Chapter 3를 요약한다."
tags = ["Book"]
+++



<br>
<br> 

> 책 [Effective Python] Chapter 3를 요약한다.


<br> 

**Index**
1. Better way 19 함수가 여러 값을 반환하는 경우 절대로 네 값 이상을 언패킹하지 말라


<br> 

# Better way 19 함수가 여러 값을 반환하는 경우 절대로 네 값 이상을 언패킹하지 말라

> 네 값 이상을 언패킹 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def get_status(numbers): 
    minimum = min(numbers)
    maximum = max(numbers)
    count = len(numbers)
    average = sum(numbers) / count 

    sorted_numbers = sorted(numbers) 
    middle = count // 2
    if count % 2 == 0: 
        lower = sorted_numbers[middle - 1] 
        upper = sorted_numbers[middle] 
        median = (lower + upper) / 2
    else: 
        median = sorted_numbers[middle]

    return minimum, maximum, average, median, count

minimum, maximum, average, median, count = get_status(numbers)
{{< /highlight >}}

<br> 

#### 문제점
- 모든 반환 값이 수(number)이기 때문에 순서를 혼동하기 쉽다. 이런 실수는 나중에 알아내기 어려운 버그를 만든다._반환 값이 많으면 실수하기도 아주 쉬워진다._
- 함수를 호출하는 부분과 반환 값을 언패킹하는 부분이 길고, 여러 가지 방법으로 줄을 바꿀 수 있어서 _가독성이 나빠진다._

<br> 



#### 해결 방법
이런 문제를 피하려면 함수가 _여러 값을 반환하거나 언패킹을 할 때_ 값이나 변수를 `네 개 이상` 사용하면 안된다.
많은 값을 언패킹해야 한다면 `경랑 클래스`(lightweight class)나 `namedtuple`을 사용하고 함수도 이런 값을 반환하게 만드는 것이 낫다. 

<br> 

> 경량 클래스


{{< highlight python  "linenos=true,hl_inline=false" >}}
@dataclass
class Number:
    minimum: int
    maximum: int    
    count: int
    average: int 
{{< /highlight >}}

<br> 


