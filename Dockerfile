FROM  java:8u102-jdk
MAINTAINER Pranav S Kurup

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget

RUN useradd -d /opt/oneweb -m oneweb

RUN su oneweb

WORKDIR /opt/oneweb


### install Elasticsearch

ENV ES_VERSION 2.4.0


RUN \
 wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/elasticsearch-${ES_VERSION}.tar.gz && \
 tar xvzf elasticsearch-${ES_VERSION}.tar.gz && \
 rm -f elasticsearch-${ES_VERSION}.tar.gz



RUN \
 chown -R oneweb:oneweb /opt/oneweb/