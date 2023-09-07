;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(require 's)
(setq process (r2-pipe-new "/home/void/dev/HeapLAB/.glibc/glibc_2.30_no-tcache/libc.so.6"))

(defgroup r2pipe nil
  "Run and interact with radare2 under Emacs."
  :prefix "r2pipe-"
  :group 'tools)

(defcustom r2-bin-path "/usr/bin/r2"
  "The path to the radare2 program.")

(setq latest-output nil)

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

(setq r2pipe (r2open"/home/void/dev/HeapLAB/.glibc/glibc_2.30_no-tcache/libc.so.6"))

(defun r2pipe-find-string (str)
  (cdr (assoc 'offset (json-read-from-string (s-replace "]" "" (s-replace "[" "" (r2cmd r2pipe (format "/j %s" str))))))))

(defun r2pipe-clean-json (str)
  (s-replace "[" "" (s-replace "]" "" str)))

(defun r2pipe-find-xrefs (data)
  (r2cmd-json r2pipe (format "axtj @ %s" data)))

(setq binsh (r2pipe-find-string "/bin/sh"))

(r2cmd r2pipe "aaa")
(setq xrefs (r2pipe-find-xrefs binsh))

(json-read-from-string (r2pipe-clean-json xrefs))


latest-output
