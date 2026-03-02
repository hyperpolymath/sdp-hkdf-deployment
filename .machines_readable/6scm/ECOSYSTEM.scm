;; SPDX-License-Identifier: PMPL-1.0-or-later
;; ECOSYSTEM.scm - Ecosystem relationships for sdp-hkdf-deployment
;; Media-Type: application/vnd.ecosystem+scm

(ecosystem
  (version "1.0.0")
  (name "sdp-hkdf-deployment")
  (type "infrastructure")
  (purpose "Rootless/SDP deployment infrastructure for HKDF cryptographic services")

  (position-in-ecosystem
    "Part of the hyperpolymath security infrastructure ecosystem. "
    "Provides deployment tooling for HKDF cryptographic services "
    "using rootless containers with SDP perimeter enforcement.")

  (related-projects
    (dependency "svalinn" "High-assurance authentication kernel")
    (dependency "vordr" "Real-time state verification")
    (dependency "cerro-torre" "Container base image and signing")
    (sibling "ambientops" "Operations infrastructure"))

  (what-this-is
    "Deployment tooling for HKDF cryptographic services "
    "using rootless containers with SDP perimeter enforcement.")

  (what-this-is-not
    "Not a cryptographic library. Not a key management system. "
    "This is deployment infrastructure only."))
