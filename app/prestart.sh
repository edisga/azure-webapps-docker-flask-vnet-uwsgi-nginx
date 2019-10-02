#!/bin/sh
set -e
# Get environment variables to show up in SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

echo "Random port: $PORT" 
#This code is based on this entry point https://github.com/tiangolo/uwsgi-nginx-flask-docker/blob/fa9d991ebcc210edd12d64f8ab8e96c6e2ef04c9/python3.7/entrypoint.sh
echo "Generating Ningx Conf based on random port ..."
    # Get the URL for static files from the environment variable
    USE_STATIC_URL=${STATIC_URL:-'/static'}
    # Get the absolute path of the static files from the environment variable
    USE_STATIC_PATH=${STATIC_PATH:-'/app/static'}
    content_server='server {\n'
    content_server=$content_server"    listen ${PORT};\n"
    content_server=$content_server'    location / {\n'
    content_server=$content_server'        try_files $uri @app;\n'
    content_server=$content_server'    }\n'
    content_server=$content_server'    location @app {\n'
    content_server=$content_server'        include uwsgi_params;\n'
    content_server=$content_server'        uwsgi_pass unix:///tmp/uwsgi.sock;\n'
    content_server=$content_server'    }\n'
    content_server=$content_server"    location $USE_STATIC_URL {\n"
    content_server=$content_server"        alias $USE_STATIC_PATH;\n"
    content_server=$content_server'    }\n'
    # If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
    if [ "$STATIC_INDEX" = 1 ] ; then
        content_server=$content_server'    location = / {\n'
        content_server=$content_server"        index $USE_STATIC_URL/index.html;\n"
        content_server=$content_server'    }\n'
    fi
    content_server=$content_server'}\n'
    # Save generated server /etc/nginx/conf.d/nginx.conf
    printf "$content_server" > /etc/nginx/conf.d/nginx.conf
    # Save generated server /etc/nginx/conf.d/nginx.conf
 