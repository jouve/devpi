# syntax=docker/dockerfile:experimental

FROM alpine:3.12.1

COPY poetry.txt /

RUN apk add --no-cache gcc libffi-dev musl-dev openssl-dev python3-dev
RUN python3 -m venv /usr/share/poetry
RUN /usr/share/poetry/bin/pip install -c /poetry.txt pip
RUN /usr/share/poetry/bin/pip install -c /poetry.txt wheel
RUN /usr/share/poetry/bin/pip install -c /poetry.txt poetry

COPY pyproject.toml poetry.lock /

RUN --mount=type=cache,target=/srv /usr/share/poetry/bin/poetry export --without-hashes > /srv/requirements.txt
RUN --mount=type=cache,target=/srv cd /srv && /usr/share/poetry/bin/pip wheel -r requirements.txt

FROM alpine:3.12.1

RUN --mount=type=cache,target=/srv \
    set -e; \
    apk add --no-cache libffi python3; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install --no-cache-dir --find-links file:///srv -r /srv/requirements.txt; \
    find /usr -name __pycache__ -print0 | xargs -0 rm -rf; \
    adduser -D devpi; \
    mkdir /var/lib/devpi; \
    chown devpi:devpi /var/lib/devpi

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3141

VOLUME /var/lib/devpi

USER devpi

CMD [ "docker-entrypoint.sh" ]
