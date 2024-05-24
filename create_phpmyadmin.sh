envsubst < phpmyadmin_replica_set.yaml | kubectl apply -f -
envsubst < phpmyadmin_loadbalancer.yaml | kubectl apply -f -