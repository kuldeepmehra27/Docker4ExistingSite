FROM kuldeepmehra09/ubuntu AS ubuntuOS

# Configure Drupal
ARG PROJECT_NAME="drupal8"

RUN apt-get update
ENV WORKDIR /var/www/html

# Install Apache
RUN apt-get install -y apache2 && \
    apt-get install -y apache2-doc && \
    apt-get install -y apache2-utils && \
    apt-get clean 

# Set apache env vars & permissions
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_CONFDIR=/etc/apache2
ENV APACHE_ENVVARS=/etc/apache2/envvars
RUN chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /etc/apache2/ && \
    chown -R www-data:www-data /var/log/apache2

# This is resolve 404 isseue
RUN echo "\n<Directory /var/www/>" >> /etc/apache2/apache2.conf && \
    echo "\t Options Indexes FollowSymLinks" >> /etc/apache2/apache2.conf && \
    echo "\t AllowOverride All" >> /etc/apache2/apache2.conf && \
    echo "\t Require all granted" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf &&\
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Enable apache modules
RUN a2enmod rewrite && a2enmod proxy

# Virtual host configs
COPY ./DockerData/docker-configs/apache-drupal8.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
RUN service apache2 restart && bash

# Remove apache default index html file
RUN rm -rf $WORKDIR/index.html

# Install PHP 7.2
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php7.2

# Install PHP modules
RUN apt-get install -y php7.2-mysql php7.2-mbstring php7.2-dom php7.2-simplexml php7.2-ssh2 php7.2-xml php7.2-xmlreader php7.2-curl php7.2-exif php7.2-ftp php7.2-gd  php7.2-iconv php7.2-imagick php7.2-json  php7.2-mbstring php7.2-posix php7.2-sockets php7.2-tokenizer php7.2-mysqli php7.2-pdo  php7.2-sqlite3 php7.2-ctype php7.2-fileinfo php7.2-zip php7.2-exif php7.2-bcmath php7.2-cli php7.2-common

# PHP configuration
RUN sed -e 's/max_execution_time = 30/max_execution_time = 120/' -i /etc/php/7.2/apache2/php.ini
RUN sed -e 's/upload_max_filesize = 2M/upload_max_filesize = 60M/' -i /etc/php/7.2/apache2/php.ini
RUN sed -e 's/post_max_size = 8M/post_max_size = 64M/' -i /etc/php/7.2/apache2/php.ini
RUN sed -e 's/memory_limit = 128M/memory_limit = 1024M/' -i /etc/php/7.2/apache2/php.ini
RUN sed -e 's/max_input_time = 60/max_input_time = 300/' -i /etc/php/7.2/apache2/php.ini

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');" && \
    composer self-update --1

# Copy composer lock & json files
COPY ./composer.lock $WORKDIR/
COPY ./composer.json $WORKDIR/

# Run composer install
RUN composer install --working-dir=$WORKDIR

# Copy patches, all files & dirs
COPY . $WORKDIR/

# Copy settings file
COPY ./DockerData/data/dump/settings.php $WORKDIR/sites/default/settings.php

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
