
```console
# apt-get install ssh-import-id
$ ssh-import-id $GITHUBACCOUNT
```

Install everything:
```console
# apt-get install -y nginx uwsgi python3-venv python3-pip postgresql

```

 debootstrap bionic myroot http://archive.ubuntu.com/ubuntu

## nginx

tutorial: <https://www.netguru.co/codestories/nginx-tutorial-basics-concepts>

- Config files in sites available --> inactive
- Symlink in sites-enabled to activate
  
```console
/etc/nginx/sites-available:
total 16
drwxr-xr-x 2 root root 4096 Oct 25 13:20 ./
drwxr-xr-x 8 root root 4096 Oct 25 12:53 ../
-rw-r--r-- 1 root root 2416 Apr  6  2018 default
-rw-r--r-- 1 root root 2418 Oct 25 13:20 flask

/etc/nginx/sites-enabled:
total 8
drwxr-xr-x 2 root root 4096 Oct 25 13:23 ./
drwxr-xr-x 8 root root 4096 Oct 25 12:53 ../
lrwxrwxrwx 1 root root   32 Oct 25 13:23 flask -> /etc/nginx/sites-available/flask
```

Minimal config example:

```console
root@infra:~ # mkdir -p /srv/www/static
root@infra:~ # cp /etc/nginx/sites-available/{default,flask}
root@infra:~ # vi /etc/nginx/sites-available/flask
root@infra:~ # ### edit config, change root dir
root@infra:~ # sed -r '/^\s*#/d' /etc/nginx/sites-available/flask

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /srv/www/static;

        index index.html index.htm index.nginx-debian.html;
        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }
}
root@infra:~ # echo '<html><head></head><body>Hello, world!</body></html>'  > /srv/www/index.html
root@infra:~ # rm /etc/nginx/sites-enabled/default
root@infra:~ # ln -s /etc/nginx/sites-{available,enabled}/flask
root@infra:~ # man nginx    # how to load new config??
root@infra:~ # nginx -s reload
root@infra:~ # wget -qO- localhost  # check if it worked
<html><head></head><body>Hello, world!</body></html>
root@infra:~ #
```
