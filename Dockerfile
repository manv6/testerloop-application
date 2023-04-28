FROM node:18-alpine AS base
WORKDIR /var/task

COPY package.json package-lock.json tsconfig.json ./
COPY overloop-testing-framework-frontend/ overloop-testing-framework-frontend/
COPY overloop-testing-framework-server/ overloop-testing-framework-server/
COPY scripts/ scripts/
COPY src/ src/
RUN npm run init && npm run build

EXPOSE 8080
CMD node dist/index.js
