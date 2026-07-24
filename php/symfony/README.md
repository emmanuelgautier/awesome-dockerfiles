# Symfony Application Dockerfile Example

## Description

This repository provides a production-ready Dockerfile example for containerizing a Symfony application. It uses a multi-stage build to install PHP dependencies with Composer and serve the application with PHP 8.5 and Apache.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore` and `docker/` folder into your Symfony application
2. Build the Docker image by running the following command:

```bash
docker build -t image-name .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8000:80 -e APP_SECRET=your-secret-here image-name
```

4. Test your application container by visiting `http://localhost:8000`

## What's included

- Multi-stage build: Composer dependencies and the final PHP-Apache runtime are built in isolated stages, keeping the final image lean.
- Production PHP configuration: OPcache enabled with timestamp validation disabled and preloading of the compiled container (`docker/php.prod.ini`).
- Non-dev, optimized autoloader Composer install (`--no-dev --optimize-autoloader`).
- The container (routes, services) is warmed for the `prod` environment at build time via `bin/console cache:warmup`, so the first request doesn't pay the compilation cost.
- Apache is configured with `FallbackResource /index.php` (`docker/apache.conf`) so Symfony's front controller handles routing without needing `mod_rewrite`/`.htaccess`.
- Entrypoint script (`docker/entrypoint.sh`) that refuses to start if `APP_SECRET` isn't provided at runtime — no default or generated secret is ever baked in or created on the fly.
- Correct file ownership on `var/` for the `www-data` user.

## Customization

- **Environment Variables**: `APP_SECRET` is required — the container won't start without it. Pass it via `-e APP_SECRET=...`, an env file, or a secrets manager at runtime. Do not bake secrets into the image; real environment variables always take precedence over the values in `.env`.
- **Database / Doctrine**: this example ships the minimal `symfony/skeleton` (no ORM). If you add `symfony/orm-pack`, install the matching PHP extension (e.g. `pdo_pgsql` or `pdo_mysql`) in the `base` stage and run `doctrine:migrations:migrate` as a separate step (an init container or deployment hook), not inside the image build.
- **Assets**: if you add a frontend toolchain (AssetMapper, Webpack Encore, Vite), add a Node.js build stage that compiles assets into `public/`, then `COPY --from=` it into the final stage, the same way the Laravel example handles its Vite build.
- **PHP extensions**: add any extra `docker-php-ext-install` calls your application needs.

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and Symfony documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
