# mTLS (Mutual TLS) — Mobile Security Guide

## Overview

In standard HTTPS, only the **server** proves its identity to the client. The client (mobile app) remains anonymous — any app, script, or bot that knows the endpoint can send requests freely.

**mTLS** (Mutual TLS) closes this gap: **both sides** authenticate each other. If the client doesn't have a trusted certificate, the server rejects the connection at the **Transport Layer** — before any API logic is reached.

---

## TLS vs mTLS

| Aspect | TLS (HTTPS) | mTLS |
|--------|------------|------|
| Server proves identity | Yes (via SSL Certificate) | Yes |
| Client proves identity | No | Yes (via Client Certificate) |
| Authentication type | One-sided | Mutual (two-sided) |
| Rejection layer | API Layer | Transport Layer |
| Protection against unknown clients | No | Yes |

---

## How the mTLS Handshake Works

1. **Client connects** to the server and verifies the server's certificate (same as standard TLS).
2. **Server requests** the client's certificate.
3. **Client presents** its Client Certificate.
4. **Server validates** the certificate signature and trust chain.
5. If valid → connection established. If not → connection **rejected immediately** (before reaching any API endpoint).

> The client never sends its Private Key. It performs a **Proof of Possession** — signing a challenge to prove it owns the key, without exposing the key itself.

---

## Critical Mistake: Shared Identity (Security Theater)

**The wrong way:**
- Bundling a single Client Certificate + Private Key inside the app's assets.
- All users/devices share the same certificate.

**Why it's dangerous:**
- Anyone who reverse-engineers the app extracts the certificate.
- Attacker can spoof any client and talk to the server freely.
- This is **not real mTLS** — it's Security Theater (false sense of security).

**The correct way:**
- Each device **generates its own unique Key Pair** locally.
- Private Key stored in the most secure storage available:
  - **iOS:** Secure Enclave
  - **Android:** Hardware-backed Keystore
- The Private Key **never leaves** the secure storage.

---

## Hardware-Backed mTLS in Flutter

### The Challenge

Flutter's `SecurityContext` expects Private Key bytes in memory — but the whole point of the Secure Enclave/Keystore is that the key **never** gets exported, not even to the app developer.

### The Solution

The device's secure hardware performs the signing **internally** and returns only the result.

| Platform | API to Use |
|----------|-----------|
| **Android** | `X509KeyManager` (via KeyStore) |
| **iOS** | `SecIdentity` (via Keychain + Secure Enclave) |

**Bridge to Flutter** using:
- **Platform Channels** (MethodChannel), or
- **Dart FFI** (Foreign Function Interface)

> Pure-Dart mTLS works fine with software-based keys, but for **hardware-backed** mTLS (bank-grade), you must use native platform APIs via a bridge.

---

## Certificate Lifecycle Management

mTLS is not a one-time feature — it's a full system with a lifecycle:

### 1. Provisioning (Issuing the Certificate)

1. User authenticates with **strong authentication** (e.g., Biometric + OTP).
2. Device generates a **Key Pair** inside the Secure Enclave/Keystore.
3. Device sends a **CSR (Certificate Signing Request)** to the Backend CA.
4. Backend CA signs and returns the certificate to the device.

### 2. Renewal (Auto-Renewal Before Expiry)

- Certificates have an expiration date.
- Must be renewed **automatically before expiry** to avoid locking users out of the app unexpectedly.

### 3. Revocation (Invalidating Stolen Devices)

If a device is stolen, the certificate must be **revoked immediately**.

| Method | Description |
|--------|-------------|
| **CRL** (Certificate Revocation List) | A list of revoked certificates checked by the server |
| **OCSP** (Online Certificate Status Protocol) | Real-time protocol — server checks certificate validity instantly |

> **Without revocation, mTLS protection is incomplete.** A stolen device with a valid certificate (e.g., 2 months until expiry) gives the attacker full access for that entire period.

---

## Architecture Summary

```
┌─────────────────────────────────────────────────┐
│                   Mobile Device                  │
│                                                  │
│  ┌──────────────┐    ┌────────────────────────┐  │
│  │  Flutter App  │◄──►│  Platform Channel/FFI  │  │
│  └──────┬───────┘    └──────────┬─────────────┘  │
│         │                       │                 │
│         │              ┌────────▼──────────┐      │
│         │              │  Secure Enclave /  │      │
│         │              │  HW Keystore       │      │
│         │              │  (Private Key)     │      │
│         │              └────────┬──────────┘      │
│         │                       │                 │
│         │            Signs internally,            │
│         │            returns result only           │
│         ▼                       ▼                 │
│  ┌─────────────────────────────────────────────┐  │
│  │         mTLS Handshake (Transport Layer)     │  │
│  │  Client Cert + Proof of Possession sent      │  │
│  └──────────────────────┬──────────────────────┘  │
└─────────────────────────┼─────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────┐
│                    Server                        │
│                                                  │
│  1. Validate Server Cert ✓ (client side)         │
│  2. Validate Client Cert ✓ (server side)         │
│  3. Check Revocation (CRL/OCSP) ✓               │
│  4. Only then → allow API access                 │
└─────────────────────────────────────────────────┘
```

---

## Key Takeaways

1. **HTTPS + SSL Pinning is not enough** — server still doesn't know who the client is.
2. **mTLS authenticates both sides** — rejection happens at Transport Layer, before API logic.
3. **Never bundle shared certificates** in the app — each device must have a unique identity.
4. **Private Keys must stay in hardware** — Secure Enclave (iOS) / HW Keystore (Android).
5. **Flutter needs native bridges** for hardware-backed mTLS (Platform Channels or FFI).
6. **Certificate Lifecycle is mandatory** — Provisioning, Renewal, and Revocation.
7. **Security is an architectural decision** from line one, not an afterthought.
