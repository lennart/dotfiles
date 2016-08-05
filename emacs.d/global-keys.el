(global-set-key (kbd "M-p") 'imenu)

;; Multiple Cursors



(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c <") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c l") 'mc/mark-more-like-this-extended)

;; ...

(global-set-key (kbd "C-c C-}") 'org-publish-project)

(global-set-key (kbd "C-,") 'indent-region)
(global-set-key (kbd "C-c p") 'imenu)
(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-?") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c ]") 'rotate-layout)
(global-set-key (kbd "C-c [") 'rotate-window)


(global-set-key (kbd "C-c \\") 'mark-paragraph)
(global-set-key (kbd "C-c |") 'duplicate-paragraph)


(provide 'global-keys)
