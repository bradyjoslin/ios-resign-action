# iOS Resign GitHub Action

Resigns `ipa` files using GitHub Actions.

## Usage

Example usage in a worfklow:

```yaml
name: Resign

on: workflow_dispatch

jobs:
  iOS:
    name: iOS
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: bradyjoslin/ios-resign-action@v1
        with:
          ipa_path: ./sample.ipa
          mobileprovision: ${{ secrets.MOBILEPROVISION }}
          cert_p12: ${{ secrets.CERT_P12 }}
          p12_pass: ${{ secrets.P12_PASS }}
          signing_identity: ${{ secrets.SIGNING_IDENTITY }}
      - uses: actions/upload-artifact@v2
        with:
          name: ipa
          path: ./**.ipa
```

## Inputs

| input            | value                                                            | required? |
| ---------------- | ---------------------------------------------------------------- | --------- |
| ipa_path         | Path to ipa file                                                 | Y         |
| mobileprovision  | Base64 representation of mobile provisioning file                | Y         |
| cert_p12         | Base64 representation p12 distribution cert                      | Y         |
| p12_pass         | Password used when exporting p12 distribution cert from keychain | Y         |
| signing_identity | iOS Signing Identity                                             | Y         |

## FAQ

**How do you create base64 of p12 or mobileprovision file?**

`base64 cert.12 > cert.txt`

The contents of the text file is the p12 file in base64 format, which you can store as a GitHub Secret.
