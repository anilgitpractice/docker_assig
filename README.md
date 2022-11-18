# Csvserver application dockerization 

### References for some useful docs.

[Docker hub ](https://hub.docker.com/).

[Docker docs](https://docs.docker.com/).

[Shell scripting](https://www.tutorialspoint.com/unix/shell_scripting.htm).

[Csvserver git url](https://github.com/infracloudio/csvserver).

1. Install docker on your machine by below url [ Installation url ](https://docs.docker.com/desktop/install/linux-install/).

2.  After completion of the docker installation follow the below steps for the dockerization of csvserver application.

3. First of all you can download or clone the csvserver application to the above csvserver git url.

3. After downloading or cloning the repository you get a **master.zip file** unzip the file by using the below command.
 ~~~
 $ unzip master.zip file 
~~~
4. Then you have get a README.md file and **solution** folder, cd  into the **solution** directory.

## Pulling required images from dockerhub

1. First pull the required image to the local repository  by using the below docker command
~~~
docker  pull <image name : tag >
~~~
2. In this case we required a **infracloudio/csvserver:latest** docker image from 
docker hub so execute command shown in below
~~~
 docker  pull  infracloudio/csvserver:latest 
~~~
3. By executing the command```<docker images>``` you can see the available images in the docker local repository 

## Running a docker image 

1. If want run a docker image you want execute the following command
~~~
docker  run  <image name :tag> 
~~~~
2. The above command you have not mention  a tag docker taking a latest default

3. When you execute this command the docker daemon first checks the image in local repository if it is not present in local repository the demon goes to the dockerhub    and pull the image into local repository automatically  and run the container 

4. In the this case we have already pulled the **infracloudio/csvserver:latest** image in our local repository so you can execute the following command  shown in below 
~~~
docker run infracloudio/csvserver:latest
~~~
5. In our case we have to run the container in detach/background mode so we have to use **-d** tag on docker run command.
~~~
docker run -d  infracloudio/csvserver:latest 
~~~
6.Tag **-d** runs the container in detached/background mode.

7.You can check, if the container started or not by using the command 
~~~
docker ps
~~~
8.It will shoes the running containers in the docker engine
 
9.If you want to see all the available containers like stopped,paused ,and exited containers by adding the tag **-a** to the above command.
~~~
docker  ps -a
~~~

10. In our case *infracloudio/csvserver:latest* The image created a container but it is not running. It is  in  the excited state  that's why it is not shown in the ```docker ps``` command. so we have to use another command ```docker ps -a``` it will shows the all containers in the docker engine 

![image](https://user-images.githubusercontent.com/97168620/202320390-53d9454b-0dcf-444a-b958-96a4665c35d5.png)

11. **infracloudio/csvserver:latest** The image created a container but is in an excited state. So we have to know the reason for this error

12. If we want find out the reason/error by approaching to logs by using the following docker command 
~~~
docker  logs <containerID>
~~~
![image](https://user-images.githubusercontent.com/97168620/202320817-cddbe5ee-9e33-4dbf-879c-7e8aa485831f.png)

13. It is showing a reason for the error it requires a  input data from the host /source to the container

14. So you can pass the input data by using the volume tag  **-v** into the docker run command.
~~~
docker  run -d  -v source path:destination path <image name:tag> 
~~~
15. In our case we have to pass the input data to the container by using the **gencsv.sh** to write a script for generating a file named **inputFile**  inside of this file to generate comma separated values with index and random numbers.
 
16. For creating the gencsv.sh shell script first  create a file name gencsv.sh by using      the
~~~
 $ touch  gencsv.sh
~~~

17. After writing the shell script, run the shell script file by using the commands ```./gencsv.sh``` or ```sh gencsv.sh```
![image](https://user-images.githubusercontent.com/97168620/202326397-572f5f86-59bd-4825-8e41-95c16cb15758.png)

18. It will generates the  inputFile and ten entries  comma separated values with index and random numbers

19. Now you can give the source path to docker run command where the inputFile is generated and destination path it is shown in **error log** 
 
20. After generating an inputFile again, run the container by using the command
~~~
docker run -d  -v source path:destination path <infracloudio/csvserver:latest >
~~~
21.  After running the docker run command shown in (20). The container will running in background mode so you can execute the command shown in (7).you can see the running container 

![image](https://user-images.githubusercontent.com/97168620/202326866-ab54061a-5fbb-4698-955f-5fa5b501fd07.png)

22. After running the container we have to Get shell access to the container and find the port. on which port  application is listening.

23. If you want to execute the commands on a running container by using the following docker command 
~~~
docker  exec -it <container ID> command to pass 
~~~
24. In this **-it** means the interactive mode

25. Command to pass means which command to pass inside of a container 

26. In our case we used the following command to access the shell inside of a container 
~~~
docker  exec -it <our container ID> /bin/bash
~~~
![image](https://user-images.githubusercontent.com/97168620/202308483-08a43533-8a7b-4002-9666-d830d534f470.png)
 
27. Getting inside of a container you want to see the port on which the application is listing by using the linux command inside of a container that is
~~~
$ netstat  -nltp
~~~
28. It will shows the active listing ports inside of a container  and process id and the state of the process 

29. In our case it showing **9300/tcp** port in the state is listing 

![image](https://user-images.githubusercontent.com/97168620/202327381-82aeae46-6bed-48bb-a935-0d079783c72a.png)

30. If you want to see the host port of a  container lets execute a docker command 
~~~
docker  inspect <container ID>
~~~
31. When we execute this command it shows the bunch of data in the json format 

32. You can check the  exposed port and host port in the network section 

33. In our case it shows this ports shown in below

![image](https://user-images.githubusercontent.com/97168620/202327750-fa69bf25-7166-4d47-854e-8fe36aa471a1.png)

34. Once we knowing about the ports stop/delete the container 
```
docker stop <containerID>
docker  rm < containerID>
```
![image](https://user-images.githubusercontent.com/97168620/202319925-a3684067-8e53-442b-ac66-ad6c8d20c9cd.png)

35. Above case we see the application in a listing state inside of a container. Now we have to expose our container to the outside world(web accessing) so we have to do port mapping.

36. You can do the port mapping by passing the **-p** tag into a docker run command shown below.
~~~
docker run -p hostport:container port <image name:tag>
~~~
37. In our case we  observed  two ports one is container port **9300/tcp** and host port **9393**. So we have to mapping this ports in a docker run command by using the **-p** tag shown below.
~~~
docker  run -d  -p 9393:9300 -v source path:destination path infracloudivserver:latest
~~~
38. Now the container will be started. We have to access this in a web page. 

39. The application is accessible on the host at http://localhost:9393.

The output look like this 

![image](https://user-images.githubusercontent.com/97168620/202328156-e49900fa-d968-4e3c-8567-4b7a79ed4c7c.png)

40. It is successfully accessing the web and showing some data in the web page.

41.  Our application requirements we have to set the  environmental variable to the container by executing the docker command.
 
42. So we have to pass environment variables to the docker run command by using the  **--env** or **-e environment variable name=value** 
~~~
docker run -e environment_varible=false <image name:tag>
~~~
43. In our case they provide one environment variable named. 
**CSVSERVER_BORDER** to have the value of **Orange**. So we have to execute docker run command like shown below
~~~
docker run -d -p 9393:9300 -e CSVSERVER_BORDER=Orange -v source path:destination path  infracloudio/csvserver:latest
~~~
44. In the web page we have seen a difference in welcome note should have an orange color border.

![image](https://user-images.githubusercontent.com/97168620/202318100-f4231a0f-4f82-445b-9d7d-97ca299e1f2d.png)

45. So we successfully dockerized our csvserver application. 

