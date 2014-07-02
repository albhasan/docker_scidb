Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

Files:
<ul>
<li>Dockerfile - Docker file for building a Docker Image</li>
<li>config.ini - SciDB's configuration file</li>
<li>setup.sh - Script for creating a Docker image</li>
<li>containerSetup.sh - Script for setting up SciDB inside a container</li>
</ul> 

Instructions

<ol>
<li>Clone the project to a folder</li>
<li>Modify scripts to fit your needs</li>
	<ol>
		<li><b>NOTE</b>: setup.sh removes the stopped containers and the unused images, ALL OF THEM!</li>
		<li>The Dockerfile sets up the passwords for root, postgres and scidb users</li>
	</ol> 
<li>CHMOD the SH files</li>
<li>Execute setup.sh. NOTE: This will remove the stopped containers and unused docker images</li>
<li>Log in your container</li>
<li>Execute /home/root/containerSetup.sh. <b>NOTE</b>: You need to copy and paste the commands to a terminal</li>
</ol> 
