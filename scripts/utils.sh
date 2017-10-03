#!/bin/bash

# Source this file to be able to call its functions
# E.g.:
# $ source ./utils.sh && running_in_docker && echo $RUNNING_IN_DOCKER
# Should lead to 0 or 1 being printed.

# Determines if the script is being executed in a Docker container, result accessible via $RUNNING_IN_DOCKER (1=yes, 0=no)
# https://stackoverflow.com/a/23575107
function running_in_docker() {
    RUNNING_IN_DOCKER=1
    (awk -F/ '$2 == "docker"' /proc/self/cgroup | read non_empty_input) || RUNNING_IN_DOCKER=0
}
