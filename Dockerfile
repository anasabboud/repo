FROM centos
ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13
# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget
# Downloading & Config Java 8
#-O /tmp/jdk-8-linux-x64.tar.gz
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
RUN tar xzf jdk-8u161-linux-x64.tar.gz

#RUN yum -y install jdk-8u161-linux-x64.rpm
#RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
#RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
#RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
#EXPOSE 8080
#install Spring Boot artifact
#VOLUME /tmp
#ADD /terg/helloworld-1.0.jar helloworld-1.0.jar
#RUN sh -c 'touch /helloworld-1.0.jar'
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/helloworld-1.0.jar"]
