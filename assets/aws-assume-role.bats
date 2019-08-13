#!/usr/bin/env bats

@test "assumes a role; returns a success return code" {
    run aws-assume-role --account sandbox --role administrator
    [ "$status" -eq 0 ]
}

@test "assumes a role; creates a profile with the same name as the account" {
    local account=sandbox
    aws-assume-role --account $account --role administrator
    run aws configure list --profile $account
    [ "$status" -eq 0 ]
}

@test "assumes a role; returns valid json" {
    aws-assume-role --account sandbox --role administrator | sed -n -e '/^Profile: /,$p' | sed '1d' | jq .
    [ "$?" -eq 0 ]
}

@test "uses the role when only one is available" {
    run aws-assume-role --account sandbox
    [ "$status" -eq 0 ]
}

@test "allows unknown roles to be passed in and errors when they are denied access" {
    run aws-assume-role --account sandbox --role $(uuidgen)
    [ "$status" -eq 255 ]
}

@test "errors if account is unknown" {
    run aws-assume-role --account $(uuidgen)
    [ "$status" -eq 1 ]
}

@test "prompts for an account; assumes role using the input" {
    run expect -c '
        spawn aws-assume-role --role administrator
        expect "#?"
        send "3\r"
        interact
        catch wait result
        exit [lindex $result 3]
    '
    [ "$status" -eq 0 ]
}

@test "prompts for an account; errors on invalid input" {
    run expect -c '
        spawn aws-assume-role --role administrator <<< "{}"
        expect "#?"
        send "foo\r"
        interact
        catch wait result
        exit [lindex $result 3]
    '
    [ "$status" -eq 1 ]
}