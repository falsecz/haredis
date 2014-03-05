#!/bin/bash
HAPROXY="http://localhost:8080/"
CMD="$1"
ARGS="$2"
ARG1=`echo $ARGS | awk '{print $1}'`

echo $1 ---- $2 >> /tmp/xxx

call_curl () {
	DATA=`echo "s=$1&action=$2&b=%234" | sed -e s/:/%3A/`
	curl $HAPROXY --data "$DATA"
	echo curl $HAPROXY --data "$DATA" -- $CMD $ARGS
}


[ "$CMD" = "+sdown" ] && [ "$ARG1" = "master" ] && \
	call_curl `echo $ARGS | awk '{print $2 ":" $3 ":" $4}'` 'disable'

[ "$CMD" = "+sdown" ] && [ "$ARG1" = "slave" ] && \
	call_curl `echo $ARGS | awk '{print $6 ":" $3 ":" $4}'` 'disable'

[ "$CMD" = "+convert-to-slave" ] && \
	call_curl `echo $ARGS | awk '{print $6 ":" $3 ":" $4}'` 'enable'

[ "$CMD" = "+switch-master" ] && \
	call_curl `echo $ARGS | awk '{print $1 ":" $4 ":" $5}'` 'enable'

[ "$CMD" = "+elected-leader" ] && \
	call_curl `echo $ARGS | awk '{print $2 ":" $3 ":" $4}'` 'enable'

# without exit code, sentinel thinks the script is still running and locks any further execution
exit 0
