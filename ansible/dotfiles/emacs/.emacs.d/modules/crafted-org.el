;;; crafted-org.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2022
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;; Commentary

;; Provides basic configuration for Org Mode.

;;; Code:

(crafted-package-install-package 'org-appear)

;; Return or left-click with mouse follows link
(customize-set-variable 'org-return-follows-link t)
(customize-set-variable 'org-mouse-1-follows-link t)

;; Display links as the description provided
(customize-set-variable 'org-link-descriptive t)

;; Hide markup markers
(customize-set-variable 'org-hide-emphasis-markers t)
(add-hook 'org-mode-hook 'org-appear-mode)

;; disable auto-pairing of "<" in org-mode
(add-hook 'org-mode-hook (lambda ()
    (setq-local electric-pair-inhibit-predicate
    `(lambda (c)
       (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))

(crafted-package-install-package 'org-modern)

(setq org-auto-align-tags nil
      org-tags-column 0
      org-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e t
      org-insert-heading-respect-content t

      ;; Org styling, hide markup etc.
      org-hide-emphasis-markers t
      org-pretty-entities t
      org-ellipsis "…"

      ;; Agenda styling
      org-agenda-tags-column 0
      org-agenda-block-separator ?─
      org-agenda-time-grid '((daily today require-timed)
                             (800 1000 1200 1400 1600 1800 2000)
                             " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
      org-agenda-current-time-string
      "<─ now ────────────────────────────────────────────────")

(if (display-graphic-p)
    (setq org-modern-table t)
  (setq org-modern-table nil))

(global-org-modern-mode)

(provide 'crafted-org)
;;; crafted-org.el ends here
