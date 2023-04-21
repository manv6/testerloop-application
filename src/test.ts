import { APIGatewayProxyEvent, Context } from "aws-lambda";
import { handler } from "./index.js";

export const event = (path: string, httpMethod: string): APIGatewayProxyEvent => ({
    body: JSON.stringify({
        query: "{ test }",
    }),
    headers: { 'content-type': 'application/json' },
    multiValueHeaders: {},
    httpMethod,
    isBase64Encoded: false,
    path,
    pathParameters: null,
    queryStringParameters: null,
    multiValueQueryStringParameters: null,
    stageVariables: null,
    resource: '',
    requestContext: {
        accountId: 'accountId',
        apiId: 'apiId',
        // This one is a bit confusing: it is not actually present in authorizer calls
        // and proxy calls without an authorizer. We model this by allowing undefined in the type,
        // since it ends up the same and avoids breaking users that are testing the property.
        // This lets us allow parameterizing the authorizer for proxy events that know what authorizer
        // context values they have.
        authorizer: null,
        protocol: 'protocol',
        httpMethod,
        identity: {
            accessKey: null,
            accountId: null,
            apiKey: null,
            apiKeyId: null,
            caller: null,
            clientCert: null,
            cognitoAuthenticationProvider: null,
            cognitoAuthenticationType: null,
            cognitoIdentityId: null,
            cognitoIdentityPoolId: null,
            principalOrgId: null,
            sourceIp: 'sourceIp',
            user: null,
            userAgent: null,
            userArn: null,
        },
        path,
        stage: 'stage',
        requestId: 'requestId',
        requestTimeEpoch: 1234,
        resourceId: 'resourceId',
        resourcePath: 'resourcePath',
    },
});

export const context = (): Context => ({
    callbackWaitsForEmptyEventLoop: false,
    functionName: '',
    functionVersion: '',
    invokedFunctionArn: '',
    memoryLimitInMB: '',
    awsRequestId: '',
    logGroupName: '',
    logStreamName: '',
    getRemainingTimeInMillis: function (): number {
        throw new Error('Function not implemented.');
    },
    done: function (error?: Error | undefined, result?: any): void {
        throw new Error('Function not implemented.');
    },
    fail: function (error: string | Error): void {
        throw new Error('Function not implemented.');
    },
    succeed: function (messageOrObject: any): void {
        throw new Error('Function not implemented.');
    }
});

(async function() {
    const cb = () => {};
    
    console.log(await handler(
        event('/index.html', 'GET'),
        context(), 
        cb
    ));

    console.log(await handler(
        event('/api/grahpql', 'POST'), 
        context(), 
        cb
    ));
})();
