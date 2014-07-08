Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

Files:
<ul>
<li><code>Dockerfile</code> - Docker file for building a Docker Image</li>
<li><code>config.ini</code> - SciDB's configuration file</li>
<li><code>setup.sh</code> - It removes existing containers and images. Then, it creates a Docker image called "scidb_img".</li>
<li><code>containerSetup.sh</code> - It set ups SciDB inside a container and creates some test data.</li>
<li><code>iquery.conf</code> - IQUERY configuration file.</li>
</ul> 

Instructions:

<ol>
<li>Clone the project and CD to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
<li>Modify the scripts to fit your needs</li>
	<ol>
	<li><code>Dockerfile</code> sets up the passwords for root, postgres and scidb users</li>
	<li><code>config.ini</code> sets up the user and password for scidb on postgres</li>
	</ol> 
<li>Enable <code>setup.sh</code> for execution (<code>chmod +x setup.sh</code>) and run it (<code>./setup.sh</code>): This will create a new image from the Dockerfile. <b>WARNING: This will delete all the stopped containers and unused images</b>.
<li>Start a container. For example, this command starts the container "scidb1" and it maps the host's folder "test" to the container's folder "data": <code>docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test:/home/scidb/data scidb_img</code></li>
<li>Log into the container: <code>ssh -p 49901 root@localhost</code></li>
<li>Execute <code>/home/root/containerSetup.sh</code>. <b>NOTE</b>: You need to copy & paste the commands to a terminal</li>
</ol> 

<b>NOTES</b>:<br/>
Changing SciDB setup requires modifying <code>config.ini</code> and later a modification on <code>containerSetup.sh</code>. For example, changing single instance default configuration for one with 7 instances would require changing the lines on <code>containerSetup.sh</code>:

<ul>
<li><code>yes | scidb.py initall scidb_docker</code></li>
<li><code>scidb.py startall scidb_docker</code></li>
<li><code>scidb.py status scidb_docker</code></li>
</ul>


For these:
<ul>
<li><code>yes | scidb.py initall scidb_docker_bigdata</code></li>
<li><code>scidb.py startall scidb_docker_bigdata</code></li>
<li><code>scidb.py status scidb_docker_bigdata</code></li>
</ul>
