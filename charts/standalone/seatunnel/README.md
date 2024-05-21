## SeaTunnel on K8s Helm Chart

```
helm install seatunnel seatunnel
```

example job is written in file `seatunnel.streaming.conf`
```
env {
  parallelism = 2
  job.mode = "STREAMING"
  checkpoint.interval = 2000
}

source {
  FakeSource {
    parallelism = 2
    result_table_name = "fake"
    row.num = 16
    schema = {
      fields {
        name = "string"
        age = "int"
      }
    }
  }
}

sink {
  Console {
  }
}
```
you can ckeck if seatunnel cluster has successfully deployed by these commands.



```
kubectl exec -it  seatunnel-0  -- /opt/seatunnel/bin/seatunnel.sh --config /data/seatunnel.streaming.conf
kubectl exec -it  seatunnel-0  -- tail -f /opt/seatunnel/logs/seatunnel-engine-server.log | grep ConsoleSinkWriter
```


