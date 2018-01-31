# AlpineLinux with a glibc-2.26-r0 and Oracle Java 8
FROM alpine:3.6

MAINTAINER Anastas Dancha <anapsix@random.io>
# thanks to Vladimir Krivosheev <develar@gmail.com> aka @develar for smaller image
# and Victor Palma <palma.victor@gmail.com> aka @devx for pointing it out

# Java Version and other ENV
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=162 \
    JAVA_VERSION_BUILD=12 \
    JAVA_PACKAGE=server-jre \
    JAVA_JCE=unlimited \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.26-r0 \
    MAVEN_VERSION=3.5.2 \
    LANG=C.UTF-8

# Install prerequisites
RUN apk add --no-cache curl

#ENTRYPOINT ["/usr/bin/curl"]

    # MAVEN ====================================================================
RUN    apk add --no-cache curl tar && \
    mkdir -p /usr/share/maven /usr/share/maven/ref && \
    curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    # CLEANUP ==================================================================
    apk del build-dependencies unzip curl tar libstdc++ && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /data

COPY settings-docker.xml /usr/share/maven/ref/

CMD ["mvn"]

#FROM alpine:latest
#
#RUN mkdir /aela2
#COPY . /aela2


#FROM ubuntu:14.04
#MAINTAINER javacodegeeks
#
#RUN apt-get update && apt-get install -y python-software-properties software-properties-common
#RUN add-apt-repository ppa:webupd8team/java
#
#RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
#
#RUN apt-get update && apt-get install -y oracle-java8-installer maven
#
#ADD . /usr/local/helloworld
#RUN cd /usr/local/helloworld &&  mvn install
#CMD ["java", "-cp", "/usr/local/helloworld/target/helloworld-1.0.jar", "HelloWorld"]
