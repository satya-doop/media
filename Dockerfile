FROM alpine:3.12
LABEL MAINTAINER = s.prakashsharma1989@gmail.com

RUN apk --no-cache add php php-fpm php-mbstring php-xml nginx supervisor curl && \
	rm /etc/nginx/conf.d/default.conf


COPY nginx.conf /etc/nginx/nginx.conf

COPY fpm-fool.conf /etc/php/php-fpm.d/www.conf

COPY php.ini /etc/php/conf.d/custom.ini

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/www/html

RUN chown -R nobody.nobody /var/www/html && \
	chown -R nobody.nobody /run && \
	chown -R nobody.nobody /var/lib/nginx && \
	chown -R nobody.nobody /var/log/nginx && \
	touch /var/log/php7/error.log && \
	chown -R nobody.nobody /var/log/php7/error.log && \
	chmod 755 /var/log/php7/error.log

USER nobody

WORKDIR /var/www/html
COPY --chown=nobody index.php /var/www/html/

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
