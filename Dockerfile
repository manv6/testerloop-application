FROM node:18-alpine AS base
WORKDIR /var/task

COPY package.json package-lock.json tsconfig.json ./
COPY testerloop-frontend/ testerloop-frontend/
COPY scripts/ scripts/
COPY src/ src/
RUN --mount=type=secret,id=npmrc,target=.npmrc npm run init && npm run build

EXPOSE 8080
CMD node dist/serve.js
