FROM php:7.4-cli

RUN apt-get update -qq \
	&& apt-get install -qqy build-essential libssl-dev unzip git-core git-ftp lftp

RUN curl -OLs https://composer.github.io/installer.sig \
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php --no-ansi --install-dir=/usr/bin --filename=composer \
	&& php -r "unlink('composer-setup.php'); unlink('installer.sig');"

RUN curl https://www.libssh2.org/download/libssh2-1.9.0.tar.gz > /tmp/libssh.tar.gz \
	&& tar -xzf /tmp/libssh.tar.gz -C /tmp/ \
	&& cd /tmp/libssh2* \
	&& ./configure --prefix=/usr \
	&& make \
	&& make install

RUN curl https://curl.se/download/curl-7.72.0.tar.gz > /tmp/curl.tar.gz \
	&& tar -xzf /tmp/curl.tar.gz -C /tmp/ \
	&& cd /tmp/curl* \
	&& ./configure --prefix=/usr --disable-libcurl-option --disable-shared --with-libssh2=/usr/ \
	&& make \
	&& make install

RUN ldconfig
