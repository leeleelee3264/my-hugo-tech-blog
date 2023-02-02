+++
title = "[Infra] (en) Write Shell script to deploy server and rotate log"
date = "2021-01-05"
description = "Write shell script to deploy server and rotate log."
tags = ["Infra"]
+++


<br>
<br> 

> Write shell script to deploy server and rotate log.

<br> 

**Index**
1. Shell script to deploy server
2. Shell script to rotate log 
3. (plus) `/dev/null`

<br> 

##### UPDATE VERSION OF SHELL SCRIPT WITH PASSWORD
One month ago, I make this shell script with hard coded user password and I knew that was a bad idea. It is well known fact that leaving password somewhere or some files can be a huge problem with security later. So I decided to fix it.

<br>

> How to request password in shell script 

{{< highlight bash  "linenos=true,hl_inline=false" >}}

#!/bin/bash

# This file is for deployment  aiv site to latest version. 

echo enter the password for ${USER} and press enter
IFS= read -rs PASSWD
sudo -k 

if sudo -lS &> /dev/null <<EOF
$PASSWD
EOF

then 
	sudo systemctl reload shiny-server
	sleep .9
	sudo systemctl status shiny-server | cat
	echo "Successfully updated aiv" 
else 
	echo "The password is wrong. Please check again" 
fi
{{< /highlight >}}


<br>

In this way, I don't have to hard code password. It will check the password and then do other thing. It deletes the password after that, so if I want to do one more, I have to enter the password again.     


<br>
<br>

# Shell script to deploy server 
Today, I handed over a project to a teammate I had taken over from a colleague who was about to quit the job. The one thing I was concerning is the fact that the teammate
will take over whole part of the project. It means she is going to do deploy as well and she is quite new with Linux.  

I didn't think it is a good idea to let her know all the command using for deployment. 
So I decided to making shell script containing the command! (I've wanted to learn about shell script too)

<br>

### Let's write the script step-by-step
The most important beginning of shell script! As far as I remember, all the shell script is working with `bash` file in bin directory. To execute shell script, do not forget to wirte `#!/bin/bash` line.


{{< highlight bash  "linenos=true,hl_inline=false" >}}

#!/bin/bash
{{< /highlight >}}


<br>

Give the bash file you were writing execution roll. Bash file is for execution after all. This is almost everything I know about shell script. Now let's take a look at the bash file I wrote today.



{{< highlight bash  "linenos=true,hl_inline=false" >}}

touch test_bash.sh 
chmod +x test_bash.sh
{{< /highlight >}}


<br> 

> deploy shell script

{{< highlight bash  "linenos=true,hl_inline=false" >}}

#!/bin/bash 

# add some comment to let people know what this bash file for. 

pw="password_I_used_in_server"

echo ${pw} | sudo -kS systemctl reload shiny-server 
sleep .5

echo ${pw} | sudo -kS systemctl status shiny-server | cat 
echo "Successfully updated aiv"
{{< /highlight >}}

<br> 

> deploy shell script detail 

1. `echo ${pw}` (lint 7)
   - I wanted to make bash file which passes writing password in the middle of execution. So I just give password as param. 
   - For this, I have to write pw in a file in advance. Bad for security. Need to think about more secure way. 
2. `sudo -kS` (line 7)
   - `S` is for getting password from 'echo' command.  
   - `k` is for reset timestamp. When the timestamp remains in sudo command, it might cause some error.
3. `sleep .5` (line 8)
   - To put delay from reloading. 
4. `systemctl status shiny-server | cat` (line 10) 
   - I want to show the status of service. 
   - But Systemctl needs to be quit. So I just printed it.


<br>

### Shell Script to deploy spring server

In previous example, I wrote shell script to deploy shiny-server. But I usually use shell script to deploy `Spring jar` server. 

<br>

> deploy shell script for Spring 

{{< highlight bash  "linenos=true,hl_inline=false" >}}

#!/bin/bash

DATE=`date +'%Y%m%d'`
echo $DATE

ETC_JAVA_OPTS=-XX:+UseStringDeduplication

# supposed to be one line.    
nohup java -Xms128m -Xmx128m -XX:NewRatio=1 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps  
-XX:+PrintGCDateStamps -Xloggc:./gc.log -Dspring.profiles.active=prod $* -jar file_name.jar >> ./server.log &

tail -F server.log
{{< /highlight >}}


<br>

It's Java, so I passed GC, heap size, running profile etc.

It should be running in `background`. Unless, it will get stopped when I close a terminal which is running jar. So I used `nohup` command.

The file is not just about running jar file. It makes log file keep going. `>>` command means stdout will be remained in a file located right behind the command. Tail is just to make sure the jar file is successfully built.

<br>

# Shell script to rotate log



> shell script to rotate log

{{< highlight bash  "linenos=true,hl_inline=false" >}}

#!/bin/bash

DATE=`date +'%Y%m%d'`
DATE2=`date +'%Y%m'`

LOG_FILENAME=backup_server$DATE.log
LOG_DIRNAME="backup_server${DATE2}_log"


if [ -e $LOG_FILENAME ]
then
    echo "$LOG_FILENAME exist"
else
    echo "cp server.log $LOG_FILENAME"
    cp server.log $LOG_FILENAME
    cp -f /dev/null server.log

    echo "now tail.."
fi

# moving log to dir file script
if [ -e $LOG_DIRNAME ]
then
 :
else
 mkdir $LOG_DIRNAME

fi

mv $LOG_FILENAME $LOG_DIRNAME

tail -F server.log
{{< /highlight >}}


This one is for managing log file. These two main process are like that. 

(1) make current log file to backup file and make new log file to be used soon  
(2) move freshly made backup log file to proper log file directory. 

<br> 

# `/dev/null`

What is `/dev/null` in the bash command? It's like _official empty file of Linux_. The file is always empty. It has to be.

In the bash, I didn't delete server.log file, because I'll keep using it after moving all contents in file to a backup file. In this purpose, `/dev/null` is best choice.
Think like this.

<br> 

> Scenario detail  
1. `/dev/null` is always empty
2. Copy content in `/dev/null` to server.log
   - It means content(which is empty) is copied to server.log. Basically, server.log file should be empty too.
3. You can also use 'cat /dev/null > server.log'
   - cat will print `/dev/null` content(which is empty) and '>' will pass the content to specific file(server.log).

<br> 


Using this command makes so easy to remove data and make file size to zero. I have a feeling it will be super useful managing linux server memory!

 