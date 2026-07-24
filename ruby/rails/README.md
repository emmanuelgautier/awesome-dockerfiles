# Ruby on Rails Application Dockerfile Example

## Description

This repository provides a production-ready Dockerfile example for containerizing a Ruby on Rails application. It uses a multi-stage build to install gems and precompile assets with Bundler, and serve the application with Puma.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore` and `docker/` folder into your Rails application
2. Build the Docker image by running the following command:

```bash
docker build -t image-name .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8000:3000 -e SECRET_KEY_BASE=your-secret-here image-name
```

4. Test your application container by visiting `http://localhost:8000`

## What's included

- Multi-stage build: build tools, gems and precompiled assets stay in the `build` stage, keeping the final image lean and free of compilers.
- Non-dev, non-test gem install (`BUNDLE_WITHOUT=development:test`, `BUNDLE_DEPLOYMENT=1`) using the committed `Gemfile.lock`.
- Assets are precompiled at build time (`assets:precompile`) so the first request doesn't pay the compilation cost.
- Runs as a dedicated non-root `rails` user.
- Entrypoint script (`docker/entrypoint.sh`) that refuses to start if neither `SECRET_KEY_BASE` nor `RAILS_MASTER_KEY` is provided at runtime — no secret is ever baked into the image — and runs `db:prepare` before booting the server.
- `HEALTHCHECK` against Rails' built-in `/up` endpoint.

## Customization

- **Environment Variables**: `SECRET_KEY_BASE` (or `RAILS_MASTER_KEY` if you use encrypted credentials) is required — the container won't start without one. Pass it via `-e`, an env file, or a secrets manager at runtime.
- **Database**: this example ships with SQLite for simplicity. `config/database.yml` points the `production` environment at `storage/production.sqlite3` — mount `storage/` as a persistent volume, or switch to PostgreSQL/MySQL by updating the Gemfile and `database.yml` and installing the matching client library (e.g. `libpq-dev`/`libmysqlclient-dev`) in the `runtime` stage.
- **Assets**: if you add a JavaScript build step (esbuild, Vite, Tailwind CLI), add a Node.js build stage that compiles assets, then let `assets:precompile` pick them up before `COPY --from=build`.
- **Background jobs / cable**: add the relevant gems (Solid Queue, Solid Cable, Sidekiq, ...) and run their workers as separate containers/processes, not inside this web image.

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and Ruby on Rails documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
