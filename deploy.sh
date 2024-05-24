# Make sure to set the environment variables MYSQL_DATABASE and WP_NAME before running the script.
if [ -z "$MYSQL_DATABASE" ]; then
    echo "MYSQL_DATABASE is not set"
    exit 1
fi

if [ -z "$WP_NAME" ]; then
    echo "WP_NAME is not set"
    exit 1
fi

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "MYSQL_ROOT_PASSWORD is not set"
  exit 1
fi

./create_mysql.sh
./create_database.sh
./create_phpmyadmin.sh
./create_wordpress.sh
