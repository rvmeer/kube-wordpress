# Define the MySQL secret, PVC, ReplicaSet, and Service
kubectl apply -f mysql_secret.yaml
kubectl apply -f mysql_pvc.yaml
kubectl apply -f mysql_replica_set.yaml
kubectl apply -f mysql_service.yaml

# Now run create_database.sh to create the database in MySQL