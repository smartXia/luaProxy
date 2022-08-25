FROM openresty/openresty:bionic
RUN luarocks install luajson
RUN luarocks install lua-resty-jwt

# 
# CP /opt/www/html/  /opt/www/html/;