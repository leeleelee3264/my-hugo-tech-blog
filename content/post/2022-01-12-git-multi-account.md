+++
title = "[General] 터미널에서 여러 개의 Github 계정 사용하는 방법"
date = "2022-01-12"
description = "이 포스트에서는 SSH key, ssh config 와 ssh-keygen를 사용하여 여러 개의 Github 계정을 사용하는 방법을 알아본다."
tags = ["General"]
+++


<br>
<br> 

> 이 포스트에서는 SSH key, ssh config 와 ssh-keygen를 사용하여 여러 개의 Github 계정을 사용하는 방법을 알아본다.

<br> 

**Index**
1. 깃허브 계정 여러 개 세팅하기 
2. 매번 해줘야 하는 작업들  
3. 레퍼런스 

<br> 

# 깃허브 게정 여러 개 세팅하기 

### 디렉터리 세팅하기 
복수의 깃허브 계정을 사용 할 때,  각 계정들의 root source directory를 나누어두면 관리적 측면에서도, git config 설정을 할 때에도 더 편리하다.

> 디렉터리 예시 

```shell
.
└── home
    ├── office
    └── personal

```

<br>

### ssh 키 발급


#### Step 1 사용할 계정들의 키 발급

{{< highlight shell  "linenos=true,hl_inline=false" >}}
ssh-keygen -t ed25519 -C "leelee@office.com" -f ~/.ssh/id_rsa_personal
ssh-keygen -t ed25519 -C "leelee@personal.com" -f ~/.ssh/id_rsa_office
{{< /highlight >}}


<br>

#### Step 2 로컬의 ssh-agent 에 발급받은 키 연결:

{{< highlight shell  "linenos=true,hl_inline=false" >}}
ssh-add --apple-use-keychain ~/.ssh/id_rsa_personal
ssh-add --apple-use-keychain ~/.ssh/id_rsa_office
{{< /highlight >}}


위에서 연결한 ssh 키 정보들은 `ssh-add -l` 로 확인이 가능하다.

<br> 

#### Step 3 ssh config 작성


발급받은 키들과 깃허브 계정 정보를 로컬 단에서 연결을 하기 위해 .ssh/config 에 관련 정보들을 작성을 한다.

> .ssh/config

{{< highlight shell  "linenos=true,hl_inline=false" >}}
# Personal GitHub account
Host github.com-personal 
    HostName github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa

# Office Github account
Host github.com-office
    HostName github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa_office
{{< /highlight >}}


<br>

### ssh 키 깃허브에 등록

> ssh-keygen 결과물 
- `id_rsa.pub`
  - 외부로 공개되는 공개키이다. 
  - github에 등록되는 키다. 
  - 파일 끝을 보면 이메일을 확인할 수 있다. 
- `id_rsa`
  - 외부로 공개되면 안되는 비밀키이다. 

<br>

> id_rsa.pub 에시 

{{< highlight shell  "linenos=true,hl_inline=false" >}}
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID+d2UkNy9yBi6Dd2pc7O1MPik87UhC81GzyTzlKYYRI leelee@office.com
{{< /highlight >}}


<br>


##### github setting 페이지로 이동

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://www.heady.io/hs-fs/hubfs/Assets%20June%202020/Blog%20Images/1_Zz-0nINK5t3TrX0KIz2rYw.png?width=227&name=1_Zz-0nINK5t3TrX0KIz2rYw.png" >
<figcaption align = "center">[Picture 1] Github Setting 메뉴바</figcaption>

<br>

##### SSH and GPG Keys 항목에서 New SSH key 등록 
office를 위한 `id_rsa_personal.pub` 와 `id_rsa_office.pud` 를 각각 등록해준다. 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://www.heady.io/hs-fs/hubfs/Assets%20June%202020/Blog%20Images/1_-gpWpnwo_0Ang-WMgVrY1A.png?width=900&name=1_-gpWpnwo_0Ang-WMgVrY1A.png" >
<figcaption align = "center">[Picture 2] New SSH key 등록</figcaption>

<br>


### 계정 정보 명시

Github에서 사용하는 **name과** **email을** 별도로 설정해주지 않으면 개인 리포지토리에 올릴 커밋의 작성자가 회사 계정으로 되어있거나, 권한이 없다며 push를 할 수 없다. 떄문에 각각 계정별로 정보를 명시해줘야 한다.

<br>

> 계정 정보 명시 시나리오 default: personal 
- home과 office 디렉터리에 각각 .gitconfig 파일을 하나씩 만들어준다. 
- home의 .gitconfig에 personal 계정의 name과 email을 입력해준다. 
  - office 의 .gitconfig를 불러오는 설정을 추가해준다.
- office의 .gitconfig에 회사 계정의 name과 email을 입력해준다.

<br>

> home .gitconfig

{{< highlight shell  "linenos=true,hl_inline=false" >}}
[user]
	name = leelee-personal
	email = leelee@personal.com
[includeIf "gitdir:~/office/"]
	path = ~/office/.gitconfig
{{< /highlight >}}

<br>

> office .gitconfig

{{< highlight shell  "linenos=true,hl_inline=false" >}}
[user]
	name = leelee-office
	email = leelee@office.com
{{< /highlight >}}


<br>

> 완성된 디렉터리 에시 
```shell
.
└── home
    ├── .gitconfig
    ├── office
    │   └── .gitconfig
    └── personal

```

<br>


# 매번 해줘야 하는 작업들


### 레포지토리 주소 수정
.ssh/config 에서 연결할 Host를 계정별로 분기해서 각각 `github.com-personal` 과 `github.com-office` 로 구분을 했다. 때문에 매번 레포지토리를 만들거나, 클론할 때 구분하는 작업을 해줘야한다. git remote set-url 로 레포지토리를 연결할 떄도 똑같은 형식으로 해줘야 한다.

<br>

> 기존 url

{{< highlight shell  "linenos=true,hl_inline=false" >}}
git clone git@github.com:(Repo path).git
{{< /highlight >}}

<br>

> 수정 url

{{< highlight shell  "linenos=true,hl_inline=false" >}}
git clone git@github.com-office:(Repo path).git
{{< /highlight >}}



<br>

> set-url 예시

{{< highlight shell  "linenos=true,hl_inline=false" >}}
git remote set-url origin git@github.com-office:(Repo path).git
{{< /highlight >}}


<br>

# Reference

[[CodeWords: A Mobile Application Blog by Heady]](https://www.heady.io/blog/how-to-manage-multiple-github-accounts)

