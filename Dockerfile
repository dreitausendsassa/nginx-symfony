FROM dreitausendsassa/nginx-symfony:7.2-prod

RUN apk add --no-cache php7.2-xdebug zsh git

RUN echo "php_admin_flag[display_errors] = on" >> /etc/php/7.2/php-fpm.d/www.conf

# Add zsh as default shell
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
ENV SHELL /bin/zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set symfony environment
ENV APP_ENV dev
