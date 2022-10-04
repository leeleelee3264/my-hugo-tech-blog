+++
title = "(en) Java Regex Cheat Sheet"
date = "2021-01-11"
description = "Java Regex Cheat Sheet에 대해서 다룬다."
tags = ["Cheat"]
+++


<br>
<br> 

> Java Regex Cheat Sheet에 대해서 다룬다.

<br> 

**Index**
1. Change plain text to Korean Phone Number format
2. Extracting SubString 

<br> 

# Change plain text to Korean Phone Number format


{{< highlight java  "linenos=true,hl_inline=false" >}}

 public static void testNumber(String src) {

        Pattern SRC_PHONE_FORMAT =  Pattern.compile("(\\d{3})(\\d{4})(\\d{4})");
        Pattern DEST_PHONE_FORMAT = Pattern.compile("$1-$2-$3");

        String dest = src.replaceFirst(SRC_PHONE_FORMAT.toString(), DEST_PHONE_FORMAT.toString());
        System.out.println(dest);
 }
{{< /highlight >}}

<br> 

맨처음에는 패턴들에 통째로 `replaceAll을` 걸었는데 그럼 결과가 그냥 DEST_PHONE_FORMAT.toString()이랑 동일한 결과가 나온다. 
`replaceFirst를` 걸어서 ()()() 이렇게 끊어서 하나씩 적용을 시켜주면 된다. 원래 regex group으로 값들을 꺼내서 바꿀까 했는데 이 쪽이 조금 더 명시적인 느낌이 들었다. 

<br> 

# Extracting SubString

### Extracting before and after of specific character

Let's say I get string with static prefix and I only need string after the prefix. 

For example, `A:COME_IN`. `A` is prefix and I only need `COME_IN`.
I could guess prefix is only one character, however it wouldn't be general to many case. So I will set wild care before and after of the prefix.

<br> 

> Extracting before and after with `:`  

{{< highlight java  "linenos=true,hl_inline=false" >}}

String src = "A:COME_IN"; 

Pattern pattern = Pattern.compile("([^,]*):([^,]*)");
Matcher mater = pattern.matcher(src);

if(mater.find()) {
        String before = mater.group(1); // "A"
        String after = mater.group(1); // "COME_IN"
}
{{< /highlight >}}

<br>

> Code detail 
- Use `find()` to move forward. It works like iterator `hasNext()`. It keeps moving after checking a part of the src string. Finding makes matcher keep moving forward
- `group(0)` return whole chosen string if src matches pattern. `group(1)` is 'A', `group(2)` is 'COME_IN'

<br> 

I usually don't make matcher. I just go for `pattern.matcher(src).matches` because in that case I don't have to return a string. It was just for checking existence and compatibility for format.
But in this case, I have to return sub string.



<br> 

### Extracting between special characters

Think about string like this. `I (Love) you` and let's say I want to extract Love. This will teach me how to do this.

<br> 

> Extract Love between `()`

{{< highlight java  "linenos=true,hl_inline=false" >}}

Pattern pattern = Pattern.compile("\\((.*?)\\)");
        Matcher matcher = pattern.matcher(src);

        if(matcher.find()) {
            System.out.println(matcher.group(0)); // (Love)
            System.out.println(matcher.group(1)); // Love
        }
{{< /highlight >}}

<br> 

> Code detail

- `\\` is escape for `(` and `)`. It is well known fact that some characters can cause confusion to computer, so it's like safety lock for those kind of letters.

<br> 

Leave the link about group for later. I think I'll confused by the concept again [[what is group in java regex]](https://www.tutorialspoint.com/javaregex/javaregex_capturing_groups.htm)
