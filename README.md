Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB 14.12</a>. NOTE: This is not the latest version of SciDB but the last one to offer a binary install. 

<h3>Files:</h3>
<ul>
	<li><code>LICENSE</code> - License file.</li>
	<li><code>README.md</code> - This file.</li>
	<li><code>conf</code> - SHIM configuration file.</li>
	<li>Docker files:
		<ul>
			<li><code>Dockerfile</code> - Docker file for building a Docker Image.</li>		
			<li><code>setup.sh</code> - Host script for removing old containers and images from host machine. Then, it creates a Docker image called "scidb_img".</li>
		</ul>
	</li>
	<li>Container files:
		<ul>
			<li><code>containerSetup.sh</code> - Script for setting up SciDB on a container. It also creates some test data.</li>		
			<li><code>iquery.conf</code> - IQUERY configuration file.</li>
			<li><code>startScidb.sh</code> - Container script for starting SciDB.</li>
			<li><code>stopScidb.sh</code> - Container script for stopping SciDB.</li>
			<li><code>scidb_docker.ini</code> - SciDB's configuration file.</li>
		</ul>
	</li>
</ul>


<h3>Prerequisites:</h3>
<ul>
	<li>Internet access.</li>
	<li><a href="http://www.docker.com/">Docker</a>.</li>
</ul>


<h3>Instructions:</h3>
<ol>
	<li>Clone the project and then go to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
	<li>Modify the configuration file <em>scidb_docker.ini</em> according to your needs and your hardware. Here you can find a helper <a href="https://github.com/Paradigm4/configurator">application</a>.</li>
	<li>Enable <code>setup.sh</code> for execution <code>chmod +x setup.sh</code> and run it <code>./setup.sh</code>. This creates a new Docker image from the Dockerfile and then it starts a container. You can also create containers manually using a command like this: <code>docker run -d --name="scidb1" -p 49901:22 -p 49902:8083 --expose=5432 --expose=1239 scidb_img</code></li>
	<li>Log into the container: <code>ssh -p 49901 root@localhost</code>. The default password is <em>xxxx.xxxx.xxxx</em></li>
	<li>Execute the script <code>/home/root/./containerSetup.sh</code>. This script set SciDB up and then it runs a small query.</li>
</ol>


<h5>NOTES:</h5>
<ul>
	<li><code>containerSetup.sh</code> includes commands for moving postgres' files to a different folder. Mounting a docker volume on that folder enables storage of catalog data in the host.</li>
	<li>When using volumes, match user's ID of a container-user "scidb" to a host-user with the proper writing rights.</li>
</ul>

