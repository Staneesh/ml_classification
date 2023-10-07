FROM nvidia/cuda:11.8.0-devel-ubuntu20.04
ENV TZ=Europe/Warsaw
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    python3-venv

# Configure Poetry
ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

# Install poetry separated from system interpreter
RUN python3 -m venv $POETRY_VENV
RUN $POETRY_VENV/bin/pip install -U pip setuptools
RUN $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Add `poetry` to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app
# COPY pyproject.toml ./
# RUN poetry lock
# RUN cat poetry.lock
# Install dependencies
COPY poetry.lock pyproject.toml ./
RUN poetry install

# Run your app
COPY . /app
CMD [ "poetry", "run", "python", "-c", "print('Hello, World!')" ]

