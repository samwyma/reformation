#!/usr/bin/env bats

aliases=assets/aliases

@test "k8-cluster-domain returns the domain of the cluster" {
    k8_cluster_name() {
        echo "k8.foo.bar.com"
    }
    export -f k8_cluster_name

    run $aliases/k8_cluster_domain
    echo $output
    [[ "$output" == "foo.bar.com" ]]
}

@test "k8-cluster-domain drops the first subdomain of the domain" {
    subdomain=$(uuidgen)

    k8_cluster_name() {
        echo "$subdomain.foo.com"
    }
    export -f k8_cluster_name

    run $aliases/k8_cluster_domain
    [[ "$output" != "subdomain.*" ]]
}
