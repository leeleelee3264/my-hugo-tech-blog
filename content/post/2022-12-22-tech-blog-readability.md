+++
title = "블로그 리팩토링 - Hugo 도입과 읽고 싶어지는 기술 블로그 만들기"
date = "2022-12-22"
description = "개인 기술 블로그 가독성 향상 프로젝트에 대해 다룬다."
tags = ["Project"]
+++



<br>
<br> 

> 2022-09-16 부터 2022-10-08 동안 진행한 블로그 리팩토링에 대해 다룬다. 
> > [[티스토리 블로그]](https://calgaryhomeless.tistory.com/?page=1)   
> > [[Jekyll 블로그]](https://leeleelee3264.github.io/old-blog/)

<br> 
<br> 

**Index**
1. Intro: 기술 블로그, 이대로 괜찮은가? 
2. Hugo 도입기
3. 읽고 싶은 기술 블로그 만들기
4. 프로젝트 회고  

<br> 

# Intro: 기술 블로그, 이대로 괜찮은가?

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
<figcaption align = "center">[Picture 1] 직관적인 블로그 이름과 다소 도발적인 닉네임</figcaption>

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

티스토리 블로그에 [[Jekyll로 이전하는 방법]](https://calgaryhomeless.tistory.com/1)에 대해서도 포스팅을 했다.

<br> 

> Jekyll를 선택한 이유
- 마음에 드는 테마가 Jekyll로 구현이 되어있었다.
- Jekyll로 Github Page를 만드는 튜토리얼이 많았다. (사실 Jekyll로 하는 방법 밖에 없었다.)  

<br> 

> Jekyll의 문제점
- Github Page, Jekyll 자체의 진입장벽이 있다. 
- 검색 노출이 잘 안되어 방문자 수가 별로 없다. (Github Page의 문제점)
- 설치를 잘못해서 내 로컬에서 Jekyll을 실행할 수 없었다. 
  - 결과적으로 Github에 배포를 완료해야만 포스팅을 볼 수 있었다. _즉, 로컬에서 프리뷰를 할 수 없었다._ 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/old_blog.png" >
<figcaption align = "center">[Picture 4] 좋지 않은 가독성2</figcaption>

<br> 

(참고로 Jekyll은 `Ruby`로 작성되었다). 로컬에서 바로 바로 프리뷰를 보며 에디팅을 할 수 없었기 때문에 가독성은 더 엉망이 되었다. 그 당시에는 포스팅이 어떻게 보일지 미리 고민을 하지 않고 무작정 글을 쓰기만 했다. 
그리고 이때에도 구성에 대해서 고민하지 않았다. 돌이켜보면 그 때는 재미있는 글, 읽고 싶은 글을 쓰는 것에 전혀 관심이 없었나 싶다. 

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
- 검색 노출이 잘 안되어 방문자 수가 별로 없다. (Github Page의 문제점)

<br> 

### 테마 선택 

블로그 리팩토링에서 블로그 테마도 중요한 부분을 차지한다. 테마를 바꾸는 게 소소한 재미이기도 하고 블로그의 인상과 가독성을 크게 좌지우지 하기 때문에 심사숙고 해서 선택해야 했다. 한참 테마 쇼핑을 하다가 [[Fuji]](https://themes.gohugo.io/themes/hugo-theme-fuji/) 라는 테마를 선택했다. 

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
보면서 하나씩 따라하면 빠르게 Hugo 블로그를 생성할 수 있다. 

<br> 

> Go 설치하기

아직 Homebrew에서 Go 설치를 지원하지 않아서, 공식 홈페이지인 [[Go 다운로드]](https://go.dev/doc/install)에 가서 패키지 파일을 다운로드 받아야 한다. 
다운로드 후, 압축을 풀고 `.pkg` 로 끝나는 파일을 클릭하면 설치 화면이 나와, 순차적으로 설치를 진행하면 된다.  

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# 완료 후, 설치가 잘 되었나 버전을 찍어본다
go version
{{< /highlight >}}


<br> 

> Hugo 설치하기

{{< highlight bash  "linenos=true,hl_inline=false" >}}
brew install hugo
# 설치가 잘 되었나 버전을 찍어본다
hugo version 
{{< /highlight >}}

<br>

이제부터는 위에서 선택한 테마를 적용해서 나만의 블로그를 생성하는 방법에 대해 다뤄보겠다.
테마 사이트에 들어가보면 각각 테마의 Introduction에 해당 테마를 `git`의 `submodule`로 가져오라고 하고 있다.
내가 선택한 Fuji 테마의 깃허브 주소인 `https://github.com/dsrkafuu/hugo-theme-fuji.git` 예시로 사용하겠다.



<br> 

> 블로그 만들기 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
# 블로그 레포지토리를 만들어준다 
mkdir my-hugo-tech-blog  
cd my-hugo-tech-blog 

# hugo 블로그를 만들어준다
hugo new site quickstart
{{< /highlight >}}

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

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/hugo.png" >
<figcaption align = "center">[Picture 6] Webstrom Run Configuration</figcaption>

<br> 

Jetbrains의 Webstorm은 Hugo를 지원하고 있다. `Run Configuration` 에서 Hugo를 위한 새로운 Configuration을 만들고 `Command to run` 항목에 
`hugo server` 를 선택하면 Webstorm에서도 손쉽게 Hugo 블로그를 실행할 수 있다. 

<br> 

> 새 페이지 만들기 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
hugo new {파일 이름}
{{< /highlight >}}

위의 커맨드로 설정된 테마가 적용된 hugo 페이지를 만들 수 있다. 

<br> 

### Hugo로 Github Page에 베포하기 
Jekyll은 Github에서 공식 지원을 하기 때문에 Github Page를 배포 하려면 github.io 레포지토리를 만들고 Push만 해주면 끝이었다. 
<u>하지만 Hugo는 공식 지원을 하지 않다보니 몇 가지 세팅을 해줘야 한다.</u> 세팅이 끝나면 아래의 3가지 결과물이 나온다. 순서에 따라서 한 번 만들어보도록 하겠다. 

<br> 

> 결과물  

1. 블로그 레포지토리 (이전 단계에서 이미 생성)
2. {username}.github.io 레포지토리 
3. 배포 스크립트 

<br> 

#### 블로그 레포지토리 
위에서 `my-hugo-tech-blog` 라는 이름의 Blog 레포지토리를 이미 로컬에 만들었다. github 사이트에서 블로그 레포지토리를 만들고, 연결만 해주면 된다. 

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/my_hugo.png" >
<figcaption align = "center">[Picture 7] Github에 만든 블로그 레포지토리</figcaption>

<br> 

> github 연결 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
cd my-hugo-tech-blog
git remote add origin https://github.com/my-hugo-tech-blog.git public
git push
{{< /highlight >}}

<br> 

#### {username}.github.io 레포지토리 

{username} 은 `github 계정의 username`을 넣어준다. 나의 github 계정 username인 `leeleelee3264`를 예시로 사용하겠다. 
github 사이트에서 leeleelee.github.io 레포지토리를 만들어, 연결해준다. 

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/leelee.png" >
<figcaption align = "center">[Picture 7] Github에 만든 github.io 레포지토리</figcaption>

<br> 

> 로컬에 github.io 레포지토리 생성 후, github 연결 

{{< highlight bash  "linenos=true,hl_inline=false" >}}
mkdir leeleelee3264.github.io
cd leeleelee3264.github.io
git init 

# 미리 만들어둔 github의 {username}.github.io 레포지토리에 연결한다. 
git remote add origin https://github.com/leeleelee3264@github.io.git public
git push 
{{< /highlight >}}

<br> 


#### 배포 스크립트

레포지토리 2개를 모두 만들었다면 마지막으로 중요한 작업이 하나 더 남았다. 바로 `github.io 레포지토리`를 `블로그 레포지토리`의 `서브 모듈`로 추가해줘야 한다.

배포를 위해서는 블로그 레포지토리에서 hugo로 블로그를 빌드해야 한다. hugo로 블로그를 빌드하면 `public`이라는 결과물 폴더가 만들어진다. 이 폴더를 github.io 레포지토리에 내보내야 Github Page로 배포가 된다.
처음에 이 과정을 잘 이해하지 못해 많은 시간을 소요했다.  

<br> 

> Github Page 배포 과정 
1. 블로그 레포지토리에서 hugo로 블로그 빌드하여 public 폴더 생성
2. public 폴더를 github.io 레포지토리로 내보내기 
3. Github가 github.io의 내용물을 Github Page로 배포

<br> 

> [중요!] github.io 레포지토리를 블로그 레포지토리 서브 모듈로 추가

{{< highlight bash  "linenos=true,hl_inline=false" >}}
cd my-hugo-tech-blog

# public 폴더를 서브모듈로 추가해준다
git submodule add https://github.com/leeleelee3264/leeleelee3264.github.io.git public
{{< /highlight >}}

<br> 

이렇게 서브모듈로 추가를 해주면 포스팅을 작성 완료 했을 때 마다 hugo 블로그를 빌드하고 커밋하고, 서브 모듈인 github.io 레포지토리에도 커밋을 해줘야 한다. 
매번 배포를 할 때 마다 두 개의 레포지토리를 커밋하기가 번거롭기 때문에 쉘 스크립트를 작성했다.

<br> 

> 배포 스크립트 blog_build.sh

{{< highlight bash  "linenos=true,hl_inline=false" >}}
#! /bin/sh

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Build blog with hugo"
echo "Author: LeeLee"
echo "Date: 2022-09-17"
echo "This script is for build blog and commit to git."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""

TODAY=$(date)

# build blog
hugo -t fuji

# commit and push build result to github.io
cd public || exit
# shellcheck disable=SC2094
touch date.txt | date >> date.txt
git add .
git commit -m "Publish blog to github.io Date: $TODAY"
git push origin master

# commit and push posting resource
cd ..
git add .
git commit -m "Add posting resource after publishing Date: $TODAY"
git push

{{< /highlight >}}


<br> 

이제 배포를 할 일이 있으면 작성한 쉘 스크립트를 실행하기만 하면 된다.

> 스크립트 실행

{{< highlight bash  "linenos=true,hl_inline=false" >}}
./blog_build.sh
{{< /highlight >}}


<br> 

# 읽고 싶은 기술 블로그 만들기 
Hugo 를 도입한 게 기술적 리팩토링이었다면 이제는 글쓰기적 리팩토링인 읽고 싶은 기술 블로그 만들기 에 대해 언급하도록 하겠다. 

<br> 

### 포스트 규칙 만들기 

<u>가독성 향상</u>을 위해 모든 포스트가 따라야 하는 규칙, 즉 컨벤션을 만들고 기존에 작성했던 포스트들을 
새로운 규칙을 적용하여 전면 수정을 진행했다. 결과적으로 통일감 있고, 포스트에 내용들이 번잡스럽게 담기지 않아 가독성이 많이 좋아졌다. 

<br> 

> 규칙 

1. 포스트 앞에는 항상 `1줄 summary`와 `index`를 작성한다.
2. middle title, small title, image, example 사이에 적절하게 `br`를 두어 공간을 확보한다. 
3. image caption은 [Picture 1] 설명설명 식으로 작성한다.
4. 여러 줄의 코드를 쓸 때에는 Hugo의 `highlight`를 사용한다. 넘버링이 default로 되어있다.
5. 한 줄의 코드를 쓰거나 코드가 아닐 경우에 (url 등) `markdown code block`을 사용한다.
6. link 를 할 때에는 링크에 대괄호를 써 [링크] 로 표기해 식별할 수 있도록 한다.
7. 정렬을 할 때는 1,2,3,4 보다는 `-` 을 사용하는 `dot` 정렬을 사용한다.

<br>

> 규칙을 적용해 수정한 포스트 예시 


  <img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/shiny.png" >
  <figcaption align = "center">[Picture 7] 규칙 적용 포스트</figcaption>

<br> 




### 셀장님의 피드백

본격적인 글쓰기 리팩토링을 하기 전에 기존에 작성했던 포스트 중 하나를 회사의 셀장님께 피드백을 부탁드렸다. 워낙 글을 잘 쓰시는 분이라 정말 필요한 피드백을 주셨다. 셀장님의 리뷰를 십분 반영해서 완성한 포스트가 [[디지털 인증서 파헤치기 (2/2) - 심화: from CA to Chain of Trust]](https://leeleelee3264.github.io/post/2022-08-27-digital-certificate-part-final/)이다.

<br> 

> 피드백 핵심

1. 제목이 명확하면서 구미를 당겨야 한다. 
   1. 정직한 이름의 <u>Digital Certificate</u> 보다는 <u>Digital Certificate 쌩기초</u> 이런 식으로 작명한다.
2. 글의 흐름이 너무 길면 읽기 힘들다. 
   1. 길면 끊어서 여러 편으로 작성한다. 
   2. 웬만하면 `4000`자가 넘어가지 않도록 한다.
3. 글이 너무 정보 전달만 하려 하면 안된다. <u>이야기를 한다는 느낌으로 글을 써야 한다.</u>
4. 왜 이러한 주제와 목차를 다루게 되었는지 `배경 설명`을 하면 좋다.



<br>


모든 포스트에 통용되는 규칙을 만드는 것은 가독성 향상에 큰 도움이 된다. 하지만 이런 규칙 외에도 필요한 것은 구성이다. 결국 블로그 구성이 엉망으로 되어있으면 읽기 싫어지기 때문이다.
셀장님의 피드백을 적극 받아드려 포스트의 구성을 수정했다. 대표적으로 <u>이야기를 한다는 느낌으로 글은 전개하기 위해 배경을 설명하는 Intro를 도입했다.</u> 

<br> 

> Intro의 도입 


  <img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/intro.png" >
  <figcaption align = "center">[Picture 8] Intro 적용 포스트 </figcaption>




<br> 

# 프로젝트 회고

### 마음의 짐을 내려놓으며
막 경력을 시작하여 아무것도 모를 때 만들었던 기술 블로그라 미흡한 부분이 많았지만, 이번에 리팩토링을 거치면서 제법 보완을 해 뿌듯하다. 
매번 내 블로그에 들어올 때 마다 마음이 묘하게 무거웠는데 이제 한 결 가벼워진 기분이다. _리팩토링의 가장 큰 수확은 내가 쓴 글을 나중에 읽어도 
읽기 싫거나 지루하지 않다는 점이다._ 

앞으로도 나뿐만 아니라 다른 사람들에게도 지루하지 않고, 나중에 생각이 나서 다시 들어와서 읽는 기술 블로그가 되도록 노력해야 겠다. 


<br> 

### 새로운 과제: 조금 더 근면성실하게 포스팅 하기 
2022년에는 겨우겨우 *12*개의 포스팅을 했다. 바쁘다는 핑계로 2021년보다 훨씬 못한 숫자의 포스팅을 하게 되어 안타깝다. 
포스팅의 빈도가 낮아지니 더불어 잔디도 많이 심지 못했다. 2023년에는 딱 이것의 2배인 *24*개의 포스팅을 하고, 잔디도 더 많이 심도록 노력하겠다. 

<br> 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/blog/green.png" >
  <figcaption align = "center">[Picture 9] 듬성듬성 잔디</figcaption>

<br> 


항상 블로그 포스팅에는 사소한 주제보다는 의미있는, 큰 규모의 글을 다뤄야 한다는 부담 때문에 더 자주 포스팅을 하지 못한다. 
앞으로는 부담을 내려두고 정말 기록을 위한 사소한 주제를 다뤄야겠다. 








