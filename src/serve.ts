import { exec } from 'child_process'

exec("sh ./scripts/setFrontendEnvs.sh", (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
});

import * as tl from './index.js';

const app = await tl.createDefaultServer();
await tl.startServer(app);
