#!/bin/bash

set -e

# Regenerate the mobileprovision from base64
cd "$RUNNER_TEMP" || exit 1
echo -n "$MOBILEPROVISION" | base64 --decode --output CI.mobileprovision
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp CI.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles

# Regenerate the p12 from base64 and install in new temp keychain
KEYCHAIN_PATH=$RUNNER_TEMP/temp_resign
KEYCHAIN_PASS=$(echo "$(date)""$RANDOM" | base64)
echo -n "$CERT_P12" | base64 --decode --output cicert.p12
security create-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_PATH"
security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
security unlock-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_PATH"
security import cicert.p12 -P "$P12_PASS" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
security list-keychain -d user -s "$KEYCHAIN_PATH"

fastlane sigh resign "$IPA_PATH" --keychain_path "$KEYCHAIN_PATH" --signing_identity "$SIGNING_IDENTITY" --provisioning_profile "CI.mobileprovision"

# Clean up
rm ~/Library/MobileDevice/Provisioning\ Profiles/CI.mobileprovision
