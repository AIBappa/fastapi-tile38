# pull official base image
FROM python:3.10.6-slim-buster

# set work directory
WORKDIR /usr/src

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN set -eux \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl \
    && pip install --upgrade pip \
    && rm -rf /root/.cache/pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# copy pyproject file - following command copies poetry files to working directory which is noted above. This working directory is same as the docker-compose.yml volume mounted.
COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root
