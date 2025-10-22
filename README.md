# docker-postgres-pgbigm

PostgreSQL with pg_bigm extension pre-installed.

## Features

- Based on official PostgreSQL Docker images
- pg_bigm extension (v1.2-20250903) pre-compiled and ready to use
- Multi-platform support (linux/amd64, linux/arm64)
- Automated builds via GitHub Actions

## Supported PostgreSQL Versions

- PostgreSQL 16.6, 16.8, 16.9
- PostgreSQL 17.4, 17.5

## Usage

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/riseshia/docker-postgres-pgbigm:17.5
```

### Run Container

```bash
docker run -d \
  --name postgres-pgbigm \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  ghcr.io/riseshia/docker-postgres-pgbigm:17.5
```

### Enable pg_bigm Extension

Connect to your database and run:

```sql
CREATE EXTENSION pg_bigm;
```

### Docker Compose Example

```yaml
services:
  db:
    image: ghcr.io/riseshia/docker-postgres-pgbigm:17.5
    environment:
      POSTGRES_PASSWORD: mysecretpassword
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## Building Locally

```bash
# Build for default version (PostgreSQL 17)
docker build -t postgres-pgbigm .

# Build for specific PostgreSQL version
docker build --build-arg PG_VERSION=16.9 -t postgres-pgbigm:16.9 .

# Build for specific pg_bigm version
docker build --build-arg PGBIGM_VERSION=1.2-20250903 -t postgres-pgbigm .
```

## Image Tags

- `17.5`, `17.4` - PostgreSQL 17.x versions
- `16.9`, `16.8`, `16.6` - PostgreSQL 16.x versions
- `{version}-YYYYMMDD` - Dated builds (e.g., `17.5-20251022`)
- `{version}-{sha}` - Specific commit builds (e.g., `17.5-abc1234`)

## About pg_bigm

pg_bigm is a PostgreSQL extension that provides full-text search functionality using bigram indexing. It's particularly useful for:

- Japanese text search
- Partial match searches
- Fast LIKE queries

Learn more at: https://github.com/pgbigm/pg_bigm

## License

This repository's configuration files are provided as-is. PostgreSQL and pg_bigm are subject to their respective licenses.
