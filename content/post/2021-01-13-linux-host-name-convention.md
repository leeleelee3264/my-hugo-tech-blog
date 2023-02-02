+++
title = "[Infra] (en) Name convention of host and URL"
date = "2021-01-13"
description = "Name Convention of Host and URL: Reserved characters and unsafe characters."
tags = ["Infra"]
+++


<br>
<br> 

> Name Convention of Host and URL: Reserved characters and unsafe characters.

<br> 

**Index**
1. Troubleshooting for Name Convention  
2. Name Convention 

<br> 

# Troubleshooting for Name Convention  

### How I occurred the trouble 
Today, I had to be through very awful exception. There is an api server I have to send a request to update  meta data. For performance issue, this server just cached meta data and uses it till updated.
Usually it's quite simple. Make request with `RestTemplate` in Spring boot.


This situation got started two days age. _The server which contains api server moved to new ec2 machine, and it had new ip_. So I have to send my request to the new ip.
I had wrote a previous ip on `application.properties`. Just like this.

<br> 

> application.properties

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

api.server.domain=http://172.22.32.1:8000
{{< /highlight >}}


<br> 

Let's say the new ip is `180.1.1.1:8000`. I could just change application.properties to `http://180.1.1.1:8000`, but it's so annoying I have to change application.properties file and rebuild, re-deploy server every time when ip gets changed.
I thought now is the perfect timing to use `/etc/hosts` file in Linux.

<br> 

#### /etc/hosts
Domain is kine of alias of ip. In other words, every domain has its own ip. When we type domain to go to specific site, before this request goes any farther it goes to `DNS` server to get a real ip of the domain.

`/etc/hosts` are local DNS file for own ubuntu machine. Ubuntu usually goes check the file first and goes to DNS. The file used to work like back up DNS long time age to prevent DNS error.

Nowadays, the file use to find host name which is not registered in DNS. For example, localhost. There is no real domain named localhost, it's just living in the file. 

<br> 

> /etc/hosts example

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

# /etc/hosts
127.0.0.1 localhost
  {{< /highlight >}}


<br> 

Like localhost, I wanted to make own host name for this inner server. These were what I did.


> my own /etc/hosts 

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

# /etc/hosts in Linux  
127.0.0.1 api_call_server
{{< /highlight >}}


<br> 

And used the domain like this. 


> api_call_server in Spring boot

{{< highlight java  "linenos=true,hl_inline=false" >}}

# application.properties in Spring boot 
api.server.domain=http://api_call_server

# code in Spring boot and I use RestTemplate to send a request
@Value("${api.server.domain}")
private String serverDomain
{{< /highlight >}}


<br> 


But it turned out I did something wrong. I kept getting `400 Bad request` from api server. You may get `unknown host exception` when you send a request to a host which is not in /etc/hosts file. But I already added!
On my second thought, maybe the reason for the exception is DNS caching. But it was not that. 

<br> 

#### Reason for the exception  
_I used not allowed character in host name._


At that time, I should have known about host name convention better. you see, my own host name is `api_call_server` now let's see what characters are allowed for naming host.

<br> 

### Name Convention 

#### Host Name convention
- `a-z`, `A-Z`
- `0-9`
- `-`
     
These are all. No others. I'll keep in mind I cannot use `_` in Url. Only Hyphen would work. So I change host name from `api_call_server` to `api-call-server`. After changing, I no longer saw 400 bad request.

<br> 

### Url Name convention
- `a-z`, `A-Z`
- `0-9`
- `-`
- `. _ ~ ( ) ' ! * : @ , ;`

<br> 

#### Not safe to use 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://user-images.githubusercontent.com/35620531/104724934-bc2fbc80-5774-11eb-8e14-834e49730680.png" >
<figcaption align = "center">[Picture 1] Not Safe in URL</figcaption>

<br> 

In not safe, there are two concepts. Reserved and unsafe.

##### Reserved
- Literally reserved for system. You can see those letters in Linux env a lot. Safety of Url is not static when url containing reserved character. I think I'd better not use them.

##### Unsafe 
- Just do not use them. If I want to use one of them, I have to percent encoding and it's on RFC.

<br> 

#### (plus) only use lower case in URL
_We had better use Lowercase when it comes to making urls._ 

Lowercase is more traditional way and considering `UX`, users don't have to press shift.
And don't mix them too. (It called safe approach). With `SEO`(search engine optimize), google consider lowercase url and uppercase url are the same. 

For example, `http://love.pizza.com/HOME.html` and `http://lova.pizza.com/home.html` are the same.
Take a look at [[lower/upper matters]](https://www.searchenginejournal.com/url-capitalization-seo/343369/#close) for more information. 
