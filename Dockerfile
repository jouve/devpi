FROM python:3.6-alpine3.7

ARG DEVPI_SERVER_VERSION=4.4.0
ARG DEVPI_WEB_VERSION=3.2.2
RUN apk add --no-cache libffi gcc musl-dev libffi-dev && \
    pip install "devpi-server==$DEVPI_SERVER_VERSION" "devpi-web==$DEVPI_WEB_VERSION" && \
    apk del --no-cache gcc musl-dev libffi-dev

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD [ "/docker-entrypoint.sh" ]

