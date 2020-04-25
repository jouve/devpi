FROM alpine:3.11.6

COPY Pipfile Pipfile.lock ./

RUN adduser -D devpi

RUN set -e; \
    apk add --no-cache gcc libffi libffi-dev musl-dev python3 python3-dev; \
    pip3 install pip==20.0.2; \
    pip install appdirs==1.4.3 certifi==2020.4.5.1 distlib==0.3.0 filelock==3.0.12 pipenv==2018.11.26 six==1.14.0 virtualenv==20.0.18 virtualenv-clone==0.5.4; \
    pipenv install --system --deploy; \
    pip uninstall -y distlib filelock pipenv virtualenv virtualenv-clone; \
    rm -rf /root/.cache; \
    apk del --no-cache gcc libffi-dev musl-dev python3-dev; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

CMD [ "docker-entrypoint.sh" ]
