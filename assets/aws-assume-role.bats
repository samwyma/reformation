#!/usr/bin/env bats

_account=sandbox
export AWS_DEFAULT_PROFILE="$_account"

config="{
    \"$_account\": {
        \"mfa\": false,
        \"id\": $(aws account-id),
        \"roles\": [
            "administrator"
        ],
        \"session_duration\": {
            \"minutes\": 720
        }
    }
}"

@test "assumes a role; returns a success return code" {
    run aws-assume-role --account $_account --role administrator <<< $config
    [ "$status" -eq 0 ]
}

@test "assumes a role; creates a profile with the same name as the account" {
    aws-assume-role --account $_account --role administrator
    run aws configure list --profile $_account <<< $config
    [ "$status" -eq 0 ]
}

@test "assumes a role; returns valid json" {
    aws-assume-role --account $_account --role administrator <<< $config | sed -n -e '/^Profile: /,$p' | sed '1d' | jq .
    [ "$?" -eq 0 ]
}

@test "assumes a role; returns the profile in the json" {
    local profile=$(aws-assume-role --account $_account --role administrator <<< $config | sed -n -e '/^Profile: /,$p' | sed '1d' | jq -r .Profile)
    [ "$profile" == "$_account" ]
}

@test "uses the role when only one is available" {
    run aws-assume-role --account $_account <<< $config
    [ "$status" -eq 0 ]
}

@test "allows unknown roles to be passed in and errors when they are denied access" {
    run aws-assume-role --account $_account --role $(uuidgen) <<< $config
    [ "$status" -eq 255 ]
}

@test "errors if account is unknown" {
    run aws-assume-role --account $(uuidgen) <<< $config
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