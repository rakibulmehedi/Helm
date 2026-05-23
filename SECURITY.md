# Security Policy

## Scope

Pocketa is an offline-first, local-storage-only mobile application. It does not transmit user financial data to any server. There is no backend, no authentication service, and no cloud storage in the current MVP.

All data is stored locally on the user's device using Hive.

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

- No encryption at rest (Hive stores data in plaintext on device; relies on OS-level device security)
- No PIN/biometric lock on the app (planned for future phase)
- No network transmission of financial data

## Out of Scope

- Vulnerabilities in third-party Flutter packages (report to the package maintainer)
- Jailbreak/root device attacks (out of scope for MVP)
- Social engineering

## Supported Versions

Only the current main branch is actively maintained.
