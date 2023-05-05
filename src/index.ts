import * as url from 'url';
import * as path from 'path';
import express, { Express } from 'express';
import cors, { CorsRequest } from 'cors';
import parser from 'body-parser';
import { expressMiddleware } from '@apollo/server/express4';
import { createContext } from 'otf-server/context.js';
import server from 'otf-server/server.js';
import config from './config.js';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const FRONTEND_PATH = path.join(__dirname, '../overloop-testing-framework-frontend/build');

export async function useBackendMiddleware(app: Express, path = '/api/*') {
    await server.start();
    app.use(path, cors<CorsRequest>(), parser.json(), expressMiddleware(server, { context: createContext }));
}

export async function useFrontendMiddleware(app: Express) {
    app.use(express.static(FRONTEND_PATH));
    app.get('*', (_, res) => res.sendFile(path.resolve(FRONTEND_PATH, 'index.html')));
}

export async function createServer() {
    const app = express();
    return app;
}

export async function createDefaultServer() {
    const app = express();
    await useBackendMiddleware(app);
    await useFrontendMiddleware(app);
    return app;
}

export async function startServer(app: Express, port = config.PORT) {
    app.listen(port, function() {
        console.log('[testerloop] Server listening on port: ', port);
    });
}
