#!/usr/bin/env bash

# docker cleanup helpers
alias docker-containers-stop='[[ "$(docker ps -a -q)" != "" ]] && docker stop $(docker ps -a -q); true'
alias docker-containers-remove='docker-containers-stop && [[ "$(docker ps -a -q)" != "" ]] && docker rm $(docker ps -a -q); true'
alias docker-volumes-remove='docker-containers-remove && [[ "$(docker volume ls -f dangling=true -q)" != "" ]] && docker volume rm $(docker volume ls -f dangling=true -q); true'
alias docker-images-remove='[[ "$(docker images -a -q)" != "" ]] && docker rmi -f $(docker images -a -q); true'
alias docker-clean='docker-containers-stop; docker-containers-remove; docker-volumes-remove; docker-images-remove; docker system prune -f; true'

function dock() {
  case $1 in
    # https://github.com/localstack/localstack
    # API Gateway at http://localhost:4567
    # Kinesis at http://localhost:4568
    # DynamoDB at http://localhost:4569
    # DynamoDB Streams at http://localhost:4570
    # Elasticsearch at http://localhost:4571
    # S3 at http://localhost:4572
    # Firehose at http://localhost:4573
    # Lambda at http://localhost:4574
    # SNS at http://localhost:4575
    # SQS at http://localhost:4576
    # Redshift at http://localhost:4577
    # ES (Elasticsearch Service) at http://localhost:4578
    # SES at http://localhost:4579
    # Route53 at http://localhost:4580
    # CloudFormation at http://localhost:4581
    # CloudWatch at http://localhost:4582
    # SSM at http://localhost:4583
    localstack)
      docker run \
        --init \
        --name 'dock_localstack' \
        --publish '4567-4583:4567-4583' \
        --publish '8080:8080' \
        --env 'SERVICES= ' \
        --env 'DEBUG= ' \
        --env 'DATA_DIR= ' \
        --env 'PORT_WEB_UI= ' \
        --env 'LAMBDA_EXECUTOR= ' \
        --env 'KINESIS_ERROR_PROBABILITY= ' \
        --env 'DOCKER_HOST=unix:///var/run/docker.sock' \
        --volume '/private/tmp/localstack:/tmp/localstack' \
        --volume '/var/run/docker.sock:/var/run/docker.sock' \
        localstack/localstack
      docker stop 'dock_localstack'
      docker rm 'dock_localstack'
      ;;

    # https://hub.docker.com/_/mongo/
    mongo)
      echo 'mongodb://localhost:27017'
      echo ''
      docker run \
        --name 'dock_mongo' \
        --publish '27017:27017' \
        mongo:latest
        # --volume '/data/db' \
      docker stop 'dock_mongo'
      docker rm 'dock_mongo'
      ;;

    # https://hub.docker.com/_/redis/
    redis)
      echo 'redis://127.0.0.1:6359'
      echo ''
      docker run \
        --name 'dock_redis' \
        --publish '6379:6379' \
        redis:alpine
        # --volume '/data' \
      docker stop 'dock_redis'
      docker rm 'dock_redis'
      ;;

    # https://hub.docker.com/_/postgres/
    postgres)
      echo 'postgres://postgres:postgres@localhost:5432/postgres'
      echo ''
      docker run \
        --name 'dock_postgres' \
        --publish '5432:5432' \
        --env 'POSTGRES_USER=postgres' \
        --env 'POSTGRES_PASSWORD=postgres' \
        --env 'POSTGRES_DB=postgres' \
        postgres:alpine
        # --volume '/var/lib/postgresql/data' \
      docker stop 'dock_postgres'
      docker rm 'dock_postgres'
      ;;

    # https://hub.docker.com/_/nats-streaming/
    nats-streaming)
      echo 'nats://localhost:4222'
      echo 'http://localhost:8222'
      echo ''
      docker run \
        --name 'dock_nats-streaming' \
        --publish '4222:4222' \
        --publish '8222:8222' \
        nats-streaming:latest -store file -dir '/datastore' -m 8222
        # --volume '/datastore' \
      docker stop 'dock_nats-streaming'
      docker rm 'dock_nats-streaming'
      ;;

    # https://www.docker.elastic.co
    elasticsearch)
      echo 'http://elastic:changeme@localhost:9200'
      echo ''
      docker run \
        --name 'dock_elasticsearch' \
        --publish '9200:9200' \
        --publish '9300:9300' \
        --env 'discovery.type=single-node' \
        docker.elastic.co/elasticsearch/elasticsearch:7.1.1
        # --volume '/usr/share/elasticsearch/data' \
      docker stop 'dock_elasticsearch'
      docker rm 'dock_elasticsearch'
      ;;

    # https://danfarrelly.nyc/MailDev/
    maildev)
      echo 'smtp://localhost:1025/?ignoreTLS=true'
      echo ''
      docker run \
        --name 'dock_maildev' \
        --publish '1080:80' \
        --publish '1025:25' \
        djfarrelly/maildev
      docker stop 'dock_maildev'
      docker rm 'dock_maildev'
      ;;

    *)
      echo "Unknown dock: '${1}'"
      echo "supported docks:"
      echo "  localstack"
      echo "  mongo"
      echo "  redis"
      echo "  postgres"
      echo "  nats-streaming"
      echo "  elasticsearch"
      echo "  maildev"
      echo ""
      ;;
  esac
}
