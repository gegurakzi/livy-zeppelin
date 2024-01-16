# Zeppelin with Livy interpreter

### 0. add dependencies

spark/jars , spark/conf

### 1. build images

1. builder 
2. spark
3. livy
4. livyserver
5. zeppelin

### 2. install helm

```
helm install <chart name> <path/to/chart>
```

### 3. Livy interpreter setting
```
Zeppelin web ui
-> interpreters
-> livy
-> zeppelin.livy.url=http://<Livy Server service name>:<Livy Server service port>
```