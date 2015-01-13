# Smeagol

A standalone [Gollum](https://github.com/gollum/gollum) Wiki with GitHub OAuth22 support.

## Installation

    $ useradd -d /var/lib/smeagol -U -r -s /bin/bash smeagol
    $ cd /var/lib
    $ git clone https://github.com/apfohl/smeagol.git smeagol
    $ su - smeagol
    $ mkdir wiki
    $ cd wiki && git init
    $ cd .. && mkdir nginx
    $ mkdir log
    $ cp .env_example .env
    $ bundle install --deployment
    $ exit
    $ bundle exec foreman export -a smeagol -l /var/lib/smeagol/log -u smeagol initscript /etc/init.d
    $ chmod +x /etc/init.d/smeagol
    $ chown -R www-data:www-data /var/lib/smeagol/nginx/
    $ service start smeagol

Edit ```.env```:

    WIKI_URL=https://wiki.example.com
    WIKI_PATH=/var/lib/smeagol
    WIKI_REPOSITORY_PATH=/var/lib/smeagol/wiki
    WIKI_GITHUB_CLIENT_ID=<client_id>
    WIKI_GITHUB_CLIENT_SECRET=<client_secret>
    WIKI_USER=smeagol
    WIKI_GROUP=smeagol

Create ```/etc/nginx/sites-available/wiki``` with following content:

    upstream wiki {
        server unix:/var/lib/smeagol/unicorn/smeagol.sock;
    }

    server {
        listen 80;
        listen [::]:80;
        server_name wiki.example.com;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    server {
        listen [::]:443;
        include /etc/nginx/ssl_params;

        server_name wiki.example.com;
        access_log /var/lib/smeagol/nginx/access.log;
        error_log /var/lib/smeagol/nginx/error.log;

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
