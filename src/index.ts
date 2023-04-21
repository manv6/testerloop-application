import * as url from 'url';
import * as path from 'path';
import serverless from 'serverless-http';
import express from 'express';
import type { APIGatewayProxyHandler, APIGatewayProxyResult } from 'aws-lambda';
import { graphqlHandler } from 'otf-server';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const FRONTEND_PATH = path.join(__dirname, '../overloop-testing-framework-frontend/build');

const app = express();
app.use(express.static(FRONTEND_PATH));
const staticHandler = serverless(app, { provider: 'aws' });

export const handler: APIGatewayProxyHandler = async function(event, ctx, cb) {
    const result = event.path.startsWith('/api') 
        ? graphqlHandler(event, ctx, cb)
        : staticHandler(event, ctx);
    return result as unknown as APIGatewayProxyResult;
};
