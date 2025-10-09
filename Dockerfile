FROM python:3.11-slim

ENV POETRY_VERSION=2.2.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \ 
    && apt-get install --no-install-recommends -y build-essential curl git \ 
    && rm -rf /var/lib/apt/lists/*

ENV PATH="$POETRY_HOME/bin:$PATH"

RUN curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION

WORKDIR /app

COPY pyproject.toml poetry.lock /app/

RUN poetry install --no-root --no-cache

COPY . /app

CMD ["poetry", "run", "python", "-m", "nbclient", "--execute", "--timeout=600", "--kernel-name=python3", "sentences_topic_pipeline.ipynb"]
