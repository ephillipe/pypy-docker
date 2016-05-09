FROM pypy:2-5.1.1

RUN apt-get update \
    && apt-get install -y \
       enchant libffi-dev libc-ares-dev nscd \
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

RUN pip install --upgrade -r /usr/src/requirements.txt
RUN pwd; id

CMD ["/var/tmp/entrypoint.sh"]
