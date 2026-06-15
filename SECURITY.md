# Security Policy

## Scope

Helm is an offline-first mobile application. User financial data is stored locally on the device using Hive CE with AES encryption backed by the platform keystore. The current beta does not transmit financial data to any Helm-owned backend.

## Reporting a Vulnerability

If you discover a security vulnerability:

1. **Do not open a public GitHub issue.**
2. Email the maintainer directly: rakibulmehedi.dev@gmail.com
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

You will receive a response within 72 hours.

## Known Scope Limitations

- **Client-side Magic Link mock**: The Magic Link authentication flow in the current build is a client-side mock (`AuthRemoteDataSource`). Tokens are generated and verified locally; an attacker with root access to the device can inspect or tamper with this state. Before production, Magic Link verification MUST be moved to a backend service that issues single-use tokens and validates them server-side.
- PIN/biometric lock is implemented locally but is not a substitute for OS-level device security.
- No network transmission of financial data in the current build.

## Out of Scope

- Vulnerabilities in third-party Flutter packages (report to the package maintainer)
- Social engineering
- Compromised-device attacks that bypass OS sandboxing when the device is unlocked

## Supported Versions

Only the current main branch is actively maintained.
