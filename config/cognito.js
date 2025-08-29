const { CognitoIdentityProviderClient } = require('@aws-sdk/client-cognito-identity-provider')

const client = new CognitoIdentityProviderClient({
    region: process.env.AWS_REGION
})

module.exports = client