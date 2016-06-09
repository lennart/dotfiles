;;; package --- Summary

;;; Commentary:


;;; Code:

(when (> emacs-major-version 23)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("marmalade" .
                 "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/")
               'APPEND))

;; Imports

(add-to-list 'load-path "~/tidal/emacs")

(setenv "PATH" (concat (getenv "PATH") ":/home/m/bin:/home/m/.cabal/bin"))
(setq exec-path (append exec-path '("/home/m/bin"
                                    "/home/m/.cabal/bin")))

(require 'flycheck)
(require 'yasnippet)
(require 'auto-complete-config)
(require 'tidal)
;; (require 'daumenkino)
;; (require 'load-synths)
(require 'cc-mode)
(require 'icicles)
(require 'hindent)
(require 'haskell-mode)
(require 'sclang)
(require 'web-mode)
(require 'css-mode)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

(ac-config-default)

;; Commands

(setq tidal-interpreter "/usr/bin/ghci")
(setq-default css-comb-executable "/usr/local/bin/csscomb")
(setq-default hs-lint-command "~/.cabal/bin/hlint -h Default -h ~/.local/hlint")


;; Functions

;; (defun toggle-window-split ()
;;   (interactive)
;;   (if (= (count-windows) 2)
;;       (let * ((this-win-buffer (window-buffer))
;;               (next-win-buffer (window-buffer (next-window)))
;;               (this-win-edges (window-edges (selected-window)))
;;               (next-win-edges (window-edges (next-window)))
;;               (this-win-2nd (not (and (<= (car this-win-edges)
;;                                           (car next-win-edges))
;;                                       (<= (cadr this-win-edges)
;;                                           (cadr next-win-edges)))))
;;               (splitter
;;                (if (= (car this-win-edges)
;;                       (car (window-edges (next-window))))
;;                    'split-window-horizontally
;;                  'split-window-vertically)))
;;            (delete-other-windows)
;;            (let ((first-win (selected-window)))
;;              (funcall splitter)
;;              (if this-win-2nd (other-window 1))
;;              (set-window-buffer (selected-window) this-win-buffer)
;;              (set-window-buffer (next-window) next-win-buffer)
;;              (select-window first-win)
;;              (if this-win-2nd (other-window 1))))))

;; (define-key ctl-x-4-map "t" 'toggle-window-split)




(defun align-to-equals (begin end)
"BEGIN Align region to equal signs.
END"
   (interactive "r")
   (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))


;;(defcustom simple-synth "SimpleSynth virtual input"
;;   "The simplest synth"
;;  :type 'string)

(defvar auto-minor-mode-alist ()
  "A list of filename patterns vs correpsonding minor mode functions.
see `auto-mode-alist'.  All elements of this alist are checked,
meaning you can enable multiple minor modes for the same regexp.")

(defun enable-minor-mode-based-on-extension ()
  "Check file name against auto-minor-mode-alist to enable minor modes.
The checking happens for all pairs in auto-minor-mode-alist"
  (when buffer-file-name
    (let ((name buffer-file-name)
          (remote-id (file-remote-p buffer-file-name))
          (alist auto-minor-mode-alist))
      ;; Remove backup-suffixes from file name.
      (setq name (file-name-sans-versions name))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match (caar alist) name)
            (funcall (cdar alist) 1))
        (setq alist (cdr alist))))))



;; Hooks

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook #'hindent-mode)

(add-hook 'find-file-hook 'enable-minor-mode-based-on-extension)



;; Settings

(setq-default haskell-hoogle-command "hoogle")

(setq inhibit-startup-message t)
(setq c-default-style "bsd"
      c-basic-offset 2)

(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(setq-default js-indent-level 2)
(setq-default css-indent-offset 2)


(setq-default flycheck-emacs-lisp-load-path load-path)

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)
                      '(haskell-stack-ghc)))

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(json-jsonlist)))

(setq-default flycheck-temp-prefix ".flycheck")

(flycheck-add-mode 'javascript-eslint
                   'web-mode)



;; Custom vars


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-mode-hook
   (quote
    (turn-on-haskell-indent turn-on-haskell-indentation)) t)
 '(haskell-program-name "/usr/local/bin/ghci")
 '(hindent-style "johan-tibell")
 '(safe-local-variable-values
   (quote
    ((haskell-indent-spaces . 4)
     (haskell-process-use-ghci . t)
     (hamlet/basic-offset . 4)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Modes

(global-auto-revert-mode t)

(ace-popup-menu-mode 1)

(menu-bar-mode -1)

(icy-mode 1)

(yas-global-mode 1)

;; Alarms off

(setq ring-bell-function 'ignore)


;; Shortcuts

;(global-set-key (kbd "TAB") 'dabbrev-expand)

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



(define-key haskell-mode-map "\C-ch" 'haskell-hoogle)
(define-key haskell-mode-map "\C-ci" 'haskell-navigate-imports)
(define-key haskell-mode-map "\C-c." 'haskell-align-imports)





;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
;; Trim trailing whitespace on save
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)


(add-to-list 'auto-mode-alist '("\\.frag\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . c-mode))


(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-c C-p") 'yas-expand)
(define-key yas-minor-mode-map (kbd "C-c C-i") 'yas/insert-snippet)

(define-key sclang-mode-map (kbd "C-c C-s") 'sclang-start)
(define-key sclang-mode-map (kbd "C-c C-q") 'sclang-stop)
(define-key sclang-mode-map (kbd "C-c C-v") 'sclang-show-post-buffer)


(defun my-web-mode-hook ()
"BEGIN Hooks for Web mode.
Adjusts indentation.
END"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'my-web-mode-hook)

;; No modifier on right alt (for compose)
(setq-default ns-right-alternate-modifier nil)

;; After Load

(eval-after-load 'css-mode
            '(define-key css-mode-map (kbd "C-c C-x c") 'css-comb))



(provide '.emacs)
;;; .emacs ends here
