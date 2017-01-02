(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 3)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(run-at-time nil (* 5 60) 'recentf-save-list)



(provide 'recent)