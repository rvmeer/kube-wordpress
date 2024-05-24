# Make sure MYSQL_DATABASE exists
if [ -z "$MYSQL_DATABASE" ]; then
    echo "MYSQL_DATABASE is not set"
    exit 1
fi

# Make sure WP_NAME exists
if [ -z "$WP_NAME" ]; then
    echo "WP_NAME is not set"
    exit 1
fi

envsubst < wordpress_pvc.yaml | kubectl apply -f -
envsubst < wordpress_replica_set.yaml | kubectl apply -f -
envsubst < wordpress_loadbalancer.yaml | kubectl apply -f -