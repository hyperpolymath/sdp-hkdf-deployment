;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Project state for sdp-hkdf-deployment

(state
  (metadata
    (version "0.1.0")
    (schema-version "1.0")
    (created "2026-02-19")
    (updated "2026-03-02")
    (project "sdp-hkdf-deployment")
    (repo "hyperpolymath/sdp-hkdf-deployment"))

  (project-context
    (name "SDP HKDF Deployment")
    (tagline "Rootless/SDP deployment for HKDF cryptographic services")
    (tech-stack ("containerfiles" "nickel" "yaml" "haskell")))

  (current-position
    (phase "incubation")
    (overall-completion 20)
    (working-features
      ("RSR compliance structure"
       "Container definition stubs"
       "SDP configuration"
       "Contractiles framework"))))
