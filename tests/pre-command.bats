#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# export JQ_STUB_DEBUG=3


# aws sts assume-role --role-arn arn:aws:iam::123456789012:role/xaccounts3access --role-session-name s3-access-example

# {
#     "AssumedRoleUser": {
#         "AssumedRoleId": "AROA3XFRBF535PLBIFPI4:s3-access-example",
#         "Arn": "arn:aws:sts::123456789012:assumed-role/xaccounts3access/s3-access-example"
#     },
#     "Credentials": {
#         "SecretAccessKey": "9drTJvcXLB89EXAMPLELB8923FB892xMFI",
#         "SessionToken": "AQoXdzELDDY//////////wEaoAK1wvxJY12r2IrDFT2IvAzTCn3zHoZ7YNtpiQLF0MqZye/qwjzP2iEXAMPLEbw/m3hsj8VBTkPORGvr9jM5sgP+w9IZWZnU+LWhmg+a5fDi2oTGUYcdg9uexQ4mtCHIHfi4citgqZTgco40Yqr4lIlo4V2b2Dyauk0eYFNebHtYlFVgAUj+7Indz3LU0aTWk1WKIjHmmMCIoTkyYp/k7kUG7moeEYKSitwQIi6Gjn+nyzM+PtoA3685ixzv0R7i5rjQi0YE0lf1oeie3bDiNHncmzosRM6SFiPzSvp6h/32xQuZsjcypmwsPSDtTPYcs0+YN/8BRi2/IcrxSpnWEXAMPLEXSDFTAQAM6Dl9zR0tXoybnlrZIwMLlMi1Kcgo5OytwU=",
#         "Expiration": "2016-03-15T00:05:07Z",
#         "AccessKeyId": "ASIAJEXAMPLEXEG2JICEA"
#     }
# }

# aws organizations list-accounts

# {
#         "Accounts": [
#                 {
#                         "Arn": "arn:aws:organizations::111111111111:account/o-exampleorgid/111111111111",
#                         "JoinedMethod": "INVITED",
#                         "JoinedTimestamp": 1481830215.45,
#                         "Id": "111111111111",
#                         "Name": "Master Account",
#                         "Email": "bill@example.com",
#                         "Status": "ACTIVE"
#                 },
#                 {
#                         "Arn": "arn:aws:organizations::111111111111:account/o-exampleorgid/222222222222",
#                         "JoinedMethod": "INVITED",
#                         "JoinedTimestamp": 1481835741.044,
#                         "Id": "222222222222",
#                         "Name": "Production Account",
#                         "Email": "alice@example.com",
#                         "Status": "ACTIVE"
#                 },
#                 {
#                         "Arn": "arn:aws:organizations::111111111111:account/o-exampleorgid/333333333333",
#                         "JoinedMethod": "INVITED",
#                         "JoinedTimestamp": 1481835795.536,
#                         "Id": "333333333333",
#                         "Name": "Development Account",
#                         "Email": "juan@example.com",
#                         "Status": "ACTIVE"
#                 },
#                 {
#                         "Arn": "arn:aws:organizations::111111111111:account/o-exampleorgid/444444444444",
#                         "JoinedMethod": "INVITED",
#                         "JoinedTimestamp": 1481835812.143,
#                         "Id": "444444444444",
#                         "Name": "Test Account",
#                         "Email": "anika@example.com",
#                         "Status": "ACTIVE"
#                 }
#         ]
# }

# export AWS_ACCESS_KEY_ID=ASIAIOSFODNN7EXAMPLE
# export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# export AWS_SESSION_TOKEN=AQoDYXdzEJr...<remainder of session token>
# aws ec2 describe-instances --region us-west-1

setup() {

    stub jq \
        "-r .Credentials.AccessKeyId : echo AKIAIOSFODNN7EXAMPLE" \
        "-r .Credentials.SecretAccessKey : echo wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
        "-r .Credentials.SessionToken : echo ABcDEFghIJkl...<rest-of-token>==" \
        "--arg level_name_uppercase \"EXAMPLE TEST\" '.Accounts[] | select(.Name|ascii_upcase == $level_name_uppercase ).Id' : echo not-parsed-123456789012" \
        "-r . : echo 123456789012"
}

teardown() {
    unstub jq
}

@test "Test jq functionality" {
    run "$PWD/hooks/pre-command"

    assert_success
    assert_output --partial "finished"
}