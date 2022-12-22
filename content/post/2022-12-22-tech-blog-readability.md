+++
title = "(작성중)[Project] 블로그 리팩토링: 읽고 싶어지는 기술 블로그 만들기"
date = "2022-12-22"
description = "개인 기술 블로그 가독성 향상 프로젝트에 대해 다룬다."
tags = ["Project"]
+++



<br>
<br> 

> 2022-09-16 부터 2022-10-08 동안 진행한 블로그 리팩토링에 대해 다룬다. 
> > [[기존 Jekyll 블로그]](https://leeleelee3264.github.io/old-blog/)

<br> 
<br> 

**Index**
1. Intro
2. Hugo 도입기
3. 프로젝트 회고  

<br> 

# Intro

### 문서화의 중요성 

요즘들어 개발자의 업무에서 `개발` 말고도 중요한 부분들이 많다는 생각이 자주 든다. 특히 `문서화`의 중요성을 다시금 환기하고 있다.  

2022년 1년간 회사에 들어와서 많은 문서들을 작성해왔다. 어떤 문서는 개발자들과 공유하기 위해 만들었고, 또 다른 문서는 기획자와 같은 비개발자들과 소통을 하기 위해 만들었다.
점점 문서로 소통하는 일이 많아지다보니 자연스럽게 _문서가 담고 있는 내용도 중요하지만, 가독성과 구성도 신경을 써야 할 필요를 느꼈다._ 

잘 작성된 문서는 매끄러운 소통을 하게 해주는 동시에 자료로의 역할도 하기 떄문에 가능한 읽기 좋고 잘 정리된 문서를 만들려고 노력하고 있다. 

<br> 

### 기술 블로그 점검 
그러던 중 내가 운영하던 기술 블로그의 포스팅들을 하나씩 살펴봤다. 이전에는 보이지 않았던 좋지 않은 가독성, 부자연스러운 구성들이 많이 눈에 들어왔다. 
고민을 하던 중, 마침 기존에 사용하던 `Jekyll`에서 불편 사항들을 느끼는 것들도 많아서 대대적으로 블로그를 손보는 프로젝트를 진행했다. 

이제부터 2020년 1월부터 지금까지 어떤 플랫폼을 사용하여 블로그를 운영했고, 어떤 문제점이 있어 2022년 09월 16일부터 10월 08일, 약 한 달 동안 `블로그 리팩토링 프로젝트`를 진행했는지 다뤄보도록 하겠다. 

<br> 

### 블로그 연대기 

#### 2020년: 티스토리 

[[_티스토리 블로그 링크_]](https://calgaryhomeless.tistory.com/?page=1)


<br> 

> 티스토리를 선택한 이유 
- 익숙한 블로그 플랫폼이라 초기에 빠르게 기술 블로그를 만들 수 있다. 
- Git 사용도 제대로 모르던 시절이라 Github page에 진입장벽이 느껴졌다.  
- 호스팅과 검색어 노출 등을 티스토리 자체에서 관리해 줘, 따로 신경을 쓸 필요가 없다. 
- 에디터 지원이 잘 되어있어 편하게 글을 쓸 수 있다. 

<br> 

> 티스토리의 문제점 
- Github Page를 사용해 기술 블로그를 만드는 게 유행이어서, 유행에 조금 뒤떨어졌다.  


<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/ti.png" >
<figcaption align = "center">[Picture 1] 직관적인 블로그 이름과 다소 부적절한 닉네임</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/tistory_cal.png" >
<figcaption align = "center">[Picture 2] 현재까지도 꾸준한 티스토리 방문자 유입</figcaption>

<br> 

2021년 09월 이후로 새로운 포스팅이 없는데도 방문자 수가 꾸준한 걸 보면, 손쉽게 많은 사람들이 보게 만들기 위해서는 티스토리가 좋은 선택지임이 틀림없다. 
티스토리를 사용했을 때 호스팅과 검색어 노출을 신경쓰지 않았고, 에디터도 편리해서 블로그 포스팅을 하는 데 거부감이 없었다. 

사실 이번 리팩토링 프로젝트를 진행했을 때 다시 티스토리로 돌아갈까 고민하기도 했다. 방문자 유입이 많아야 글을 쓰는 재미와 보람도 있기 때문이다. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/tistory.png" >
<figcaption align = "center">[Picture 3] 좋지 않은 가독성</figcaption>

<br> 

하지만 이때도 가독성은 신경을 쓰지 않아 읽기가 조금 불편했고 구성 또한 마찬가지였다. 하고 싶은 말만 가득 써둔, 냅다 기술 지식을 전하는 포스트였던 것이다. _얼마나 읽기도 불편하고 재미도 없는지, 
사실은 나도 이때 써둔 글을 다시 읽으러 가거나 하지 않는다.._ 


<br> 

#### 2021-2022년: Jekyll
[[Jekyll 블로그 링크]](https://leeleelee3264.github.io/old-blog/)

<br> 

티스토리를 잘 쓰던 중, 갑자기 Github Page를 사용해 기술 블로그를 운영하기로 마음먹는다. 계기는 단순하다. `One Day One Commit`을 해서 Github에 `잔디심기`를 하고 싶었다. 
티스토리를 사용하면 매일 잔디를 심기가 어렵기 때문에 과감하게 포기하고, Github Page로 옮겨가는 프로젝트를 진행했다. 

블로그에 [[Jekyll로 이전하는 방법]](https://calgaryhomeless.tistory.com/1)에 대해서도 포스팅을 했다.

<br> 

> Jekyll를 선택한 이유
- 마음에 드는 테마가 Jekyll로 구현이 되어있었다.
- Jekyll로 Github Page를 만드는 튜토리얼이 많았다. (사실 Jekyll로 하는 방법 밖에 없었다.)  

<br> 

> Jekyll의 문제점
- 호스팅을 직접 해야 해서 번거롭고, Jekyll 설치를 해야 하는 등 진입장벽이 있다. 
- 검색 노출이 잘 안되어 방문자 수가 별로 없다. 
- 설치를 잘못해서 내 로컬에서 Jekyll을 실행할 수 없었다. 
  - 결과적으로 Github에 배포를 완료해야만 포스팅을 볼 수 있었다. _즉, 로컬에서 프리뷰를 할 수 없었다._ 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/old_blog.png" >
<figcaption align = "center">[Picture 4] 좋지 않은 가독성2</figcaption>

<br> 

참고로 Jekyll은 `Ruby`로 작성되었다. 로컬에서 바로 바로 프리뷰를 보며 에디팅을 할 수 없었기 때문에 가독성은 더 엉망이 되었다. 그 당시에는 포스팅이 어떻게 보일지 미리 고민을 하지 않고 무작정 글을 쓰기만 했다. 
그리고 이때에도 구성에 대해서 고민하지 않았다. 돌이켜보면 그 때는 재미있는 글, 읽고 싶은 글을 쓰는 것에 전혀 관심이 없었나보다. 

<br> 

# Hugo 도입기 

로컬에서 실행이 안된다는 치명적인 Jekyll을 계속 사용하기는 쉽지 않았다. 블로그 리팩토링을 진행하며 어떤 플랫폼으로 이전을 해야 할까 고민을 하던 중 `Hugo`를 선택했다.  


Hugo를 선택한 이유로 _Go를 기반으로 만들어졌다_ 가 있는데 마침 Go를 배워보고 싶어서 선택했다. 하지만 지금 와서 생각을 하면 Hugo를 쓴다고 해서 Go에 대해 알게 되거나 하는 것은 아닌 것 같다. 


<br> 

> Hugo를 선택한 이유 
- Jekyll 대안으로 Github Page에 사용이 가능하다. (잔디심기를 계속 할 수 있다)
- Jekyll 만큼은 아니지만 꽤 많은 테마가 구현되어 있다. 
- 페이지를 빌드하는 속도가 굉장히 빠르다. 
- `Go`를 기반으로 만들어졌다.

<br> 

> Hugo의 문제점 
- 아직까지는 없다. 

<br> 

### 테마 선택 

블로그 리팩토링에서 블로그 테마도 중요한 부분을 차지한다. 테마를 바꾸는 게 소소한 재미이기도 하고 블로그의 인상과 가독성을 크게 좌지우지 하기 때문에 심사숙고 해서 선택해야 한다. 한참 테마 쇼핑을 하다가 [[Fuji]](https://themes.gohugo.io/themes/hugo-theme-fuji/) 라는 테마를 선택했다. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/fuji.png" >
<figcaption align = "center">[Picture 5] Fuji 테마</figcaption>


<br> 

`다크모드`도 지원을 하고 테마 자체가 군더더기 없이 깔끔해서 마음에 들었다. 그리고 개발자가 Introduction을 상세하게 써줘서 그대로 보고 따라하기 좋아보였다. 
또한 `Tag`를 설정하면 사이드 바에 노출이 되는 것도 좋았고, `Archives` 라는 메뉴에서 페이지네이션 없이 모든 포스트를 보여주는 것도 좋았다. 

가끔 내가 쓴 글을 찾아보면서 페이지네이션이 들어가 있어 넘기기 귀찮을 때가 많았는데 아주 편리하게 쓸 수 있을 거 같았다. 


<br> 

### Hugo 설치 및 블로그 생성 

Jekyll과 마찬가지로 Hugo로 블로그를 운영하기 위해서는 로컬에 Hugo를 설치해야 한다. Hugo는 공식문서가 굉장히 잘 되어있는데, [[공식문서 quick-start]](https://gohugo.io/getting-started/quick-start/) 를 
보면서 하나씩 따라하면 굉장히 빠르게 Hugo 블로그를 생성할 수 있다. 

<br> 

> Hugo 설치하기

{{< highlight bash  "linenos=true,hl_inline=false" >}}
brew install hugo
{{< /highlight >}}

<br>

이제부터는 위에서 선택한 테마를 적용해서 나만의 블로그를 생성하는 방법에 대해 다뤄보겠다. 

<br> 

> 블로그 만들기 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# 블로그 디렉터리를 만들어준다 
mkdir my-hugo-tech-blog  
cd my-hugo-tech-blog 

# hugo 블로그를 만들어준다
hugo new site quickstart
{{< /highlight >}}

테마 사이트에 들어가보면 각각 테마의 Introduction에 해당 테마를 `git`의 `submodule`로 가져오라고 하고 있다. 
내가 선택한 Fuji 테마의 깃허브 주소인 `https://github.com/dsrkafuu/hugo-theme-fuji.git` 예시로 사용하겠다.

<br> 

> 블로그에 테마 적용하기 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
git init 
git submodule https://github.com/dsrkafuu/hugo-theme-fuji.git

# 테마의 configuration 복사해준다
cp themes/fugi/config.toml . 
{{< /highlight >}}


Hugo에서 블로그의 configuration은 `config.toml` 이라는 파일에서 관리가 된다. 각 테마 안에 config.toml 파일이 존재하는데 내가 만든 사이트에 해당 테마를 적용하고 싶다면 테마의 config.toml을 
그대로 `복사`해서 나의 블로그 디렉터리에 넣어주면 된다.

<br> 

> 로컬에서 블로그 실행하기 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
hugo server 
{{< /highlight >}}

<br> 


> Webstorm에서 블로그 실행하기


<br> 

### Hugo로 Github에 Publishing 하기 


### 포스트 구성 정하기 



<br> 

# 프로젝트 회고 








