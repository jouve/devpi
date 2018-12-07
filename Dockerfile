FROM python:3.7-alpine3.8

COPY Pipfile Pipfile.lock ./

RUN apk add --no-cache gcc libffi libffi-dev musl-dev && \
    pip install pipenv==2018.11.26 && \
    pipenv install --system --deploy && \
    pip uninstall -y virtualenv virtualenv-clone pipenv && \
    rm -rf /root/.cache && \
    apk del --no-cache gcc libffi-dev musl-dev

EXPOSE 3141

VOLUME /var/lib/devpi

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD [ "/docker-entrypoint.sh" ]

