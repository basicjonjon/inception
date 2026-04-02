FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    sudo \
    nginx \
    openssl \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress \
    && chown -R www-data:www-data /var/www/wordpress \
    && chmod 755 /var/www/wordpress

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=jle-doua.42.fr/UID=jle-doua"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]