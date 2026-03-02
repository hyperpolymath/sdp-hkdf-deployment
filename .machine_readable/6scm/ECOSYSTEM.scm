;; SPDX-License-Identifier: PMPL-1.0-or-later
;; ECOSYSTEM.scm - Ecosystem position for sdp-hkdf-deployment
;; Media-Type: application/vnd.ecosystem+scm

(ecosystem
  (version "1.0")
  (name "sdp-hkdf-deployment")
  (type "infrastructure")
  (purpose "Rootless/SDP deployment infrastructure for HKDF cryptographic services")

  (position-in-ecosystem
    (category "security-infrastructure")
    (subcategory "cryptographic-deployment")
    (unique-value ("HKDF service deployment" "SDP perimeter enforcement")))

  (related-projects
    (dependency "svalinn" "High-assurance authentication kernel")
    (dependency "vordr" "Real-time state verification")
    (dependency "cerro-torre" "Container base image"))

  (what-this-is
    "Deployment tooling for HKDF cryptographic services "
    "using rootless containers with SDP perimeter enforcement.")

  (what-this-is-not
    "Not a cryptographic library. Not a key management system. "
    "This is deployment infrastructure only."))
