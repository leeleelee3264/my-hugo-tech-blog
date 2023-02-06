+++
title = "[Backend] 예제로 배우는 스프링 입문 강의 노트"
date = "2023-02-06"
description = "예제로 배우는 스프링 입문 강의를 들으며 작성한 노트를 정리한다."
tags = ["Backend"]
+++


<br>
<br> 

> 예제로 배우는 스프링 입문 강의를 들으며 작성한 노트를 정리한다. 

<br> 

**Index**
1. Intro: 나와 Spring의 관계, 이대로 괜찮은가?
2. 스프링 IoC
3. 스프링 AOP 
4. 스프링 PSA 

<br> 

# Intro: 나와 Spring의 관계, 이대로 괜찮은가?
Spring을 쓰기 시작하면서 개발자 경력을 시작했다. 그렇게 2년 동안 Spring을 쓰다가 지금 회사로 이직을 하면서 Django를 쓰게 되었다. 
1년 정도 Django를 쓰다 보니 언제부터인가 Spring이 낯설게 느껴졌다. 

#### 나와 Spring의 관계, 이대로 괜찮지 않다. 

Spring이 더 멀어지기 전에 다시 Spring 공부를 시작할 필요를 느꼈다. 어떻게 공부를 할까 고민하던 중, 예전에 인프런에서 백기선님의 Spring 강의를 듣던 게 
생각이 나서 가볍게 들어보기로 했다. 입문 강의지만 중요한 내용이 많아 노트를 작성하며 듣다 보니 아예 블로그에 노트를 제대로 정리하면 좋을 것 같아 포스팅을 한다. 


<br> 


# 스프링 IoC

### Inversion Of Control (제어권의 역전)

- <U>내가 사용할 의존성을 내가 직접 만들지 않고, 다른 쪽에서 만들어 줄 것이라 생각하여 제어권을 넘겨준다.</U>
  - 내가 쓸 의존성(객체)를 new로 만들지 않는다.  
- 이때 다른 쪽이란 Spring이며, Spring이 DI로 의존성을 주입해준다. 
  - 내가 사용할 의존성의 인터페이스만 맞으면 어떤 것을 주입해줘도 상관 없다. 
  - 테스트도 편리해진다. 

<br> 

> 내가 사용할 의존성을 내가 직접 만들 경우 

{{< highlight java  "linenos=true,hl_inline=false" >}}
class OwnerController {
    private OwnerRepository repository = new OwnerRepository(); 
}
{{< /highlight >}}

<br> 

> 내가 사용할 의존성을 다른 쪽에서 만들어 주는 경우

{{< highlight java  "linenos=true,hl_inline=false" >}}
class OwnerController {
    private OwnerRepository repo; 

    public OwnerController(OwnerRepository repo) {
        this.repo = repo; 
    }
}
{{< /highlight >}}

- OwnerController는 OwnerRepository 없이는 아예 생성 조차 될 수 없다. 
- OwnerRepository가 꼭 주어진다는 약속 아래에 코드가 만들어졌기 때문에 OwnerRepository에 구현되어있는 메서드를 써도 안전하다.

<br> 

> OwnerController를 생성할 때 OwnerRepository를 주입해주는 예시 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Test
public void testDoSomething() {
    OwnerRepository ownerRepository = new OwnerRepository(); 
    OwnerController ownerController = new OwnerController(ownerRepository); 
    
    ownerController.doSomething(); 
}
{{< /highlight >}}

<br>

### Bean 
- 스프링이 관리하는 객체들을 뜻한다. 
- 빈으로 등록하면 어떤 일이 일어나는가?
  - OwnerController를 만든다고 하면 `Spring`이 Bean으로 만들어진 OwnerRepository를 가져와 주입을 해준다.
  - Spring이 IoC 컨테이너에서 Bean을 관리하고 있기 때문에, 생성자나 어노테이션을 보고 필요한 의존성을 주입해주면서 의존성 관리를 해준다. 

<br> 

> 일반 객체 생성과 Bean 생성 

{{< highlight java  "linenos=true,hl_inline=false" >}}
// 일반 객체 생성 
SimpleClass simpleClass = new SimpleClass();

// Bean 생성 
SimpleClass simpleClassBean = applicationContext.getBean(SimpleClass.class); 
{{< /highlight >}}

- 위에서는 일반 객체를 생성했다. 이렇게 객체를 생성하면 Spring은 이 객체가 무엇인지 알 수 없다. 
- 아래에서는 Spring이 관리하는 IoC 컨테이너에서 Bean을 가져왔다. 

<br> 

#### Spring 컨테이너 안에 빈을 등록하는 방법 


<br> 

# 스프링 AOP


<br>

# 스프링 PSA