# These are commands to run software I don't necessarily want to setup on my
# machine, but could run in a docker container

function dock() {
  case $1 in
    -h|--help)
      echo
      echo "  Usage: dock [application]"
      echo
      echo "    An application to run common daemons"
      echo
      echo "  Examples:"
      echo
      echo "    $ dock elasticsearch"
      echo
      ;;

    ls|list)
      echo "elasticsearch"
      echo "mongo"
      echo "postgres"
      echo "redis"
      ;;

    # Elasticsearch
    # =============
    elasticsearch)
      echo "username = elastic"
      echo "password = changeme"
      docker run \
        -p 9200:9200 \
        -e "http.host=0.0.0.0" \
        -e "transport.host=127.0.0.1" \
        docker.elastic.co/elasticsearch/elasticsearch:5.5.1
      ;;

    # MongoDB
    # =======
    mongo)
      docker run \
        -p 27017:27017 \
        mongo:latest
      ;;

    # PostgreSQL
    # ==========
    postgres)
      echo "database = postgres"
      echo "username = postgres"
      echo "password = postgres"
      # TODO volume = /var/lib/postgresql/data
      docker run \
        -p 5432:5432 \
        -e "POSTGRES_USER=postgres" \
        -e "POSTGRES_PASSWORD=postgres" \
        -e "POSTGRES_DB=postgres" \
        postgres:alpine
      ;;

    # Redis
    # =====
    redis)
      docker run \
        -p 6379:6379 \
        redis:alpine
      ;;

    # All else
    *)
      dock --help
      ;;
  esac
}

function _complete_dock() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  case "$cur" in
    *)
      COMPREPLY=( $( compgen -W "$(dock ls)" -- "$cur" ) )
      ;;
  esac

  return 0
}

complete -F _complete_dock dock
