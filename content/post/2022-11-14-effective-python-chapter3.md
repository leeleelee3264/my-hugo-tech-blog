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
2. Better way 20 None을 반환하기보다는 예외를 발생시켜라
3. [22를 작성하고 할 에정이다]
4. Better way 22 변수 위치 인자를 사용해 시각적인 잡음을 줄여라 


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

# Better way 20 None을 반환하기보다는 예외를 발생시켜라 

반환 값을 `None`으로 하면서 이 값에 *특별한 의미를 부여*하려 하면 안된다. None인지 검사하는 대신, 실수로 빈 값을 False 로 취급하는 검사를 실행할 수 있다. 


> None을 반환하는 함수 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def careful_divide(a, b): 
    try: 
        return a / b
    except ZeroDivisionError:
        return None
{{< /highlight >}}

<br> 

> None을 반환하는 함수를 사용하여 판별 

{{< highlight python  "linenos=true,hl_inline=false" >}}
x, y = 0, 5 
result = careful_divide(x, y) # result = 0 

if not result: 
    print('잘못된 임력') # 0으로 나누는 것이 아니라서 0을 return 했지만 False로 취급됐다. 

>>> 
잘못된 입력 
{{< /highlight >}}

<br> 

함수에서 None을 반환하면 오류를 야기하기 쉬운데, 실수할 가능성을 줄이는 방법은 두 가지이다.
- 반환값을 `튜플`로 분리한다. 
- 결코 None을 반환하지 않고, `Exception`을 호출한 쪽으로 발생시켜서 호출자가 이를 처리하게 한다. 

<br> 

#### 해결 방법 1: 반환값을 튜플로 분리한다.

> 튜플을 반환하는 함수 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def careful_divide(a, b): 
    try: 
        return True, a/b 
    except ZeroDivisionError: 
        return False, None

## Caller ## 
success, result = careful_divide(x, y)
if not success: 
    print('잘못된 입력')
{{< /highlight >}}

<br>

이 방법의 문제점은 호출하는 쪽에서 튜플의 첫 번째 부분을 쉽게 무시할 수 있다는 것이다. 결국 None을 반환한 경우와 마찬가지로 실수할 가능성이 높아진다.  

<br> 



#### 해결 방법 2: 결코 None을 반환하지 않고, Exception을 호출한 쪽으로 발생시켜서 호출자가 이를 처리하게 한다

> Exception을 발생시키는 함수 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def careful_divide(a, b):
    try:
        return a/b
    except ZeroDivisionError:
        raise ValueError('잘못된 입력')

## Caller ## 
x, y = 5, 2
try: 
    result = careful_divide(x, y)
except ValueError: 
    print('잘못된 입력')
else: 
    print(f'결과는 {result} 입니다.')
{{< /highlight >}}

<br> 

호출자는 더 이상 반환 값에 대한 조건문을 사용하지 않아도 된다. 대신 반환 값이 항상 올바르다고 가정하고 _try 문의 else 블록에서 이 값을 즉시 사용할 수 있다._


<br>


> 발생 예외 문서화 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def careful_divide(a, b):
    """
    Raises: ValueError
    """
    try:
        return a/b
    except ZeroDivisionError:
        raise ValueError('잘못된 입력')
{{< /highlight >}}

<br> 

파이썬의 점진적 타입 지정에서는 함수의 인터페이스에 예외가 포함되는지 표현하는 방법이 의도적으로 제외되었다. 때문에 호출자가 어떤 Exception을 잡아내야 할지
결정할 수 있도록 _발생시키는 예외를 문서에 명시해야 한다._

<br> 


# [22를 작성하고 할 에정이다]

<br> 

# Better way 22 변수 위치 인자를 사용해 시각적인 잡음을 줄여라 

`*args` - Variable Positional arguments (위치 가변 인자)   
`**kwargs` - Variable Keyword arguments (키워드 가변 인자)

<br>

위치 인자를 가변적으로 받을 수 있으면 함수 호출이 더 깔끔해지고 시각적 잡음도 줄어든다. 이런 위치 인자를 `varargs` 나 `star args` 라고 한다.

<br> 

> 인자 수가 고정 되어 있을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def log(message, values): 
    if not values: 
        print(message)
    else: 
        value_str = ', '.join(str(x) for x in values)
        print(f'{message}: {value_str}')

log('안녕', [])
{{< /highlight >}}

이렇게 빈 리스트를 넘기기보다는 두 번째 인자를 완전히 생략하면 좋을 것이다. 파이썬에서는 마지막 위치 인자 이름 앞에 `*`를 붙이면 된다. 

<br> 

> 인자 수가 가변으로 되어 있을 때 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def log(message, *values)
    ...

log('안녕')
{{< /highlight >}}

<br> 

> 시퀸스를 가변 인자 자리에 넘기기 

{{< highlight python  "linenos=true,hl_inline=false" >}}
favorite = [7, 33, 99]
log('좋아하는 숫자는:' *favorites)
{{< /highlight >}}

이미 시퀸스(리스트 등)이 있는데 _가변 인자 자리에 시퀸스를_ 사용하고 싶다면 * 연산자를 사용하면 된다.


<br>

### 가변 위치 인자 문제점 

#### 가변 위치 인자가 함수에 전달되기 전에 항상 튜플로 변환된다

함수를 호출하는 쪽에서 제너레이터 앞에 * 연산자를 사용하면 제너레이터의 모든 원소를 얻기 위해 반복한다는 뜻이다. 
이렇게 만들어지는 튜플은 제너레이터가 만들어낸 모든 값을 포함하며, 이로 인해 _메모리를 아주 많이 소비하거나 프로그램이 중단돼버릴 수 있다._

<br>

> 제너레이터 값을 가변 위치 인자에 전달 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def my_generator():
    for i in range(10):
        yield i 

def my_func(*args): # 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 가 전달된다.
    print(args)

it = my_generator()
my_func(*it)
{{< /highlight >}}



##### 예방법

_가변 위치 인자 자리에 제너레이터를 넣지 말자._ 제너레이터를 쓰는 이유는 메모리에 올릴 값을 한정하려는 의도인데 가변 위치 인자와 함께 사용하면 모든 값이 메모리에 올라간다.

`*args`를 받는 함수는 인자 목록에서 가변적인 부분에 들어가는 인자의 개수가 처리하기 좋을 정도로 *충분히 작다는 사실*을 이미 알고 있는 경우에 가장 적합하다. 

또한 `*args`는 주로 프로그래머의 **편의**와 **코드 가독성**을 위한 기능이다. 

<br> 


#### 함수에 새로운 위치 인자를 추가하면 해당 함수를 호출하는 모든 코드를 변경해야 한다 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def log(sequence, message, values):
    if not values:
        print(f'{sequence} - {message}')
    else:
        value_str = ', '.join(str(x) for x in values)
    print(f'{sequence} - {message}: {value_str}')

log('좋아하는 숫자는:' *favorites) # message가 sequence의 자리에 있어서 이상하게 출력됨 
log (1, '안녕')
{{< /highlight >}}


이미 가변 인자가 존재하는 함수 인자 목록의 *앞부분에 위치 인자를 추가*하려고 시도하면 기존의 호출코드가 미묘하게 깨진 결과를 보여줄 수 있다. 

##### 예방법
- *args를 받아들이는 함수를 확장할 떄는 `키워드 기반 인자`만 사용한다. 
- `타입 애너테이션`을 사용한다.

{{< highlight python  "linenos=true,hl_inline=false" >}}
def foo(*args: str, **kwargs: int)
    ...
{{< /highlight >}}



<br> 





