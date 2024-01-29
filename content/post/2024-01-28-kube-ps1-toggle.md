+++
title = "[General] shellscript로 kube-ps1 토글 기능 구현하기"
date = "2024-01-28"
description = "shellscript로 kube-ps1 토글 기능 구현하는 방법에 대해 알아본다."
tags = ["General"]
+++


<br>
<br> 

> shellscript로 kube-ps1 토글 기능 구현하는 방법에 대해 알아본다.

<br> 

**Index**
1. Intro
2. 구현하기 

<br> 

# Intro 

[[General] DevOps Engineer에 최적화된 맥 설정하기](https://leeleelee3264.github.io/post/2024-01-17-mac-setting/) 에서 지금 사용중인 
쿠버네티스 클러스터와 네임스페이스를 터미널 Prompt에 보여주는 kube-ps1을 설치했다. 편리한 툴이지만 매번 클러스터 정보를 불러와야 해서 그런지 원격 클러스터에 접속했을 때 터미널이 너무 느려졌다. 그래서 쿠버네티스 작업을 할 때는 해당 기능을 키고, 아닐 때는 끌 수 있는 기능을 
shellscript로 구현했다. 





<br>

# 구현하기

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/kube/kube.gif" >
<figcaption align = "center">[Picture 1] 토글 기능</figcaption>

<br>

본 문서를 끝까지 따라하면 위의 gif처럼 필요에 따라 kube-ps1 을 키고 끄는 기능을 사용할 수 있다.

<br>

### shellscript 작성 

> kube.sh  

{{< highlight shell  "linenos=true,hl_inline=false" >}}
#!/bin/bash

ZSHRC_FILE="$HOME/.zshrc"
KUBE_PS1_COMMAND='source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"'
PS1_COMMAND='PS1='"'"'$(kube_ps1)'"'"'$PS1'

remove_lines() {
    sed -i '' "/$(echo "$KUBE_PS1_COMMAND" | sed 's/\//\\\//g')/d" "$ZSHRC_FILE"
    sed -i '' "/$(echo "$PS1_COMMAND" | sed 's/\//\\\//g')/d" "$ZSHRC_FILE"
}

add_lines() {
    echo "$KUBE_PS1_COMMAND" >> "$ZSHRC_FILE"
    echo "$PS1_COMMAND" >> "$ZSHRC_FILE"
}

main() {
    if grep -q "$(echo "$KUBE_PS1_COMMAND" | sed 's/\//\\\//g')" "$ZSHRC_FILE" && grep -q "$(echo "$PS1_COMMAND" | sed 's/\//\\\//g')" "$ZSHRC_FILE"; then
        echo "Lines already exist. Removing them."
        remove_lines
    else
        echo "Lines do not exist. Adding them."
        add_lines
    fi

}

main
{{< /highlight >}}

<br>

**상세**

{{< highlight python  "linenos=true,hl_inline=false" >}}
source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
{{< /highlight >}}

kube-ps1을 사용하려면 .zshrc에 위의 두 줄을 추가해야 한다. 내가 작성한 쉘스크립트는 .zshrc에 두 줄이 이미 있으면 삭제해서 kube-ps1 기능을 off하고, 
없으면 추가해서 기능을 on 한다. 그런데 처음에는 `PS1='$(kube_ps1)'$PS1` 를 그대로 쉘스크립트에 넣었더니 변수로 kube_ps1이 변수로 인식이 되어서 `./kube.sh: line 5: kube_ps1: command not found` 오류가 났다.

스택오버플로우를 찾아보다가 [How to escape single quotes within single quoted strings](https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings) 에 나와있는 방식대로
`'"'"'` 를 사용해서 문제를 해결했다. 


<br>

### alias 등록 

> .zshrc 

{{< highlight python  "linenos=true,hl_inline=false" >}}
# kube prompt turn off/on
alias kube="./kube.sh && source ~/.zshrc"
{{< /highlight >}}

기호에 맞는 alias로 등록해서 사용하면 된다! 

