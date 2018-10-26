FROM jugendpresse/apache:php-7.2
MAINTAINER Martin Winter <m.winter@jugendpresse.de>

ENV APACHE_WORKDIR="/var/www/simplesamlphp"

RUN wget 'https://simplesamlphp.org/download?latest' -O /tmp/simplesamlphp.tar.gz
RUN tar xfz /tmp/simplesamlphp.tar.gz --strip=1 -C $APACHE_WORKDIR
RUN rm -f /tmp/simplesamlphp.tar.gz

# COPY files/templates/* /templates/
# COPY files/install.sh /boot.d/

RUN update-ca-certificates

# run on every (re)start of container
ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
