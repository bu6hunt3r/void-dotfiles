;;; example-config.el -- Example Crafted Emacs user customization file -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Crafted Emacs supports user customization through a `config.el' file
;; similar to this one.  You can copy this file as `config.el' to your
;; Crafted Emacs configuration directory as an example.
;;
;; In your configuration you can set any Emacs configuration variable, face
;; attributes, themes, etc as you normally would.
;;
;; See the README.org file in this repository for additional information.

;;; Code:
;; At the moment, Crafted Emacs offers the following modules.
;; Comment out everything you don't want to use.
;; At the very least, you should decide whether or not you want to use
;; evil-mode, as it will greatly change how you interact with Emacs.
;; So, if you prefer Vim-style keybindings over vanilla Emacs keybindings
;; remove the comment in the line about `crafted-evil' below.

(require 'crafted-defaults)    ; Sensible default settings for Emacs
(require 'crafted-updates)     ; Tools to upgrade Crafted Emacs
(require 'crafted-completion)  ; selection framework based on `vertico`
                                        ;(require 'crafted-ui)          ; Better UI experience (modeline etc.)
(require 'crafted-ide)
;; (require 'crafted-smtpmail)
;; (require 'crafted-mu4e)
(require 'crafted-python)
;; (require 'crafted-haskell)
;; (require 'crafted-latex)
(require 'crafted-windows)     ; Window management configuration
(require 'crafted-editing)     ; Whitspace trimming, auto parens etc.
(require 'crafted-evil)        ; An `evil-mode` configuration
(require 'crafted-org)         ; org-appear, clickable hyperlinks etc.
(require 'crafted-project)     ; built-in alternative to projectile
(require 'crafted-speedbar)    ; built-in file-tree
;; (require 'crafted-screencast)  ; show current command and binding in modeline
(require 'crafted-compile)     ; automatically compile some emacs lisp files
;; (require 'crafted-pdf-reader)
;; Set the default face. The default face is the basis for most other
;; faces used in Emacs. A "face" is a configuration including font,
;; font size, foreground and background colors and other attributes.
;; The fixed-pitch and fixed-pitch-serif faces are monospace faces
;; generally used as the default face for code. The variable-pitch
;; face is used when `variable-pitch-mode' is turned on, generally
;; whenever a non-monospace face is preferred.
(add-hook 'emacs-startup-hook
          (lambda ()
            (custom-set-faces
             `(default ((t (:font "agave Nerd Font Mono 14"))))
             `(fixed-pitch ((t (:inherit (default)))))
             `(fixed-pitch-serif ((t (:inherit (default)))))
             `(variable-pitch ((t (:font "agave Nerd Font Mono 14")))))))

;; Themes are color customization packages which coordinate the
;; various colors, and in some cases, font-sizes for various aspects
;; of text editing within Emacs, toolbars, tabbars and
;; modeline. Several themes are built-in to Emacs, by default,
;; Crafted Emacs uses the `deeper-blue' theme. Here is an example of
;; loading a different theme from the venerable Doom Emacs project.
(crafted-package-install-package 'doom-themes)
(crafted-package-install-package 'magit)
(crafted-package-install-package 'evil-snipe)
(evil-snipe-override-mode 1)
(crafted-package-install-package 'toc-org)
(progn
  (add-hook 'org-mode-hook 'toc-org-mode))

(progn
  (disable-theme 'deeper-blue)          ; first turn off the deeper-blue theme
  (load-theme 'doom-outrun-electric t)) ; load the doom-palenight theme

;; (crafted-package-install-package 'tron-legacy-theme)
;; (load-theme 'tron-legacy t)

;; (crafted-package-install-package 'nano-modeline)
;; (nano-modeline-mode 1)

;; Doom modeline mode
(doom-modeline-mode 1)

;;(customize-set-variable 'crafted-startup-inhibit-splash t)
;; To not load `custom.el' after `config.el', uncomment this line.
;; (setq crafted-load-custom-file nil)

;; Initialize `'org-agenda-files
(setq org-agenda-files '("/home/void/todo.org.gpg"))
;; Set custom `'org-agenda commands
(setq org-agenda-custom-commands
      '(("f" "List projects depending on feedback"
         tags "FEEDBACK")))

;; Prefer to have backup files in one speficific directory
(setq backup-directory-alist '((".*" . "~/.Trash")))

;; Allow gpg-agent to read from emacs' input
(setq epa-pinentry-mode 'loopback)

(setenv "PATH" (concat (getenv "PATH") ":/home/void/.local/bin/"))
(add-to-list 'load-path "/home/void/.local/bin/")

(crafted-package-install-package 'ligature)

(ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
;; Enables ligature checks globally in all buffers. You can also do it
;; per mode with `ligature-mode'.
(global-ligature-mode t)

(defun dired-open-file ()
  "In dired, opedn the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))

(define-key dired-mode-map (kbd "C-c o") 'dired-open-file)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(defun esh-history ()
      "Interactive search eshell history."
      (interactive)
      (require 'em-hist)
      (save-excursion
        (let* ((start-pos (eshell-bol))
           (end-pos (point-at-eol))
           (input (buffer-substring-no-properties start-pos end-pos)))
          (let* ((command (ivy-read "Command: "
                                (delete-dups
                                 (when (> (ring-size eshell-history-ring) 0)
                                   (ring-elements eshell-history-ring)))
                                :preselect input
                                :action #'ivy-completion-in-region-action))
             (cursor-move (length command)))
        (kill-region (+ start-pos cursor-move) (+ end-pos cursor-move))
        )))
      ;; move cursor to eol
      (end-of-line)
      )

(define-key global-map (kbd "C-c r") 'esh-history)

(global-set-key (kbd "C-<return>") 'shell-pop)

(crafted-package-install-package 'default-text-scale)
(default-text-scale-mode 1)

((lambda ()
  (crafted-package-install-package 'org-bullets)
  (add-hook 'org-mode-hook (lambda ()
                             (org-bullets-mode 1)))))
((lambda()
    (crafted-package-install-package 'which-key)
    (which-key-mode 1)))

((lambda ()
    (crafted-package-install-package 'anzu)
    (require 'anzu)
    (global-anzu-mode)
    (global-set-key (kbd "M-%") 'anzu-query-replace)
    (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)))

(add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode)))

;; (add-hook 'prog-mode-hook (lambda () (hs-minor-mode)))

(setq prettify-symbols-alist '(("\\" . 955)))

;; (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; (load-file "~/.emacs.d/cdlatex.el")
;; (require 'cdlatex)

(setenv "PATH" (concat (getenv "PATH") ":/home/void/lean-3.4.2-linux"))
(setq exec-path (append exec-path '("/home/void/lean-3.4.2-linux")))

(setq lean-rootdir "/home/void/lean-3.4.2-linux")

(setenv "LEAN_PATH" "/home/void/lean-3.4.2-linux/lib/lean/library/")

(crafted-package-install-package 'direnv)
(direnv-mode)

(crafted-package-install-package 'projectile)
(crafted-package-install-package 'undo-tree)
(global-undo-tree-mode)

;;store org-mode links to messages
;; (require 'org-mu4e)
;;store link to message if in header view, not to header query
(setq org-mu4e-link-query-in-headers-mode nil)

(setq org-capture-templates
      '(("t" "todo" entry (file+headline "~/todo.org.gpg" "Tasks")
         "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")))
(with-eval-after-load "eglot"
  (add-to-list 'eglot-server-programs '(awk-mode "awk-language-server")))

(with-eval-after-load "eglot"
  (add-to-list 'eglot-server-programs '(lua-mode "/home/void/dev/lua-language-server/bin/lua-language-server")))

;; org-mode pretty tables
;; (progn
;;   (add-to-list 'load-path "~/.emacs.d/site-lisp")
;;   (require 'org-pretty-table)
;;   (add-hook 'org-mode-hook (lambda () (org-pretty-table-mode))))

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

(add-to-list 'load-path
              "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)


(crafted-package-install-package 'all-the-icons)
(crafted-package-install-package 'all-the-icons-dired)
;; (org-roam-db-autosync-mode)

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

  ;; example-config.el ends here
