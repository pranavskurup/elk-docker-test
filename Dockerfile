FROM  java:8u102-jdk
MAINTAINER Pranav S Kurup

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget
ENV ONEWEB_HOME /opt/oneweb
RUN useradd -d ${ONEWEB_HOME} -m oneweb

WORKDIR ${ONEWEB_HOME}


### install Elasticsearch

ENV ES_VERSION 2.4.0
ENV ES_PACKAGE elasticsearch-${ES_VERSION}.tar.gz
ENV ES_HOME ${ONEWEB_HOME}/elasticsearch-${ES_VERSION}
ENV ES_LOG_DIR ${ONEWEB_HOME}/log/elasticsearch-${ES_VERSION}
ENV ES_DATA_DIR ${ONEWEB_HOME}/data/elasticsearch-${ES_VERSION}

RUN \
 wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/${ES_PACKAGE} && \
 tar xvzf ${ES_PACKAGE} && \
 rm -f ${ES_PACKAGE}

RUN \
 mkdir ${ES_LOG_DIR} -p && \
 mkdir ${ES_DATA_DIR} -p
### install Logstash

ENV LOGSTASH_VERSION 2.4.0
ENV LOGSTASH_PACKAGE logstash-${LOGSTASH_VERSION}.tar.gz
ENV LOGSTASH_HOME ${ONEWEB_HOME}/logstash-${LOGSTASH_VERSION}

RUN \
 wget https://download.elasticsearch.org/logstash/logstash/${LOGSTASH_PACKAGE} && \
 tar xvzf ${LOGSTASH_PACKAGE} && \
 rm -f ${LOGSTASH_PACKAGE}
 
### install Kibana
ENV KIBANA_VERSION 4.5.0 
ENV KIBANA_PACKAGE kibana-${KIBANA_VERSION}-linux-x64.tar.gz
ENV KIBANA_HOME ${ONEWEB_HOME}/kibana-${KIBANA_VERSION}-linux-x64

RUN \
 wget https://download.elastic.co/kibana/kibana/${KIBANA_PACKAGE} && \
 tar xvzf ${KIBANA_PACKAGE} && \
 rm -f ${KIBANA_PACKAGE}

### install Filebeat
ENV FILEBEAT_VERSION 1.0.1
ENV FILEBEAT_PACKAGE filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz
ENV LOGSTASH_HOME ${ONEWEB_HOME}/filebeat-${LOGSTASH_VERSION}-x86_64

RUN \
 wget https://download.elastic.co/beats/filebeat/${FILEBEAT_PACKAGE} && \
 tar zxvf ${FILEBEAT_PACKAGE} && \
 rm -f ${FILEBEAT_PACKAGE}


###############################################################################
#                               CONFIGURATION
###############################################################################

### configure Elasticsearch

ADD ./config/elasticsearch.yml ${ES_HOME}/config/elasticsearch.yml

RUN \
 chown -R oneweb:oneweb /opt/oneweb/
ADD ./init/elastic-init /etc/init.d/es-service

RUN chmod +x /etc/init.d/es-service

ADD ./config/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5601 9200 9300 5000 5044

CMD [ "/usr/local/bin/start.sh" ]