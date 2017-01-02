;;; package --- Summary
;; tidal interaction with haskell-interactive-process
;; based upon standard tidal setup replacing inferior haskell process

;;; Commentary:

;; this will hopefully be a better experience within Emacs than inferior haskell process.

;;; Code:
(require 'tidal)

(defvar tidal-i-session nil)
(defvar tidal-i-process nil)

(defun tidal-i-start ()
  "Start an interactive tidal session."
  (interactive)
  (setq tidal-i-session (haskell-session-make "Tidal Interactive"))
  (setq tidal-i-process (haskell-process-start tidal-i-session))
  )

(defun tidal-i-stop ()
  "Stop the interactive tidal session."
  (interactive)
;;  (delete-process tidal-i-process)
  (haskell-session-kill tidal-i-session)
  (setq tidal-i-session nil)
  (setq tidal-i-process nil)
  )
(defun tidal-i-run-multiple-lines ()
  "Run multiple lines in interactive process."
  (interactive)
  (mark-paragraph)
  (let* ((s (buffer-substring-no-properties (region-beginning)
                                            (region-end)))
         (s* (if tidal-literate-p
                 (tidal-unlit s)
               s)))
  ;;  (tidal-i-send-string ":{")
    (tidal-i-send-string s*)
;;    (tidal-i-send-string ":}")
    (mark-paragraph)
    (pulse-momentary-highlight-region (mark) (point))
    ))

(defun tidal-i-send-string (s)
  (haskell-process-send-string tidal-i-process s)
  )

(provide 'tidal-interactive)
;;; tidal-interactive ends here
