import * as url from 'url';
import * as path from 'path';
import { readFile } from 'fs/promises';
import express, { Express } from 'express';
import parser from 'body-parser';
import compression from 'compression';
import { z } from 'zod';
import { expressMiddleware } from '@apollo/server/express4';
import { createContext } from '@testerloop/server/dist/context.js';
import server from '@testerloop/server/dist/server.js';
import config from './config.js';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const FRONTEND_PATH = path.join(__dirname, '../testerloop-frontend/build');
const APQ_PATH = path.join(__dirname, '../testerloop-frontend/src/gql/__generated__/persistedQueries.json');

export async function useBackendMiddleware(app: Express, path = '/api*') {
    await server.start();
    app.use(path, parser.json(), expressMiddleware(server as any, { context: createContext }));
}

export async function useFrontendMiddleware(app: Express) {
    app.use(express.static(FRONTEND_PATH));
    app.get('*', (_, res) => res.sendFile(path.resolve(FRONTEND_PATH, 'index.html')));
}

export async function createServer() {
    const app = express();
    return app;
}

const APQFileSchema = z.object({}).catchall(z.string());

export async function configureDefaultAPQ(apqPath: string) {
    const rawData = await readFile(apqPath, 'utf-8');
    const parsed = APQFileSchema.parse(JSON.parse(rawData));

    for (const [hash, document] of Object.entries(parsed)) {
        server.cache.set(`apq:${hash}`, document);
    }
}

export async function createDefaultServer() {
    const app = express();
    app.use(compression({
        filter: () => true,
    }));
    configureDefaultAPQ(APQ_PATH);
    await useBackendMiddleware(app);
    await useFrontendMiddleware(app);
    return app;
}

export async function startServer(app: Express, port = config.PORT) {
    app.listen(port, function () {
        console.log('[testerloop] Server listening on port: ', port);
    });
}
