# Linux Webserver/reverse proxy: nginx, uwsgi & flask

## Preparation

Import your SSH-keys from GitHub:

```console
me@server:~# sudo apt-get install ssh-import-id      # for debian
me@server:~# ssh-import-id $GITHUBACCOUNT
```

*Experimental: install a ubuntu chroot inside Debian:*

```console
me@server:~# debootstrap bionic myroot http://archive.ubuntu.com/ubuntu
me@server:~# sudo debian_chroot=myroot chroot myroot/
(myroot)root@server:~# apt-get install man ssh vim git lsof at tmux gawk screen curl wget telnet dnsutils tcpdump nmap
```

Install everything:

```console
root@server:~# apt-add-repository universe
root@server:~# apt-get install -y nginx uwsgi python3-venv python3-pip postgresql

```

## nginx

tutorial: <https://www.netguru.co/codestories/nginx-tutorial-basics-concepts>

- Config files in sites available --> inactive
- Symlink in sites-enabled to activate

```console
root@server:~# ls -l /etc/nginx/sites-*
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
root@server:~# mkdir -p /srv/www/static
root@server:~# cp /etc/nginx/sites-available/{default,flask}
root@server:~# vi /etc/nginx/sites-available/flask
root@server:~# ### edit config, change root dir
root@server:~# sed -r '/^\s*#/d' /etc/nginx/sites-available/flask

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
root@server:~# echo '<html><head></head><body>Hello, world!</body></html>'  > /srv/www/static/index.html
root@server:~# rm /etc/nginx/sites-enabled/default
root@server:~# ln -s /etc/nginx/sites-{available,enabled}/flask
root@server:~# man nginx    # how to load new config??
root@server:~# nginx -s reload
root@server:~# wget -qO- localhost  # check if it worked
<html><head></head><body>Hello, world!</body></html>
root@server:~#
```

## Flask

cat << EOF > /srv/www/flask/web.py
from flask import Flask, g, request, abort, flash, render_template

log = logging.getLogger(__name__)
app = Flask(__name__, template_folder='./templates')

@app.route('/')
def home():
    return '<html><head></head><body>Hello, Flask!</body></html>'

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    log.info("Flask app starting")
    app.run(host='0.0.0.0', debug=True)

EOF
