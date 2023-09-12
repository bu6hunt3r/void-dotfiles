;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(require 's)

(defgroup r2pipe nil
  "Run and interact with radare2 under Emacs."
  :prefix "r2pipe-"
  :group 'tools)

(defcustom r2-bin-path "/usr/bin/r2"
  "The path to the radare2 program.")

(setq latest-output nil)

(setq json-object-type 'plist
      json-array-type 'list)

(defun r2--copy-output-filter (process output)
  (setq latest-output output))

(defun r2open (file)
  (make-process :name "r2pipe" :buffer "r2pipe"
                :command (list r2-bin-path "-q0" file)
                :connection-type 'pipe
                :filter 'r2--copy-output-filter
                :stderr (get-buffer-create " r2-stderr")))

(defun r2write (process cmd)
  (process-send-string process (concat cmd "\n")))

(defun r2cmd (process cmd)
  (r2write process cmd)
  (sit-for 0.5)
  latest-output)

(defun r2cmd-json (process cmd)
  (json-read-from-string (r2cmd process cmd)))

(defun r2pipe-find-string (process str)
  (plist-get (car (r2cmd-json process (format "/j %s" str))) :offset))


(defun r2pipe-find-xrefs (process obj-addr)
  (r2cmd-json process (format "axtj @ %s~lea rdi" obj-addr)))

(defun r2pipe-search-magic-gadgets (xrefs)
  (seq-filter (lambda (elem) (string-prefix-p "lea rdi" (plist-get elem :opcode))) xrefs))

(defun r2pipe-offset-magic-gadgets (gadgets)
  (setq offsets (mapcar (lambda (elem) (plist-get elem :from)) gadgets))
  offsets)

(defun r2pipe-disassemble-gadget (process offset)
  (setq result (r2cmd-json process (format "pducj @ %s" offset)) result))

(defun r2pipe-magic-gadgets (process)
  (progn
    (setq binsh (r2pipe-find-string process "/bin/sh"))
    (setq xrefs (r2pipe-find-xrefs process binsh))
    (setq magic-gadgets (r2pipe-search-magic-gadgets xrefs))
    (setq offsets (r2pipe-offset-magic-gadgets magic-gadgets)))
  offsets)

  ;; EXAMPLE
;;  (format "axtj @ %s~lea rdi" binsh)
;; (setq r2pipe (r2open"/home/void/dev/HeapLAB/.glibc/glibc_2.30_no-tcache/libc.so.6"))

;; (r2cmd r2pipe "aaa")

;; (r2cmd-json r2pipe "/j /bin/sh")

;; (setq binsh (r2pipe-find-string r2pipe "/bin/sh"))

;; (setq xrefs (r2pipe-find-xrefs r2pipe binsh))

;; (setq potential-gadgets (r2pipe-search-magic-gadgets xrefs))

;; (setq offsets (r2pipe-offset-magic-gadgets potential-gadgets))

;; (plist-get (setq first (r2pipe-disassemble-gadget r2pipe (car offsets))) :text)

;; (setq disassembly (r2pipe-disassemble-gadget r2pipe (car offsets)))

;; (r2pipe-magic-gadgets r2pipe)
