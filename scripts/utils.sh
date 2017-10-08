#!/bin/bash

# Source this file to be able to call its functions
# E.g.:
# $ source ./utils.sh && running_in_docker && echo $RUNNING_IN_DOCKER
# Should lead to 0 or 1 being printed.

# Reads comma seperated values from a given XML value in a given file and stores them as array in the global variable $XML_VALUES
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the XML file.
function read_csv_from_xml_val() {
    PATHTOCSPROJ=$1
    XML_VALUE_NAME=$2

    # Example line: <RuntimeIdentifiers>win-x64;linux-x64</RuntimeIdentifiers>
    XML_VALUE_LINE=$(grep "<${XML_VALUE_NAME}>.*</${XML_VALUE_NAME}>" $PATHTOCSPROJ)
    XML_VALUE_LINE=$(echo $XML_VALUE_LINE | sed "s/\ *//" | sed "s/<${XML_VALUE_NAME}>//" | sed "s/<\/${XML_VALUE_NAME}>//")
    XML_VALUE_LINE=${XML_VALUE_LINE//;/ }
    XML_VALUES=($XML_VALUE_LINE)
    # Bash functions can't return arbitrary values - only exit codes. Use the global variable $XML_VALUES instead.
}

# Determines if the script is being executed in a Docker container, result accessible via $RUNNING_IN_DOCKER (1=yes, 0=no)
# https://stackoverflow.com/a/23575107
function running_in_docker() {
    RUNNING_IN_DOCKER=1
    (awk -F/ '$2 == "docker"' /proc/self/cgroup | read non_empty_input) || RUNNING_IN_DOCKER=0
}
