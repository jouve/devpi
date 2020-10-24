FROM alpine:3.12.0

COPY poetry.txt /

RUN set -e; \
    apk add --no-cache gcc libffi-dev musl-dev openssl-dev python3-dev; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install -c /poetry.txt pip; \
    /usr/share/poetry/bin/pip install -c /poetry.txt wheel; \
    /usr/share/poetry/bin/pip install -c /poetry.txt poetry

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN /usr/share/poetry/bin/poetry export > /requirements.txt

FROM alpine:3.12.0

COPY --from=0 /requirements.txt /usr/share/devpi/requirements.txt

RUN set -e; \
    apk add --no-cache libffi python3 \
                       gcc libffi-dev musl-dev python3-dev; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install --no-cache-dir -r /usr/share/devpi/requirements.txt; \
    find -name __pycache__ | xargs rm -rf; \
    rm -rf /root/.cache; \
    apk del --no-cache gcc libffi-dev musl-dev python3-dev; \
    adduser -D devpi; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3141

VOLUME /var/lib/devpi

USER devpi

CMD [ "docker-entrypoint.sh" ]
