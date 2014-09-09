# Freifunk Magdeburg Wiki

## Installation

    $ useradd -d /var/lib/gollum -U -r -s /bin/bash gollum
    $ cd /var/lib
    $ git clone https://github.com/apfohl/ffmd-wiki.git gollum
    $ su - gollum
    $ mkdir wiki
    $ cd wiki && git init
    $ cd .. && mkdir nginx
    $ mkdir log
    $ cp .env_example .env
    $ bundle install --deployment
    $ exit
    $ bundle exec foreman export -a gollum -l /var/lib/gollum/log -u gollum initscript /etc/init.d
    $ chmod +x /etc/init.d/gollum
    $ chown -R www-data:www-data /var/lib/gollum/nginx/
    $ service start gollum

Edit ```.env```:

    WIKI_URL=https://wiki.md.freifunk.net
    WIKI_PATH=/var/lib/gollum
    WIKI_REPOSITORY_PATH=/var/lib/gollum/wiki
    WIKI_GITHUB_CLIENT_ID=<client_id>
    WIKI_GITHUB_CLIENT_SECRET=<client_secret>
    WIKI_USER=gollum
    WIKI_GROUP=gollum

Create ```/etc/nginx/sites-available/wiki``` with following content:

    upstream wiki {
        server unix:/var/lib/gollum/unicorn/wiki.sock;
    }

    server {
        listen 80;
        listen [::]:80;
        server_name wiki.md.freifunk.net;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    server {
        listen [::]:443;
        include /etc/nginx/ssl_params;

        server_name wiki.md.freifunk.net;
        access_log /var/lib/gollum/nginx/access.log;
        error_log /var/lib/gollum/nginx/error.log;

        location / {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass http://wiki;
        }
    }

Create a symlink to enable the site:

    $ cd /etc/nginx/sites-enabled
    $ ln -s /etc/nginx/sites-available/wiki wiki
    $ service nginx restart
