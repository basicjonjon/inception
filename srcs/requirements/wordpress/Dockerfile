FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    wget \
    curl
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh
EXPOSE 9000
CMD ["/init.sh"]