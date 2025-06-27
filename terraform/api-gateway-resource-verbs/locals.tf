locals {
  authorizer_appender = {
    "application/json" = <<EOF
#set($inputRoot = $input.json('$'))

{
    "resource": "$context.resourcePath",
    "path": "$context.path",
    "httpMethod": "$context.httpMethod",
    "headers": {
        "Accept": "$input.params().header.get('Accept')",
        "Authorization": "$input.params().header.get('Authorization')",
        "CloudFront-Forwarded-Proto": "$input.params().header.get('CloudFront-Forwarded-Proto')",
        "CloudFront-Is-Desktop-Viewer": "$input.params().header.get('CloudFront-Is-Desktop-Viewer')",
        "CloudFront-Is-Mobile-Viewer": "$input.params().header.get('CloudFront-Is-Mobile-Viewer')",
        "CloudFront-Is-SmartTV-Viewer": "$input.params().header.get('CloudFront-Is-SmartTV-Viewer')",
        "CloudFront-Is-Tablet-Viewer": "$input.params().header.get('CloudFront-Is-Tablet-Viewer')",
        "CloudFront-Viewer-ASN": "$input.params().header.get('CloudFront-Viewer-ASN')",
        "CloudFront-Viewer-Country": "$input.params().header.get('CloudFront-Viewer-Country')",
        "Host": "$input.params().header.get('Host')",
        "User-Agent": "$input.params().header.get('User-Agent')",
        "Via": "$input.params().header.get('Via')",
        "X-Amz-Cf-Id": "$input.params().header.get('X-Amz-Cf-Id')",
        "X-Amzn-Trace-Id": "$input.params().header.get('X-Amzn-Trace-Id')",
        "X-Forwarded-For": "$input.params().header.get('X-Forwarded-For')",
        "X-Forwarded-Port": "$input.params().header.get('X-Forwarded-Port')",
        "X-Forwarded-Proto": "$input.params().header.get('X-Forwarded-Proto')",
        "content-type": "$input.params().header.get('content-type')",
        "x-api-key": "$input.params().header.get('x-api-key')",

        ## Adiciona os valores do authorizer
        #if($context.authorizer)
        "X-user-pool": "$context.authorizer.X-user-pool",
        "X-authenticated-user": "$context.authorizer.X-authenticated-user",
        "X-expires": "$context.authorizer.X-expires",
        "X-hash-authorities": "$context.authorizer.X-hash-authorities"
        #end
    },
    "queryStringParameters": $input.params().querystring,
    "pathParameters": $input.params().path,
    "stageVariables": $stageVariables,
    "requestContext": {
        "accountId": "$context.accountId",
        "resourceId": "$context.resourceId",
        "stage": "$context.stage",
        "domainName": "$context.domainName",
        "domainPrefix": "$context.domainPrefix",
        "requestId": "$context.requestId",
        "extendedRequestId": "$context.extendedRequestId",
        "protocol": "$context.protocol",
        "identity": {
            "apiKey": "$context.identity.apiKey",
            "apiKeyId": "$context.identity.apiKeyId",
            "sourceIp": "$context.identity.sourceIp",
            "userAgent": "$context.identity.userAgent"
        },
        "resourcePath": "$context.resourcePath",
        "path": "$context.path",
        "authorizer": {
            "X-user-pool": "$context.authorizer.X-user-pool",
            "X-authenticated-user": "$context.authorizer.X-authenticated-user",
            "X-expires": "$context.authorizer.X-expires",
            "X-hash-authorities": "$context.authorizer.X-hash-authorities"
        },
        "httpMethod": "$context.httpMethod",
        "requestTime": "$context.requestTime",
        "requestTimeEpoch": $context.requestTimeEpoch,
        "apiId": "$context.apiId"
    },
    ## Se body não estiver vazio, mantém. Se estiver vazio, define como string vazia.
    "body": #if($input.body != "") "$input.body" #else "" #end,
    "isBase64Encoded": false
}
EOF
  }
}