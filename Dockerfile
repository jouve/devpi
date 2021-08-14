FROM jouve/poetry:1.1.7-alpine3.14.1

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN poetry export --without-hashes > /requirements.txt

FROM alpine:3.14.1

COPY --from=0 /requirements.txt /usr/share/devpi/requirements.txt

RUN set -e; \
    apk add --no-cache --virtual .build-deps \
        cargo \
        gcc \
        libffi-dev \
        make \
        musl-dev \
        openssl-dev \
        python3-dev \
    ; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install wheel==0.36.2; \
    /usr/share/devpi/bin/pip install -r /usr/share/devpi/requirements.txt; \
    adduser -D devpi; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/devpi \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
    ); \
    apk del --no-cache .build-deps; \
    rm -rf /root/.cache /root/.cargo

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3141

VOLUME /var/lib/devpi

USER devpi

CMD [ "docker-entrypoint.sh" ]
