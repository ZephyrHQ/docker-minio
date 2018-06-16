#!/usr/bin/env sh
NO_REPLICAS=${REPLICAS:-4}
HOST=${SERVICE:-"minio"}
VOLUME_PATH=${VOLUME:-"export"}

TASKS="tasks"
QUERY="${TASKS}.${HOST}"

echo $*
echo NO_REPLICAS $NO_REPLICAS
echo HOST $NO_REPLICAS
echo VOLUME_PATH $VOLUME_PATH
echo TASKS $TASKS
echo QUERY $QUERY
exit
until nslookup "${HOST}"
do
  echo "waiting for service discovery..."
done

NO_HOSTS=0
while [[ "${NO_HOSTS}" -lt "${NO_REPLICAS}" ]]
do
  echo "waiting for all replicas to come online..."
  NO_HOSTS=$(nslookup "${QUERY}" | grep Address | wc -l)
  echo "${NO_HOSTS}" -lt "${NO_REPLICAS}"
done

HOSTNAMES=$(nslookup "${QUERY}" | grep "Address" | awk '{ print $3 }' | sed -e 's/^/http:\/\//' | sed -e "s/$/\/${VOLUME_PATH}/" | tr '\n' ' ' | sed -e 's/[ \t]*$//')
echo "hostnames = $HOSTNAMES"

# start server
eval "minio server" "${HOSTNAMES}"
