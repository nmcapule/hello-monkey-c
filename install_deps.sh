#!/bin/bash

# Lifted from:
# https://github.com/cedric-dufour/connectiq-sdk-docker/blob/master/Dockerfile

export CIQ_SDK_VERSION="6.2.1"

export CIQ_SDK_DOWNLOAD_URL="https://developer.garmin.com/downloads/connect-iq"
export CIQ_SDK_MANAGER_DIR_URL="${CIQ_SDK_DOWNLOAD_URL}/sdk-manager"
export CIQ_SDK_MANAGER_LIST_URL="${CIQ_SDK_MANAGER_DIR_URL}/sdk-manager.json"
export CIQ_SDK_DIR_URL="${CIQ_SDK_DOWNLOAD_URL}/sdks"
export CIQ_SDK_LIST_URL="${CIQ_SDK_DIR_URL}/sdks.json"

export DEBIAN_FRONTEND='noninteractive' \
    && sudo apt-get update --quiet \
    && sudo apt-get install --no-install-recommends --yes jq

export CIQ_SDK_MANAGER_URL="${CIQ_SDK_MANAGER_DIR_URL}/$(wget -qO- "${CIQ_SDK_MANAGER_LIST_URL}" | jq -r '.linux')" \
    && wget --progress=bar "${CIQ_SDK_MANAGER_URL}" -O ~/connectiq-sdk-manager-linux.zip \
    && mkdir -p "/opt/connectiq-sdk-manager-linux" \
    && cd "/opt/connectiq-sdk-manager-linux" \
    && unzip ~/connectiq-sdk-manager-linux.zip \
    && chmod -R go-w "/opt/connectiq-sdk-manager-linux"

export CIQ_SDK_URL="${CIQ_SDK_DIR_URL}/$(wget -qO- "${CIQ_SDK_LIST_URL}" | jq -r ".[] | select(.version==\"${CIQ_SDK_VERSION}\") | .linux")" \
    && wget --progress=bar "${CIQ_SDK_URL}" -O ~/connectiq-sdk-linux.zip \
    && mkdir -p "/opt/connectiq-sdk-linux" \
    && cd "/opt/connectiq-sdk-linux" \
    && unzip ~/connectiq-sdk-linux.zip \
    && chmod -R go-w "/opt/connectiq-sdk-linux"

sudo ln -s "/opt/connectiq-sdk-manager-linux/bin/sdkmanager" "/usr/local/bin/sdkmanager" \
    && touch "/opt/connectiq-sdk-linux/bin/default.jungle"

mkdir -p "$HOME/.Garmin/ConnectIQ/"
echo "/opt/connectiq-sdk-linux" > "$HOME/.Garmin/ConnectIQ/current-sdk.cfg"
echo "/usr/local/bin/sdkmanager" > "$HOME/.Garmin/ConnectIQ/sdkmanager-location.cfg"

# Put this in your ~/.bashrc
# export CIQ_HOME=$(cat "$HOME/.Garmin/ConnectIQ/current-sdk.cfg")
