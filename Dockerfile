FROM kong:latest

ADD ./kong /kong

ENV KONG_PROXY_ERROR_LOG /dev/stdout
ENV KONG_ADMIN_ERROR_LOG /dev/stdout
ENV KONG_ADMIN_LISTEN 0.0.0.0:8001
ENV KONG_PLUGINS 'bundled,external-auth'
ENV KONG_LUA_PACKAGE_PATH './?.lua;./?/init.lua;/?.lua'
