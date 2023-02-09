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

> 스프링 트라이앵글 = IoC, AOP, PSA 

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

> 일반 객체 생성

{{< highlight java  "linenos=true,hl_inline=false" >}}
SimpleClass simpleClass = new SimpleClass();
{{< /highlight >}}

- 위에서는 일반 객체를 생성했다. 이렇게 객체를 생성하면 Spring은 이 객체가 무엇인지 알 수 없다. 

<br> 

#### Spring 컨테이너 안에 빈을 등록하는 방법 

##### @Bean 어노테이션

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Configuration 
public class SampleConfig {
    @Bean 
    public SampleBean sampleBean() {
        return new SampleBean(); 
}
{{< /highlight >}}

<br>

- `Configuration` 어노테이션을 사용한다. 
- Configuration 안에 `Bean` 어노테이션을 사용해 빈을 만든다.
  - new로 생성되어 리턴되는 것이 빈이 되어, IoC 컨테이너 안으로 들어간다. 

<br>

##### @Component 어노테이션 
- `Controller`, `Service`, `Configuration` 어노테이션 모두 Component 어노테이션을 가지고 있다. 
- `ComponentScan` 어노테이션으로 Spring 런타임에 컴포넌트스캔을 해서 자동으로 detect 되어 IoC 컨테이너 안으로 들어간다. 
  - ComponentScan은 `SpringBootApplication` 어노테이션에 들어가 있다. 때떄로 SpringBootApplication 파일보다 위에 객체를 만들면 못 찾는 이유가 이것 때문이다. 

<br>

JPA에서 사용하는 Repository는 `@Repository`를 사용해서 빈으로 등록되는 것이 아니라, `Repository 인터페이스`를 상속받아야 빈으로 등록이 된다. 

<br>

> SpringApplication 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(
excludeFilters = {@Filter(
type = FilterType.CUSTOM,
classes = {TypeExcludeFilter.class}
), @Filter(
type = FilterType.CUSTOM,
classes = {AutoConfigurationExcludeFilter.class}
)}
)
public @interface SpringBootApplication {
... 
}
{{< /highlight >}}

<br>

##### Bean과 Component의 차이 
- Spring에서 관리하는 객체를 모두 Bean이라고 하기 때문에 사실 용어 자체로 볼 떄는 Component도 Bean에 포함이 된다.  
- 개발자가 컨트롤 할 수 없는 외부 라이브러리를 빈으로 등록하고 싶을 때 @Bean을 사용한다. 
  - 빈은 메소드에 사용한다.
  - 컴포넌트는 클래스에 사용한다. 


<br> 

### IoC 컨테이너 
IoC 컨테이너는 `ApplicationContext` 또는 `BeanFactory`를 사용해서 접근할 수 있다. BeanFactory가 IoC 컨테이너 자체라고 볼 수 있으며, ApplicationContext는 BeanFactory를 상속했다. 

IoC 컨테이너는 빈을 만들고, 해당 빈을 필요로 하는 곳에 의존성을 주입해준다. <U>Spring에서 의존성 주입은 빈끼리만 가능하다.</U> 의존성 주입을 IoC에서 해주고 있기 떄문에 빈이 아니라면 IoC에 들어가지 않아, 관리를 할 수 없다. 

<br> 

### SingleTon

Bean은 SingleTon으로 만들어진다. 그래서 ApplicationContext나 BeanFactory로 Bean을 가져와 인스턴스의 값을 봐보면 매번 같다. <U>SingleTon으로 단 한 번 만 만들어졌기 때문이다.</U>  
멀티 쓰레드에서 SingleTon을 만드는 것은 번거로운데 IoC 컨테이너를 사용하면 편하게 싱글톤을 만들 수 있고, 이게 IoC 컨테이너를 사용하는 이유 중 하나이다. 

<br> 

### DI 

#### 의존성 주입 방법 

> 필드 주입 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Controller 
class OwnerController {
    
    @Autowired 
    private OwnerRepository owners; 
... 
{{< /highlight >}}

> 생성자 주입 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Controller
class OwnerController {

    private final OwnerRepository owners;

    // @Autowired
    public OwnerController(OwnerRepository owners) {
        this.owners = owners; 
    }
...
{{< /highlight >}}

<br>

- _필수적으로 필요한 파라메터가 없을 때 인스턴스 자체를 만들 수 없어서 강제성을 줄 수 있다._
  - 그런데 가끔 순환참조의 문제가 일어날 수 있다. 이럴때는 다른 주입법을 써야 하거나 순환참조가 일어나지 않도록 구조를 짜야 한다. 
- 원래는 생성자에서도 @Autowired 를 써야 했는데 Spring 4.3 부터 없어졌다. 

<br>

> Setter 주입 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Controller
class OwnerController {

    private OwnerRepository owners;

    @Autowired 
    public void setOwners(OwnerRepository owners) {
        this.owners = owners; 
    } 
{{< /highlight >}}


<br>

Bean으로 등록하지 않고 @Autowired로 의존성 주입을 해달라고 하면 Spring 입장에서는 모르기 때문에 의존성을 주입해 줄 수 없고, 결과적으로 어플리케이션 자체가 안 뜨게 된다. 


# 스프링 AOP
Aspect Oriented Programming의 약자로, 관점(관심사)를 기준으로 흩어진 코드를 한 곳으로 모으는 기능이다. Spring의 대표적인 AOP로는 `@Transactional`이 있다. 

<br>

> AS-IS 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/aaa.png" >
<figcaption align = "center">흩어져있는 코드</figcaption>


- 같은 동작을 여러 곳에서 하고 있는데, 그 때마다 구현을 했다. 
- AAAA가 변경이 일어난다면, 쓰는 곳에 다 찾아가 고쳐줘야 한다. 
- <U>원래의 기능만 남겨두고 공통적이고 부가적인 기능을 한 곳에 모을 수 없을까?</U> -> AOP

<br> 

> TO-BE 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/bbb.png" >
<figcaption align = "center">모여있는 코드</figcaption>

<br>

AOP의 핵심은 실제 코드에는 없는데, 런타임에는 마치 있는 것처럼 동작을 한다는 것이다. 이렇게 없던 기능을 쏙 넣어주는 것에는 여러 방법이 있다. 

### 기능을 넣어주는 방법 

#### 컴파일할 때 넣어주기 
- 실제 함수에는 AAAA가 없는데, 컴파일을 하면서 마치 함수에 AAAA가 있는 것처럼 넣어준다. 
- `AspectJ`가 이런 일을 해주고 있다.

{{< highlight java  "linenos=true,hl_inline=false" >}}
A.java --> (컴파일) --> A.class 
              |
        AAAA 넣어주기
{{< /highlight >}}

<br>

#### 바이트코드를 조작해서 넣어주기 
- A.java애서 컴파일을 해 A.class를 만들면 A.class를 사용할 때 `ClassLoader`로 클래스를 읽어 메모리로 올린다.
- 메모리에 올라가는 A.class의 바이트코드를 조작해서 마치 함수에 AAAA가 있는 것처럼 넣어준다.  
- 이또한 AspectJ가 해준다. 

<br>

#### 프록시 패턴으로 구현하기
- <U>Spring AOP가 사용하는 방법이다.</U>
- 디자인 패턴 중 하나인 프록시 패턴을 사용해서 AOP를 구현했다. 
- [프록시 패턴](https://www.notion.so/7e4bdf0c9ef049e994f802c0eacea551#db43dcc19ab1480fbdd2c67deaf58582)의 핵심은 기존의 코드를 건드리지 않고 새로운 기능을 추가했다는 점이다. 
  - 이렇게 된다면 클라이언트 코드도 변화가 없거나, 최소화 된다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/proxy.png" >
<figcaption align = "center">프록시 패턴 예시</figcaption>

<br>

##### 프록시 패턴 만들어보기 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/payment.png" >
<figcaption align = "center">payment 인터페이스</figcaption>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/cash.png" >
<figcaption align = "center">cash 클래스</figcaption>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/cashperf.png" >
<figcaption align = "center">cash perf 클래스</figcaption>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/store.png" >
<figcaption align = "center">Store 클래스</figcaption>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/store_test.png" >
<figcaption align = "center">Store Test 클래스</figcaption>


<br>

# 스프링 PSA