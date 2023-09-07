;;; crafted-r2pipe.el --- r2pipe support for emacs   -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Void User

;; Author: Void User <void@faulobst>
;; Keywords: tools

(require 'json)
(require 'seq)

;; Temporary storage for r2 process std output
(setq r2-pipe-out-string nil)

(defun r2-pipe-filter (process output)
  "This filter callback is used by emacs whenever a process has output"
  (setq r2-pipe-out-string (concat r2-pipe-out-string output)))

(defun r2-pipe-new (cmdline)
  "Spawn r2 with cmdline and return process object on success or nil on failure"
  (let ((process (start-process "radare2" nil "r2" "-q0" cmdline)))
    (if (equal (process-status process) 'run)
      (progn (set-process-filter process 'r2-pipe-filter) process)
      nil)))

(defun r2-cmd (process command)
  "Executes an r2 command and returns output to string"
  (setq r2-pipe-out-string nil)
  (process-send-string process (format "%s\n" command))
  (accept-process-output process)
  r2-pipe-out-string)

(defun r2-cmd-json (process command)
  "Executes a json r2 command and returns output in an elisp object"
  (json-read-from-string (r2-cmd process command)))


(defun r2-pipe-output-to-string (out)
  "Formats the result of r2pipe output into human readable string."
  (let (result)
    (mapc (lambda (o)
            (setq result
                  (concat result
                          (format "%s \n" (cdr (assoc 'opcode o)))
                          ) )) out))
  result)

(defun r2-pipe-output-to-buffer (out)
  "Will write the ouptput of an r2pipe command to a newly created buffer."
  (with-current-buffer (get-buffer-create "r2pipe-output")
    (insert (output-to-string out))))
(defun r2-pipe-close (process)
  "Closes r2"
  (process-send-string process "q!!\n"))

(defun r2-kill (process)
  "Kills r2"
  (kill-process process))

(provide 'r2pipe)
