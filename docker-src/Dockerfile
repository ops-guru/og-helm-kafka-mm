FROM debian:jessie
MAINTAINER paul@opsguru.io

ENV KAFKA_VERSION "2.2.0"
ENV KAFKA_MM_CFG_ROOT "/etc/mirror-maker"
ENV KAFKA_ROOT "/opt/kafka"
ENV SCALA_VERSION "2.12"
ENV KAFKA_HEAP_OPTS "-Xms1024M -Xmx1024M"
ENV KAFKA_MM_WHITELIST ".*"
ENV KAFKA_MM_NUMSTREAMS "1"
ENV JMXPORT "9998"

# Zulu
ENV ZULU_OPENJDK_VERSION="8=8.30.0.1"
# This affects how strings in Java class files are interpreted.  We want UTF-8 and this is the only locale in the
# base image that supports it
ENV LANG="C.UTF-8"

RUN echo "===> Creating dedicated user/group for MirroMaker" \
    && useradd kafka -m 
RUN echo "===> Updating debian ....." \
    && echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list \
    && echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list \
    && apt-get -qq update \
    \
    && echo "===> Installing some Ops 3rd parties ....." \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                apt-transport-https \
                curl \
                netcat \
                wget \
    && echo "Installing Zulu OpenJDK ${ZULU_OPENJDK_VERSION}" \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 \
    && echo "deb http://repos.azulsystems.com/debian stable  main" >> /etc/apt/sources.list.d/zulu.list \
    && apt-get -qq update \
    && apt-get -y install zulu-${ZULU_OPENJDK_VERSION} \
    && echo "===> Installing Kerberos Patch ..." \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install krb5-user \
&& rm -rf /var/lib/apt/lists/*

# Install Kafka binaries & set up MM
RUN mkdir ${KAFKA_ROOT}
RUN mkdir ${KAFKA_MM_CFG_ROOT}
RUN wget http://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O - \
    | tar xvfz - --strip-components=1 -C ${KAFKA_ROOT}

ADD ./run.sh ${KAFKA_ROOT}/
RUN chmod +x ${KAFKA_ROOT}/run.sh
RUN chown kafka:kafka -R ${KAFKA_ROOT}

CMD ["su", "-c", "${KAFKA_ROOT}/run.sh", "kafka"]
