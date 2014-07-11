Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

Files:
<ul>
<li><code>.pam_environment</code> - User's environmental variable file.</li>
<li><code>Dockerfile</code> - Docker file for building a Docker Image.</li>
<li><code>LICENSE</code> - License file.</li>
<li><code>README.md</code> - This file.</li>
<li><code>conf</code> - SHIM configuration file.</li>
<li><code>config.ini</code> - SciDB's configuration file.</li>
<li><code>containerSetup.sh</code> - Commands for setting up SciDB inside a container. It also creates some test data.</li>
<li><code>iquery.conf</code> - IQUERY configuration file.</li>
<li><code>setup.sh</code> - Host script for removing existing containers and images from host machine. Then, it creates a Docker image called "scidb_img".</li>
<li><code>startScidb.sh</code> - Simple script for starting SciDB.</li>
<li><code>stopScidb.sh</code> - Simple script for stopping SciDB.</li>
</ul>

Prerequisites:
<ul>
<li><a href="http://www.docker.com/">Docker</a></li>
</ul>

Instructions:

<ol>
<li>Clone the project and CD to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
<li>Modify the scripts to fit your needs:
	<ul>
	<li><code>Dockerfile</code> sets up the passwords for root, postgres and scidb users.</li>
	<li><code>config.ini</code> sets up the user and password for scidb user on postgres.</li>
	</ul> 
</li>
<li>Enable <code>setup.sh</code> for execution (<code>chmod +x setup.sh</code>) and run it (<code>./setup.sh</code>): This creates a new image from the Dockerfile. <b>WARNING: This will delete all the stopped containers and unused images</b>.
<li>Start a container. For example, these examples create a container called "scidb1" from the "scidb_img" image:
	<ul>
	<li>Keep all the data in the container: <code>docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 scidb_img</code></li>
	<li>Keep SciDB's data on a host's folder: <code>docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test/data:/home/scidb/data scidb_img</code></li>
	<li>Keep SciDB's data and catalog (postgres) data on host's folders: <code>docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test/data:/home/scidb/data -v /var/bliss/scidb/test/catalog:/home/scidb/catalog scidb_img</code></li>
	</ul>
</li>
<li>Log into the container: <code>ssh -p 49901 root@localhost</code></li>
<li>Execute the commands in <code>/home/root/containerSetup.sh</code>. <b>NOTE</b>: You need to copy & paste the commands to a terminal</li>
</ol> 

<b>NOTES</b>:
<br/>
<br/>
<code>containerSetup.sh</code> despite the extension, this file is not meant to be ran as a bash script.
<br/>
<br/>
<code>containerSetup.sh</code> includes instructions on moving postgres files to a different folder. Mounting a volume on that folder enable storage of catalog data in the host.
<br/>
<br/>
When using volumes, match user's ID of a container-user "scidb" to a host-user with the proper writing rights.
<br/>
<br/>
Changing SciDB setup requires the addition of a new configuration to <code>config.ini</code> and later a modification on <code>startScidb.sh</code>. For example, changing single instance default configuration for one with 7 instances would require changing the lines on <code>startScidb.sh</code>:
<ul>
<li><code>scidb.py initall scidb_docker</code></li>
<li><code>scidb.py startall scidb_docker</code></li>
<li><code>scidb.py status scidb_docker</code></li>
</ul>
For these:
<ul>
<li><code>scidb.py initall scidb_docker_bigdata</code></li>
<li><code>scidb.py startall scidb_docker_bigdata</code></li>
<li><code>scidb.py status scidb_docker_bigdata</code></li>
</ul>
