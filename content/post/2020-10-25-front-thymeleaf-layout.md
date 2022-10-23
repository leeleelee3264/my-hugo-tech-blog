+++
title = "(en) Divide Layout in Thymeleaf"
date = "2020-10-25"
description = "Divide layout in thymeleaf"
tags = ["Frontend"]
+++


<br>
<br> 

> Divide layout in thymeleaf.

<br> 

**Index**
1. Trouble with not dividend html layout 
2. Divide layout 
3. Outro

<br> 

# Trouble with not dividend html layout

_How do I feel about not divide html layout. Suffocating with 2000 line!_

At first, I didn't know the importance about splitting html and making layout. But when I saw 2000 line html files with so many duplicated code (mostly nav, header, side-bar) I felt like I should change my mind. In my opinion, the good things about such work are ...

<br> 

> Pros in dividend html layout 
- I don't have to rewrite every header, footer, side-bar (AKA general frame of Web HTML) each time. (**no more duplication!**)
- I can control general <meta> tags and web clouded script src and stylesheet in link tags quite easily
- Feel like more formatting with HTML files because they have certain blocks extends from default layout.

<br> 

# Divide layout 

### Library to Divide layout in Thymeleaf  
Currently, I'm using thymeleaf (basic template provided from spring boot). So I'm going to talk about what I did to make thymeleaf layout. To be honest, I don't have many choice in terms of layout in thymeleaf. 

I was able to find one available user-based thymeleaf library. I'm still quite worrying about not using official library, but actually it's very cool library. You can find the github page of the [[ultraq/thymeleaf-layout-dialect]](https://github.com/ultraq/thymeleaf-layout-dialect)
over here.      

And I just found out the fact that the library contains error with Java 11. In my company, we still use JDK 1.8, so I just went for it.


<br> 


### Let's implement! 

In this project, I have to separate page with three languages, Korean, English and Spanish. At that time, I didn't think deeply and making a mistake of making too many html file. It's pain in my ass nowadays. 

Anyway, the point is I don't want to write same codes in each and every files and I found out the code for navigation bar and js css resource tag are everywhere! So I collected them and made to one common file.

<br> 

> Goal of Implementation 
- Write a code in `default layout` if you want to apply to everywhere.
- Slice the page and make to `fragment`. 
  - The best option is footer, navigation bar and something unchangeable and contains everywhere.
- Keep slicing in defaultLayout page. 
  - Make room for `body-part`, `head-part` and `script-part` and more! It's gonna be your lovely template.
- Finally, it's time for action! Make real html aka part of your web and extends defaultLayout. 

<br> 

I'm gonna leave a link about [[스프링기반 프로젝트,리팩토링,디자인패턴 정보 생성 best practice]](https://eblo.tistory.com/57). You can figure out how to use the library.

<br> 


### defaultLayout.html (main template)

{{< highlight html  "linenos=true,hl_inline=false" >}}

<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout">
<head>
    <meta charset="UTF-8">
    <title layout:title-pattern="$CONTENT_TITLE"></title>
    <link rel="icon" type="image/png" th:href="@{/project/static/favicon.png}">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" integrity="sha512-bLT0Qm9VnAYZDflyKcBaQ2gg0hSYNQrJ8RilYldYQ1FxQYoCLtUjuuRuZo+fjqhx/qtq/1itJ0C2ejDxltZVFg==" crossorigin="anonymous"></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js'></script>

    <link th:href="@{https://fonts.googleapis.com/css?family=Source+Sans+Pro&display=swap}" rel="stylesheet">
    <th:block layout:fragment="customPreScript">

    </th:block>

    <th:block layout:fragment="customStyle">

    </th:block>

    <style>
        #n_logout {
            cursor: pointer;
        }
    </style>
</head>

<body>
    <th:block th:if="${session.login.lang == 'en'}">
        <div th:replace="fragments/portal/nav-side-en :: nav-side-en"></div>
    </th:block>

    <th:block th:if="${session.login.lang == 'ko'}">
        <div th:replace="fragments/portal/nav-side-ko :: nav-side-ko"></div>
    </th:block>

    <th:block th:if="${session.login.lang == 'es'}">
        <div th:replace="fragments/portal/nav-side-es :: nav-side-es"></div>
    </th:block>

    <th:block layout:fragment="content">
    </th:block>

    <script src="/project/static/js/Util2.js"></script>
    <script th:src="@{/project/static/js/b/sideBar.js}"></script>
    <script th:src="@{/project/static/js/dnx_ajax.js}"></script>
    <th:block layout:fragment="customScript">

    </th:block>

    <script>
        $('#n_logout').click(function () {
            alert('로그아웃 하시겠습니까?');

            let post_param = {
                request_url:'/project/b/logout',
                next_url: (function (result) {
                    if (result === 0) {
                        window.location.href = '/project/b/login'
                    }
                    else {
                        alert("ERROR!! SERVER ERROR 발생! 개발자에게 알려주세요.")
                    }
                })

            }

            ajax_post(post_param)
        });

    </script>
</body>
</html>
{{< /highlight >}}

<br> 


### nav-side-en.html (fragment)

{{< highlight html  "linenos=true,hl_inline=false" >}}

<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" >

<th:block th:fragment="nav-side-en">
    <div class="nav-side-menu">
        <div class="brand"><img src="/tcadmin/static/img/w_logo.png" width="154px"></div>
        <div class="menu-list">

            <ul id="menu-content" class="menu-content collapse out">

                <li class="collapsed">
                    <a>
                        <div id="num" class="side-home">Home</div>
                    </a>
                </li>

                <li class="collapsed">
                    <a href="/tcadmin/b/user/list">
                        <div id="num" class="side-home">User</div>
                    </a>
                </li>

                <li class="collapsed">
                    <a href="/tcadmin/b/user/report">
                        <div id="num" class="side-home">Report</div>
                    </a>
                </li>

                <li class="collapsed">
                    <a href="/tcadmin/tts/login">
                        <div id="num" class="side-home">Admin</div>
                    </a>
                </li>

            </ul>
        </div>

    </div>

    <div class="nav">
        <input type="checkbox" id="nav-check">
        <div class="nav-header">
            <div class="nav-title">
                <span class="home-menu">
                     <a href="#" id="home-menu-text"></a>
                </span>

                <th:block layout:fragment="customNav">

                </th:block>
            </div>
        </div>

        <div class="nav-links">
            <a href="#" style="font-weight:bold;"><span th:text="${session.login.login_id}"></span></a>
            <a id="n_logout">Log out</a>

        </div>
    </div>

    <script>
        (function f() {
            let pageTitle = document.title
            document.getElementById('home-menu-text').textContent= pageTitle

            let collClasses = document.getElementsByClassName("side-home")

            for(let i = 0; i < collClasses.length; i++) {
                let coll = collClasses.item(i)

                if(coll.textContent === pageTitle) {
                    coll.closest('li').classList.add('active')
                }
            }

        })()
    </script>
</th:block>

</html>
{{< /highlight >}}


<br> 

### en_list.html (real usage)

{{< highlight html  "linenos=true,hl_inline=false" >}}

<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns:layout="http://www.ultraq.net.nz/web/thymeleaf/layout"
      layout:decorate="~{fragments/portal/defaultLayout}">

<head>
    <title>User</title>

    <th:block layout:fragment="customStyle">
        <link rel="stylesheet" th:href="@{/tcadmin/static/css1/user.css}"/>
        <link rel="stylesheet" th:href="@{/tcadmin/static/rMateChartH5/Assets/Css/rMateChartH5.css}"/>
    </th:block>
</head>

<body>
<th:block layout:fragment="content">
<div class="card">
	  <p>This page contains real usage of layout divison</p>
</div>
</th:block>

<th:block layout:fragment="customScript">

    <script>
        console.log("Hello, you")
    </script>
</th:block>
</body>

</html>
{{< /highlight >}}



<br> 

# Outro 

### Importance of Dividing  
I'm writing this post to remind myself of importance of dividing html layout that I had not known about before. After writing and writing, now I slowly think about how important to find uniformity and extract that part as a single function to reduce code and usability. 

In the future, when I have to create new function or manage the code, it will be way better in this way, because I don't have to look around all 2000 line code. It's in the one file.
I'll re-think before coding to build better program to manage.

