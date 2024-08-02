import { z } from 'zod';
// @ts-ignore
import { envFormat as serverEnvFormat } from 'testerloop-server/dist/config.js';

const envFormat = serverEnvFormat.extend({
    PORT: z.coerce.number()
});

const config = envFormat.parse(process.env);
export default config;
