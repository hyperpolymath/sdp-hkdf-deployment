;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Project state tracking for sdp-hkdf-deployment
;; Media-Type: application/vnd.state+scm

(define-state sdp-hkdf-deployment
  (metadata
    (version "0.1.0")
    (schema-version "1.0.0")
    (created "2026-02-19")
    (updated "2026-03-02")
    (project "sdp-hkdf-deployment")
    (repo "hyperpolymath/sdp-hkdf-deployment"))

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
    (milestones
      ((name "Initial Setup")
       (status "in-progress")
       (completion 50)
       (items
         ("Initialize repository structure" . done)
         ("Add standard workflows" . done)
         ("Define HKDF service parameters" . todo)
         ("Harden Containerfile" . todo)))))

  (blockers-and-issues
    (critical ())
    (high ())
    (medium ())
    (low ()))

  (critical-next-actions
    (immediate
      "Define HKDF service parameters"
      "Harden Containerfile for rootless execution")
    (this-week
      "Integrate svalinn and vordr")
    (this-month
      "Deploy HKDF service with SDP enforcement"))

  (session-history ()))

;; Helper functions
(define (get-completion-percentage state)
  (current-position 'overall-completion state))

(define (get-blockers state severity)
  (blockers-and-issues severity state))

(define (get-milestone state name)
  (find (lambda (m) (equal? (car m) name))
        (route-to-mvp 'milestones state)))
