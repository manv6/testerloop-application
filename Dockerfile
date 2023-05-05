FROM node:18-alpine AS base
WORKDIR /var/task

FROM base AS frontend
COPY testerloop-frontend/package.json testerloop-frontend/package.json
COPY testerloop-frontend/package-lock.json testerloop-frontend/package-lock.json
RUN cd testerloop-frontend && npm ci
COPY testerloop-frontend/ testerloop-frontend/
RUN cd testerloop-frontend && npm run build

FROM base AS server

COPY package.json package-lock.json tsconfig.json ./
COPY scripts/ scripts/
COPY src/ src/
RUN --mount=type=secret,id=npmrc,target=.npmrc npm ci
RUN npm run build
COPY --from=frontend /var/task/testerloop-frontend/build/ testerloop-frontend/build/

EXPOSE 8080
CMD node dist/serve.js
