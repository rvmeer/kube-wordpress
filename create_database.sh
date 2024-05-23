# Check if MYSQL_ROOT_PASSWORD is set
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "MYSQL_ROOT_PASSWORD is not set"
  exit 1
fi

# Check if MYSQL_DATABASE is set
if [ -z "$MYSQL_DATABASE" ]; then
  echo "MYSQL_DATABASE is not set"
  exit 1
fi

MYSQL_POD=$(kubectl get pods --no-headers=true | awk '/mysql-/ {print $1}')
kubectl exec -it  $MYSQL_POD -- mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE;"
