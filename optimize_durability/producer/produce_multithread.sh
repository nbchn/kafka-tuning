#!/bin/bash

produce_data_once() {
  kafka-producer-perf-test \
    --producer.config /etc/kafka/producer.properties \
    --throughput -1 \
    --num-records 100000 \
    --topic perf-test \
    --record-size 512 > /etc/kafka/perf_$1.log &
}

 kafka-topics \
    --bootstrap-server kafka-1:9092,kafka-2:9092,kafka-3:9092 \
    --create \
    --topic perf-test \
    --partitions 6 \
    --replication-factor 3 || {
  echo "topic already exists"
}

echo "starting 10 perf producers"

for i in $(seq 1 10); do produce_data_once $i & done
