#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

export JQ_STUB_DEBUG=3

function setup() {
    stub jq \
        "-r .Credentials.AccessKeyId : echo ASIAExampleUsageAttempt1" \
        "-r .Credentials.AccessKeyId : echo ASIAExampleUsageAttempt2" \
        "-r .Credentials.AccessKeyId : exit 1"
}

function teardown() {
    unstub jq
}

@test "Multiple Invocations of Same Command and Same Arguments" {
    run bash -c "jq -r .Credentials.AccessKeyId"
    assert_success
    assert_output "ASIAExampleUsageAttempt1"

    run bash -c "jq -r .Credentials.AccessKeyId"
    assert_success
    assert_output "ASIAExampleUsageAttempt2"

    run bash -c "jq -r .Credentials.AccessKeyId"
    assert_failure
}