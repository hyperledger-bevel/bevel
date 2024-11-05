##############################################################################################
#  Copyright Accenture. All Rights Reserved.
#
#  SPDX-License-Identifier: Apache-2.0
##############################################################################################

# Validate HashiCorp Vault responses
validateVaultResponseHashicorp() {
    if [ "$2" = "LOOKUPSECRETRESPONSE" ]; then
        http_code=$(curl -fsS -o /dev/null -w "%{http_code}" \
            --header "X-Vault-Token: ${VAULT_TOKEN}" \
            "${VAULT_ADDR}/v1/${1}")
        curl_response=$?

        echo "HTTP response code from Vault: $http_code"
        echo "Curl response code from Vault: $curl_response"

        if [ "$http_code" = "200" ] && [ "$curl_response" = "0" ]; then
            echo "Validation successful for: $3"
        else
            echo "Validation failed for: $3"
            exit 1
        fi
    fi
}

# Initialize HashiCorp Vault token
initHashicorpVaultToken() {
    # Retrieve the Kubernetes service account token
    KUBE_SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    # Request a Vault token using the Kubernetes authentication method
    RESPONSE=$(curl -sS --request POST "${VAULT_ADDR}/v1/auth/${KUBERNETES_AUTH_PATH}/login" -H "Content-Type: application/json" -d \
        '{"role":"'${VAULT_APP_ROLE}'","jwt":"'${KUBE_SA_TOKEN}'"}')
    # Print the Vault API response
    echo "Vault token API call response: $RESPONSE"

    # Extract error message (if any) from the response using jq
    ERROR=$(echo "$RESPONSE" | jq -r '.errors[0]')
    # Extract the Vault secret data from the response using jq
    export VAULT_TOKEN=$(echo "$RESPONSE" | jq -r '.auth.client_token')

    # Check if the Vault token is empty, null, or contains errors
    if [ -z "$VAULT_TOKEN" ] || [ "$VAULT_TOKEN" = "null" ] || echo "$VAULT_TOKEN" | grep -q "errors"; then
        echo "Error: Failed to obtain Vault token."
        echo "Error Details: $ERROR"
        exit 1
    else
        echo "Vault token successfully obtained."
    fi
}

# Read HashiCorp Vault secret
readHashicorpVaultSecret() {
    # Send a request to Vault API to read a secret
    RESPONSE=$(curl --header "X-Vault-Token: ${VAULT_TOKEN}" "${VAULT_ADDR}/v1/${1}")
    # Print the Vault API response
    echo "Vault read API call response: $RESPONSE"

    # Extract error message (if any) from the response using jq
    ERROR=$(echo "$RESPONSE" | jq -r '.errors[0]')
    # Extract the Vault secret data from the response using jq
    VAULT_SECRET=$(echo "$RESPONSE" | jq -r '.data.data')

    # Flag to indicate that secrets are present in the vault or not
    SECRETS_AVAILABLE="no"

    # Stop further execution of code if an error is found
    if [ -n "$ERROR" ] && [ "$ERROR" != "null" ]; then
        echo "Error: Failed to read Vault secret."
        echo "Error Details: $ERROR"
        exit 1
    else
        # Check if the Vault API response indicates a failure
        if [ -n "$VAULT_SECRET" ] && [ "$VAULT_SECRET" != "null" ] && ! echo "$VAULT_SECRET" | grep -q "errors"; then
            validateVaultResponseHashicorp "${1}" "LOOKUPSECRETRESPONSE" "read api call"
            echo "Successfully obtained Vault Secret from the path ${VAULT_ADDR}/v1/${1}"
            echo "Vault Secret: $VAULT_SECRET"
            SECRETS_AVAILABLE="yes"
        else
            echo "The secret is absent in the vault at path ${VAULT_ADDR}/v1/${1}"
            echo "NOTE: This is not an error; it indicates that the secret will be created in later code."
        fi
    fi
}

# Write a secret to the HashiCorp Vault
writeHashicorpVaultSecret() {
    # Send a request to Vault API to write a secret
    VAULT_RESPONSE=$(curl \
        -H "X-Vault-Token: ${VAULT_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST \
        -d @"${2}" \
        "${VAULT_ADDR}/v1/${1}")

    # Print the Vault API response
    echo "Vault write API call response: ${VAULT_RESPONSE}"

    # Stop further execution of code if an error is found
    # Check if the Vault API response indicates a failure
    if [ -z "$VAULT_RESPONSE" ] || [ "$VAULT_RESPONSE" = "null" ] || echo "$VAULT_RESPONSE" | grep -q "errors"; then
        echo "Error: Failed to write to Vault at path ${VAULT_ADDR}/v1/${1}"
        exit 1
    else
        validateVaultResponseHashicorp "${1}" "LOOKUPSECRETRESPONSE" "write api call"
        echo "Successfully wrote to Vault at path ${VAULT_ADDR}/v1/${1}"
    fi
}

# Main function for HashiCorp Vault operations
vaultBevelFunc() {
    if [ "$VAULT_TYPE" = "hashicorp" ]; then
        case $1 in
            "init")
                # Initialize Vault token
                initHashicorpVaultToken
                ;;
            "readJson")
                # Read Vault secret
                readHashicorpVaultSecret "$2"
                ;;
            "write")
                # Write a secret to the Vault
                writeHashicorpVaultSecret "$2" "$3"
                ;;
            *)
                # Invalid option
                echo "Invalid option"
                exit 1
                ;;
        esac
    fi
}
