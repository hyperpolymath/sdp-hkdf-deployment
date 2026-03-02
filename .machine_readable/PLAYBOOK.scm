;; SPDX-License-Identifier: PMPL-1.0-or-later
;; PLAYBOOK.scm - Operational runbook for sdp-hkdf-deployment

(define playbook
  `((version . "1.0.0")
    (procedures
      ((deploy . (("build" . "podman build -f containerfiles/Containerfile .")
                  ("test" . "just test")
                  ("release" . "just release")))
       (rollback . (("undo" . "podman rollout undo")))
       (debug . (("logs" . "podman logs hkdf-service")))))
    (alerts . ())
    (contacts
      ((maintainer . "Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>")))))
