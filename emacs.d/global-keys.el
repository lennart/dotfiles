;;; global-keys.el --- Summary

;;; Commentary:

;;; Code:


(global-set-key [M-end] 'set-font-size-small)
(global-set-key [M-insert] 'set-font-size-base)
(global-set-key [M-home] 'set-font-size-large)

;; multiple cursors, a la sublime
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
(global-set-key (kbd "C-?") 'mc/mark-all-like-this)
(global-set-key (kbd "C-|") 'mc/edit-lines)

;; js code-folding
;; (eval-after-load 'js-mode
;;   '(define-key js-mode-map (kbd "C-c C-f") 'js2-mode-toggle-element))

(provide 'global-keys)
;;; global-keys.el ends here
