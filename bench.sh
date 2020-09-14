#/bin/bash

container_healthy() {
    local name=$1
    local container=$(docker-compose ps -q $1)
    local healthy=$(docker inspect --format '{{ .State.Health.Status }}' $container)
    if [ $healthy == healthy ]
    then
        printf "$1 is healthy"
        return 0
    else
        return 1
    fi
}

retry() {
    local -r -i max_attempts="$1"; shift
    local -r -i sleep_interval="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Failed after $attempt_num attempts"
            return 1
        else
            printf "."
            ((attempt_num++))
            sleep $sleep_interval
        fi
    done
    printf "\n"
}

FOLDER=""

case "$1" in
  1)
    FOLDER="optimize_throughput"
    ;;
  2)
    FOLDER="optimize_latency"
    ;;
  3)
    FOLDER="optimize_availability"
    ;;
  4)
    FOLDER="optimize_durability"
    ;;
  *)
    echo "Usage :"
    echo "1 > throughput"
    echo "2 > latency"
    echo "3 > availability"
    echo "4 > durability"
    exit 1
esac

cd $FOLDER

docker-compose down -v --remove-orphans > /dev/null
docker-compose build > /dev/null
docker-compose up -d

echo "wait for cluster to be started and healthy"
sleep 30s

echo "start producer"

#docker-compose exec producer sh -c "./etc/scripts/produce_multithread.sh"
docker-compose exec producer sh -c "./etc/scripts/produce_monothread.sh"

docker-compose down -v --remove-orphans
