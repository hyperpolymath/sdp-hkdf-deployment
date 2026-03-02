;; SPDX-License-Identifier: PMPL-1.0-or-later
;; META.scm - Meta-level information for sdp-hkdf-deployment
;; Media-Type: application/meta+scheme

(meta
  (architecture-decisions
    ((adr-001 accepted "2026-02-19"
      "Need rootless container deployment for HKDF services"
      "Use Podman/Nerdctl with SDP perimeter enforcement"
      "Air-gap readiness, provenance tracking, zero-trust networking")))

  (development-practices
    (code-style ())
    (security
      (principle "Defense in depth with SDP perimeter enforcement"))
    (testing ())
    (versioning "SemVer")
    (documentation "AsciiDoc")
    (branching "main for stable"))

  (design-rationale
    (why-sdp
      "Secure Deployment Protocol ensures rootless execution "
      "with mandatory access control and zero-trust networking.")
    (why-hkdf
      "HKDF provides deterministic key derivation from "
      "shared secrets, critical for cryptographic service infrastructure.")))
