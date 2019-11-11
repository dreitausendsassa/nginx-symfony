FROM phpearth/php:7.2-nginx

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache php7.2-pdo_mysql php7.2-redis php7.2-mongodb php7.2-composer php7.2-yaml php7.2-imagick php7.2-mcrypt sudo bash vim

RUN echo "clear_env = no" >> /etc/php/7.2/php-fpm.d/www.conf
RUN echo "catch_workers_output = yes" >> /etc/php/7.2/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /etc/php/7.2/php-fpm.d/www.conf
RUN echo "php_admin_value[memory_limit] = 128M" >> /etc/php/7.2/php-fpm.d/www.conf

# Set symfony environment
ENV APP_ENV prod

# Logging
RUN mkfifo /tmp/stdout && chmod 777 /tmp/stdout

# Clear cronjobs
RUN echo "" | crontab -

# Entrypoint
RUN echo "#!/bin/bash" > /entrypoint.sh \
    && echo "set -e" >> /entrypoint.sh \
    && echo "if [ -f /var/www/html/startup.sh ]; then" >> /entrypoint.sh \
    && echo "sudo -u www-data -E /var/www/html/startup.sh" >> /entrypoint.sh \
    && echo "fi" >> /entrypoint.sh \
    && echo "crond -l 8 -f &" >> /entrypoint.sh \
    && echo "tail -f /tmp/stdout &" >> /entrypoint.sh \
    && echo "/sbin/runit-wrapper" >> /entrypoint.sh

RUN chmod u+x /entrypoint.sh

WORKDIR /var/www/html

CMD ["/entrypoint.sh"]