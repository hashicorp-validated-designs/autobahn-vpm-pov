#!/bin/bash

set -eo pipefail

error() {
    log "ERR" "$1"
}

warning() {
    log "WRN" "$1"
}

debug() {
    # If the variable DEBUG is set, then the  message will be logged.
    if [ -n "${DEBUG}" ]; then
        log "DBG" "$1"
    fi
}

info() {
    log "INF" "$1"
}

log() {
    # If the variable LOG_TIMESTAMP is set, then the log message will include a timestamp.
    local LEVEL=$1
    local MESSAGE=$2
    local LOG_PREFIX
    if [ -n "${LOG_TIMESTAMP}" ]; then
        LOG_PREFIX="$(date '+%Y-%m-%d %H:%M:%S %Z') "
    fi
    LOG_PREFIX="${LOG_PREFIX}${0##*/}: "

    echo "${LOG_PREFIX}[${LEVEL}] ${MESSAGE}"
} 1>&2

readonly BASE_HCP_OPERATIONS_URL="https://api.cloud.hashicorp.com/operation/2020-05-05/organizations/"
readonly BASE_HCP_PACKER_URL="https://api.cloud.hashicorp.com/packer/2023-01-01/organizations"

get_hcp_authentication_token() {
    # get_hcp_authentication_token() - Get an HCP authentication token
    #
    # This function will call the HCP API and get a valid HCP authentication token.
    #
    # The function requires a valid HCP client id and HCP client secret and expect those
    # values to be available via the following environment variables:
    # - HCP_CLIENT_ID
    # - HCP_CLIENT_SECRET
    #
    # If any of those environment variables are missing, the function will fail.
    #
    # Outputs:
    #    The function outputs a valid HCP authentication token
    #
    # Example usage:
    #    TOKEN=$(get_hcp_authentication_token)
    #
    debug "${FUNCNAME}: Executing"
    local l_hcp_client_id
    local l_hcp_client_secret
    l_hcp_client_id=${HCP_CLIENT_ID:-"empty"}
    l_hcp_client_secret=${HCP_CLIENT_SECRET:-"empty"}

    debug "${FUNCNAME}: Checking if required environment variables have been set"
    # Fail if HCP_CLIENT_ID and HCP_CLIENT_SECRET environment variables are not present
    if [ "${l_hcp_client_id}" = "empty" ] || [ "${l_hcp_client_secret}" = "empty" ]; then
        error "Please set both environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET."
        return
    fi

    RESPONSE_BODY=$(mktemp)

    debug "${FUNCNAME}: Retrieving the HCP authentication token"
    RESPONSE=$(
        curl -s --location "https://auth.idp.hashicorp.com/oauth2/token" \
            --header "Content-Type: application/x-www-form-urlencoded" \
            --output "${RESPONSE_BODY}" \
            --write-out "%{http_code}" \
            --data-urlencode "client_id=$HCP_CLIENT_ID" \
            --data-urlencode "client_secret=$HCP_CLIENT_SECRET" \
            --data-urlencode "grant_type=client_credentials" \
            --data-urlencode "audience=https://api.hashicorp.cloud"
    )

    if [ ${RESPONSE} != "200" ]; then
        error "Failed to get HCP Token (response code: ${RESPONSE})."
        error "$(cat ${RESPONSE_BODY})"
        return
    fi

    cat ${RESPONSE_BODY} | jq -r .access_token

    debug "${FUNCNAME}: Cleaning-up"
    rm -f "${RESPONSE_BODY}"
    debug "${FUNCNAME}: Finished execution"
}

hcp_registry_not_exists() {
    # hcp_registry_exists() - Checks if an HCP Packer Registry is configured
    #
    # This function will call the HCP API and validate if an HCP Packer Registry
    # exists for a specified HCP organization and HCP project pair.
    #
    # The function requires a valid HCP organization id, HCP project id and HCP
    # authentication token, and expect those values to be available via the
    # following environment variables:
    # - HCP_TOKEN
    # - HCP_ORGANIZATION_ID
    # - HCP_PROJECT_ID
    #
    # If any of those environment variables are missing, the function will fail.
    #
    # Outputs:
    #    The function return 0 if an HCP Packer Registry already exist, and 1
    #    if it doesn't.
    #
    # Example usage:
    #    hcp_registry_exists
    #
    local l_hcp_organization_id
    local l_hcp_project_id
    l_hcp_organization_id=${HCP_ORGANIZATION_ID:-"empty"}
    l_hcp_project_id=${HCP_PROJECT_ID:-"empty"}

    debug "${FUNCNAME}: Checking if required environment variables have been set"
    # Fail if HCP_ORGANIZATION_ID and HCP_PROJECT_ID environment variables are not present
    if [ "${l_hcp_organization_id}" = "empty" ] || [ "${l_hcp_project_id}" = "empty" ]; then
        error "Please set both environment variables HCP_ORGANIZATION_ID and HCP_PROJECT_ID."
        return
    fi

    RESPONSE_BODY=$(mktemp)

    debug "${FUNCNAME}: Checking if HCP Packer registry exists"
    RESPONSE=$(
        curl -s --location "${BASE_HCP_PACKER_URL}/${l_hcp_organization_id}/projects/${l_hcp_project_id}/registry" \
            --header "Authorization: Bearer ${HCP_TOKEN}" \
            --header "Content-Type: application/json" \
            --output "${RESPONSE_BODY}" \
            --write-out "%{http_code}" \
            --request GET
    )

    debug "${FUNCNAME}: Cleaning-up"
    rm -f "${RESPONSE_BODY}"
    debug "${FUNCNAME}: Finished execution"
    if [[ ${RESPONSE} == 200 ]]; then
        debug "Found HCP Packer registry"
        return 1
    elif [[ ${RESPONSE} == 404 ]]; then
        debug "The HCP Packer registry does not exist"
        return 0
    else
        error "${FUNCNAME}: HCP Packer API returned ${RESPONSE}"
    fi
}

delete_hcp_packer_registry() {
    # create_hcp_packer_registry() - Create an HCP Packer Registry
    #
    # This function will call the HCP API and create an HCP Packer Registry
    # for a specified HCP organization and HCP project pair.
    #
    # The function requires a valid HCP organization id, HCP project id and HCP
    # authentication token, and expect those values to be available via the
    # following environment variables:
    # - HCP_TOKEN
    # - HCP_ORGANIZATION_ID
    # - HCP_PROJECT_ID
    #
    # If any of those environment variables are missing, the function will fail.
    #
    # Outputs:
    #    The function return the JSON response from the HCP Packer API.
    #
    # Example usage:
    #    create_hcp_packer_registry
    #
    debug "${FUNCNAME}: Executing"
    local l_hcp_organization_id
    local l_hcp_project_id
    l_hcp_organization_id=${HCP_ORGANIZATION_ID:-"empty"}
    l_hcp_project_id=${HCP_PROJECT_ID:-"empty"}

    debug "${FUNCNAME}: Checking if required environment variables have been set"
    # Fail if HCP_ORGANIZATION_ID and HCP_PROJECT_ID environment variables are not present
    if [ "${l_hcp_organization_id}" = "empty" ] || [ "${l_hcp_project_id}" = "empty" ]; then
        error "Please set both environment variables HCP_ORGANIZATION_ID and HCP_PROJECT_ID."
        return
    fi

    hcp_registry_not_exists && {
        warning "No Registry Found."
        return
    }

    RESPONSE_BODY=$(mktemp)

    debug "${FUNCNAME}: Deleting HCP Packer registry."
    RESPONSE=$(
        curl -s --location "${BASE_HCP_PACKER_URL}/${l_hcp_organization_id}/projects/${l_hcp_project_id}/registry" \
            --header "Authorization: Bearer ${HCP_TOKEN}" \
            --header "Content-Type: application/json" \
            --output "${RESPONSE_BODY}" \
            --write-out "%{http_code}" \
            --request DELETE \
            --data '{
                "feature_tier": "PLUS"
            }'
    )

    if [ ${RESPONSE} != "200" ]; then
        error "Failed to delete HCP Packer Registry (response code: ${RESPONSE})."
        error "$(cat ${RESPONSE_BODY})"
        return
    fi
    cat ${RESPONSE_BODY}
    OPERATION_ID=$(
        cat ${RESPONSE_BODY} | jq -r .operation.id
    )
    RESPONSE=$(
        curl -s --location "${BASE_HCP_OPERATIONS_URL}/${l_hcp_organization_id}/projects/${l_hcp_project_id}/operations/${OPERATION_ID}/wait" \
            --header "Authorization: Bearer ${HCP_TOKEN}" \
            --header "Content-Type: application/json" \
            --output "${RESPONSE_BODY}" \
            --write-out "%{http_code}" \
            --request GET
    )
    if [ ${RESPONSE} != "200" ]; then
        error "Failed to wait for deletion of HCP Packer Registry (response code: ${RESPONSE})."
        error "$(cat ${RESPONSE_BODY})"
        return
    fi
    cat ${RESPONSE_BODY}
    debug "${FUNCNAME}: Cleaning-up"
    rm -f "${RESPONSE_BODY}"
    debug "${FUNCNAME}: Finished execution"
}

# Do we have our prerequisites?
HCP_TOKEN=$(get_hcp_authentication_token)
[[ -z "${HCP_TOKEN}" ]] && {
    error "Missing HCP_TOKEN"
    exit 1
}

# Is cURL available?
if type -p curl &>/dev/null; then
    debug "cURL is present."
else
    error "cURL is not present."
    exit 1
fi

# Is jq available?
if type -p jq &>/dev/null; then
    debug "jq is present."
else
    error "jq is not present."
    exit 1
fi

#
# Main logic
#
delete_hcp_packer_registry
