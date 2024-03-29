;;; crafted-ui.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;; Commentary

;; User interface customizations. Examples are the modeline and how
;; help buffers are displayed.

;; This package provides a basic, customized appearance for
;; Emacs. Specifically, it uses: Helpful to customize the information
;; and visual display of help buffers, such as that created by M-x
;; `describe-function'; Doom Modeline and Themes, to customize the
;; appearance of buffers, text, et cetera; All-the-icons, to provide
;; Doom Modeline with font-based icons (rather than raster or vector
;; images); and includes some Emacs Lisp demonstrations.

;;  Run `all-the-icons-install-fonts' to ensure the fonts necessary
;; for ALL THE ICONS are available on your system. You must run this
;; function if the "stop" icon at the beginning of this paragraph is
;; not displayed properly (it appears as a box with some numbers
;; and/or letters inside it).

;; Read the documentation for `all-the-icons'; on Windows,
;; `all-the-icons-install-fonts' only downloads fonts, they must be
;; installed manually. This is necessary if icons are not displaying
;; properly.

;;; Code:

(crafted-package-install-package 'all-the-icons)
(crafted-package-install-package 'elisp-demos)
(crafted-package-install-package 'helpful)

;;;; Font
(defun crafted-ui--set-default-font (spec)
  "Set the default font based on SPEC.

SPEC is expected to be a plist with the same key names
as accepted by `set-face-attribute'."
  (when spec
    (apply 'set-face-attribute 'default nil spec)))

(defgroup crafted-ui '()
  "User interface related configuration for Crafted Emacs."
  :tag "Crafted UI"
  :group 'crafted)

(define-obsolete-variable-alias
  'rational-ui-default-font
  'crafted-ui-default-font
  "1")
(defcustom crafted-ui-default-font nil
  "The configuration of the `default' face.
Use a plist with the same key names as accepted by `set-face-attribute'."
  :group 'crafted-ui
  :type '(plist :key-type: symbol)
  :tag "Default font"
  :set (lambda (sym val)
         (let ((prev-val (if (boundp 'crafted-ui-default-font)
                             crafted-ui-default-font
                         nil)))
         (set-default sym val)
         (when (and val (not (eq val prev-val)))
           (crafted-ui--set-default-font val)))))

;;;; Help Buffers

;; Make `describe-*' screens more helpful
(require 'helpful)
(define-key helpful-mode-map [remap revert-buffer] #'helpful-update)
(global-set-key [remap describe-command] #'helpful-command)
(global-set-key [remap describe-function] #'helpful-callable)
(global-set-key [remap describe-key] #'helpful-key)
(global-set-key [remap describe-symbol] #'helpful-symbol)
(global-set-key [remap describe-variable] #'helpful-variable)
(global-set-key (kbd "C-h F") #'helpful-function)

;; Bind extra `describe-*' commands
(global-set-key (kbd "C-h K") #'describe-keymap)

;;;; Line Numbers
(define-obsolete-variable-alias
  'rational-ui-line-numbers-enabled-modes
  'crafted-ui-line-numbers-enabled-modes
  "1")
(defcustom crafted-ui-line-numbers-enabled-modes
  '(conf-mode prog-mode)
  "Modes which should display line numbers."
  :type 'list
  :group 'crafted-ui)

(define-obsolete-variable-alias
  'rational-ui-line-numbers-disabled-modes
  'crafted-ui-line-numbers-disabled-modes
  "1")
(defcustom crafted-ui-line-numbers-disabled-modes
  '(org-mode)
  "Modes which should not display line numbers.
Modes derived from the modes defined in
`crafted-ui-line-number-enabled-modes', but should not display line numbers."
  :type 'list
  :group 'crafted-ui)

(defun crafted-ui--enable-line-numbers-mode ()
  "Turn on line numbers mode.

Used as hook for modes which should display line numbers."
  (display-line-numbers-mode 1))

(defun crafted-ui--disable-line-numbers-mode ()
  "Turn off line numbers mode.

Used as hook for modes which should not display line numebrs."
  (display-line-numbers-mode -1))

(defun crafted-ui--update-line-numbers-display ()
  "Update configuration for line numbers display."
  (if crafted-ui-display-line-numbers
      (progn
        (dolist (mode crafted-ui-line-numbers-enabled-modes)
          (add-hook (intern (format "%s-hook" mode))
                    #'crafted-ui--enable-line-numbers-mode))
        (dolist (mode crafted-ui-line-numbers-disabled-modes)
          (add-hook (intern (format "%s-hook" mode))
                    #'crafted-ui--disable-line-numbers-mode))
        (setq-default
         display-line-numbers-grow-only t
         display-line-numbers-type t
         display-line-numbers-width 2))
     (progn
       (dolist (mode crafted-ui-line-numbers-enabled-modes)
         (remove-hook (intern (format "%s-hook" mode))
                      #'crafted-ui--enable-line-numbers-mode))
       (dolist (mode crafted-ui-line-numbers-disabled-modes)
         (remove-hook (intern (format "%s-hook" mode))
                      #'crafted-ui--disable-line-numbers-mode)))))

(define-obsolete-variable-alias
  'rational-ui-display-line-numbers
  'crafted-ui-display-line-numbers
  "1")
(defcustom crafted-ui-display-line-numbers nil
  "Whether line numbers should be enabled."
  :type 'boolean
  :group 'crafted-ui
  :set (lambda (sym val)
         (set-default sym val)
         (crafted-ui--update-line-numbers-display)))

;;;; Elisp-Demos

;; also add some examples
(require 'elisp-demos)
(advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)

;; add visual pulse when changing focus, like beacon but built-in
;; from from https://karthinks.com/software/batteries-included-with-emacs/
(defun pulse-line (&rest _)
  "Pulse the current line."
  (pulse-momentary-highlight-one-line (point)))

(dolist (command '(scroll-up-command scroll-down-command
                                     recenter-top-bottom other-window))
  (advice-add command :after #'pulse-line))

(crafted-package-install-package 'doom-modeline)
(provide 'crafted-ui)

;; Font settings
(add-hook 'emacs-startup-hook
          (lambda () (custom-set-faces
                      `(default ((t (:font "JetBrains Mono 14"))))
                      `(fixed-pitch ((t (:inherit (default)))))
                      `(variable-pitch ((t (:font "JetBrains Mono 14")))))))

;; (add-hook 'emacs-startup-hook
;;           (lambda () (custom-set-faces
;;                       `(default ((t (:font "Agave Nerd Font Mono 14"))))
;;                       `(fixed-pitch ((t (:inherit (default)))))
;;                       `(variable-pitch ((t (:font "Agave Nerd Font Mono 14")))))))

;; (add-hook 'emacs-startup-hook
;;           (lambda () (custom-set-faces
;;                       `(default ((t (:font "CaskaydiaCove Nerd Font Mono 14"))))
;;                       `(fixed-pitch ((t (:inherit (default)))))
;;                       `(variable-pitch ((t (:font "CaskaydiaCove Nerd Font Mono 14")))))))

;; Disable splash on startup
(customize-set-variable 'crafted-startup-inhibit-splash t)

;; ;; Open files from dired-mode via shortcut
(crafted-package-install-package 'openwith)

(when (require 'openwith nil 'oerror)
  (setq openwith-associations
        (list
         (list (openwith-make-extension-regexp
                '("pdf" "ps" "ps.gz" "dvi"))
               "zathura"
               '(file))))
  (openwith-mode 1))

(crafted-package-install-package 'rainbow-delimiters)
(rainbow-delimiters-mode 1)

;; line-numbers-mode
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(global-set-key (kbd "C-!") 'eshell-here)

(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(crafted-package-install-package 'eshell-syntax-highlighting)

(eshell-syntax-highlighting-global-mode 1)

;; Mode line settings
;; use setq-default to set it for /all/ modes

(setq-default mode-line-format
              (list

               ;; ;; meow modal mode
               ;; (when (require 'meow nil 'noerror)
               ;;   (meow-indicator))

               ;; day and time
               ;; '(:eval (propertize (substring vc-mode 5)
               ;;                     'face 'font-lock-comment-face))


               '(:eval (propertize (format-time-string " %b %d %H:%M ")
                                   'face 'font-lock-builtin-face))

               '(:eval (propertize (substring vc-mode 5)
                                   'face 'font-lock-comment-face))

               ;; the buffer name; the file name as a tool tip
               '(:eval (propertize " %b "
                                   'face
                                   (let ((face (buffer-modified-p)))
                                     (if face 'font-lock-warning-face
                                       'font-lock-type-face))
                                   'help-echo (buffer-file-name)))

               ;; line and column
               " (" ;; '%02' to set to 2 chars at least; prevents flickering
               (propertize "%02l" 'face 'font-lock-keyword-face) ","
               (propertize "%02c" 'face 'font-lock-keyword-face)
               ") "

               ;; relative position, size of file
               " ["
               (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
               "/"
               (propertize "%I" 'face 'font-lock-constant-face) ;; size
               "] "

               ;; ansi-term's line or char mode
               ":"
               'mode-line-process
               ":"

               ;; spaces to align right
               '(:eval (propertize
                " " 'display
                `((space :align-to (- (+ right right-fringe right-margin)
                                      ,(+ 3 (string-width (if (listp mode-name) (car mode-name) mode-name))))))))

               ;(propertize org-mode-line-string 'face '(:foreground "#5DD8FF"))

               ;; the current major mode
               (propertize " %m " 'face 'font-lock-string-face)
               ;;minor-mode-alist
               ))



;;; crafted-ui.el ends here
