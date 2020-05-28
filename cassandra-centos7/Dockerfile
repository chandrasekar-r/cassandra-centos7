###
### The Cassandra image with all necessary prerequisites
###

FROM centos:centos7

######################################################################
# Install some basic tools to get started
######################################################################

ARG JAVA_VERSION=jdk1.8.0_131
ARG SETUPTOOLS=setuptools-46.1.3
ENV LANG en_US.UTF-8

#Install centos7 dependent packages.
RUN yum clean all
RUN yum install -y yum-utils python3-setuptools wget tar
RUN yum groupinstall -y "Development tools"
RUN yum -y install readline-devel tcl gcc-c++ zlib-devel sudo which nc sqlite sqlite-devel openssl xmlsec1-openssl
RUN yum -y install libxml2 libxml2-devel libxslt libxslt-devel openldap openldap-devel libffi-devel lapack-devel
RUN yum -y install boost boost-python3 boost-devel pcre-devel zlib-devel bzip2-devel openssl-devel xz-libs wget cyrus-sasl-plain telnet libjpeg-devel

# Install JDK 8 update 131 to be used across unifi application
RUN cd /opt && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz" && tar xzvf jdk-8u131-linux-x64.tar.gz

#RUN yum install --nogpgcheck -y java
RUN /usr/sbin/alternatives --install /usr/bin/java java /opt/${JAVA_VERSION}/bin/java 2

# alternatives magic for getting JDK working without issues
RUN /usr/sbin/alternatives --install \

      /usr/bin/java java /opt/${JAVA_VERSION}/bin/java 999999999 \

  --slave /usr/bin/keytool     keytool     /opt/${JAVA_VERSION}/bin/jre/bin/keytool \
  --slave /usr/bin/orbd        orbd        /opt/${JAVA_VERSION}/bin/jre/bin/orbd \
  --slave /usr/bin/pack200     pack200     /opt/${JAVA_VERSION}/bin/jre/bin/pack200 \
  --slave /usr/bin/rmid        rmid        /opt/${JAVA_VERSION}/bin/jre/bin/rmid \
  --slave /usr/bin/rmiregistry rmiregistry /opt/${JAVA_VERSION}/bin/jre/bin/rmiregistry \
  --slave /usr/bin/servertool  servertool  /opt/${JAVA_VERSION}/bin/jre/bin/servertool \
  --slave /usr/bin/tnameserv   tnameserv   /opt/${JAVA_VERSION}/bin/jre/bin/tnameserv \
  --slave /usr/bin/unpack200   unpack200   /opt/${JAVA_VERSION}/bin/jre/bin/unpack200

RUN /usr/sbin/alternatives --install \
  /usr/bin/javac javac /opt/${JAVA_VERSION}/bin/javac 999999999 \
  --slave /usr/bin/appletviewer appletviewer /opt/${JAVA_VERSION}/bin/appletviewer \
  --slave /usr/bin/apt          apt          /opt/${JAVA_VERSION}/bin/apt \
  --slave /usr/bin/extcheck     extcheck     /opt/${JAVA_VERSION}/bin/extcheck \
  --slave /usr/bin/idlj         idlj         /opt/${JAVA_VERSION}/bin/idlj \
  --slave /usr/bin/jar          jar          /opt/${JAVA_VERSION}/bin/jar \
  --slave /usr/bin/jarsigner    jarsigner    /opt/${JAVA_VERSION}/bin/jarsigner \
  --slave /usr/bin/javadoc      javadoc      /opt/${JAVA_VERSION}/bin/javadoc \
  --slave /usr/bin/javah        javah        /opt/${JAVA_VERSION}/bin/javah \
  --slave /usr/bin/javap        javap        /opt/${JAVA_VERSION}/bin/javap \
  --slave /usr/bin/jcmd         jcmd         /opt/${JAVA_VERSION}/bin/jcmd \
  --slave /usr/bin/jconsole     jconsole     /opt/${JAVA_VERSION}/bin/jconsole \
  --slave /usr/bin/jdb          jdb          /opt/${JAVA_VERSION}/bin/jdb \
  --slave /usr/bin/jhat         jhat         /opt/${JAVA_VERSION}/bin/jhat \
  --slave /usr/bin/jinfo        jinfo        /opt/${JAVA_VERSION}/bin/jinfo \
  --slave /usr/bin/jmap         jmap         /opt/${JAVA_VERSION}/bin/jmap \
  --slave /usr/bin/jmc          jmc          /opt/${JAVA_VERSION}/bin/jmc \
  --slave /usr/bin/jps          jps          /opt/${JAVA_VERSION}/bin/jps \
  --slave /usr/bin/jrunscript   jrunscript   /opt/${JAVA_VERSION}/bin/jrunscript \
  --slave /usr/bin/jsadebugd    jsadebugd    /opt/${JAVA_VERSION}/bin/jsadebugd \
  --slave /usr/bin/jstack       jstack       /opt/${JAVA_VERSION}/bin/jstack \
  --slave /usr/bin/jstat        jstat        /opt/${JAVA_VERSION}/bin/jstat \
  --slave /usr/bin/jstatd       jstatd       /opt/${JAVA_VERSION}/bin/jstatd \
  --slave /usr/bin/keytool      keytool      /opt/${JAVA_VERSION}/bin/keytool \
  --slave /usr/bin/native2ascii native2ascii /opt/${JAVA_VERSION}/bin/native2ascii \
  --slave /usr/bin/policytool   policytool   /opt/${JAVA_VERSION}/bin/policytool \
  --slave /usr/bin/rmic         rmic         /opt/${JAVA_VERSION}/bin/rmic \
  --slave /usr/bin/schemagen    schemagen    /opt/${JAVA_VERSION}/bin/schemagen \
  --slave /usr/bin/serialver    serialver    /opt/${JAVA_VERSION}/bin/serialver \
  --slave /usr/bin/wsgen        wsgen        /opt/${JAVA_VERSION}/bin/wsgen \
  --slave /usr/bin/wsimport     wsimport     /opt/${JAVA_VERSION}/bin/wsimport \
  --slave /usr/bin/xjc          xjc          /opt/${JAVA_VERSION}/bin/xjc

######################################################################
# Python 3.8.1, virtualenv, setuptools
######################################################################

RUN cd /tmp && wget "http://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz"  && tar -xvf Python-3.8.1.tgz && cd Python-3.8.1 && ./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall

# Setup some environment variables
ENV JAVA_HOME /opt/${JAVA_VERSION}/

#######################################################################
# Cassandra Installation
######################################################################
ENV INSTALL_DIR /usr/local
ENV CASSANDRA_HOME /usr/local/cassandra
RUN cd $INSTALL_DIR && wget --user $ARTIFACTORY_USER --password $ARTIFACTORY_PASSWORD $ARTIFACTORY_BASE_URI/third-party/apache-cassandra-3.11.0-bin.tar.gz
RUN tar -xzvf $INSTALL_DIR/apache-cassandra-3.11.0-bin.tar.gz -C $INSTALL_DIR
RUN mv $INSTALL_DIR/apache-cassandra-3.11.0 $CASSANDRA_HOME
RUN mkdir /var/lib/cassandra/ /var/log/cassandra/
RUN ln -s /var/lib/cassandra/ $CASSANDRA_HOME/data
RUN ln -s /var/log/cassandra/ $CASSANDRA_HOME/logs

#Enable thrift in cassandra while the server is running.
RUN sed -i 's/^start_rpc.*$/start_rpc: true/' $CASSANDRA_HOME/conf/cassandra.yaml

# Just a placeholder as a reminder that environment variables set here
# will not be visible in users profile.

ENV NOTVISIBLE "in users profile"

# Add user unifi to the cassandra image
RUN adduser cassandra
RUN echo "root:root" | chpasswd
RUN echo "cassandra:cassandra" | chpasswd
RUN echo "cassandra ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN sudo chown -R cassandra:cassandra /usr/local/cassandra/
RUN sudo chmod 777 /var/lib/cassandra/ /var/log/cassandra/
ENV PATH=$PATH:/usr/local/cassandra/bin


#Test Cassandra
RUN cassandra -v

#You need something like this to make sure environment variables are
# setup properly
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose ports for Cassandra.
EXPOSE 7000 7001 7199 9042 9160

COPY startup.sh /usr/local/bin/
RUN ln -s usr/local/bin/startup.sh /startup.sh # backwards compat
USER cassandra
RUN echo 'export PATH=$PATH:'"/usr/local/cassandra/bin" >> /home/cassandra/.bashrc
RUN source /home/cassandra/.bashrc
ENTRYPOINT ["startup.sh"]