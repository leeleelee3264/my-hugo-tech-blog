+++
title = "[Class] [예제로 배우는 스프링 입문] IoC, AOP, PSA 기초"
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
1년 정도 Django를 쓰다 보니 언제부터인가 Spring이 낯설게 느껴졌다. 나와 Spring의 관계, 이대로 괜찮지 않았다. 

Spring이 더 멀어지기 전에 다시 Spring 공부를 시작할 필요를 느꼈다. 어떻게 공부를 할까 고민하던 중, 예전에 인프런에서 백기선님의 Spring 강의를 듣던 게 
생각이 나서 가볍게 들어보기로 했다. 예제로 배우는 스프링 입문 강의는 스프링 트라이앵클이라고 불리는 `IoC`, `AOP`, `PSA`의 기본 개념을 다루고 있다.


<br> 

> 스프링 트라이앵글 = IoC, AOP, PSA 

<br>

# 스프링 IoC

### Inversion Of Control (제어권의 역전)

- <U>내가 사용할 의존성을 내가 직접 만들지 않고, 다른 쪽에서 만들어 줄 것이라 생각하여 제어권을 넘겨준다.</U>
  - 내가 쓸 의존성(객체)를 `new`로 만들지 않는다.  
- 이때 다른 쪽이란 Spring이며, Spring이 `DI`로 의존성을 주입해준다. 
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

- `OwnerController`는 `OwnerRepository` 없이는 아예 생성 조차 될 수 없다. 
- `OwnerRepository`가 꼭 주어진다는 약속 아래에 코드가 만들어졌기 때문에 `OwnerRepository`에 구현되어있는 메서드를 써도 안전하다.

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
  - `OwnerController`를 만든다고 하면 Spring이 `Bean`으로 만들어진 `OwnerRepository`를 가져와 주입을 해준다.
  - Spring이 `IoC 컨테이너`에서 Bean을 관리하고 있기 때문에, 생성자나 어노테이션을 보고 필요한 의존성을 주입해주면서 의존성 관리를 해준다. 

<br> 

> 일반 객체 생성

{{< highlight java  "linenos=true,hl_inline=false" >}}
SimpleClass simpleClass = new SimpleClass();
{{< /highlight >}}

- 위에서는 일반 객체를 생성했다. 이렇게 객체를 생성하면 Spring은 이 객체가 무엇인지 알 수 없다. 

<br> 

### Spring 컨테이너 안에 빈을 등록하는 방법 

#### @Bean 어노테이션

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

#### @Component 어노테이션 
- `Controller`, `Service`, `Configuration` 어노테이션 모두 `Component` 어노테이션을 가지고 있다. 
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

#### Bean과 Component의 차이 
- Spring에서 관리하는 객체를 모두 Bean이라고 하기 때문에 사실 용어 자체로 볼 떄는 Component도 Bean에 포함이 된다.  
- 개발자가 컨트롤 할 수 없는 <U>외부 라이브러리를 빈으로 등록하고 싶을 때 @Bean을 사용한다.</U> 
  - 빈은 `메소드`에 사용한다.
  - 컴포넌트는 `클래스`에 사용한다. 


<br> 

### IoC 컨테이너 
- IoC 컨테이너는 `ApplicationContext` 또는 `BeanFactory`를 사용해서 접근할 수 있다. BeanFactory가 IoC 컨테이너 자체라고 볼 수 있으며, ApplicationContext는 BeanFactory를 상속했다. 
- IoC 컨테이너는 빈을 만들고, 해당 빈을 필요로 하는 곳에 의존성을 주입해준다. <U>Spring에서 의존성 주입은 빈끼리만 가능하다.</U> 의존성 주입을 IoC에서 해주고 있기 때문에 빈이 아니라면 IoC에 들어가지 않아, 관리를 할 수 없다. 

<br> 

### SingleTon

- Bean은 `SingleTon`으로 만들어진다. 그래서 ApplicationContext나 BeanFactory로 Bean을 가져와 인스턴스의 값을 봐보면 매번 같다. <U>SingleTon으로 단 한 번 만 만들어졌기 때문이다.</U> 
- 멀티 쓰레드에서 SingleTon을 만드는 것은 번거로운데 IoC 컨테이너를 사용하면 편하게 싱글톤을 만들 수 있고, 이게 IoC 컨테이너를 사용하는 이유 중 하나이다. 

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

- <U>필수적으로 필요한 파라메터가 없을 때 인스턴스 자체를 만들 수 없어서 강제성을 줄 수 있다.</U>
  - 그런데 가끔 `순환참조`의 문제가 일어날 수 있다. 이럴때는 다른 주입법을 써야 하거나 순환참조가 일어나지 않도록 구조를 짜야 한다. 
- 원래는 생성자에서도 `@Autowired` 를 써야 했는데 Spring 4.3 부터 없어졌다. 

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

#### Bean이 아닌 객체를 의존성 주입하려 하면?
Bean으로 등록하지 않고 @Autowired로 의존성 주입을 해달라고 하면 Spring 입장에서는 모르기 때문에 의존성을 주입해 줄 수 없고, 결과적으로 어플리케이션 자체가 안 뜨게 된다. 

<br>


# 스프링 AOP
`Aspect Oriented Programming`의 약자로, 관점(관심사)를 기준으로 흩어진 코드를 한 곳으로 모으는 기능이다. Spring의 대표적인 AOP로는 `@Transactional`이 있다. 

<br>

> AS-IS 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/aaa.png" >
<figcaption align = "center">[Picture 1] 흩어져있는 코드</figcaption>

<br>


- 같은 동작을 여러 곳에서 하고 있는데, 그 때마다 구현을 했다. 
- AAAA가 변경이 일어난다면, 쓰는 곳에 다 찾아가 고쳐줘야 한다. 
- <U>원래의 기능만 남겨두고 공통적이고 부가적인 기능을 한 곳에 모을 수 없을까?</U> 

<br> 

> TO-BE 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/bbb.png" >
<figcaption align = "center">[Picture 2] 모여있는 코드</figcaption>

<br>

AOP의 핵심은 실제 코드에는 없는데, 런타임에는 마치 있는 것처럼 동작을 한다는 것이다. 이렇게 없던 기능을 쏙 넣어주는 것에는 여러 방법이 있다. 

<br>

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
- A.java에서 컴파일을 해 A.class를 만들면 A.class를 사용할 때 `ClassLoader`로 클래스를 읽어 메모리로 올린다.
- 메모리에 올라가는 A.class의 바이트코드를 조작해서 마치 함수에 AAAA가 있는 것처럼 넣어준다.  
- 이또한 AspectJ가 해준다. 

<br>

#### 프록시 패턴으로 구현하기
- **Spring AOP가 사용하는 방법이다.**
- 디자인 패턴 중 하나인 프록시 패턴을 사용해서 AOP를 구현했다. 
- [[프록시 패턴]](https://www.notion.so/7e4bdf0c9ef049e994f802c0eacea551#db43dcc19ab1480fbdd2c67deaf58582)의 핵심은 <U>기존의 코드를 건드리지 않고 새로운 기능을 추가했다는 점이다.</U> 
  - 이렇게 된다면 클라이언트 코드도 변화가 없거나, 최소화 된다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/proxy.png" >
<figcaption align = "center">[Picture 3] 프록시 패턴 예시</figcaption>

<br>

### 프록시 패턴 만들어보기 

**시나리오**
- `Cash`에서 시간을 축정하는 기능을 추가하고 싶어서 `CashPerf` 프록시 클래스를 만들었다.
- CashPerf를 사용한다고 해도 클라이언트인 `Store`에는 아무런 변경이 없다. 
  - Store를 생성할 떄 의존성으로 Cash 대신 CashPerf를 넣어준다. 이 둘의 인터페이스인 `Payment`를 사용하기 때문에 이렇게 변경해도 문제가 없다. 

<br>


> 인터페이스 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/payment.png" >
<figcaption align = "center">[Picture 4] payment 인터페이스</figcaption>

<br>


> 비즈니스 로직 클래스 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/cash.png" >
<figcaption align = "center">[Picture 5] cash 클래스</figcaption>

<br>


> 프록시 클래스 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/cashperf.png" >
<figcaption align = "center">[Picture 6] cash perf 클래스</figcaption>

<br>

- stopwatch로 시간을 측정하는 부분을 추가했다. 
- _프록스 클래스인 cash perf 클래스에서 비즈니스 로직 클래스인 cash를 호출한다._ 

<br>


> 클라언트 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/store.png" >
<figcaption align = "center">[Picture 7] Store 클래스</figcaption>

<br>


> 테스트 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/store_test.png" >
<figcaption align = "center">[Picture 8] Store Test 클래스</figcaption>



<br>

### Spring AOP 실습 

**목표**
- Spring AOP를 사용해서 API의 응답시간을 측정한다.

<br>


> LogExecutionTime 어노테이션 구현

{{< highlight java  "linenos=true,hl_inline=false" >}}
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD) //이 어노테이션을 어디에 쓸 것인지
@Retention(RetentionPolicy.RUNTIME) // 이 어노테이션 정보를 언제까지 유지할 것인지
public @interface LogExecutionTime {
}
{{< /highlight >}}

- 이렇게 어노테이션만 있으면 아무런 일도 일어나지 않고, 그냥 `주석`과 다름이 없다. 
- <U>이 어노테이션을 읽어서 처리하는 부분이 있어야 한다.</U> -> `Aspect`가 필요하다.

<br>

> 사용처

{{< highlight java  "linenos=true,hl_inline=false" >}}
@GetMapping("/owners/new")
@LogExecutionTime
public String initCreationForm(Map<String, Object> model) {
    Owner owner = new Owner();
    model.put("owner", owner);
    return VIEWS_OWNER_CREATE_OR_UPDATE_FORM;
}
{{< /highlight >}}


<br>

> Aspect 구현

{{< highlight java  "linenos=true,hl_inline=false" >}}
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

@Component
@Aspect
public class LogAspect {

	Logger logger = LoggerFactory.getLogger(LogAspect.class);

	@Around("@annotation(LogExecutionTime)")
	public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();

		Object proceed = joinPoint.proceed();

		stopWatch.stop();
		logger.info(stopWatch.prettyPrint());

		return proceed;
	}
}
{{< /highlight >}}

- @LogExecutionTime를 읽어서 처리하는 부분이다. 
- [Line 15] `Around`: <U>어디 사이에 Aspect를 실행하면 되는지 알려준다.</U> 여기서는 LogExecutionTime 어노테이션 사이로 설정한다.
- [Line 16] `jointPoint`: @LogExecutionTime를 부착한 API 메서드를 뜻한다. 
  - [Line 17]jointPoint를 실행하기 전에 먼저 실행한다. 
  - [Line 20] jointPoint인 API 메서드를 실행한다.
  - [Line 22] jointPoint를 실행한 후 실행한다.
  - [Line 25] jointPoint 실행 결과를 반환한다.


<br>

#### 프록시 패턴예제와 Spring AOP 실습 이해 


프록시 패턴 예제에서는 부가기능을 담은 프록시 클래스인 CashPerf를 만들어줬는데 Spring에서는 <U>@LogExecutionTime를 보고 Spring AOP가 OwnerController 프록시 클래스를 자동으로 만들어준다.</U> 
그리고 이 프록시 클래스 버전의 OwnerController를 직접 주입해주기 까지 한다.

<br>

> 비즈니스 로직이 담긴 클래스

- OwnerController 
- Cash

> 프록시 클래스 

- Spring AOP가 만들어준 OwnerController 프록시 클래스 
- CashPerf 


<br>


AOP는 공부할 부분이 굉장히 많다. 추후에는 `After`, `Before` 와 Aspect로 Exception 처리로직 만들기, 어노테이션 말고도 어디에 또 Around를 걸 수 있는지 등을 공부할 수 있다. 

<br>


# 스프링 PSA
`Portable Service Abstraction`의 약자이다. <U>PSA의 목표는 사용하는 기술스택이 달라도 우리의 코드는 달라지지 않아야 한다는 것이다.</U> 

<br>

### Service Abstraction

Spring으로 `서블릿 어플리케이션`을 만들고 있는데 실제로 `Controller`를 만들어보면 서블릿에 관련된 것을 특별히 코딩하지 않는다. URL 매핑도 `@GetMapping`, `@PostMapping` 을 사용해서 끝내버린다.
서블릿을 직접 조작한다면 아래와 같은 코드를 짜야 했을 것이다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/sb.png" >
<figcaption align = "center">[Picture 9] 서블릿을 직접 사용한다면</figcaption>

<br>

이렇게 간단하게 만들어도 그 밑에서는 서블릿 기반으로 동작한다. _이게 가능한 이유는 밑단의 서블릿 서비스를 추상화 했기 때문이다._ Spring 에서는 서블릿이 포함된 MVC외에도 다양한 Service Abstraction을 제공한다.   

<br>



### Portable 
`Spring web mvc`는 내장된 `tomcat`으로 돌아가고 있다. 이 상태에서 `Spring web flux` 를 도입하면 내장된 서버가 `netty`로 바뀐다. 완벽한 호환이 되는 것은 아니지만, 이렇게 내장 서버를 변경한다고 해도 별도의 변경 없이 실행이 된다.


<U>Spring에서 내장서버를 이미 추상화를 시켰기 때문에 변경이 되어도 지장없이 실행되는 것이다.</U> 말 그대로 내장서버가 Portable(휴대용)이 된 것이다. Spring의 내장서버로는 `tomcat`, `netty`, `jetty`, `undertow` 가 있다.



#### PSA 예시 1: @Controller
- 요청을 매핑할 수 있는 `Controller` 역할을 한다. 
- `@GetMapping` 등으로 요청을 매핑한다. 
  - 매핑: 명시한 URL이 요청으로 들어왔을 때 GetMapping을 부착한 해당 메서드에서 처리한다는 뜻이다. 
  - `path`를 많이 명시해두지만 `header`, `value`, `consumes`, `produces` 등 요청과 관련된 것들로도 매핑이 가능하다. 

<br>

> @GetMapping 


{{< highlight java  "linenos=true,hl_inline=false" >}}
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RequestMapping(
method = {RequestMethod.GET}
)
public @interface GetMapping {
@AliasFor(
annotation = RequestMapping.class
)
String name() default "";

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] value() default {};

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] path() default {};

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] params() default {};

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] headers() default {};

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] consumes() default {};

    @AliasFor(
        annotation = RequestMapping.class
    )
    String[] produces() default {};
}
{{< /highlight >}}

<br>


#### PSA 예시 2: @Transactional 

Spring에서 DB의 All or Nothing인 트랜잭션 개념을 지키기 위해서는 `@Transactional` 만 부착하면 된다. 해당 어노테이션을 쓰지 않는다면 `JDBC 트랜잭션`을 사용해 매번 로우 레벨로 코딩을 해야 한다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/roll.png" >
<figcaption align = "center">[Picture 10] JDBC Transaction</figcaption>

<br>

- `setAutoCommit`을 false로 둬서 DB에 자동으로 반영되는 것을 방지한다. 
- 모든 로직이 성공한다면 commit 해준다. 
- 예외 발생시 catch 하며, 이때까지의 DB 액션은 `rollback`한다. 

<br>

@Transactional은 트랜잭션의 경계를 지정하는 기능이 들어있는 `PlatformTransactionManager` 인터페이스에 구현이 되어있고, <U>PlatformTransactionManager는 내가 어떤 DB 기술 스텍을 사용하는지에 따라 구현체가 달라진다.</U>  

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring/platform.png" >
<figcaption align = "center">[Picture 11] PlatformTransactionManager</figcaption>

<br>

> DB 가술 스텍에 따른 TransactionManager

- JDBC, IBatis SQLMap -> `DataSourceTransactionManager`   
- JPA -> `JpaTransactionManager`    
- Hibernate -> `HibernateTransactionManger`   

<br>

##### 레퍼런스 
- [[트랜잭션 추상화 클래스의 종류와 사용법]](https://springsource.tistory.com/127)
- [[JPA, iBatis, MyBatis, Hibernate ORM]](https://m.blog.naver.com/zzang9ha/221802081128)

<br>




#### PSA 예시 3: Spring Cache 
Spring에서 사용하는 Cache도 PSA로 되어있다. 구현체로는 `javax.cache`, `ehcahe` 등이 있다.
