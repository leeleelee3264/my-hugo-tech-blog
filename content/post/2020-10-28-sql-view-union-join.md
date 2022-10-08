+++
title = "(en) MySQL View and UNION/JOIN"
date = "2020-10-28"
description = "MySQL View and UNION/JOIN"
tags = ["Infra"]
+++

<br>
<br> 

> MySQL View and UNION/JOIN 

<br> 

**Index**
1. Intro
2. View 
3. UNION/JOIN 

<br> 

# Intro 

Today, I faced my big mistake with new updated function which is made by me as well. The situation is something like this. We have a message service firing with multiple condition such as accomplish of today's step count or tag reminder of today's goal. 

<br> 

### Table Design

When we designed tables, we separate to act_message and goal_message. (Obviously, it's design error. I was supposed to create one table for these two). And there is mp3 file table music_list because the message will be playing designated mp3 file when it gets fired. 

In act_message and goal_message, voice_id is recorded and it stands for the id of music in music_list. 

<br> 

> Tables 
- act_message
- goal_message (structure is the same with act_message)
- music_list

<br> 

> Tables' Columns

{{< highlight markdown  "linenos=true,hl_inline=false" >}}

1. act_message, goal_message table

| id | voice_id | message_type | is_active |
|----|----------|--------------|-----------|
| 1  | 100      | V            | N         |
| 2  | 43       | V            | Y         |

2. music_list 
| id  | title        | url                |
|-----|--------------|--------------------|
| 43  | Oh happy day | https://something1 |
| 100 | 43           | https://something2 |
   {{< /highlight >}}


<br> 

### Troubleshooting
So, the new updated function was that _delete mp3 file in music_list_. 

What I forgot was that messages will not send when they cannot find recorded voice_id in music_list. Finally, mp3 file was removed clearly and messages which were supposed to be sent just stay calm.

I should have checked the mp3 usage before removing. For this, I thought about how to gather voice id in all the separated message tables.  
As you can predict, I decided to go with `UNION` query. _But the query statement won't be short due to combine many message tables_. At that moment my project manager recommended me to use `View`!

<br> 

# View 

I had never used VIEW command before. I did some research and found out VIEW is more like result of reserved select statement which is not a real table but fake one.   
As far as I remember, VIEW table is literally for view. It cannot work with `delete`, `update` and `insert`. For short, it cannot manipulate real data in database.

<br> 

> View  
- View is basically reserved select statement.
- View table will be made when the view table called in query.
- So you don't have to worry about updating data in View table. It will be updated every single time you call the table.
- There is no performance benefit of using view. It's the same with select query.
- The good thing is that you don't have to execute complicated select query. It's already made with View.


<br> 

# UNION and JOIN

Now let's talk about union a bit more. As you can see, I will use `UNION` command in the former query to collect all the voice id in tables. Collecting data in one place... Familiar for you? 

Yes! It sounds like `JOIN`. I used join many times, mostly when I have to combine two tables with one same value. For example, I have a table for user's birthday and a table for user's name and they both have user_id in the data. Then I can connect them with user_id and will get user's name and birthday at once.

<br> 

### JOIN VS UNION 

I want to think about the difference between UNION and JOIN. It's quite simple. UNION combine data to column when JOIN combine data to row. What I mean is, UNION will extend top to bottom and JOIN will extend left to right.

- If you want to have `additional data` in other table, go for JOIN.
- If you want to combine data in other table as `same value`, go for UNION.

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://i.stack.imgur.com/LSPyQ.png" >
<figcaption align = "center">[Picture 1] Join process</figcaption>

<br> 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://i.stack.imgur.com/l4hxo.png" >
<figcaption align = "center">[Picture 2] Union process</figcaption>


<br> 


There is an excellent explanation of [[What is the difference between JOIN and UNION?]](https://stackoverflow.com/questions/905379/what-is-the-difference-between-join-and-union#)

<br> 

### Final Query with View and Union 

Here is my final query! I made v_voice_usage which contains only one column 'voice_id'. I can use v_voice_usage as a normal table when it comes to using select command. And as I said, the view query will build table when I'm looking for v_vocie_usage.

<br>

> Query 

{{< highlight sql  "linenos=true,hl_inline=false" >}}

CREATE VIEW v_voice_usage AS
SELECT voice_id 
FROM act_message
WHERE message_type = 'V' AND voice_id > 0

UNION ALL

SELECT voice_id 
FROM goal_message 
WHERE message_type = 'V' AND voice_id > 0

// Let's say if I have two voice id 'voice_id' and 'voice_id2', I can use this way too. 
SELECT voice_id 
FROM act_message 
WHERE message_type = 'V' AND voice_id > 0

UNION ALL

SELECT voice_id2 AS voice_id
FROM act_message
WHERE message_type = 'V' AND voice_id2 > 0
{{< /highlight >}}

<br> 


> Query Result 

{{< highlight markdown  "linenos=true,hl_inline=false" >}}

| voice_id |
|----------|
| 1        |
| 43       |
| 100      |
| 5223     |
{{< /highlight >}}


<br> 


### UNION ALL or UNION? 
If I write `UNION` query, I wouldn't get duplicated value. _UNION command will distinct the same values._ It's pretty awesome function. However, it comes with price just like `DISTINCT` command. As you know _DISTINCT is not cheap_. It will make your program become quite slowly. 

If I don't care about duplicated values or you can handle it in server side, then I would go with `UNION ALL`.
It doesn't contain distinct process. Less work, faster query result.

<br> 

### Where to put WHERE for performance  

- `The worst case`
  - use WHERE on the result of UNION. 
  - all the distinct work and meaningless combine
- `Slightly better case`
  - use WHERE before UNION. 
  - at least query will sort the data which is suitable with condition
- `Better case`
  - use WHERE before UNION ALL 
  - less work + less wok

<br> 

> Put WHERE 

{{< highlight sql  "linenos=true,hl_inline=false" >}}

// 1. the worst
CREATE v_voice_usage AS
SELECT voice_id 
FROM act_message

UNION 

SELECT voice_id 
FROM goal_message 

SELECT *
FROM v_voice_usage
WHERE voice_id > 0 

// 2. better case
SELECT voice_id 
FROM act_message
WHERE message_type = 'V' AND voice_id > 0

UNION 

SELECT voice_id 
FROM goal_message 
WHERE message_type = 'V' AND voice_id > 0

// 3. Better case
SELECT voice_id 
FROM act_message
WHERE message_type = 'V' AND voice_id > 0

UNION ALL

SELECT voice_id 
FROM goal_message 
WHERE message_type = 'V' AND voice_id > 0
{{< /highlight >}}

