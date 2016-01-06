@test "ecflow is listening on port 3141" {
    run nc -w2 -z localhost 3141
    [ $status -eq 0 ]
}

@test "ecflow log server is listening on port 9316" {
    run nc -w2 -z localhost 9316
    [ $status -eq 0 ]
}

@test "ENV ECF_SERVER DIR exists" {
    run grep "ECF_SERVER_DIR=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ENV ECF_HOME exists" {
    run grep "ECF_HOME=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ENV ECF_WORKSPACE exists" {
    run grep "ECF_WORKSPACE=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ENV ECF_BASE exists" {
    run grep "ECF_BASE=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ENV ECF_DAEMON_USER exists" {
    run grep "ECF_DAEMON_USER=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ENV ECF_ENVIRONMENT exists" {
    run grep "ECF_ENVIRONMENT=[^\n]\+" /etc/profile.d/ecflow-env.sh
    [ $status -eq 0 ]
}

@test "ecflow is listening on port 3141" {
    run nc -w2 -z localhost 3141
    [ $status -eq 0 ]
}

@test "ecflow log server is listening on port 9316" {
    run nc -w2 -z localhost 9316
    [ $status -eq 0 ]
}

@test "copy checkpoint file in crontab" {
    run  bash -c 'crontab -u ecflow -l  | grep "# Chef Name: copy checkpoint file"'
    [ $status -eq 0 ]
}

@test "copy previous checkpoint file in crontab" {
    run  bash -c 'crontab -u ecflow -l  | grep "# Chef Name: copy previous checkpoint file"'
    [ $status -eq 0 ]
}
