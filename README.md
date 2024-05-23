# Kubernetes Wordpress

This project describes how to run wordpress (or multiple wordpresses) on a kubernetes

I use minikube to let everything run on one node.

## Install kubernetes and minikube

Todo

## Create mysql instance

I use one MySQL instance for all wordpresses.

We have to do 4 things:
1. Create a secret with the mySQL password
2. Create a MySQL volume claim (PVC)
3. Create the MySQL replica set (creates the actual Pod)
4. Create the MySQL service (needed so the wordpress instances can connect to the database)

### Create the MySQL password secret

```
apiVersion: v1

# This is a workaround for the broken  --from-file kubernetes abstraction
# which doesn't sanely handle .env files
# MYSQL_DATABASE and MYSQL_USER are both set to 'wordpress'

# INSTRUCTIONS:
# Generate a MYSQL_PASSWORD and MYSQL_ROOT_PASSWORD and then save this file before using it.
# e.g.
# echo && PASS=$(cat /dev/urandom | env LC_CTYPE=C tr -dc [:alnum:] | head -c 15) && echo "Password: ${PASS}" && echo "Base64 encoded:" $(echo ${PASS} | base64)

kind: Secret
metadata:
  name: wp-db-secrets
  namespace: default

type: Opaque

data:
  # Example if you need multiple values
  # MYSQL_DATABASE: d29yZHByZXNzCg==
  # MYSQL_USER: d29yZHByZXNzCg==
  # MYSQL_PASSWORD: SXhCMzRxRXF0dERubXpR

  # This is base64 encoded -- the real password is NGiJi6A46YJTjTx
  MYSQL_ROOT_PASSWORD: TkdpSmk2QTQ2WUpUalR4
```
