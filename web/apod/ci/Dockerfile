FROM nginx:stable-alpine
COPY dist /usr/share/nginx/html
COPY nginx.tmpl /etc/nginx/conf.d/default.conf
# CMD ["nginx", "-g", "daemon off;"]

CMD /bin/sh -c "sed -i \"s/PORT/$PORT/g\" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
