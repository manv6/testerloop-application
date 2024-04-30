process.env.REACT_APP_AWS_REGION = process.env.AWS_REGION
process.env.REACT_APP_AWS_BUCKET_NAME = process.env.AWS_BUCKET_NAME
process.env.REACT_APP_AWS_ACCESS_KEY_ID = process.env.AWS_ACCESS_KEY_ID
process.env.REACT_APP_AWS_SECRET_ACCESS_KEY = process.env.AWS_SECRET_ACCESS_KEY
process.env.REACT_APP_AWS_SESSION_TOKEN = process.env.AWS_SESSION_TOKEN

console.log(process.env)

import * as tl from './index.js';

const app = await tl.createDefaultServer();
await tl.startServer(app);
