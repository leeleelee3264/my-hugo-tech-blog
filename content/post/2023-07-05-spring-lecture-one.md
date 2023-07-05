+++
title = "[Class] 스프링 입문 - 코드로 배우는 스프링 부트, 웹 MVC, DB 접근 기술"
date = "2023-07-05"
description = "스프링 입문 - 코드로 배우는 스프링 부트, 웹 MVC, DB 접근 기술 강의를 들의며 정리한 노트를 포스팅한다."
tags = ["Backend"]
+++

===
규칙
1. 포스트 앞에는 항상 summary와 index를 작성한다. 
2. big title과 middle title 사이에는 br이 없다. 
3. middle title, small title, image, example 사이에는 br이 있다. 
4. image 전에 설명을 써두도록 한다. 
5. image caption은 [Picture 1] 설명설명 식으로 작성한다. 
6. image 사이즈는 height 400 width 500
7. 여러 줄의 코드를 쓸 때에는 highlight를 사용한다. 넘버링이 default로 되어있다. 
8. 한 줄의 코드를 쓰거나 코드가 아닐 경우에 (url 등) markdown code block을 사용한다.
9. link 를 할 때에는 [링크] 로 해두어, 링크임을 식별할 수 있도록 한다. 
10. 정렬을 할 때는 1,2,3,4 보다는 - 으로 dot 정렬을 사용한다. 
=== 

<br>
<br> 

> 스프링 입문 - 코드로 배우는 스프링 부트, 웹 MVC, DB 접근 기술 강의를 들의며 정리한 노트를 포스팅한다.

<br> 

**Index**
1. session 1 라이브러리
2. session 2 View 환경설정 
3. 

<br> 

# session 1 라이브러리

<U>로그</U>
slf4j → 인터페이스이다.
logback → slf4j를 구현한 구현체, 요즘은 logback을 쓰는 추세이다.    


<U>테스트</U>
Junit이 5로 넘어갔다. → 거의 다 5를 쓰는 추세이다.
부가 라이브러리: assertj, mockito


<br>

# Session 2 View 환경 설정 
 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/viewResolver.png" >
<figcaption align = "center">[Picture 1] ViewResolver가 View를 찾는 방법</figcaption>

<br>

viewResolver는 view를 찾아서 model과 함께 타임리프 엔진에 넘긴다 → 타임리프 엔진이 모델에 있는 값으로 변환 작업을 한다. 

<br>

# session 3 빌드

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/build.png" >
<figcaption align = "center">[Picture 2] 빌드하고 실행하기</figcaption>


`no main manifest attribute, in hello-spring-1.0-SNAPSHOT.jar` 이 에러가 났는데 나는 프로젝트를 spring으로 생성하지 않고, plan java로 생성했어서 초기 설정이 부족해서 발생하는 에러라고 판단했다. 때문에 빈번하게 일어나는 에러라 생각하지 않아, 조치를 취하지 않았다. 

<br>

# session 4 정적 컨텐츠 
static 디렉터리 밑에 컨텐츠를 만들면 아무것도 안 해도 매핑이 된다. 만약 static/hello-static.html 을 만들었다면 [localhost:8080/hello-static.html](http://localhost:8080/hello-static.html) 를 치고 들어가면 컨텐츠를 볼 수 있다. 

정적 컨텐츠 요청이 오면 맨 처음에 `일반 API 요청처럼 이 url과 연결되어있는 컨트롤러를 먼저 찾는다`. 그 뒤에 없으면 static 파일을 뒤져서 결과를 반환한다. → 컨트롤러가 우선순위가 높다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/static.png" >
<figcaption align = "center">[Picture 3] 정적 컨텐츠</figcaption>

<br>


# session 5 MVC와 템플릿 엔진

MVC 패턴 - `관심도 쪼개기와 역할 분리`

{{< highlight java  "linenos=true,hl_inline=false" >}}

@GetMapping("hello-mvc")
public String helloMvc(@RequestParam("name") String name, Model model) {
    model.addAttribute("name", name);
    return "hello-template";
}
{{< /highlight >}}

요청 url: localhost:8080/hello-mvc?name=leelee

`Commnd + p` → 메서드에 대한 파라메터 정보 보기

<br>

# session 6 API

{{< highlight java  "linenos=true,hl_inline=false" >}}

@GetMapping("hello-mvc")
@ResponseBody
public String helloString(@RequestParam("name") String name) {
    return "hello" + name;
}
{{< /highlight >}}


`@ResponseBody` → HTTP Body 부분에 내가 직접 값을 넣어서 주겠다. 그래서 실제 HTTP 응답을 보면 Body 부분에는 컨트롤러가 리턴해준 값만 들어가 있다. 


class를 생성해서 응답으로 넣어주면 그게 바로 key-value 형태의 json 방식이다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/json.png" >
<figcaption align = "center">[Picture 4] json</figcaption>

`@ResponseBody` 어노테이션이 있으면 viewResolver를 호출하지 않는다. 대신 `HttpMessaheConverter`를 호출한다. (객체, String 외의 타입도 내장이 되어있다) 

객체(class) 라면 → JsonConverter (MappingJackson2HttpMessageConverter)
그냥 string이라면 → StringConverter 

<br> 

Json 라이브러리  
Jackson vs Gson(Google) → Spring에는 Jackson이 기본으로 내장되어있다. 큰 Json의 경우에는 Jackson이 성능이 좋고 작은 Json은 Gson이 성능이 좋다고.   

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/converter.png" >
<figcaption align = "center">[Picture 5] converter</figcaption>

<br>

`Command + Shift + Alt` → 괄호 닫고 자동으로 세미콜론도 붙혀준다. 

<br>

# session 7 비즈니스 요구사항 정리

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/arch.png" >
<figcaption align = "center">[Picture 6] 일반적인 웹 애플리케이션 계층 구조</figcaption>


맨날 드는 생각: 객체 값 바꾸는 것은 도대체 어디서 해야 할까? 서비스일까 도메인일까? 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/depend.png" >
<figcaption align = "center">[Picture 7] 클래스 의존관계</figcaption>

<br>

# session 8 회원 도메인과 리포지토리 만들기

요즘은 null을 그대로 반환하기 보다는 `Optional`로 감싸서 반환하는 걸 선호한다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Override
public Optional<Member> findById(Long id) {
    return Optional.ofNullable(store.get(id));
}
{{< /highlight >}}

동시성 문제가 있을 수 있을 때는 일반 Map이 아니라 `ConcurrentHashMap`을 써야 한다. Long 같은 경우도 동시성 문제가 있을 때는 `AtomicLong`을 사용한다. 

<br>

# session 9 회원 리포지토리 테스트 케이스 작성

{{< highlight java  "linenos=true,hl_inline=false" >}}
import static org.assertj.core.api.Assertions.assertThat;
		
@Test
void save() {
    Member member = new Member();
    member.setName("spring");

    repository.save(member);

    Member rst = repository.findById(member.getId()).get();
    assertThat(member).isEqualTo(rst);
    }
{{< /highlight >}}

`org.junit.jupiter.api` 에서 제공하는 assert도 있지만, `org.assertj.core` 는 assert를 조금 더 편하게 사용할 수 있어서 실무에서 많이 사용한다. `spring-boot-starter-test` 를 디펜던시로 넣어야 사용할 수 있다. 

테스트 순서는 보장이 안된다, 그래서 순서에 의존적으로 테스트를 작성하면 안된다. 하나의 테스트가 끝날 때마다 환경을 정리해주는 코드를 호출해야 한다. (clearStore는 직접 구현) 

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

	@AfterEach
    public void afterEach() {
        repository.clearStore();
    }
{{< /highlight >}}

<br>

# session 10 회원 서비스 개발

`command + option + v` → 리턴을 받아주는 코드를 만들어준다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

Optional<Member> rst = memberRepository.findByName(member.getName());
rst.ifPresent(m -> {
    throw new IllegalStateException("이미 존재하는 회원입니다.");
});
{{< /highlight >}}

Optional로 감쌌기 때문에 Optional에서 제공하는 여러 함수를 사용할 수 있다. 그리고 더이상 null check를 할 때  `if rst == null` 이런식으로 코딩하지 않는다.
Optional에 들어있는 값을 get으로 바로 꺼내는 걸 권장하지는 않는다. 

<br>

`ctrl + t` → 코드를 리팩터링 하는 방안을 추천해준다. 

`commnd + optional + m` → 코드 리팩터링 중 method 추출해서 만들어준다. 

내 생각처럼 레포지토리는 단순 무식하게 DB 왔다갔다 하는 기능으로 만드는 게 맞고, 서비스는 각종 비즈니스 로직이 들어가게 개발해야 한다. 그래서 레포지토리의 함수 이름은 단순하고 서비스의 함수 이름은 비즈니스와 유사하게 만든다. 

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}
// repository 
void save() {}
Member findbyName(String name) {}

// service 
void join() {} // 회원가입
Member findMember() {} // 어쨌든 맴버를 찾겠다는 의미가 더 강하다
{{< /highlight >}}

테스트 코드 함수는 한글 이름으로 적어도 된다~ 실제로 실무에서도 한글로 많이 쓴다. 
<br>

테스트 코드 짤 때 머리 가슴 배 처럼 3단 구성을 하면 좋다. 심지어 코드에 주석으로 3단 구성 쓰는 것도 좋다고. 

{{< highlight java  "linenos=true,hl_inline=false" >}}
    @Test
    void 회원가입() {
        // given -> 뭔가 주어졌을 때  
        
        // when -> 이걸 실행하면 
        
        // then -> 뭐가 나와야 한다. 
    }
{{< /highlight >}}

<br>

`ctrl + r` → 이전에 실행했던 것을 다시 실행해준다. 

`command + n` → Generator (생성자, 게터, 세터 등) 

<br>

# session 11 컴포넌트 스캔과 자동 의존관계 설정

Spring을 쓰려면 어지간한 것들은 Spring Bean으로 등록해서 쓰는 게 이점이 훨씬 많다. Bean은 싱글톤 객체로 등록이 된다. 단 하나의 인스턴스를 만들어 두고 여기 저기서 쓴다는 것이다. 

**TODO: 왜 싱글턴으로 만들어두는지 정리하기**



컴포넌트 에노테이션을 써서 스프링 컨테이너에 빈으로 등록된다. 이 빈들의 의존관계를 (생성자에 파라메터로 들어가는 것) 스프링이 파악해서 직접 의존관계를 주입해준다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/container.png" >
<figcaption align = "center">[Picture 8] 스프링 컨테이너</figcaption>

<br>

아무 곳에나 컴포넌트를 설정하면 안되고, `SpringBootApplication`이 있는 패키지의 밑에다가 설정해줘야 한다. 그래서 SpringBootApplication 어노테이션 안에 있는 `ComponentScan` 어노테이션이 컴포넌트를 스캔해서 스프링 컨테이너에 넣어줄 수 있다. 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/dir.png" >
<figcaption align = "center">[Picture 8] 스프링 디렉터리</figcaption>



<br>

# session 12 자바 코드로 직접 스프링 빈 등록하기

Bean 어노테이션을 사용해 Spring에 등록한다. 하지만 아무래도 편한 형식은 ComponentScan을 이용하는 방식이다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}
@Configuration
public class MemberConfig {

    @Bean
    public MemberService memberService() {
        return new MemberService(memberRepository());
    }

    @Bean
    public MemberRepository memberRepository() {
        return new MemoryMemberRepository();
    }
}
{{< /highlight >}}

<br>

**TODO: 언제 ComponentScan을 쓰고 언제 Bean을 쓰는지**

<U>ComponentScan</U> 

- 실무에서 주로 사용한다.
- 형태가 정해진 (정형화된) Controller, Service, Repository에서 많이 쓰인다.


<U>Bean</U> 

- 상황에 따라서 구현체를 바꿔야 할 때 많이 쓰인다.
    - ComponentScan에서는 어노테이션을 기존 구현체에서 삭제하고, 새로운 구현체에 붙여줘야 한다.
    - Bean으로 만들었다면 new 하는 부분에 새로운 구현체 넣어주면 된다.

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

MemoryMemberRepository를 JpaMemberRepository로 바꿀 때 

// componentscan 
~~@Repository~~
public class MemoryMemberRepository implements MemberRepository{} 

@Repository
public class JpaMemberRepository implements MemberRepository{} 

// bean
@Bean
public MemberRepository memberRepository() {
     return new JpaMemberRepository();
}
{{< /highlight >}}


개방-폐쇄 원칙 (OCP, Open-Closed Principle) 

ComponentScan 또는 Bean을 사용하면 MemberRepository에 의존성을 가지고 있는 MemberService에 아무런 수정을 가하지 않아도 된다. Spring의 DI가 다 해줬다. 

→ 설령 생성자 등의 조립하는 코드에는 변경이 갈 수 있더라도 실제 동작하는 코드에는 변경이 없다. 인터페이스 짱! 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/inter.png" >
<figcaption align = "center">[Picture 9] 인터페이스와 스프링</figcaption>

<br>

### 주입 방법 

<U>생성자 주입</U>

- 권장하는 방식이다.
- Autowired 어노테이션을 안 써도 된다. → 생성자가 딱 하나일때만 Autowired를 생략해도 된다.

<U>필드 주입</U>

- Autowired을 쓴다.
- 단점: 스프링이 뜰 때 주입되는 객체를 바꿀 수 없다. 예를 들어 생성자 형태를 쓰면 interface를 쓰고 실제 주입은 구현체를 쓸 수 있는 건데 Autowired는 안된다.

<U>setter 주입</U>

- 단점: 주입하는 setter가 public으로 열려있다.  주입 받는 객체를 setter로 바꿀 수 있다. 생성자로 객체를 조립하면 그 이후 주입에 수정이 없어야 하는데 런타임에 동적으로 setter로 바꿀 수 있으니 치명적이다.

<br>

# session 13 순수 JDBC

DB의 발전 순서 

1. 순수 JDBC
2. JdbcTemplate, Mybatis 
3. JPA
4. 스프링 데이터 JPA

순수 JDBC API를 사용한 DB 접근은 20년 전 쯤에 사용하던 방법이다. 커넥션도 직접 가지고 오고 닫아주는 등의 작업을 해야 해서 코드가 아주 길어진다. JPA 자제도 나온지 시간이 좀 지났고, 이제는 JPA를 또 한 번 정리한 스프링 데이터 JPA를 사용한다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

    @Override
    public Optional<Member> findById(Long id) {
        String sql = "select * from member where id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                Member member = new Member();
                member.setId(rs.getLong("id"));
                member.setName(rs.getString("name"));
                return Optional.of(member);
            } else {
                return Optional.empty();
            }
        } catch (Exception e) {
            throw new IllegalStateException(e);
        } finally {
            close(conn, pstmt, rs);
        }
    }
{{< /highlight >}}


<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}
# 스프링과 db가 붙기 위해 필요한 라이브러리
implementation 'org.springframework.boot:spring-boot-starter-jdbc'

# 각 db가 제공하는 클라이언트가 필요하다. h2 클라이언트 라이브러리
runtimeOnly 'com.h2database:h2'
{{< /highlight >}}


그럴 일은 거의 없지만 ring 프레임워크를 사용할 때 DB 커넥션을 직접 가지고 와야 한다면 아래의 방법을 사용해야 한다. 트랜잭션 등의 이유로 같은 커넥션을 유지해야 하기 때문이다. 

커넥션을 가져왔다면 커넥션을 끊는 부분도 꼭 해줘야 한다. DB 커넥션이 `네트워크 자원`이라 쌓이면 장애가 될 수 있다.

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

import org.springframework.jdbc.datasource.DataSourceUtils;

private Connection getConnection() {
        return DataSourceUtils.getConnection(dataSource);
}

private void close(Connection conn) throws SQLException {
        DataSourceUtils.releaseConnection(conn, dataSource);
}
{{< /highlight >}}

<br>

# session 14 스프링 통합 테스트

{{< highlight java  "linenos=true,hl_inline=false" >}}
@SpringBootTest
@Transactional
class MemberServiceIntegrationTest {
... 
}
{{< /highlight >}}


`@SpringBootTest` 는 스프링을 띄워서 테스트 한다. 이를 통합테스트라고 한다. 

`@Transactional`을 쓰면 테스트 끝나고 DB를 다 롤백을 해서 DB를 지워준다. 테스트 메소드 **하나하나**에 적용이 된다. 

스프링 컨테이너를 띄우지 않은 순수한 자바를 이용한 단위 테스트를 만드는 게 진짜 좋은 테스트다. 컨테이너까지 띄워야 한다면 테스트 단위를 잘못 잡은 것이다. 

프로덕션이 커질수록 테스트 케이스는 중요해진다. `꼼꼼하게 테스트 케이스`를 작성하려고 노력하자. 

<br>

# session 15 스프링 JdbcTemplate

JdbcTemplate이나 Mybatis를 사용하면 커넥션을 얻어오는 등의 반복적으로 사용하는 Jdbc API 호출을 직접 하지 않아도 된다. 하지만 쿼리는 직접 짜야한다. JdbcTemplate은 실무에서도 많이 쓴다. 

> 사용 법 

{{< highlight java  "linenos=true,hl_inline=false" >}}
private final JdbcTemplate jdbcTemplate;

public JdbcTemplateMemberRepository(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
}

@Override
public Optional<Member> findById(Long id) {
      List<Member> rst = jdbcTemplate.query("select * from member where id = ?", memberRowMapper());
      return rst.stream().findAny();
}

private RowMapper<Member> memberRowMapper() {
      return (rs, rowNum) -> {
            Member member = new Member();
            member.setId(rs.getLong("id"));
            member.setName(rs.getString("name"));
            return member;
        };
}
{{< /highlight >}}

<br>

# session 16 JPA

JPA를 쓰면 데이터 중심 사고에서 객체 중심의 사고가 가능하다고 한다. (더 써봐야 알듯) JPA는 표준이고 JPA의 구현체가 hibernate다. 


{{< highlight java  "linenos=true,hl_inline=false" >}}
@Entity
public class Member {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
{{< /highlight >}}


`@Entity` → JPA가 관리하는 객체를 뜻한다. 

`@GeneratedValue(strategy = GenerationType.IDENTITY)` → DB가 자동으로 만들어주는 전략을 뜻한다. 

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

public class JpaMemberRepository implements MemberRepository{

    private final EntityManager em;

		@Override
    public Optional<Member> findByName(String name) {
        List<Member> member = em.createQuery("select m from Member m where m.name = :name", Member.class)
                .setParameter("name", name)
                .getResultList();

        return member.stream().findAny();
    }
}

<br>

JPA를 쓰려면 EntityManager가 꼭 있어야 한다. EntityManager가 내부에 DataSource도 들고 있다. JPA에서 사용하는 쿼리인 `JPQL`은 대상이 Entity다. 그래서 결과값도 Entity를 가져온다.

<br>

`command + option + n` → inline return 만들어준다. 

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Transactional
public class MemberService {

    private final MemberRepository memberRepository;
}
{{< /highlight >}}


select를 제외한 JPA 쿼리문은 모두 트랜잭션 안에서 동작해야 하기 때문에 JPA repository를 사용하는 Service에 `@Transational`을 부착한다. 

<br>

# session 17 스프링 데이터 JPA

기본: Spring boot + JPA + 스프링 데이터 JPA 

스프링 데이터 JPA는 JPA를 편하게 사용할 수 있도록 도와주는 기술이다. 그래서 JPA를 먼저 공부하는 게 좋다. 

<br>

스프링 데이터 JPA를 쓰면 인터페이스만으로 개발을 완료할 수 있고 기본적인 CRUD는 코드를 쓸 필요도 없다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

public interface SpringDataJpaMemberRepository extends JpaRepository<Member, Long>, MemberRepository {

    @Override
    Optional<Member> findByName(String name);
}

{{< /highlight >}}


findByName 메소드도 사실 직접 구현을 하지 않았다. By어쩌구, By어쩌구And저쩌구 이런 식으로 컨벤션을 맞추면 스프링 데이터 JPA가 JPQL을 알아서 만들어준다. (reflection)

`JpaRepository`를 상속 받았으면 `SpringDataJpaMemberRepository`의 구현체도 Spring이 알아서 만들어준다. (Proxy Pattern) 그래서 조립하는 부분에서도 구현체를 넘겨줄 필요 없이 MemberRepository를 생성자에 넣어두기만 하면 된다. 

<br>

{{< highlight java  "linenos=true,hl_inline=false" >}}

private final MemberRepository memberRepository;

    public MemberConfig(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

//    실제 구현체를 내가 구현해서 직접 넘겨줄 필요가 없다. 
//    @Bean
//    public MemberRepository memberRepository() {
//        return new JpaMemberRepository(em);
//    }
{{< /highlight >}}


<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/data.png" >
<figcaption align = "center">[Picture 10] 스프링 데이터</figcaption>

<br>

페이징 기능까지 기본으로 제공해준다. 

실무에서 JPA + 스프링 데이터 JPA를 기본으로 깔고 복잡한 동적 쿼리는 Querydsl이라는 라이브러리를 쓴다. 앞의 3개도 커퍼가 안되면 JPA에서 네이티브 쿼리를 제공해서 생쿼리를 작성할 수 있다. 

<br>

# session 18 AOP가 필요한 상황

**TODO: 함수 소요 시간 측정 말고도 AOP가 필요한 상황이 언제 있을까**

`공통 관심 사항` ↔ `핵심 관심 사항`

공통 관심 사항은 시간 측정 등 함수들에 공통적으로 적용되는 관심사항을 뜻한다. 핵심 관심 사항은 함수마다 가지고 있는 비즈니스로직을 뜻한다. 

공통 관심 사항을 메소드 하나하나에 만들어주려면 너무 힘들다. 게다가 핵심 관심 사항이 중요한데 로직이 섞여서 관리도 어려워진다. 그리고 함수 소요 시간 측정 같은 건 함수 시작 ~ 함수 끝 시점도 잘 잡아내야 한다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

/**
 * 전체 회원 조회
 */
 public List<Member> findMembers() {
	 long start = System.currentTimeMillis();

	 try {
		 return memberRepository.findAll();
	} finally {
		 long finish = System.currentTimeMillis();
		 long timeMs = finish - start;
		 System.out.println("findMembers " + timeMs + "ms");
	 }
 }
{{< /highlight >}}

<br>

# session 19 AOP 적용

Aspect Oriented Programming → Aspect (관점), 공통 관심 사항과 핵심 관심 사항을 분리해준다. 


{{< highlight java  "linenos=true,hl_inline=false" >}}
@Bean
public TimeTraceAop timeTraceAop() {
       return new TimeTraceAop();
}
{{< /highlight >}}

AOP 빈을 사용하려면 @Component 어노테이션을 써도 되지만, Configuration에 선언해서 쓰는 걸 더 선호한다. 컨트롤러나 서비스처럼 정형화된 빈이 아니고, 특별한 빈이니 명시적으로 표시한 것이다. 

<br>

프로그램이 실행될 때 중간에 `ProceedingJoinPoint`로 인터셉트를 해서 내가 원하는 작업을 한다. 그리고 `Around`로 AOP 적용 대상을 설정할 수 있다. 

{{< highlight java  "linenos=true,hl_inline=false" >}}

    @Around("execution(* hello.hellospring..*(..))")
    public Object execute(ProceedingJoinPoint joinPoint) throws Throwable{
        long start = System.currentTimeMillis();
        System.out.println("START: " + joinPoint.toLongString());

        try {
            return joinPoint.proceed();
        } finally {
            long finish = System.currentTimeMillis();
            long timeMs = finish - start;

            System.out.println("END: " + joinPoint.toString() + " " + timeMs + "ms");
        }
    }
{{< /highlight >}}


<br>

AOP는 `프록시 패턴`을 이용해서 구현했다. AOP가 적용이 되는 대상 클래스라면 Spring에서 각 클래스의 프록시 클래스를 만들어낸다. 그래서 원하는 작업 (로그 찍기) + 클래스의 비즈니스 로직이 들어간 프록시 클래스를 만들고, 실제 서버가 돌아갈 때도 프록시 클래스를 호출한다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/aop.png" >
<figcaption align = "center">[Picture 11] aop</figcaption>

<br>

생성된 클래스의 이름을 알기 위해 로그를 찍어보면 프록시 클래스가 찍힌다. 

**TODO: CGLIB가 뭔지 알아보기**

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/spring-1/gclin.png" >
<figcaption align = "center">[Picture 12] Proxy Class</figcaption>

<br>

# session 20 다음으로

<U>프레임워크를 쓰면서 필요한 능력</U> 

이게 왜 필요하지? (핵심 원리 이해), 문제가 발생했을 때 어디부터 찾아들어가면 될지, 문제를 해결하기 위해 어떤 기능을 사용해야 하는지를 파악하고 있으면 된다. 스프링의 전체를 세세하게 다 알 수 는 없다.