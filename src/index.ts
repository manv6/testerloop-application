import * as url from 'url';
import * as path from 'path';
import express from 'express';
import cors, { CorsRequest } from 'cors';
import parser from 'body-parser';
import { expressMiddleware } from '@apollo/server/express4';
import { createContext } from 'otf-server/context.js';
import server from 'otf-server/server.js';
import config from './config.js';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const FRONTEND_PATH = path.join(__dirname, '../overloop-testing-framework-frontend/build');

const app = express();
await server.start();
app.use('/api*', cors<CorsRequest>(), parser.json(), expressMiddleware(server, { context: createContext }));
app.use(express.static(FRONTEND_PATH));
app.listen(config.PORT, function() {
    console.log('Server listening on port: ', config.PORT);
});
