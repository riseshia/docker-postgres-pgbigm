ARG PG_VERSION=17
FROM postgres:${PG_VERSION} AS builder

ARG PGBIGM_VERSION=1.2-20250903

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        build-essential \
        postgresql-server-dev-$PG_MAJOR \
        libicu-dev \
    ; \
    wget -O pg_bigm.tar.gz "https://github.com/pgbigm/pg_bigm/archive/refs/tags/v${PGBIGM_VERSION}.tar.gz"; \
    mkdir -p /tmp/pg_bigm; \
    tar -xzf pg_bigm.tar.gz -C /tmp/pg_bigm --strip-components=1; \
    cd /tmp/pg_bigm; \
    make USE_PGXS=1; \
    make USE_PGXS=1 install; \
    cd /; \
    rm -rf /tmp/pg_bigm pg_bigm.tar.gz; \
    apt-get purge -y --auto-remove \
        wget \
        build-essential \
        postgresql-server-dev-$PG_MAJOR \
        libicu-dev \
    ; \
    rm -rf /var/lib/apt/lists/*

FROM postgres:${PG_VERSION}

ENV LANG=en_US.utf8

COPY --from=builder /usr/lib/postgresql/$PG_MAJOR/lib/* /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=builder /usr/share/postgresql/$PG_MAJOR/extension/* /usr/share/postgresql/$PG_MAJOR/extension/

COPY init.sql /docker-entrypoint-initdb.d/
