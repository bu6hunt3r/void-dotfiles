#!/usr/bin/env -S emacs -Q --script
(require 'org)
(org-babel-tangle-file
 (concat user-emacs-directory "org/config/emacs.org"))
