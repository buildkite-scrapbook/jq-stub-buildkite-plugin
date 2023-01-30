# jq-stub-buildkite-plugin

```
docker compose run --rm tests
```

```
bats tests/ | tee output.txt
```

```
bats tests/ >> output.txt
```

```
docker compose run --rm tests bats tests/multiple-invocations.bats >> multiple-invocations.txt
```


## Result of investigation

Each Stub plan line can only be used for 1 invocation.

E.g. jq stub
```
stub jq \
    "-r .Credentials.AccessKeyId : echo ASIAExampleUsageAttempt1" \
    "-r .Credentials.AccessKeyId : echo ASIAExampleUsageAttempt2"
```

usage of jq stub
```
run bash -c "jq -r .Credentials.AccessKeyId" #Expected output: ASIAExampleUsageAttempt1
run bash -c "jq -r .Credentials.AccessKeyId" #Expected output: ASIAExampleUsageAttempt2
```

Although the same jq command and arguments are run, it will be based on the order of the stub declaration and can only be invoked once!

So in order to use the same command multiple times, you would need to have the same stub arguments declared for each invocation/usage.

 

It kind of defeats the purpose of a mock, in my honest opinion, but we can now have clarity around the use of the bats-mock stub and why it is "flaky" (sometimes fails and sometimes doesn't), since it depends on the number of invocations/usage of the same command with the same arguments.

## Reference
- https://github.com/buildkite-plugins/bats-mock/blob/master/tests/binstub.bats#L39
```
@test "Invoke a stub more than expected" {
  stub mycommand "llamas : echo running llamas"

  run bash -c "mycommand llamas"
  [ "$status" -eq 0 ]
  [ "$output" == "running llamas" ]

  # More executions -> return failure
  run bash -c "mycommand llamas"
  [ "$status" -eq 1 ]
  [ "$output" == "" ]

  # and they also make unstubbing fail to fail the whole command
  run unstub mycommand
  [ "$status" -eq 1 ]
  [[ "$output" == "" ]]
}
```