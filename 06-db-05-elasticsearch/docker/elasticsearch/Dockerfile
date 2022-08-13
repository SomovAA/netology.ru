FROM elasticsearch:7.17.5

ADD elasticsearch.yml /usr/share/elasticsearch/config/

RUN mkdir /var/lib/elasticsearch \
    && mkdir /var/lib/elasticsearch/logs \
    && mkdir /var/lib/elasticsearch/data \
    && mkdir /var/lib/elasticsearch/snapshots \
    && chown -R elasticsearch:elasticsearch /var/lib/elasticsearch