+++
title = "(en) Handle SQL Exception in Spring boot"
date = "2020-09-18"
description = "Handle SQL Exception in Spring boot"
tags = ["Backend"]
+++

<br>
<br> 

> Handle SQL Exception in Spring boot.

<br> 

**Index**
1. Exception in Java
2. Handle SQL Exception 
3. Reference

<br> 

# Exception in Java 

A week ago, I felt maybe I need to adjust exception of sql. At that time, I just used try-catch with Exception and print stacktrace for backend, passed some certain value to let front know something went wrong with request. I've never went deep down to Exception and how to handle, so let's first check what kind of Exception java has.

<br> 

### Exception hierarchy

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/checked_unchecked.png" >
<figcaption align = "center">[Picture 1] Java Exception</figcaption>

<br> 

Java use `Throwable` type when something goes wrong. The highest type Throwable then separate to three pieces. `Error`, `Checked Exception` and `Unchecked Exception`. 

_Error is just error._ We cannot actually do something with error. It means, we don't have to (and can't) handle error. Then what about unchecked exception and checked exception?

<br>


#### Checked Exception

If I want to run program, I have to compile code first. Compiling is like translating. Translating human friendly language such as Java, C, Python to computer friendly language which contains 0 and 1.   

If I make a mistake like opening not exist file, using not existing class or method then compiler will tell me. What should I do next? Without any choice, I must fix it. If not, I won't be able to run the program I made. Straight forwardly, **checked exception will be checked by compiler at the very first time**.

<br>  

#### Unchecked Exception

On the other hand, _compiler can't catch unchecked exception_ which will happen in the future. And I also can't catch them either. I can only predict and try to prevent code from exception with Exception handling. 

**These are happend when program is actually running**. We have certain rules about programming. Using legal argument, not accessing out of arrays, casting variable with proper  casting method, not using null as value etc. However, these kind of exception sometimes happens due to client passing wrong value, server using mistaken code ect. We shell see them after running program.

And here is the point! Can you see `SQLException` under Exception tree? SQLException is one of checked exception. And it's today's topic. Now let's dig in to SQLException.

<br>  

# Handle SQL Exception

### Why SQLException is checked exception? 

What I understand is that checked exception always pop up at compiler time. But in my ordinary code, exception related to sql pop up run time and compiler time both. 

#### Checked Exception in SQL 
When I miss or don't configure setting about sql, compiler give me lots of error and stop right there. It were mostly about connection with spring and sql. 

#### Runtime Exception in SQL 
On the other hand, If I made bad sql grammar or try to use invalid value in sql sentence, then I got runtime exception. I didn't get value I'd expected, but program was still running. 

I did some research and found out there are `SQLException` and `DataAccessException` in spring. _SQLException is checked exception and DataAccessException implements RuntimeException._



<br>

### Change SQLException to DataAccessException

_Now it's a trend to change checked exception to unchecked exception in standard spec and open source framework._ 

Most of the time, we can't react to checked exception right away. Because Java stepped into server area, we have to go through couple of step to fix exceptions. (coding, building, uploading, running...) 

People changed mind. If we can't fix exceptions fast, then at least we can make exceptions not too critical. Let's make checked exception to unchecked exception! It's bad hobby but sometimes we just ignore runtime exception and got ugly exception notification. I'll summarize it.

<br> 

#### Goal of Exception Handler

- **Turn checked exception to unchecked exception when caller (programmer) cannot fix, recover exception.**
- Then what can I do with exception with sql? connection failure, bad sql grammar... obviously not many things.
- So let's just wrap it to unchecked exception to prevent stop running program.
- We still can use try-catch with runtime exception if we want.
- It even reduces writing throws and try-catch as well.

<br> 

#### Reason of wrapping SQLException to DataAccessException

- Only DAO has SQLException
- We should not pass sqlexception all the way through with bunch of throws.
- Wrap SqlException to DataAccessException
- With DataAccessException, we can chose using exception handling when we really need.
- **It called abstraction of exception. make low level to high level.**
- With high level exception, we can get more detail about the occurred exception.

<br>

### Implement Exception Handler 

When I wrote this code, it looked decent. But I feel like I have to change a couple of things to improve. It's prototype anyway. 

Now the code's flow is very simple. `Meeting exception`, `logging exception`. I might need to handle individual case of exception later. At that moment, I'll use this code quite useful. And for good measure, I separate exception from mybatis and general concept of sql exception. Just in case.


<br> 

> Implementation 

{{< highlight java  "linenos=true,hl_inline=false" >}}

/**
 * Created By Seungmin lee
 * User: ***
 * Date: 2020-09-15
 * Description: 각종 Exception 을 logging 하고 처리할 목적으로 만든 Util
 */
@Slf4j
public class ExceptionUtil {
    /**
     * mybatis 와 mysql에서 발생하는 error 들의 상세 logging 을 위한 메소드. 
     * 추후에 로깅뿐 아니라 예외처리 로직도 넣어둘 예정. 
     * @param ex MVC 단에서 던지는 예외 
     */
    public static void sqlException(Exception ex) {
        if (Objects.isNull(ex.getCause()) || Objects.isNull(ex.getMessage())) return;
        // Mybatis 라이브러리 내부에 어떤 오류둘이 있는지 몰라 일단 한 번에 처리 
        if(ex instanceof MyBatisSystemException) {
            log.error("**** Mybatis inner exception :{} ****",  ((MyBatisSystemException) ex).getRootCause().getMessage());
            return;
        }
        // TODO: DataAccessException 과 SQLException 은 같은 수준인데 Spring에서는 DataAcessException 이 더 제너럴해서 나중에 바꿀 수 있다. 
        SQLException higherEx;
        if (ex instanceof DataAccessException) {
            higherEx = (SQLException) ((DataAccessException) ex).getRootCause();
            log.error("**** DataAccessException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        }
        if (ex instanceof BadSqlGrammarException) {
            higherEx = (SQLException) ((BadSqlGrammarException) ex).getRootCause();
            log.error("**** BadSqlGrammarException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if(ex instanceof InvalidResultSetAccessException) {
            higherEx = (SQLException) ((InvalidResultSetAccessException) ex).getRootCause();
            log.error("**** InvalidResultSetAccessException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if(ex instanceof DuplicateKeyException) {
            higherEx = (SQLException) ((DuplicateKeyException) ex).getRootCause();
            log.error("**** DuplicateKeyException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if(ex instanceof DataIntegrityViolationException) {
            higherEx = (SQLException) ((DataIntegrityViolationException) ex).getRootCause();
            log.error("**** DataIntegrityViolationException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if(ex instanceof DataAccessResourceFailureException) {
            higherEx = (SQLException) ((DataAccessResourceFailureException) ex).getRootCause();
            log.error("**** DataAccessResourceFailureException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if(ex instanceof CannotAcquireLockException) {
            higherEx = (SQLException) ((CannotAcquireLockException) ex).getRootCause();
            log.error("**** CannotAcquireLockException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if (ex instanceof DeadlockLoserDataAccessException) {
            higherEx = (SQLException) ((DeadlockLoserDataAccessException) ex).getRootCause();
            log.error("**** DeadlockLoserDataAccessException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else if (ex instanceof CannotSerializeTransactionException) {
            higherEx = (SQLException) ((CannotSerializeTransactionException) ex).getRootCause();
            log.error("**** CannotSerializeTransactionException :{} // : {} ****", higherEx.getErrorCode(), higherEx.getMessage());
        } else {
            log.error("**** Exception :{} ****", ex.getMessage());
        }
    }
}
{{< /highlight >}}


<br> 

> TODO List 

- Stop using SQLException. Use DataAccessException instead.
- Do not use DataAccessException at the top of if statement. If is the lowest exception.
- Do I really need to print detailed logging? I could just print stack trace. It even has more info.

<br> 

# Reference

- [[RuntimeException and higher exception]](https://docs.oracle.com/javase/8/docs/api/java/lang/RuntimeException.html?is-external=true)
- [[SQLException to DataAccessException]](https://jongmin92.github.io/2018/04/04/Spring/toby-4/)
- [[Runtime and Compile time]](https://dd-corp.tistory.com/9)
- [[Spring SQLException Handling]](https://webprogrammer.tistory.com/m/2448?category=149261)


