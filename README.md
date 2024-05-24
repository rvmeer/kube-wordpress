# Kubernetes Wordpress

This project describes how to run wordpress (or multiple wordpresses) on a kubernetes

I use minikube to let everything run on one node.

## Install kubernetes and minikube

Install minikube

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

To start minikube: `minikube start`.

You can configure all steps below using `minikube dashboard`. Before running the dashboard you might need to run `newgrp docker`. Or run `sudo usermod -aG docker $USER`.

See also: https://minikube.sigs.k8s.io/docs/start/

## Install everything at once

Run ./deploy.sh

this scripts needs 3 environment variables:

```
export WP_NAME=<name of the wordpress, as used in kubernetes>
export MYSQL_DATABASE=<name of the wordpress db in MySQL>
export MYSQL_ROOT_PASSWORD=<root password of the db, same for every Wordpress instance>
```

## Install the different kubernetes components

We're going to install:
1. MySQL
2. Wordpress
3. A loadbalancer

## Create MySQL instance

I use one MySQL instance for all wordpresses.

We have to do 4 things:
1. Create a secret with the mySQL password
2. Create a MySQL volume claim (PVC)
3. Create the MySQL replica set (creates the actual Pod)
4. Create the MySQL service (needed so the wordpress instances can connect to the database)

To run these steps, run `create_mysql.sh`.


When the MySQL pod runs, create a database by `create_database.sh`.

```
kebuctl get pods
kubectl exec -it <My SQL pod name> -- bash
mysql -u root -p (see secrets for the password)
create database wordpress;
```


## Create the Wordpress

This consists of:
1. A volume claim
1. A replica set with wordpress
1. A load balancer server serving wordpress

Run `create_wordpress.sh`.

The loadbalancer remains pending, you have to run `minikube tunnel` to make minikube expose the loadbalancers to a local IP address (LOCAL_IP).

For accessing the wordpress outside of your VM, use:

ssh <VM name> -L 80:LOCAL_IP:80

This creates a SSH tunnel to your local system.