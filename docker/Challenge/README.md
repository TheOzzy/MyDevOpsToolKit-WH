# 🐳 Docker Projects

Two Docker-based Flask projects.

| Project | Stack | Pattern demonstrated |
|---------|-------|----------------------|
| `Challenge` | Flask + Redis + Nginx | Multi-container app, horizontal scaling, load balancing, persistent storage |
| `WebApp-Dockerise/hello_flask` | Flask + MySQL | Dockerising a database-backed web app |

**Prerequisites:** Docker Engine 20.10+ and Docker Compose v2. Ports `5000` and `5002` free.

```
docker/
├── Challenge/
│   ├── app.py
│   ├── dockerfile
│   ├── docker-compose.yml
│   ├── nginx.conf
│   ├── requirements.txt
│   ├── static/css/style.css
│   └── templates/{base,index,count}.html
└── WebApp-Dockerise/hello_flask/
    ├── app.py
    ├── Dockerfile
    └── docker-compose.yml
```

---

## 1. Challenge — Flask + Redis + Nginx

A Flask app backed by Redis, with Nginx in front as a reverse proxy and load balancer so the app
can be scaled to multiple instances behind one entry point.

```
                      ┌──────────────┐
    Browser ────────► │    nginx     │  :5000 published
                      │ (proxy / LB) │
                      └──────┬───────┘
                             │ round-robin
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    ┌───────────┐      ┌───────────┐      ┌───────────┐
    │ web-app_1 │      │ web-app_2 │      │ web-app_3 │   Flask
    └─────┬─────┘      └─────┬─────┘      └─────┬─────┘   expose 5000
          └──────────────────┼──────────────────┘
                             ▼
                      ┌──────────────┐
                      │   redis-db   │  :6379
                      └──────┬───────┘
                             ▼
                    redis-data volume
                        (/data)
```

| Service | Role | Host port |
|---------|------|-----------|
| `nginx` | Reverse proxy / load balancer | `5000` |
| `web-app` | Flask app (`expose: 5000`, no host port) | — |
| `redis-db` | Visit counter store | `6379` |

### Endpoints

- `/` — welcome page with a button through to `/count`
- `/count` — increments and displays the `hits` counter, shared across all instances via Redis

### Run

```bash
cd Challenge
docker compose up --build
```

Open <http://localhost:5000> and <http://localhost:5000/count>.

### Scale

```bash
docker compose up --build --scale web-app=3
```

`web-app` uses `expose` rather than `ports`, which is what makes this work — with a published host
port the second replica would fail with a port conflict. Nginx is the only service bound to the host.

Nginx resolves the `web-app` hostname when it starts, so if you scale up while the stack is already
running, restart it to pick up the new containers:

```bash
docker compose restart nginx
```

### Persistent storage through Redis

The counter lives in Redis, not in Flask process memory. That does two things:

- **Shared state** — all replicas increment the same key, so the count is consistent no matter which
  container serves the request. This is what keeps the Flask tier stateless and scalable.
- **Durable state** — `redis-data:/data` means the count survives `docker compose down` / `up`.

```bash
docker compose exec redis-db redis-cli GET hits   # check the value
docker compose down -v                            # deletes the volume
```

### Load balancing with Nginx

`nginx.conf` defines an upstream pool and proxies to it:

```nginx
upstream flask_app {
    server web-app:5000;
}
server {
    listen 5000;
    location / { proxy_pass http://flask_app; }
}
```

Docker's DNS returns one address per running `web-app` container; Nginx distributes across them
round-robin. Clients only ever reach port `5000` on Nginx — Flask and Redis sit on the private
Compose network.

---

## 2. hello_flask — Flask + MySQL

A Flask app that connects to MySQL and returns the server version.

### Run

```bash
cd WebApp-Dockerise/hello_flask
docker compose up --build
```

Open <http://localhost:5002>.

### MySQL configuration

| Setting | Value |
|---------|-------|
| Host | `newdb` (the Compose service name) |
| User | `root` |
| Password | `my-secret-pw` (set in `docker-compose.yml`) |
| Database | `mysql` |

---

## Known limitations

**Challenge**
- `app.py` runs the Flask development server with `debug=True` — single-threaded and not production-safe
- `redis-db` publishes `6379` to the host unnecessarily
- Redis uses default RDB snapshots; add `--appendonly yes` to avoid losing writes on an ungraceful stop
- `dockerfile` is lowercase — Docker looks for `Dockerfile`, so this may fail on case-sensitive filesystems
- No `.dockerignore`; `__pycache__` is currently copied into the image

**hello_flask**
- `docker-compose.yml` uses `build:` with an image reference — `build:` expects a build context path, so this should be `build: .` (or `image:` if pulling a prebuilt image)
- No volume on `newdb`, so the database is wiped whenever the container is recreated
- Credentials hard-coded in `app.py` and `docker-compose.yml`
- Connects as `root` to the internal `mysql` system database
- `python:3.8-slim` base image is end-of-life
- No retry on the initial DB connection; `depends_on` waits for the container to start, not for MySQL to accept connections

**Both**
- `version: '3.8'` is obsolete under Compose v2 and prints a warning; it can be deleted
