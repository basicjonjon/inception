FROM debian:bookworm

RUN apt-get update &&\
    apt-get install -y\
    php\
    php-fpm\
    php-mysql\
    wget\
    curl\
    mariadb-client

RUN cd /var/www/html &&\
    wget https://wordpress.org/latest.tar.gz &&\
    tar -xvf latest.tar.gz --strip-components=1 &&\
    rm latest.tar.gz
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
    chmod +x wp-cli.phar &&\
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh
EXPOSE 2000
CMD ["/init.sh"]