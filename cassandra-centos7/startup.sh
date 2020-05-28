#!/bin/bash

#set native transport request size
#JVM_OPTS="$JVM_OPTS -Dcassandra.max_queued_native_transport_requests=4096"

# RUN Cassandra as cassandra_user. To run cassandra as root user, use cassandra -R.
cassandra -f

### This script should never exit. We could also use sleep infinity as the last statement
while true; do sleep 1000; done