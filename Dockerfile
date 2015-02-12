# SciDB 14.8
#
# VERSION 1.0
#
#
#
#
#
#
#PORT MAPPING
#SERVICE		DEFAULT		MAPPED
#ssh 			22			49901
#shim			8082 8083s	49902s
#Postgresql 	5432		49903
#SciDB			1239		49904


FROM ubuntu:12.04
MAINTAINER Alber Sanchez



# install
RUN apt-get -qq update && apt-get install --fix-missing -y --force-yes --allow-unauthenticated \
	openssh-server \
	sudo \
	wget \
	gdebi \
	nano \  
	postgresql-8.4 \ 
	sshpass \ 
	git-core \ 
	apt-transport-https


# Set environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN env


# Configure users
RUN useradd --home /home/scidb --create-home --uid 1005 --group sudo --shell /bin/bash scidb
RUN echo 'root:xxxx.xxxx.xxxx' | chpasswd
RUN echo 'postgres:xxxx.xxxx.xxxx' | chpasswd
RUN echo 'scidb:xxxx.xxxx.xxxx' | chpasswd
RUN echo 'xxxx.xxxx.xxxx'  >> /home/scidb/pass.txt


RUN mkdir /var/run/sshd
RUN mkdir /home/scidb/data
RUN mkdir /home/scidb/catalog


# Configure SSH
RUN sed -i 's/22/49901/g' /etc/ssh/sshd_config
RUN echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config


# Configure Postgres 
RUN echo 'host  all all 255.255.0.0/16   md5' >> /etc/postgresql/8.4/main/pg_hba.conf
RUN sed -i 's/5432/49903/g' /etc/postgresql/8.4/main/postgresql.conf


# Add files
ADD containerSetup.sh 	/home/root/containerSetup.sh
ADD conf 		/home/root/conf
ADD iquery.conf 	/home/scidb/.config/scidb/iquery.conf
ADD installPackages.R	/home/scidb/installPackages.R
ADD startScidb.sh	/home/scidb/startScidb.sh
ADD stopScidb.sh	/home/scidb/stopScidb.sh
ADD scidb_docker.ini	/home/scidb/scidb_docker.ini


RUN chown root:root \ 
	/home/root/containerSetup.sh \ 
	/home/root/conf

	
RUN chown scidb:scidb \ 
	/home/scidb/.config/scidb/iquery.conf \ 
	/home/scidb/pass.txt \ 
	/home/scidb/data \ 
	/home/scidb/catalog \ 
	/home/scidb/startScidb.sh \ 
	/home/scidb/stopScidb.sh \ 
	/home/scidb/scidb_docker.ini \ 
	/home/scidb/installPackages.R


RUN chmod +x \ 
	/home/root/containerSetup.sh \ 
	/home/scidb/startScidb.sh \ 
	/home/scidb/stopScidb.sh 


# Restarting services
RUN stop ssh
RUN start ssh
RUN /etc/init.d/postgresql restart

	
EXPOSE 49901
EXPOSE 49902


CMD    ["/usr/sbin/sshd", "-D"]
