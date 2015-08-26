@test "ecflow is listening on port 3141" {
    run nc -w2 -z localhost 3141
    [ $status -eq 0 ]
}

@test "ecflow log server is listening on port 9316" {
    run nc -w2 -z localhost 9316
    [ $status -eq 0 ]
}