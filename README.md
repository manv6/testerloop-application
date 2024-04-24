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

Releases and deployments are handled by Github Actions. The `testerloop-server` repo is published as an NPM package and the `testerloop-frontend` repo is a submodule within `testerloop-app`. The `testerloop-app` itself is published as an NPM package and is deployed to our staging site in ECS as a Docker Image.

### To release a new version of the app for the purposes of a SONY bugfix release, follow these steps

1. Increment the `testerloop-app` version number in the `package.json` file of the testerloop-app repo
2. [If making BACKEND changes] Update the version number in the `package.json` file of the `testerloop-server` repo
3. [If making BACKEND changes] Increment the `testerloop-server` Github version number to match the version above and trigger this [Github release workflow](https://github.com/testerloop/testerloop-server/blob/master/.github/workflows/release-package.yml)
4. [If making BACKEND changes] Update the `testerloop-server` package version in the `testerloop-app` `package.json` file to match the new version number
5. [If making FRONTEND changes]Update the frontend submodule to point to the required commit (if making frontend changes)

    ```bash
    cd testerloop-frontend
    git checkout <commit-hash>
    cd ..
    ```

6. Run an `npm install` in the testerloop-app repo to ensure correct package versions are installed and the `package-lock.json` file is updated
7. Run the docker script to build the app and run it in a local container for testing

    ```bash
    sh ./scripts/docker.sh
    ```

8. Once testing is complete, push the changes to the `testerloop-app` repo
9. There are two workflows for creating a new NPM package:
        - [Triggered with Github Release](https://github.com/testerloop/testerloop-app/actions/workflows/release-package.yml)
        - [Triggered manually](https://github.com/testerloop/testerloop-app/actions/workflows/sony-release-package.yml)
10. For creating a new release for Sony, add a new release through the Github UI [here](https://github.com/testerloop/testerloop-app/releases/new)
11. Create a new tag for the release number
12. Set it as not the latest release (latest stable release for Sony remains `0.1.24`

### To deploy multitenant changes to the app to staging for our own testing, follow these steps

1. Checkout the `multitenant` branch
2. Follow steps 2-8 above
3. Push changes to the `multitenant` branch which will trigger this workflow: [MULTITENANT - Deploy to ECS including DB migrations](https://github.com/testerloop/testerloop-app/actions/workflows/deploy.yml)
