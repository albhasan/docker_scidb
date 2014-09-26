Docker SciDB
============

Scripts for building a <a href="http://www.docker.com/">Docker</a> image of the array database <a href="http://www.scidb.org/">SciDB</a> 

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
			<li><code>scidb_docker_XX.ini</code> - SciDB's configuration files (see table below).</li>
		</ul>
	</li>
	<li><code>updatePortsPass.sh</code> - Host script for changing other scripts's configuration (ports, passwords, SciDB configuration)</li>
</ul>


<h3>Prerequisites:</h3>
<ul>
	<li>Internet access.</li>
	<li><a href="http://www.docker.com/">Docker</a>.</li>
</ul>


<h3>Instructions:</h3>
<ol>
	<li>Clone the project and CD to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
	<li>Enable <code>setup.sh</code> for execution (<code>chmod +x setup.sh</code>) and run it (<code>./setup.sh</code>): This creates a new image from the Dockerfile.</li>
	<li>Start a container. These examples create a container called "scidb1" from the "scidb_img" image:
		<ul>
		<li>Keep all the data in the container:   <code>docker run -d --name="scidb1" -p 49901:49901 -p 49902:49902 --expose=49903 --expose=49904 scidb_img</code></li>
		<li>Keep SciDB's data on a host's folder: <code>docker run -d --name="scidb1" -p 49901:49901 -p 49902:49902 --expose=49903 --expose=49904 -v /var/bliss/scidb/test/data:/home/scidb/data scidb_img</code></li>
		<li>Keep SciDB's data and catalog (postgres) data on host's folders: <code>docker run -d --name="scidb1" -p 49901:49901 -p 49902:49902 --expose=49903 --expose=49904 -v /var/bliss/scidb/test/data:/home/scidb/data -v /var/bliss/scidb/test/catalog:/home/scidb/catalog scidb_img</code></li>
		</ul>
	</li>
	<li>Select a configuration file that suits your needs and your hardware, for example <code>scidb_docker_2a</code> (see table below).</li>	
	<li>Log into the container: <code>ssh -p 49901 root@localhost</code>. The default password is <em>xxxx.xxxx.xxxx</em></li>
	<li>Execute the script using the SciDB configuration file of your preference <code>/home/root/./containerSetup.sh scidb_docker_2a.ini</code></li>
</ol> 


<h5>NOTES:</h5>
<ul>
	<li><code>containerSetup.sh</code> includes commands for moving postgres' files to a different folder. Mounting a volume on that folder enables storage of catalog data in the host.</li>
	<li>When using volumes, match user's ID of a container-user "scidb" to a host-user with the proper writing rights.</li>
</ul>


<h5>SciDB setup files:</h5>
<table>
  <tr>
    <th>Name</th>
    <th>Instances per server<br></th>
    <th>Max concurrent connections<br></th>
    <th>CPU cores per server<br></th>
    <th>GB per server<br></th>
  </tr>
  <tr>
    <td>scidb_docker_1.ini</td>
    <td>1<br></td>
    <td>2</td>
    <td>2</td>
    <td>2</td>
  </tr>
  <tr>
    <td>scidb_docker_2.ini</td>
    <td>2</td>
    <td>2</td>
    <td>4</td>
    <td>4</td>
  </tr>
  <tr>
    <td>scidb_docker_2a.ini</td>
    <td>2</td>
    <td>2</td>
    <td>4</td>
    <td>8</td>
  </tr>
  <tr>
    <td>scidb_docker_2b.ini</td>
    <td>2</td>
    <td>2</td>
    <td>4</td>
    <td>16</td>
  </tr>
  <tr>
    <td>scidb_docker_4.ini</td>
    <td>4</td>
    <td>4</td>
    <td>4</td>
    <td>16</td>
  </tr>
  <tr>
    <td>scidb_docker_8.ini</td>
    <td>8</td>
    <td>16</td>
    <td>24</td>
    <td>160</td>
  </tr>
</table>


Compile SciDB in a container
============================

<ul>
	<li>Clone the project and CD to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
	<li>Go to the <code>dev</code> folder</li>
	<li>Enable <code>setup.sh</code> for execution (<code>chmod +x setup.sh</code>) and run it (<code>./setup.sh</code>): This creates a new image from the Dockerfile in the <code>dev</code> folder. </li>
	<li>Start a container <code>docker run -d --name="scidb_dev1" -p 49901:22  --expose=22 --expose=1239 --expose=5432 scidb_dev_img</code></li>
	<li>Log in the container <code>ssh -p 49901 root@localhost</code>. The password is <em>xxxx.xxxx.xxxx</em> for all the users.</li>
	<li>Execute the script <code>/./containerSetup.sh</code>.</li>
</ul>

