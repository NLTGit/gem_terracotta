FROM python:3.12.2-slim-bullseye AS build_wheel

RUN apt-get update \
    && apt-get install \
    -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY . /terracotta

WORKDIR /terracotta

RUN python -m pip install --upgrade pip
RUN python setup.py bdist_wheel

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
        pymysql>=1.0.0 \
        psycopg2-binary \
        gunicorn \
        werkzeug==0.16.0 \
        markupsafe==2.0.1
RUN pip install git+https://github.com/NLTGit/gem_terracotta.git@gems 
RUN rm -rf /terracotta

COPY docker/resources /

ENV TC_SERVER_PORT=5000
EXPOSE $TC_SERVER_PORT

CMD ["/entrypoint.sh"]
