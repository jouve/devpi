FROM jouve/poetry:1.6.1-alpine3.18.4

COPY pyproject.toml poetry.lock /srv/

RUN poetry -C /srv/ export --without-hashes > /requirements.txt

FROM alpine:3.18.4

COPY --from=0 /requirements.txt /usr/share/devpi/requirements.txt

RUN set -e; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        libffi-dev \
        make \
        musl-dev \
        python3-dev \
    ; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install --no-cache-dir pip==23.2.1 setuptools==68.2.2 wheel==0.41.2; \
    /usr/share/devpi/bin/pip install --no-cache-dir --requirement /usr/share/devpi/requirements.txt; \
    adduser -D devpi; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/devpi \
        | tr ',' '\n' \
        | grep . \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
        | grep -v libc.so \
    ); \
    apk del --no-cache .build-deps

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3141

VOLUME /var/lib/devpi

USER devpi

CMD [ "docker-entrypoint.sh" ]
