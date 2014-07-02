Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

Files:
<ul>
<li>Dockerfile - Docker file for building a Docker Image</li>
<li>config.ini - SciDB's configuration file</li>
<li>setup.sh - It removes existing containers and images. Then, it creates a Docker image called "scidb_img" and starts a container (scidb1). Finally, it tries to SSH the container</li>
<li>containerSetup.sh - It creates a container "scidb1" from "scidb_img"</li>
</ul> 

Instructions:

<ol>
<li>Clone the project and CD to the docker_scidb folder</li>
<li>Modify scripts to fit your needs</li>
	<ol>
		<li><b>NOTE</b>: setup.sh removes the stopped containers and the unused images, ALL OF THEM!</li>
		<li>The Dockerfile sets up the passwords for root, postgres and scidb users</li>
	</ol> 
<li>Enable setup.sh for execution (chmod +x setup.sh) and run it. This scrit tries to SSH the newly container, if it fails, use ssh -p 49901 root@localhost</li>
<li>Execute /home/root/containerSetup.sh. <b>NOTE</b>: You need to copy & paste the commands to a terminal</li>
</ol> 

<b>NOTES</b>:<br/>
Changing SciDB setup requires modifying config.ini. For example, changing single instance default configuration for one with 7 instances would require changing the lines:

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