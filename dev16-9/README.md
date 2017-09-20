Docker SciDB
============

Scripts for building SciDB 16.9 inside a Docker container

<h3>Files:</h3>
<ul>
	<li><code>config.ini</code> - A sample SciDB configuration file.</li>
	<li><code>Dockerfile</code> - Script for creating a Docker image of Ubutu 14.</li>
	<li><code>README.md</code> - This file.</li>
	<li><code>setup.sh</code> - List of comands used to build SciDB.</li>
</ul>

<h5>NOTES:</h5>
<ul>
	<li>Despite its name, the instruction file <code>setup.sh</code> contains a set of commands used to compile SciDB and it is NOT meant to be ran as a script</li>
	<li></li>
</ul>

<h3>Instructions:</h3>
<ol>
	<li>Clone the project and then go to the docker_scidb folder: <code>git clone https://github.com/albhasan/docker_scidb.git</code></li>
	<li>Move the development folder <code>cd docker_scidb/dev16-9</code></li>
	<li>open the instruction file <code>gedit setup.sh &</code></li>
	<li>Copy each command from the instructions file to the console, adapting each one to your needs</li>
</ol>

