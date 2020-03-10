#!/usr/bin/env bats

_account=sandbox
export AWS_DEFAULT_PROFILE="$_account"

@test "errors if the config is empty" {
    run ./assets/aws-assume-role --account $_account --role administrator <<< ""
    [ "$status" -eq 2 ] 
}

@test "errors if the config is not valid json" {
    run ./assets/aws-assume-role --account $_account --role administrator <<< "{'"
    [ "$status" -eq 3 ] 
}

@test "assumes a role; returns a success return code" {
    run ./assets/aws-assume-role --account $_account --role administrator
    [ "$status" -eq 0 ]
}

@test "assumes a role; creates a profile with the same name as the account" {
    ./assets/aws-assume-role --account $_account --role administrator
    run aws configure list --profile $_account
    [ "$status" -eq 0 ]
}

@test "assumes a role; returns valid json" {
    ./assets/aws-assume-role --account $_account --role administrator | sed -n -e '/^Profile: /,$p' | sed '1d' | jq .
    [ "$?" -eq 0 ]
}

@test "assumes a role; returns the profile in the json" {
    local profile=$(./assets/aws-assume-role --account $_account --role administrator | sed -n -e '/^Profile: /,$p' | sed '1d' | jq -r .Profile)
    [ "$profile" == "$_account" ]
}

@test "uses the role when only one is available" {
    run ./assets/aws-assume-role --account $_account
    [ "$status" -eq 0 ]
}

@test "allows unknown roles to be passed in and errors when they are denied access" {
    run ./assets/aws-assume-role --account $_account --role $(uuidgen)
    [ "$status" -gt 0 ]
}

@test "errors if account is unknown" {
    run ./assets/aws-assume-role --account $(uuidgen)
    [ "$status" -eq 1 ]
}
