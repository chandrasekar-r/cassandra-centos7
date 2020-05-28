#!/bin/bash

set -e



function check_last_command_status {
  if [ $? != 0 ]; then
    echo "An error has occurred with the previous command."
    exit 1

  fi

}


  while [[ $# -ge 1 ]]; do
    key="$1"

    case $key in
	-n|--cassandra-version)
	    CASSANDRA_BASE_VERSION="$2"
	    shift # pass argument
	    ;;
	-h|--help)
	    run_help
	    exit 2
	    ;;
	*)
	    usage
	    exit 2
	    ;;
    esac
    shift # past argument or value
  done


  if [ "$CASSANDRA_BASE_VERSION" = "" ]; then
    echo "The version of cassandra cannot be empty. It must contain one decimal place, e.g., 21.0"
    exit 1

  fi


# Build Cassandra image and tag it as latest. This should be done from a gCloud instance
docker build -t cassandra/cassandra-centos7 .
check_last_command_status
