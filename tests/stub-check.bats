#!/usr/bin/env bats

load "/usr/local/lib/bats/load.bash"

export JQ_STUB_DEBUG=3

function jq_tester {
    jq --arg search_string_uppercase "BATS TEST" '.Accounts[] | select(.Name|ascii_upcase == $search_string_uppercase).Id'
}

@test "jq args" {

    _CURL_ARGS="--arg search_string_uppercase \"BATS TEST\" '.Accounts[] | select(.Name|ascii_upcase == \$search_string_uppercase).Id'"

    stub jq \
        "${_CURL_ARGS} : echo $_CURL_ARGS"

    run jq_tester
    assert_success
    unstub jq
}
