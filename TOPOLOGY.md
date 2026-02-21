<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- TOPOLOGY.md — Project architecture map and completion dashboard -->
<!-- Last updated: 2026-02-19 -->

# SDP HKDF Deployment — Project Topology

## System Architecture

```
                        ┌─────────────────────────────────────────┐
                        │              OPERATOR / ADMIN           │
                        │        (Deployment & Provisioning)      │
                        └───────────────────┬─────────────────────┘
                                            │
                                            ▼
                        ┌─────────────────────────────────────────┐
                        │           SDP HKDF INFRASTRUCTURE       │
                        │    (Rootless/SDP Crypto Service)        │
                        └──────────┬───────────────────┬──────────┘
                                   │                   │
                                   ▼                   ▼
                        ┌───────────────────────┐  ┌────────────────────────────────┐
                        │ CONFIGURATIONS        │  │ CONTAINER RUNTIME              │
                        │ - HKDF Parameters     │  │ - Rootless Podman/Nerdctl      │
                        │ - Policy Rules        │  │ - SDP Perimeter Enforcement    │
                        └───────────────────────┘  └────────────────────────────────┘

                        ┌─────────────────────────────────────────┐
                        │          REPO INFRASTRUCTURE            │
                        │  Justfile Automation  .machine_readable/  │
                        │  contractiles/        0-AI-MANIFEST.a2ml  │
                        └─────────────────────────────────────────┘
```

## Completion Dashboard

```
COMPONENT                          STATUS              NOTES
─────────────────────────────────  ──────────────────  ─────────────────────────────────
DEPLOYMENT CORE
  HKDF Configs                      █░░░░░░░░░  10%    Initial parameters stubs
  Containerfiles                    █░░░░░░░░░  10%    Rootless base stubs
  SDP Policies                      ░░░░░░░░░░   0%    Pending specification

REPO INFRASTRUCTURE
  Justfile Automation               ██████████ 100%    Standard tasks active
  .machine_readable/                ██████████ 100%    STATE tracking active
  0-AI-MANIFEST.a2ml                ██████████ 100%    AI entry point verified

─────────────────────────────────────────────────────────────────────────────
OVERALL:                            ██░░░░░░░░  ~20%   Incubation / Initialization
```

## Key Dependencies

```
Crypto Requirement ───► HKDF Config ───► Container Build ──► SDP Deploy
```

## Update Protocol

This file is maintained by both humans and AI agents. When updating:

1. **After completing a component**: Change its bar and percentage
2. **After adding a component**: Add a new row in the appropriate section
3. **After architectural changes**: Update the ASCII diagram
4. **Date**: Update the `Last updated` comment at the top of this file

Progress bars use: `█` (filled) and `░` (empty), 10 characters wide.
Percentages: 0%, 10%, 20%, ... 100% (in 10% increments).
