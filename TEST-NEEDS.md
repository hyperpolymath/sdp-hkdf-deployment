<!--
SPDX-License-Identifier: MPL-2.0
Copyright (c) Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->
# TEST-NEEDS.md — sdp-hkdf-deployment

## CRG Grade: C — ACHIEVED 2026-04-04

## Current Test State

| Category | Count | Notes |
|----------|-------|-------|
| Test infrastructure | Present | `tests/` directory exists |
| Test framework | Configured | Deployment validation framework |

## What's Covered

- [x] Test directory structure

## Still Missing (for CRG B+)

- [ ] SDP key derivation tests
- [ ] HKDF integration tests
- [ ] Deployment validation tests
- [ ] Security property tests
- [ ] Performance benchmarks

## Run Tests

```bash
cd /var/mnt/eclipse/repos/sdp-hkdf-deployment && just test
```
