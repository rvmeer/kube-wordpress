# Check if MYSQL_ROOT_PASSWORD is set
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "MYSQL_ROOT_PASSWORD is not set"
  exit 1
fi

export MYSQL_ROOT_PASSWORD_B64=$(echo -n $MYSQL_ROOT_PASSWORD | base64)

# Define the MySQL secret, PVC, ReplicaSet, and Service
envsubst < mysql_secret.yaml | kubectl apply -f -
envsubst < mysql_pvc.yaml | kubectl apply -f -
envsubst < mysql_replica_set.yaml | kubectl apply -f -
envsubst < mysql_service.yaml | kubectl apply -f -

# Now run create_database.sh to create the database in MySQL