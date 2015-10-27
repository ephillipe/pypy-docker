FROM pypy:2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

VOLUME /usr/src/app

ONBUILD RUN pip install -r /usr/src/requirements.txt
