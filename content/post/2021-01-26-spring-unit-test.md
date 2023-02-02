+++
title = "[Backend] (en) Test Spring Boot with Junit5"
date = "2021-01-26"
description = "Test Spring boot with Junit5: Repository test, service test, controller test, integration test."
tags = ["Backend"]
+++


<br>
<br> 

> Test Spring boot with Junit5: Repository test, service test, controller test, integration test. 

<br> 

**Index**
1. Why unit test?  
2. Implement unit test 

<br> 

# Why unit test? 

Making test code is always big burden for me. No time for writing test code, and also don't know how. What is `@SpringBootTest` and `Junit`?  

The main point of making _test code has to be united!_ Do not test whole flow! TBH I've usually done test e2e way. 
I thought test with spring boot test code is so heavy that I have to wait for server reload a lot. And now I know it happened because I tried to test entire program. It is just like the server I had written right before the test. My bad.

There are three parts of testing code. I'll cover step-by-step. I got a lot of help from [[Testing Spring Boot]](https://www.baeldung.com/spring-boot-testing)! Should check before working with test code. 

> Test Code Step 
1. Repository (JPA) test
2. Service test
3. Controller test
4. Integrate test

<br>

# Implement unit test 

### Basic libs for test in spring boot

I had no idea how people use `assertThat`, because I only got `assert`. It turned out that I have to install additional lib `junit`. I thought all the test function was built in `spring-boot-starter-test`. Silly me.

There are so many options of test function include assertThat and assert. I'm quite sure I do have to check as soon as possible to handle junit test 100%. Take a look at [[Junit test function]](https://junit.org/junit5/docs/snapshot/user-guide/index.html)

<br>

> junit5 library

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

 testImplementation('org.springframework.boot:spring-boot-starter-test') {
        exclude group: 'org.junit.vintage', module: 'junit-vintage-engine'
    }

testCompile group: 'org.junit.jupiter', name: 'junit-jupiter-api', version: '5.7.0'
{{< /highlight >}}


<br>


### Repository test 


> UserRepository 

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Repository
public interface UsersRepository extends JpaRepository<UsersVO, Long> {

    List<UsersVO> findByName(String name);

    List<UsersVO> findByNameLike(String name);

    /**
     * jpa update 는 분명 모든 것을 한 큐에 업데이트 하는 그런.. 성격인가봄
     * @param id
     * @param name
     */
    @Modifying
    @Query("update users u " +
            "set u.name = :name " +
            "where u.id = :id")
    void updateName(@Param(value = "id") long id, @Param(value = "name") String name);
}
{{< /highlight >}}


<br> 

> Test code for UserRepository

{{< highlight java  "linenos=true,hl_inline=false" >}}

@ExtendWith(SpringExtension.class)
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class UsersRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private UsersRepository usersRepository;

    @Test
    public void whenSave_thenReturnUsers() {
        UsersVO jpaEntity = UsersVO.builder()
                .name("tryNoDB")
                .salary(20000)
                .build();

        entityManager.persist(jpaEntity);
        entityManager.flush();

        UsersVO saved = usersRepository.save(jpaEntity);
        assertThat(saved.getName()).isEqualTo(jpaEntity.getName());
    }

    @Test
    public void should_update_name_by_id() {
        long id = 2;
        String name = "Jamie";
        String notName = "rer";

        // entityManager 은 진짜 jpa 에 있는 entity 를 위한거다.
        // jpa entity 가 아니면 못 쓴다는 소리임임
//       entityManager.persist(id);
//        entityManager.flush();;

        usersRepository.updateName(id, name);
        List<UsersVO> updated = usersRepository.findByName(name);

        assertThat(updated.get(0).getName()).isEqualTo(notName);
    }
}
{{< /highlight >}}


<br>

#### Code detail 

- `@ExtendWith(SpringExtension.class)`
  - Making a connection between spring boot and junit during test
- `@DataJpaTest`
  - Building test env for database. It configured in memory H2 db to divide our real db during the test.
- `TestEntityManager`
  - Putting sample data before testing. Because H2 db is empty.
  
<br>

#### Mistake: Test with Real Data 
  I'm a very beginner of JPA. I quite know nothing about JPA, but I know `persistence` is great deal in JPA. To keep this policy we should use `EntityManager`. I guess it's something like cache before commit to real db. 


  And I have so many experiences updating our real db record during test. The change didn't go back either. Now I think I know why. I have to use `@DataJpaTest` to make fake env for db testing. Keep in mind it only takes `@Entity` object.


Take a look at [[JPA test doc]](https://bezkoder.com/spring-boot-unit-test-jpa-repo-datajpatest/) for more test code for JPA. 

<br>

### Service test

> UsersService Interface

{{< highlight java  "linenos=true,hl_inline=false" >}}

public interface UsersService {

    List<UsersVO> findByName(String name);
    List<UsersVO> findByNameLike(String name);
    UsersVO save(UsersVO vo);
}
{{< /highlight >}}


<br>

> UserService Implementation 

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Slf4j
@Service
public class UsersServiceImp implements UsersService {

    @Autowired
    private UsersRepository usersRepository;

    @Override
    public List<UsersVO> findByName(String name) {
        try {
            return usersRepository.findByName(name);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    @Override
    public List<UsersVO> findByNameLike(String name) {
        try {
            return usersRepository.findByNameLike(name);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    @Override
    public UsersVO save(UsersVO vo) {
        usersRepository.save(vo);
        return vo;
    }
}
{{< /highlight >}}

<br>

> Test Code for UsersService

{{< highlight java  "linenos=true,hl_inline=false" >}}

@ExtendWith(SpringExtension.class)
class UsersServiceImpTest {

    // 일단 test code 에서 autowired 하는데 필요한 형식이다
    @TestConfiguration
    static class UsersServiceTestConfiguration {

        @Bean
        public UsersService usersService() {
            return new UsersServiceImp();
        }
    }

    @Autowired
    UsersService UsersService;

    // 이렇게 mock 으로 해두면 진짜 리포지토리 부르는 걸 우회한다.
    @MockBean
    private UsersRepository usersRepository;

    @BeforeEach
    public void setUp() {
        UsersVO test = UsersVO.builder()
                .name("test_account")
                .salary(1000)
                .build();

        Mockito.when(usersRepository.findByName(test.getName()))
                .thenReturn(Collections.singletonList(test));
    }

    @Test
    public void whenValidName_thenUsersShouldBeFound() {
        String name = "test_account";
        List<UsersVO> found = UsersService.findByName(name);

        assertThat(found.get(0).getName()).isEqualTo(name);
    }

    @Test
    void whenSaved_thenUsersShouldBeReturned() {
        UsersVO test = UsersVO.builder()
                .name("dummy_account")
                .salary(1000)
                .build();

        UsersVO saved = UsersService.save(test);

        assertThat(saved.getName()).isEqualTo(test.getName());
    }
}
{{< /highlight >}}

<br>

Service layer injects Repository (aka persistence layer) but in test, service layer don't have to know how it works.
It means we have to make full service test code without wiring repository and we can do it with _Mocking_ function. It literally mock repository. 

<br>


#### Code detail

- `@TestConfiguration`
  - At first, I couldn't understand why I use the annotation. UsersServiceImp is already made as @Bean and official doc told me the annotation is used to wire UsersServiceImp and work like bean. 
  - It's because UserServiceImp is _implementation_. In normal situation, our smart spring will load UsersServiceImp even though we wrote UsersService but it's not working in the test, so we have to do it _manually_. @TestConfiguration help the test to do this process. 

- `@MockBean`
  - In test env, everything is independent. We have to test service without real repository unless we test both of them. @MockBean help to make _fake, mocked repository_ for service. 
  - It's mocked so basically it's not connected with the _real db_ and it means we have no data. In `setUp()` method, we have to make homemade preparation. Set up Mocked data and even make mock repository action there.

<br>


### Controller test
Controller test code is just like Service test code. Don't have to know  service, only focus on controller part.

> ApiController

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Slf4j
@Controller
@RequestMapping("/api")
public class ApiController {

    private final UsersServiceImp usersServiceImp;

    public ApiController(UsersServiceImp usersServiceImp) {
        this.usersServiceImp = usersServiceImp;
    }

    @PostMapping("/bean/valid")
    @ResponseBody
    public ResponseEntity beanValid(@Valid @RequestBody MessageDTO messageDTO) {
        String value = messageDTO.getMessage();
        return new ResponseEntity<>("Your request is accepted!", HttpStatus.OK);
    }

    @GetMapping("/jpa/get")
    public String getByJpa(
            @RequestParam @Nullable String name,
            Model model
    ) {
        List<UsersVO> users =  usersServiceImp.findByName(name);

        model.addAttribute("userList", users);
        return "mockTest";
    }

    @PostMapping("/jpa/save")
    @ResponseBody
    public ResponseEntity saveByJpa(
        @Valid @RequestBody UsersVO usersVO
    ) {
        UsersVO result = usersServiceImp.save(usersVO);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
{{< /highlight >}}


<br>

> Test Code for ApiController 

{{< highlight java  "linenos=true,hl_inline=false" >}}

// @SpringBootTest 이 어노테이션을 쓰면 통합 테스트가 된다. unit 테스트에서 지향해야 함. 그리고 이건 실제 db 가 엑세스가 된다.
@ExtendWith(SpringExtension.class)
// 이 어노가 있으면 마치 ApiController 만 있는 것처럼 스프링 부트를 제한해준다.
@WebMvcTest(ApiController.class)
class ApiControllerTest {

    // 얘가 바로 full http server 시작 안 하고 controller 테스트 할 수 있게 해주는 것!
    @Autowired
    private MockMvc mvc;

    @MockBean
    private UsersServiceImp usersServiceImp;

    @Autowired
    protected ObjectMapper objectMapper;

    protected String asJsonString(final Object object) throws JsonProcessingException {
        return objectMapper.writeValueAsString(object);
    }

    @Test
    public void givenUsersVO_whenGetUsersVO_thenReturnPOJO() throws Exception {

        UsersVO dummy = UsersVO.builder()
                .name("jamie")
                .salary(1000)
                .build();

        given(usersServiceImp.save(dummy)).willReturn(dummy);

        mvc.perform(post("/api/jpa/save")
                .content(asJsonString(dummy))
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is(dummy.getName())));

    }

}
{{< /highlight >}}

<br>


#### Code detail

- `@WebMvcTest` 
  - Annotation will make MVC infrastructure to our test condition.
  - It makes spring boot server which _only has ApiController_.  
  - Furthermore, MockMvc provide super easy controller test env _without loading entire server_. (light and fast!)

- `@SpringBootTest`
  - Blind it for integration test aka test everything! 
  - It doesn't make mock bean, so it will do read and write your db. You should be aware this.

<br>



### Integrate test

And in addition, I already made integration test using `@SpringBootTest`
It did not make any mock bean so that it always access real db. In this code, I can check GET page answer too.

<br>


> ControllerTestFrame.class

{{< highlight java  "linenos=true,hl_inline=false" >}}

@SpringBootTest
@AutoConfigureMockMvc
public abstract class ControllerTestFrame {

    protected MockMvc jsonMock;

    @Autowired
    protected ObjectMapper objectMapper;

    abstract protected Object controller();

    protected String asJsonString(final Object object) throws JsonProcessingException {
        return objectMapper.writeValueAsString(object);
    }

    @BeforeEach
    private void setup() {
        jsonMock = MockMvcBuilders.standaloneSetup(controller())
                // to bind exception with mockMvc
                .setControllerAdvice(new MyExceptionHandler())
                .addFilter(new CharacterEncodingFilter(StandardCharsets.UTF_8.name(), true))
                .alwaysDo(print())
                .build();

    }

}
{{< /highlight >}}

<br>


> Test code for Integrate test 

{{< highlight java  "linenos=true,hl_inline=false" >}}

public class ApiControllerTestNotUnit extends ControllerTestFrame {

    @Autowired
    private ApiController apiController;

    @Override
    protected Object controller() {
        return apiController;
    }

    /**
     *  mvc test with post param POJO
     * @throws Exception
     */
    @Test
    public void beanValid() throws Exception {

        MessageDTO user = new MessageDTO(1, "", "434", "r3r3r");

        jsonMock.perform(post("/api/bean/valid")
            .contentType(MediaType.APPLICATION_JSON)
            .content(asJsonString(user)));
    }

    /**
     * test get page with param
     * 이 형태는 아무래도 실제로 spring application 을 띄운게 아니라서 modelandview 정보만 찍어주고 실제는 파악이 힘든 듯
     */
    @Test
    public void getByJpa() throws Exception {

        MultiValueMap<String, String> param = new LinkedMultiValueMap<>();
        param.add("name", "Sam");

        jsonMock.perform(get("/api/jpa/get").params(param))
                .andExpect(view().name("mockTest"))
                .andDo(MockMvcResultHandlers.print())
                .andReturn();

    }

    /**
     * 이래 놓으면 실제로 db에 저장이 되어버린다. 망함.. 방법은 db 분리하기다. 선택에 따라서 test 환경에서는 h2 같은 db를 쓸 수 잆다고 함
     * @throws Exception
     */
    @Test
    public void saveByJpa() throws Exception {

        UsersVO jpaEntity = UsersVO.builder()
                .name("noinDB")
                .salary(2000)
                .build();

        jsonMock.perform(post("/api/jpa/save")
                .contentType(MediaType.APPLICATION_JSON)
                .content(asJsonString(jpaEntity)));
    }

}
{{< /highlight >}}

<br>




### (plus) MockMvc
I'm not familiar with assert function. Until getting used to it, I decide to check result with my eyes. It means I want to 
print the response on console window. 

Spring already got a solution. In Integerate test, I mock request with mockMvc. With mockMvc, I can ues mvcResult to change result to printable Object. Here is what I do. 

<br>

> MockMvc to check response

{{< highlight java  "linenos=true,hl_inline=false" >}}


import org.springframework.test.web.servlet.MockMvc;

@Test 
void logout() throws Exception {
 
    String targetUrl = String.format("%s%s", contextPath, "/logout");
    Map<String, String> sessionMap = new HashMap<>();
    sessionMap.put("session_key", "inputed_session_key");
 
    //when
    MvcResult resultMock = mockMvc.perform(post(targetUrl)
                .requestAttr(XCConstant.REQ_APP_LANG, testLang)
                .requestAttr(XCConstant.REQ_AUTH_TOKEN, "")
                .contentType(MediaType.APPLICATION_JSON)
                .content(asJsonString(sessionMap)))
                .andReturn();
 
    // then
    String result = resultMock.getResponse().getContentAsString();
    log.info("#### {} test ####", targetUrl);
    log.info(result);
}
{{< /highlight >}}


<br> 
Do not forget to attach `@WebMvcTest` or `@AutoConfigureMockMvc` to autowired mockMvc Object in your class. This will let you call mockMvc without any configuration or statement. 
