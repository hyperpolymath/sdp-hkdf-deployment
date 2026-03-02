;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Project state for sdp-hkdf-deployment
;; Media-Type: application/vnd.state+scm

(state
  (metadata
    (version "0.1.0")
    (schema-version "1.0")
    (created "2026-02-19")
    (updated "2026-03-02")
    (project "sdp-hkdf-deployment")
    (repo "github.com/hyperpolymath/sdp-hkdf-deployment"))

  (project-context
    (name "sdp-hkdf-deployment")
    (tagline "Rootless/SDP deployment for HKDF cryptographic services")
    (tech-stack ("containerfiles" "nickel" "yaml" "haskell")))

  (current-position
    (phase "incubation")
    (overall-completion 20)
    (components ())
    (working-features
      ("RSR compliance structure"
       "Container definition stubs"
       "SDP configuration")))

  (route-to-mvp
    (milestones ()))

  (blockers-and-issues
    (critical)
    (high)
    (medium)
    (low))

  (critical-next-actions
    (immediate)
    (this-week)
    (this-month))

  (session-history ()))
