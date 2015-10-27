FROM pypy:2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

VOLUME /usr/src/app

ONBUILD RUN pip install -r /usr/src/requirements.txt

ENV APP_SCRIPT "application.py"
ENV APP_PORT "application.py"

CMD ["pypy", "${APP_SCRIPT}", "--port=${APP_PORT}"]
