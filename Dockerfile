FROM python:3.7-alpine3.8

COPY lock.py Pipfile.lock /

RUN python lock.py <Pipfile.lock >requirements.txt

FROM python:3.7-alpine3.8

COPY --from=0 /requirements.txt .

RUN apk add --no-cache gcc libffi libffi-dev musl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del --no-cache gcc libffi-dev musl-dev

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD [ "/docker-entrypoint.sh" ]

