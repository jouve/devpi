FROM alpine:3.11

COPY Pipfile Pipfile.lock ./

RUN adduser -D devpi

RUN set -e; \
    apk add --no-cache gcc libffi libffi-dev musl-dev python3 python3-dev; \
    pip3 install pip==19.3.1; \
    pip install certifi==2019.11.28 pipenv==2018.11.26 virtualenv==16.7.9 virtualenv-clone==0.5.3; \
    pipenv install --system --deploy; \
    pip uninstall -y virtualenv virtualenv-clone pipenv; \
    rm -rf /root/.cache; \
    apk del --no-cache gcc libffi-dev musl-dev python3-dev; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

CMD [ "docker-entrypoint.sh" ]
