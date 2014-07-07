Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

Files:
<ul>
<li>Dockerfile - Docker file for building a Docker Image</li>
<li>config.ini - SciDB's configuration file</li>
<li>setup.sh - It removes existing containers and images. Then, it creates a Docker image called "scidb_img".</li>
<li>containerSetup.sh - It creates a container "scidb1" from "scidb_img"</li>
<li>iquery.conf - IQUERY configuration file</li>
</ul> 

Instructions:

<ol>
<li>Clone the project and CD to the docker_scidb folder</li>
<li>Modify the scripts to fit your needs</li>
	<ol>
	<li>setup.sh mounts the host's folder /var/bliss/scidb/test in to the container as /home/scidb/data.</li>
	<li>The Dockerfile sets up the passwords for root, postgres and scidb users</li>
	</ol> 
<li>Enable setup.sh for execution (chmod +x setup.sh) and run it: This will create a new image from the Dockerfile. <b>WARNING</b>: This will delete all the stopped containers and unused images.
<li>Start a container. For example: docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test:/home/scidb/data scidb_img</li>
<li>Log into the container using: ssh -p 49901 root@localhost</li>
<li>Execute /home/root/containerSetup.sh. <b>NOTE</b>: You need to copy & paste the commands to a terminal</li>
</ol> 

<b>NOTES</b>:<br/>
Changing SciDB setup requires modifying config.ini and later a modification on containerSetup.sh. For example, changing single instance default configuration for one with 7 instances would require changing the lines on containerSetup.sh:

<ul>
<li>yes | scidb.py initall scidb_docker</li>
<li>scidb.py startall scidb_docker</li>
<li>scidb.py status scidb_docker</li>
</ul>


For these:
<ul>
<li>yes | scidb.py initall scidb_docker_bigdata</li>
<li>scidb.py startall scidb_docker_bigdata</li>
<li>scidb.py status scidb_docker_bigdata</li>
</ul>
