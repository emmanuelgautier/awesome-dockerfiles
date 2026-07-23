# Laravel Application Dockerfile Example

## Description

This repository provides a production-ready Dockerfile example for containerizing a Laravel application. It uses a multi-stage build to install PHP dependencies with Composer, build frontend assets with Node.js, and serve the application with PHP 8.3 and Apache.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore` and `docker/` folder into your Laravel application
2. Build the Docker image by running the following command:

```bash
docker build -t image-name .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8000:80 --env-file .env image-name
```

4. Test your application container by visiting `http://localhost:8000`

## What's included

- Multi-stage build: Composer dependencies, npm/Vite assets, and the final PHP-Apache runtime are built in isolated stages, keeping the final image lean.
- Production PHP configuration: OPcache enabled with timestamp validation disabled, error display off (`docker/php.prod.ini`).
- Non-dev, optimized autoloader Composer install (`--no-dev --optimize-autoloader`).
- Entrypoint script (`docker/entrypoint.sh`) that ensures `APP_KEY` is set (generating one as a fallback if missing), runs package discovery (skipped during `composer install --no-scripts` since the vendor build stage lacks the full app), and caches config, routes and views on container start.
- Correct file ownership on `storage` and `bootstrap/cache` for the `www-data` user.

## Customization

- **Environment Variables**: provide your `.env` file (or individual `-e` flags / a secrets manager) at runtime. Do not bake secrets into the image. Set a stable `APP_KEY` this way in production — the entrypoint only generates a throwaway one as a fallback, and a key that changes on every restart invalidates existing sessions/encrypted data.
- **Database migrations**: run `php artisan migrate --force` as a separate step (e.g. an init container or deployment hook), not inside the image build. `.env.example` ships with `SESSION_DRIVER`/`CACHE_STORE=file` and `QUEUE_CONNECTION=sync` so the app boots without a migrated database; switch these to `database` (and install `pdo_sqlite` or another driver) only once you've migrated.
- **Database driver**: only `pdo_mysql` is installed by default (matching `DB_CONNECTION=mysql` in `.env.example`). Add the relevant `docker-php-ext-install` call (e.g. `pdo_pgsql`) or `pecl install`/enable `pdo_sqlite` if you use a different database.
- **Queue workers / scheduler**: this image only runs the web server. Use the same image with a different `CMD` (e.g. `php artisan queue:work`) for workers, and a scheduler (cron or Kubernetes CronJob) calling `php artisan schedule:run`.
- **PHP extensions**: add any extra `docker-php-ext-install` calls your application needs.

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and Laravel documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
