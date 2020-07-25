FROM alpine:3.12.0
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST

COPY pipenv.txt /

RUN set -e; \
    apk add --no-cache python3; \
    python3 -m venv /tmp/pipenv; \
    /tmp/pipenv/bin/pip install -r /pipenv.txt

COPY Pipfile Pipfile.lock /srv/

WORKDIR /srv

RUN /tmp/pipenv/bin/pipenv lock -r > /requirements.txt

FROM alpine:3.12.0
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST

COPY --from=0 /requirements.txt /usr/share/devpi/requirements.txt

RUN set -e; \
    apk add --no-cache libffi python3 \
                       gcc libffi-dev musl-dev python3-dev; \
    python3 -m venv /usr/share/devpi; \
    /usr/share/devpi/bin/pip install --no-cache-dir wheel==0.34.2; \
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
