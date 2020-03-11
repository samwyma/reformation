#!/usr/bin/env bats

file="assets/aliases/kubectl.sh"

@test "k8-cluster-domain returns the domain of the cluster" {
    source $file

    k8_cluster_name() {
        echo "k8.foo.bar.com"
    }
    export -f k8_cluster_name

    run k8_cluster_domain
    [[ "$output" == "foo.bar.com" ]]
}

@test "k8-cluster-domain drops the first subdomain of the domain" {
    source $file
    subdomain=$(uuidgen)

    k8_cluster_name() {
        echo "$subdomain.foo.com"
    }
    export -f k8_cluster_name

    run k8_cluster_domain
    [[ "$output" != "subdomain.*" ]]
}
