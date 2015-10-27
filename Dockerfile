FROM pypy:2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD requirements.txt /usr/src/requirements.txt
RUN pip install -r /usr/src/requirements.txt
