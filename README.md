# Stylr-Twenty

> Original [README](https://github.com/twentyhq/twenty/blob/main/README.md).

This is a fork of the original Twenty CRM repository, that we are self-hosting in AWS.

## Local environment setup

### Tools

1. Install [Node.js](https://nodejs.org/en/download) v24.5.0 (or higher)
2. or, only install nvm, and switch to Node v24.5.0 using `nvm use v24.5.0`
3. Install Yarn v4: `npm install -g yarn`
4. Install Docker Desktop (https://www.docker.com/products/docker-desktop/)

### Project setup
1. Copy `packages/twenty-docker/.env.example` to `.env` (in root of project).
2. Set the value of the `PG_DATABASE_PASSWORD` to a 20 character random string (with no special characters).
3. Create a random secret `node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"` and copy that the `APP_SECRET` in the `.env` file
4. Run `yarn` to install dependencies.


## Running locally

>Make sure you have docker desktop running locally

1. run `docker compose up -d` to start the database and redis
2. Open browser to http://localhost:3000

> Note: if you change the database password, you need to bring docker down and up again: `docker compose down --volumes` followed by `docker compose up -d`


## Deploy

We need to deploy all the docker containers to an existing container-service in LightSail (in AWS) called `stylr-twenty-development`.

The configuration is defined in `deploy/containers.json`.

```bash
aws lightsail create-container-service-deployment --service-name stylr-twenty-development --containers file://deploy/containers.json --public-endpoint file://deploy/public-endpoint.json
```