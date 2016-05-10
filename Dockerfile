FROM pypy:2-5.1.1

RUN apt-get update \
    && apt-get install -y \
       cron enchant libffi-dev libc-ares-dev nscd \
    && apt-get clean -y \
	&& apt-get autoclean -y \
	&& apt-get autoremove -y \
	&& rm -rf /usr/share/locale/* \
	&& rm -rf /var/cache/debconf/*-old \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /usr/share/doc/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
VOLUME /usr/src/app

ADD assets/myspell.tar.gz /usr/share/enchant/myspell
ADD entrypoint.sh /var/tmp/entrypoint.sh
ADD requirements.txt /usr/src/requirements.txt

RUN curl -q -L https://raw.github.com/kvz/cronlock/master/cronlock -o /usr/bin/cronlock \
	&& chmod +x /usr/bin/cronlock

RUN pip install --upgrade pip \
	&& pip install -r /usr/src/requirements.txt

CMD ["/var/tmp/entrypoint.sh"]
