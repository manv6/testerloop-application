FROM node:18-alpine AS base

ARG ENABLE_DB=false
ENV ENABLE_DB=$ENABLE_DB

ARG REACT_APP_TESTERLOOP_API_KEY=false
ENV REACT_APP_TESTERLOOP_API_KEY=$REACT_APP_TESTERLOOP_API_KEY
ARG REACT_APP_GRAPHQL_API_URL=false
ENV REACT_APP_GRAPHQL_API_URL=$REACT_APP_GRAPHQL_API_URL

ARG REACT_APP_COGNITO_REGION=''
ENV REACT_APP_COGNITO_REGION=$REACT_APP_COGNITO_REGION

ARG REACT_APP_PROJECT_REGION=''
ENV REACT_APP_PROJECT_REGION=$REACT_APP_PROJECT_REGION

ARG REACT_APP_OAUTH_DOMAIN=''
ENV REACT_APP_OAUTH_DOMAIN=$REACT_APP_OAUTH_DOMAIN

ARG REACT_APP_USER_POOL_ID=''
ENV REACT_APP_USER_POOL_ID=$REACT_APP_USER_POOL_ID

ARG REACT_APP_POOL_WEB_CLIENT_ID=''
ENV REACT_APP_POOL_WEB_CLIENT_ID=$REACT_APP_POOL_WEB_CLIENT_ID

ARG REACT_APP_IDENTITY_POOL_ID=''
ENV REACT_APP_IDENTITY_POOL_ID=$REACT_APP_IDENTITY_POOL_ID

ARG REACT_APP_GOOGLE_CLIENT_ID=''
ENV REACT_APP_GOOGLE_CLIENT_ID=$REACT_APP_GOOGLE_CLIENT_ID

ARG REACT_APP_REDIRECT_SIGN_IN=''
ENV REACT_APP_REDIRECT_SIGN_IN=$REACT_APP_REDIRECT_SIGN_IN

ARG REACT_APP_REDIRECT_SIGN_OUT=''
ENV REACT_APP_REDIRECT_SIGN_OUT=$REACT_APP_REDIRECT_SIGN_OUT


WORKDIR /var/task

FROM base AS frontend
COPY testerloop-frontend/package.json testerloop-frontend/package.json
COPY testerloop-frontend/package-lock.json testerloop-frontend/package-lock.json
RUN cd testerloop-frontend && npm ci
COPY testerloop-frontend/ testerloop-frontend/
RUN cd testerloop-frontend && npm run build

FROM base AS server

COPY package.json package-lock.json tsconfig.json ./

RUN --mount=type=secret,id=npmrc,target=.npmrc npm ci

COPY src/ src/

RUN \
if [ "${ENABLE_DB}" != "true" ]; then \
npm remove prisma && rm -rf ./prisma ; \
else \
cp -r node_modules/testerloop-server/prisma ./prisma && npx prisma generate ; \
fi

RUN npm run build

COPY --from=frontend /var/task/testerloop-frontend/build/ testerloop-frontend/build/
COPY --from=frontend /var/task/testerloop-frontend/src/gql/__generated__/persistedQueries.json testerloop-frontend/src/gql/__generated__/

EXPOSE 8080

CMD if [ "${ENABLE_DB}" = "true" ]; then \
   npx prisma migrate deploy && node dist/serve.js ; \
else \
   node dist/serve.js ; \
fi

