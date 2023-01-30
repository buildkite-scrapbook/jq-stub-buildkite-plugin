#!/usr/bin/env bats

load "/usr/local/lib/bats/load.bash"

export JQ_STUB_DEBUG=3

function jq_tester {
    jq --arg search_string_uppercase "BATS TEST" '.Accounts[] | select(.Name|ascii_upcase == $search_string_uppercase).Id'
}

function jq_r_dot_tester {
    jq -r '.'
}

function jq_piped_tester {
    jq -r .Credentials.AccessKeyId | jq -r '.'
}

function echo_piped_jq_tester {
    full_name=$(jq -r .Credentials.AccessKeyId)
    short_name=$(echo "${full_name}" | jq -r '.')
    echo "$short_name"
}

@test "jq args" {

    _JQ_ARGS="--arg search_string_uppercase \"BATS TEST\" '.Accounts[] | select(.Name|ascii_upcase == \$search_string_uppercase).Id'"

    stub jq \
        "${_JQ_ARGS} : echo $_JQ_ARGS"

    run jq_tester
    assert_success
    unstub jq
}

@test "jq raw output dot" {
    _JQ_ARGS="-r '.'"

    stub jq \
        "${_JQ_ARGS} : echo 123456789012"
    
    run jq_r_dot_tester
    assert_success
    unstub jq
}

@test "jq piped" {
    stub jq \
        "-r '.' : echo 123456789012" \
        "-r .Credentials.AccessKeyId : echo ASIAPEXAMPLEXE1234567"

    run jq_piped_tester
    assert_success
    unstub jq
}

@test "echo piped jq" {
    stub jq \
        "-r '.' : echo bob" \
        "-r .Credentials.AccessKeyId : echo bobthebuilder"

    run echo_piped_jq_tester
    assert_success
    assert_output "bob"
    unstub jq
}