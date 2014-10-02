#!/bin/bash
HAPROXY="http://localhost:8080/"
CMD="$1"
ARGS="$2"
ARG1=`echo $ARGS | awk '{print $1}'`


call_curl () {
	DATA=`echo "s=$1&action=$2&b=%234" | sed -e s/:/%3A/`
	curl --silent -o /dev/null $HAPROXY --data "$DATA"
	echo curl $HAPROXY --data "$DATA"
	return 0
}


[ "$CMD" = "+odown" ] && [ "$ARG1" = "master" ] && \
	call_curl `echo $ARGS | awk '{print $2 ":" $3 ":" $4}'` 'disable'

[ "$CMD" = "+sdown" ] && [ "$ARG1" = "slave" ] && \
	call_curl `echo $ARGS | awk '{print $6 ":" $3 ":" $4}'` 'disable'

[ "$CMD" = "+switch-master" ] && \
	call_curl `echo $ARGS | awk '{print $1 ":" $4 ":" $5}'` 'enable' &&
	call_curl `echo $ARGS | awk '{print $1 ":" $2 ":" $3}'` 'disable'

[ "$CMD" = "-odown" ] && [ "$ARG1" = "master" ] && \
	call_curl `echo $ARGS | awk '{print $2 ":" $3 ":" $4}'` 'enable'

# without exit code, sentinel thinks the script is still running and locks any further execution
exit 0
