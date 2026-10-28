# Mobile Security Policy

> **Mandatory** for all Full Up apps (Worker, Corp, Pay, Driver, Delivery, Provider, Individuals).
> Every developer MUST read and follow this policy before handling secrets, keys, or sensitive data.

---

## 1. Golden Rule

**Never store sensitive secrets on the client.**

Any secret the app can access, the device owner can access. No technique — White-Box Cryptography, RASP, obfuscation — changes this fundamental truth. If the worst-case scenario of a fully compromised client is catastrophic, that secret belongs on the server, not the device.

---

## 2. Secret Management

### 2.1 What MUST Stay on the Server

- API master keys / admin tokens
- Payment processing secrets
- Database credentials
- Third-party service secrets (Firebase admin SDK keys, etc.)
- Any secret where exposure = catastrophic business impact

### 2.2 What Can Live on Device (with protection)

- User session tokens (short-lived, server-revocable)
- Device-generated encryption keys (stored in Keystore/Keychain)
- Refresh tokens (with proper rotation)

### 2.3 Prohibited Practices

| Practice | Why It's Dangerous |
|---|---|
| Hardcoding secrets in Dart code | Extracted trivially from AOT snapshot |
| Storing secrets in `--dart-define` | Ends up in the binary as plain text |
| `.env` files as assets | Unpacking APK/IPA exposes them immediately |
| Secrets in Native layer via MethodChannel | MethodChannel traffic is hookable via Frida; native strings visible in disassembly |
| Splitting keys across multiple files | Reverse engineers reassemble them easily |
| Relying solely on `--obfuscate` | Only renames symbols; strings and constants remain intact |

---

## 3. On-Device Key Storage

### 3.1 Use Platform Secure Storage

- **Android**: Use `AndroidKeyStore` with `setUserAuthenticationRequired(true)`
- **iOS**: Use `Keychain` with appropriate Access Control Flags

### 3.2 Bind Keys to User Authentication

Always require biometric or device credential authentication before key usage:

- **Android**: `setUserAuthenticationRequired` + `setUserAuthenticationParameters`
- **iOS**: `SecAccessControlCreateFlags` with `.biometryCurrentSet` or `.userPresence`

### 3.3 Know the Limitations

- Keystore/Keychain protect keys from **extraction**, not from **usage** — a rooted device can call the API and use the key just like the app does
- iOS Secure Enclave supports limited key types (primarily P-256) — AES keys are encrypted by the Enclave but stored outside it
- Not all Android devices have StrongBox; fall back gracefully

---

## 4. App Attestation

### 4.1 Android — Play Integrity API

- Verdict MUST be verified **on the server**, never locally
- Only `MEETS_STRONG_INTEGRITY` (hardware-backed) provides real assurance
- Basic verdicts are bypassable on many devices

### 4.2 iOS — App Attest

- Attestation verification MUST happen **on the server**
- Use `DCAppAttestService` to generate and verify attestation keys

### 4.3 Critical Rules

- **Never** let the app validate its own attestation result locally — an attacker can patch that check in minutes
- Attestation is a signal, not a guarantee — always combine with other layers

---

## 5. Obfuscation & Hardening

### 5.1 Always Enable (but don't rely on)

```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

This is a **baseline**, not a security boundary. It raises the cost of reverse engineering but does not protect secrets.

### 5.2 Additional Hardening Layers

- **Root/Jailbreak detection**: Detect and respond (not just detect and warn)
- **Anti-tampering**: Verify app integrity at runtime
- **Anti-debugging**: Detect Frida, debugger attachment, instrumentation
- **SSL Pinning**: Pin certificates for all API communication

> These are speed bumps, not walls. Layer them together to maximize attacker cost.

---

## 6. White-Box Cryptography

### 6.1 When to Consider

- Contactless/HCE payments requiring software-based key protection
- DRM / content protection
- Devices without hardware-backed security (Android fragmentation)
- Business-critical keys that **must** exist on-device

### 6.2 Requirements If Used

- Use **commercial solutions only** — all published academic White-Box AES constructions have been broken (BGE Attack, DCA, DFA)
- Must include: External Encodings + Device Binding + Key Renewal
- The vendor must be contractually responsible for security
- Keys must rotate via server-pushed updates — assume any key will eventually be extracted

### 6.3 Trade-offs

- Lookup tables can add **tens of MBs** to app size
- Significant performance overhead vs hardware-accelerated AES
- Decision must come from a proper threat model (STRIDE/DREAD), not guesswork

---

## 7. Architecture Decision Flow

```
Is the secret catastrophic if exposed?
├── YES → Keep it on the server. No exceptions.
└── NO → Can it be generated on-device?
    ├── YES → Generate & store in Keystore/Keychain with biometric binding
    └── NO → Must it persist on-device?
        ├── YES → Use server-managed key rotation + attestation + hardening layers
        └── NO → Fetch from server at runtime, hold in memory only, clear after use
```

---

## 8. Security Checklist (Pre-Release)

> The full, step-by-step rules with code snippets, the extended checklist and the pentest verification matrix are in [security/mobile_app_hardening_rules.md](security/mobile_app_hardening_rules.md).

- [ ] No hardcoded secrets in Dart, native, or asset files
- [ ] All API keys that can be server-side ARE server-side
- [ ] On-device keys use Keystore/Keychain with user authentication
- [ ] Attestation verification happens server-side only
- [ ] `--obfuscate` and `--split-debug-info` enabled for release builds
- [ ] SSL pinning implemented for all API endpoints
- [ ] Root/jailbreak detection active with appropriate response
- [ ] Anti-debugging measures in place
- [ ] No sensitive data logged in release builds
- [ ] Session tokens are short-lived and server-revocable

---

## 9. Threat Modeling Requirement

Before implementing any security feature, the team must:

1. Identify threats using **STRIDE** for each feature
2. Evaluate risk using **DREAD** scoring
3. Map **Attack Trees** with DFA (Data Flow Analysis)
4. Present findings via **PASTA** framework to relevant teams
5. Document decisions and trade-offs

Security is an architecture decision, not an afterthought.

---

## References

- White-Box Cryptography (Chow et al., 2002)
- BGE Attack on White-Box AES
- DCA / DFA attacks on software implementations
- WhibOx competition results
- EMVCo security evaluation standards for HCE
- OWASP Mobile Security Testing Guide (MASTG)
- Apple Platform Security Guide
- Android Keystore System documentation
