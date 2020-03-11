#!/usr/bin/env bash

function k8_cluster_name() {
    kubectl config view -o json | jq -r ".contexts[] | select(.name == \"$(kubectl config current-context)\") | .context.cluster"
}

function k8_cluster_domain() {
    k8_cluster_name | sed -e 's/^[a-zA-Z0-9\-_]*\.//'
}
