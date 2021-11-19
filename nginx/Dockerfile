FROM nginx:1.20
RUN rm -f /etc/nginx/conf.d/*
COPY conf.d/nginx.conf /etc/nginx/conf.d/nginx.conf
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/conf.d/nginx.conf
