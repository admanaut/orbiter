FROM nginx:stable-alpine
COPY dist /usr/share/nginx/html
COPY nginx.tmpl /etc/nginx/conf.d/nginx.tmpl

CMD /bin/sh -c "envsubst < /etc/nginx/conf.d/nginx.tmpl > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
