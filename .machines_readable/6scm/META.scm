;; SPDX-License-Identifier: PMPL-1.0-or-later
;; META.scm - Architectural decisions and project meta-information
;; Media-Type: application/meta+scheme

(define-meta sdp-hkdf-deployment
  (version "1.0.0")

  (architecture-decisions
    ((adr-001 accepted "2026-02-19"
      "Need rootless container deployment for HKDF services"
      "Use Podman/Nerdctl with SDP perimeter enforcement and air-gap readiness"
      "Ensures security isolation without root privileges. "
      "Integrates with svalinn, vordr, and cerro-torre base images.")))

  (development-practices
    (code-style
      "Follow hyperpolymath language policy. "
      "Containerfiles use Chainguard/wolfi-base images.")
    (security
      "All deployments rootless. "
      "SDP perimeter enforcement mandatory. "
      "Hypatia neurosymbolic scanning enabled.")
    (testing
      "Container image validation required. "
      "Security scanning on all pushes.")
    (versioning
      "Semantic versioning (semver).")
    (documentation
      "README.adoc for overview. "
      "STATE.scm for current state. "
      "TOPOLOGY.md for architecture.")
    (branching
      "Main branch protected. "
      "Feature branches for new work."))

  (design-rationale
    (why-sdp
      "Secure Deployment Protocol ensures rootless execution "
      "with mandatory access control and zero-trust networking.")
    (why-hkdf
      "HKDF provides deterministic key derivation "
      "critical for cryptographic service infrastructure.")))
