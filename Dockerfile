FROM python:3.12.2-bullseye AS build_wheel

RUN apt-get update
RUN apt-get install \
    -y --no-install-recommends \
    build-essential
RUN apt-get update && apt-get install -y git
RUN git --version
RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/NLTGit/gem_terracotta.git
RUN cd gem_terracotta && git checkout tags/v1.1 && cd ..
RUN mkdir /terracotta
RUN ls -la
RUN cp -a /gem_terracotta/. /terracotta/
RUN rm -rf /gem_terracotta

WORKDIR /terracotta

RUN python -m pip install --upgrade pip
RUN python setup.py bdist_wheel


FROM python:3.12.2-bullseye

COPY --from=build_wheel /terracotta/dist/*.whl /terracotta/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
        pymysql>=1.0.0 \
        psycopg2-binary \
        gunicorn \
        werkzeug==0.16.0 \
        markupsafe==2.0.1 
        
RUN pip install git+https://github.com/NLTGit/gem_terracotta.git@v1.2.2
RUN rm -rf /terracotta

COPY docker/resources /

ENV TC_SERVER_PORT=5000
EXPOSE $TC_SERVER_PORT

CMD ["/entrypoint.sh"]
