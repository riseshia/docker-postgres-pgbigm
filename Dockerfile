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

# Copy only the pg_bigm artifacts. Installing postgresql-server-dev in the builder upgrades the
# server packages to the latest minor release, so copying the whole lib directory would replace
# the base image's modules with ones built for another minor (e.g. an llvmjit.so linked against
# an LLVM version the base image does not ship, which breaks every JIT-compiled query).
# The bitcode is left out for the same reason: it is produced by the builder's newer clang.
COPY --from=builder /usr/lib/postgresql/$PG_MAJOR/lib/pg_bigm.so /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=builder /usr/share/postgresql/$PG_MAJOR/extension/pg_bigm* /usr/share/postgresql/$PG_MAJOR/extension/

COPY init.sql /docker-entrypoint-initdb.d/
