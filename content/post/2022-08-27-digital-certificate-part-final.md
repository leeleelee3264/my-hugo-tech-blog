+++
title = "Markdown Syntax"
date = "2020-05-11"
description = "Markdown Syntax test page"
tags = ["markdown", "css", "html", "themes"]
+++


{{< highlight html  "linenos=true,hl_inline=false" >}}
<section id="main">
  <div>
   <h1 id="title">{{ .Title }}</h1>
    {{ range .Pages }}   {{ range .Pages }}   {{ range .Pages }} &nbsp;  {{ range .Pages }}   {{ range .Pages }}   {{ range .Pages }}   {{ range .Pages }}
        {{ .Render "summary"}}
    {{ end }}
  </div>
</section>
{{< /highlight >}}

{{< figure src="/static/img/demo/excelIcon.png" caption="what" >}}

