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
<li>Clone/Donwload the files to a folder</li>
<li>Modify scripts to fit your needs</li>
<li>CHMOD the SH files</li>
<li>Execute setup.sh. NOTE: This will remove the stopped containers and unused docker images</li>
<li>Log in your container</li>
<li>Execute containerSetup.sh inside the container</li>
</ol> 
