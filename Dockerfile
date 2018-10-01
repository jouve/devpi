FROM python:3.7-alpine3.8

ARG DEVPI_SERVER_VERSION=4.7.1
ARG DEVPI_WEB_VERSION=3.4.1
RUN apk add --no-cache libffi gcc musl-dev libffi-dev && \
    pip install --no-cache-dir "devpi-server==$DEVPI_SERVER_VERSION" "devpi-web==$DEVPI_WEB_VERSION" && \
    apk del --no-cache gcc musl-dev libffi-dev

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD [ "/docker-entrypoint.sh" ]

