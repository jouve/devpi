FROM alpine:3.13.0

COPY poetry.txt /

RUN set -e; \
    apk add --no-cache cargo gcc libffi-dev musl-dev openssl-dev python3-dev; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install -r /poetry.txt

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN /usr/share/poetry/bin/poetry export --without-hashes > /requirements.txt

FROM alpine:3.13.0

COPY --from=0 /requirements.txt /usr/share/devpi/requirements.txt

RUN set -e; \
    apk add --no-cache libffi python3 \
                       cargo gcc libffi-dev make musl-dev python3-dev; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install --no-cache-dir -r /usr/share/devpi/requirements.txt; \
    find /usr -name __pycache__ -print0 | xargs -0 rm -rf; \
    adduser -D devpi; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi; \
    apk del --no-cache cargo gcc libffi-dev make musl-dev python3-dev

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3141

VOLUME /var/lib/devpi

USER devpi

CMD [ "docker-entrypoint.sh" ]
