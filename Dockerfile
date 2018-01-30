FROM dockette/alpine:3.4

MAINTAINER Milan Sulc <sulcmil@gmail.com>

ENV JAVA_VERSION=8
ENV JAVA_UPDATE=112
ENV JAVA_BUILD=15
ENV JAVA_HOME="/usr/lib/jvm/default-jvm"
ENV LANG=C.UTF-8
ENV GLIBC_VERSION=2.23-r3

ENV MAVEN_VERSION=3.3.9
ENV USER_HOME_DIR="/root"
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Based on offical @andreptb/Dockerfiles (thank you)
# Based on offical MAVEN image (thank you)

RUN apk upgrade --update && \
    apk add --no-cache --virtual=build-dependencies libstdc++ curl ca-certificates unzip && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION}.zip \
        "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/jce_policy-${JAVA_VERSION}.zip" && \
    gunzip /tmp/java.tar.gz && \
    tar -C /tmp -xf /tmp/java.tar && \
    mkdir -p "/usr/lib/jvm" && \
    mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    unzip -jo -d "$JAVA_HOME/jre/lib/security" "/tmp/jce_policy-${JAVA_VERSION}.zip" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    apk del glibc-i18n && \
    rm -rf "$JAVA_HOME/"*src.zip \
           "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/bin/jjs" \
           "$JAVA_HOME/jre/bin/keytool" \
           "$JAVA_HOME/jre/bin/orbd" \
           "$JAVA_HOME/jre/bin/pack200" \
           "$JAVA_HOME/jre/bin/policytool" \
           "$JAVA_HOME/jre/bin/rmid" \
           "$JAVA_HOME/jre/bin/rmiregistry" \
           "$JAVA_HOME/jre/bin/servertool" \
           "$JAVA_HOME/jre/bin/tnameserv" \
           "$JAVA_HOME/jre/bin/unpack200" \
           "$JAVA_HOME/jre/lib/ext/nashorn.jar" \
           "$JAVA_HOME/jre/lib/jfr.jar" \
           "$JAVA_HOME/jre/lib/jfr" \
           "$JAVA_HOME/jre/lib/oblique-fonts" && \
    # MAVEN ====================================================================
    apk add --no-cache curl tar && \
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
