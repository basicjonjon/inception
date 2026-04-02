FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y mariadb-server
COPY ./tools/init.sh /
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /init.sh
EXPOSE 3306
CMD ["/init.sh"]