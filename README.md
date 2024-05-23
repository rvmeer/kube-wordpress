# Kubernetes Wordpress

This project describes how to run wordpress (or multiple wordpresses) on a kubernetes

I use minikube to let everything run on one node.

## Install kubernetes and minikube

Todo

You can configure all steps below using `minikube dashboard`.

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

### Create the persistent volume claim for the database

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-volume
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: do-block-storage
```

### Create a MySQL replica set

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: mysql
  # labels so that we can bind a Service to this Pod
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: database
        image: mysql:5.7
        resources:
          limits:
            memory: 512Mi
          requests:
            memory: 256Mi
        args:
          # We need this to prevent mysql from throwing up -- our DO volume will be mounted here
          - "--ignore-db-dir=lost+found"
        # A nice way to get a whole bunch of values from a k8s secret into a container's  environment variables
        envFrom:
          - secretRef:
              name: wp-db-secrets
        ## The old way (one for each value):
        # env:
        # # Use a secret, avoid having plaintext passwords all over your configs
        # - name: MYSQL_ROOT_PASSWORD
        #   valueFrom:
        #     secretKeyRef:
        #       name: wp-db-secrets
        #       key: MYSQL_ROOT_PASSWORD
        livenessProbe:
          tcpSocket:
            port: 3306
        ports:
          - containerPort: 3306
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-data
        persistentVolumeClaim:
          claimName: mysql-volume
```

### Create the MySQL service

```
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
  - port: 3306
    protocol: TCP
  selector:
    app: mysql
```
