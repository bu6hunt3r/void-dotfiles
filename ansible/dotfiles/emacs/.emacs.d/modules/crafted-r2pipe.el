;;; crafted-r2pipe.el --- r2pipe support for emacs   -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Void User

;; Author: Void User <void@faulobst>
;; Keywords: tools

(require 'json)
(require 'seq)

(defgroup r2pipe nil
  "Run and interact with radare2 under Emacs."
  :prefix "r2pipe-"
  :group 'tools)

(defcustom r2-bin-path "/usr/bin/r2"
  "The path to the radare2 program.")

(defun r2--copy-output-filter (process output)
  (setq latest-output output))


(defun r2open (file)
  (make-process :name "r2pipe" :inbuffer "r2pipe"
                :command (list r2-bin-path "-q0" file)
                :connection-type 'pipe
                :filter 'r2--copy-output-filter
                :stderr (get-buffer-create " r2-stderr")))

(defun r2cmd (process cmd)
  (r2write process cmd)
  (sit-for 0.5)
  latest-output)

(defun r2cmd-json (process cmd)
  (json-read-from-string (r2cmd process cmd)))

(defun r2write (process cmd)
  (process-send-string process (concat cmd "\n")))

(defun r2pipe-find-string (process str)
  (cdr  (assoc 'offset (aref (r2cmd-json process (format "/j %s" str)) 0))))

(defun r2pipe-output-to-buffer (out)
  "Will write the ouptput of an r2pipe command to a newly created buffer."
  (with-output-to-temp-buffer (get-buffer-create "r2pipe-output")
    (print out)))

(defun r2pipe-find-xrefs (process obj-addr)
  (r2cmd-json process (format "axtj @ %s" obj-addr)))

(defun r2pipe-return-gadgets (xrefs &optional gadget)
  (unless gadget (setq gadget "lea rdi"))
    (mapcar (lambda (e) (cdr (assoc 'from e)))
            (seq-filter (lambda (elem)
                          (string-match-p gadget (cdr (assoc 'opcode elem)))) xrefs)))

(defun r2pipe-one-gadgets (process &optional str gadget)
  (unless str (setq str "/bin/sh"))
  (unless gadget (setq gadget "lea rdi"))
  (let ((xrefs))
    (setq binsh (r2pipe-find-string process str))
    (setq xrefs (r2pipe-find-xrefs process binsh))
    (setq gadgets (r2pipe-return-gadgets xrefs gadget))
    )
  gadgets)


(defun r2pipe--get-insns-until-call (process offset)
  (progn
    (r2pipe-output-to-buffer
     (r2cmd r2pipe (format "pduc @ %s" offset))
     )
    (setq num_insns (- (with-current-buffer "r2pipe-output"
                         (count-lines (point-min) (point-max))) 2))))

(defun r2pipe-analyze-reg-writes (process offset)
  (r2cmd process (format "aeaw 1 @ %s" offset)))

(defun r2pipe-analyze-reg-reads (process offset)
  (r2cmd process (format "aear 1 @ %s" offset)))


(defvar r2pipe-calling-conventions
      '((:x86 rdi rsi)
        (:arm asdasd)))

(cdr (assoc :x86 r2pipe-calling-conventions))
(let ((r2pipe-calling-conventions '((:arm2 osd))))
  (cdr (assoc :x86 r2pipe-calling-conventions)))

(defun r2pipe-cc-register-p (arch reg)
  (let ((regs (cdr (assoc arch r2pipe-calling-conventions))))
    (when regs
      (member reg regs))))
(r2pipe-cc-register-p :x86 'rdx)

(defun r2pipe-kill (process)
  "Kills r2"
  (kill-process process))

(defun r2pipe-close (process)
  "Closes r2"
  (process-send-string process "q!!\n"))

(provide 'crafted-r2pipe)
