FROM prestashop/prestashop:latest
RUN apt-get update && apt-get install -y default-mysql-client
COPY start.sh /start.sh
ENTRYPOINT ["/start.sh"]
