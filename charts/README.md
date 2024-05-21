# Charts for DataFrame

### How to install
- commands should be executed in this directory
#### Ozone
```
kubectl apply -f ozone-minikube
```
```
service includes
- om-public: ozone web ui
```

#### Spark-Livy
```
helm install spark spark-livy
```
```
service includes
- spark-webui: spark web ui
- spark-livy: livy web ui
- spark-zeppelin: zeppelin web ui
```

#### SeaTunnel
```
helm install seatunnel seatunnel
```
