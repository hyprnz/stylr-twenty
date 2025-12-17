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

> Note: These fabricated credentials are then going to be used in local deployments 


## Running locally

>Make sure you have docker desktop running locally

1. run `docker compose up -d` to start the database and redis
2. Open browser to http://localhost:3000

> Note: if you change the database password, you need to bring docker down and up again: `docker compose down --volumes` followed by `docker compose up -d`


## Deploy to LightSail

We need to deploy all the docker containers to an existing container-service in LightSail (in AWS) called `stylr-twenty-development`.

### Source: Docker images on your local machine

PreRequisites:

1. Install the ["LightSail Control" plugin](https://docs.aws.amazon.com/en_us/lightsail/latest/userguide/amazon-lightsail-install-software.html#install-software-lightsailctl)
   * You may need to restart your terminal for the `lightsailctl` command to be available
2. Deployment configuration is defined in `deploy/containers.json`.
3. You will need to create a `deploy/.env.local` file with the following variables:
   * `PG_USERNAME` (username of the PostgreSQL database)
   * `PG_PASSWORD` (password of the PostgreSQL database)
   * `PG_HOST` (host of the PostgreSQL database, in AWS)
   * `PG_DB` (name of the PostgreSQL database. by default should be: `stylr-twenty`)
   * `APP_SECRET` (a random 25 character string, with no special characters )
   * `SERVER_URL` (the full URL of the lightsail container-service)
   * `REDIS_URL` (the URL of the redis instance, in LightSail)

> Note: DO NOT add the `deploy/.env.local` file to source control!

Execute the following commands:

1. `docker images` to view the installed containers on your local machine
2. Run these commands:

```bash
aws lightsail push-container-image --region ap-southeast-2 --service-name stylr-twenty-development --label server --image twentycrm/twenty:latest
aws lightsail push-container-image --region ap-southeast-2 --service-name stylr-twenty-development --label redis --image redis:latest
```

Now that we have some docker images loaded into the container-service, we can create a deployment using those images, with the configuration defined in `deploy/containers.json` and `deploy/public-endpoint.json`.

1. Generate the file `deploy/containers.json`:
   1. Update the following settings in `deploy/.env.local`:
      * `SERVER_URL` - to be the "Public domain" of the container-service
      * `SERVER_IMAGE_NAME` - to be the name of the `server` image in the container-service
      * `REDIS_IMAGE_NAME` - to be the name of the `redis` image in the container-service
   2. Run the `deploy/generate-config.sh` script to produce `deploy/containers.json`. 
2. Deploy with this command:

```bash
aws lightsail create-container-service-deployment --service-name stylr-twenty-development --containers file://deploy/containers.json --public-endpoint file://deploy/public-endpoint.json --no-cli-pager
```

> Note: DO NOT add the `deploy/containers.json` file to source control!