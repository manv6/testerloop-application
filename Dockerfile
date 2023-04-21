FROM public.ecr.aws/lambda/nodejs:18 AS base

WORKDIR /var/task
COPY package.json package-lock.json tsconfig.json ./
RUN npm ci

FROM base AS build
COPY src/ ./
RUN npm run build

FROM base AS runner
COPY --from=build /var/task/dist ./

CMD ["index.handler"]
