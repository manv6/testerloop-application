# Testerloop App 

This document will guide you through the process of setting up and running the Testerloop app monorepo. A script for building and mounting the app in a Docker container is provided. 

This repository brings together the [testerloop-server](https://github.com/testerloop/testerloop-server) and the [testerloop-frontend](https://github.com/testerloop/testerloop-frontend) repositories. 

## Prerequisites

Before getting started, make sure you have the following installed:

- [NVM](https://github.com/nvm-sh/nvm) 
- [Node.js](https://nodejs.org/en/download/)
- [npm](https://www.npmjs.com/get-npm)
- [Docker](https://docs.docker.com/get-docker/)

You will also need valid AWS credentials. If you don't have them yet, follow [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html#access-keys-and-secret-access-keys).

## Step 1: Clone the Repository

Start by cloning the repository using SSH:

```bash
git clone git@github.com:testerloop/testerloop-app.git
```

Navigate into the cloned repository:

```bash
cd testerloop-app
```

## Step 2: Set Up Configuration Files

Copy the .env.shadow and .npmrc.shadow files to .env and .npmrc, respectively:

```bash
cp .env.shadow .env && cp .npmrc.shadow .npmrc
```

## Step 3: Update .env File

Open the .env file and replace the placeholders with your AWS credentials:

```bash
PORT=8080

AWS_BUCKET_REGION=YOUR_AWS_BUCKET_REGION
AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
AWS_BUCKET_NAME=YOUR_AWS_BUCKET_NAME
EXPIRES_IN=3600
```

## Step 4: Update .npmrc File

Open the .npmrc file and replace <GITHUB_TOKEN> with the token provided by the Testerloop team:

```bash
@testerloop:registry=https://npm.pkg.github.com/
//npm.pkg.github.com/:_authToken=<GITHUB_TOKEN>
```

## Step 5: Run the Docker Install Script

*_You will need to have the Docker daemon running in order to run the app in a container._*

Run the install script:

```bash
sh ./scripts/docker.sh
```

This script will install the latest changes to the `testerloop-frontend` submodule and `@testerloop/server` package, build the app and run it in a container.

_A limitation of this is that the `@testerloop/server` package won't be updated with all changes made to the `testerloop-server` repo until a new version of the package is published._

You should now have the Testerloop app running locally on your machine at `http://localhost:8080`.

## Step 6: Rebuilding the App

If changes are made to the frontend submodule or the backend package, you can run the docker script again to remove the old container and rebuild the app.

```bash
sh ./scripts/docker.sh
```

# Running Without Docker

Follow the above steps 1-4 and then continue with the following steps.

## Step 5: Initialize Frontend Submodule

Initialize and update Git submodule:

```bash
git submodule update --init --recursive
```

## Step 6: Install Dependencies

Run the install script:

```bash
sh ./scripts/install.sh
```
## Step 7: Run the Server in Development Mode

Finally, start the server:

```bash
npm run dev
```

You should now have the Testerloop app running locally on your machine.


## Releases

Releases are handled via github workflows which publish a new release. Only the testerloop-server is an npm package that requires a new release. 

[Github version workflow](https://github.com/testerloop/testerloop-server/blob/master/.github/workflows/increment-version.yml)
[Github release workflow](https://github.com/testerloop/testerloop-server/blob/master/.github/workflows/release-package.yml)

These workflows are currently kicked-off manually.