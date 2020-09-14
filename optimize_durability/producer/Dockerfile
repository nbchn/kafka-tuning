FROM  confluentinc/cp-kafka
MAINTAINER nils.bouchardon@gmail.com
ENV container dockerls
COPY producer.properties /etc/kafka/producer.properties
COPY produce.sh /etc/scripts/produce.sh
COPY produce_monothread.sh /etc/scripts/produce_monothread.sh
COPY produce_multithread.sh /etc/scripts/produce_multithread.sh
CMD tail -f /dev/null
