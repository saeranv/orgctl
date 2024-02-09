# TUTOR DAEMON[1]

## TODO:
- add to /etc/init.d file after testing

## Usage 
```
/tutor/daemon.sh start 
/tutor/daemon.sh stop 
/tutor/daemon.sh restart 
```

### PID 
The PID gets written to /var/run/tutor.pid, and will be deleted when 
daemon is stopped. You can also check PID using a specific port with:
`lsof -i :<PORT>`. By default, app.py uses PORT=5000


## Permissions

### For ./daemon.sh
To ensure write permission to `/var/run/`
`sudo chmod +x ./daemon.sh`

### For app.py 
When starting flask server via `python app.py`, the `--pid` flag writes the server pid to `/var/run/tutor.pid`, which requires elevated write permission. Run the following:
`sudo chown $(whoami):$(whoami) /var/run`

## References
https://somesh-rokz.medium.com/how-to-create-daemons-in-linux-with-a-simple-hello-world-bash-example-e739dea78284
