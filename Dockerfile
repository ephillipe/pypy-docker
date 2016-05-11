FROM buildpack-deps:xenial

# remove several traces of debian python
RUN apt-get purge -y python.*
RUN apt-get update \
	&& apt-get install -y curl build-essential \
    && apt-get clean -y \
	&& apt-get autoclean -y \
	&& apt-get autoremove -y \
	&& rm -rf /usr/share/locale/* \
	&& rm -rf /var/cache/debconf/*-old \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /usr/share/doc/*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYPY_VERSION 5.0.1

RUN set -x \
	&& curl -SL "https://bitbucket.org/pypy/pypy/downloads/pypy-${PYPY_VERSION}-linux64.tar.bz2" \
		| tar -xjC /usr/local --strip-components=1

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.1
RUN curl -SL 'https://bootstrap.pypa.io/get-pip.py' | pypy \
	&& pip install --upgrade pip==$PYTHON_PIP_VERSION

#####################################################################################################

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

RUN curl -q -L https://raw.github.com/kvz/cronlock/master/cronlock -o /usr/bin/cronlock \
	&& chmod +x /usr/bin/cronlock

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
VOLUME /usr/src/app

ADD assets/myspell.tar.gz /usr/share/enchant/myspell
ADD requirements.txt /usr/src/app/requirements.txt
RUN pip install --upgrade pip \
	&& pip install -r /usr/src/app/requirements.txt

ADD entrypoint.sh /var/tmp/entrypoint.sh
ENTRYPOINT ["/var/tmp/entrypoint.sh"]

CMD ["pypy"]
