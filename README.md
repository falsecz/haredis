# Redis HA - sentinel + haproxy + haproxy stats api


### Run redis cluster
```
redis-server --port 6666
redis-server --port 6667
redis-server --port 6668
```

### Set slaves
```
redis-cli -p 6667 SLAVEOF 127.0.0.1 6666
redis-cli -p 6668 SLAVEOF 127.0.0.1 6666
```

### Run sentinel
```
redis-server sentinel.conf  --sentinel
```

### Run haproxy
```
haproxy -f haproxy.cfg -db
```

Open http://localhost:8080/ and try kill some redis

