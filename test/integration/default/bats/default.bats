@test "ecflow is listening on port 3141" {
    run nc -w2 -z localhost 3141
    [ $status -eq 0 ]
}

@test "ecflow log server is listening on port 9316" {
    run nc -w2 -z localhost 9316
    [ $status -eq 0 ]
}

@test "ENV ECF_HOME EXISTS" {
    out=$(echo $ECF_HOME)
    [$out -ne ""]
}

@test "ENV ECF_WORKSPACE exists" {
    out=$(echo $ECF_WORKSPACE)
    [$out -ne ""]
}

@test "ENV ECF_BASE exists" {
    out=$(echo $ECF_BASE)
    [$out -ne ""]
}

@test "ENV ECF_DAEMON_USER exists" {
    out=$(echo $ECF_DAEMON_USER)    
    [$out -ne ""]
}

@test "ENV ECF_ENVIRONMENT exists" {
    out=$(echo $ECF_ENVIRONMENT)    
    [$out -ne ""]
}

@test "backup script installed" {
    run test -f /usr/local/bin/backup_log_and_checkpoint.sh
    [ $status -eq 0 ]
}
