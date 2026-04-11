FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    wget \
    curl

RUN cd /var/www/html &&\
    wget https://wordpress.org/latest.tar.gz &&\
    tar -xvf latest.tar.gz --strip-components=1 &&\
    rm latest.tar.gz
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh
EXPOSE 9000
CMD ["/init.sh"]