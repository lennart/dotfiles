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
                                    )))
; generics
(require 'ido)
(require 'flycheck)
(require 'yasnippet)
(require 'auto-complete-config)
(require 'cc-mode)
(require 'icicles)
; specifics
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
(defun align-to-equals (begin end)
"BEGIN Align region to equal signs.
END"
   (interactive "r")
   (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))
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
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(add-hook 'haskell-mode-hook #'hindent-mode)
(add-hook 'find-file-hook 'enable-minor-mode-based-on-extension)
;; Settings
(setq inhibit-startup-message t)
(setq-default tab-width 2)
(setq-default flycheck-emacs-lisp-load-path load-path)
(setq c-default-style "bsd"
      c-basic-offset 2)
(defvaralias 'c-basic-offset 'tab-width)
(setq-default js-indent-level 2)
(setq-default css-indent-offset 2)

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
;; Modes
(desktop-save-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-auto-revert-mode t)
(projectile-global-mode)
(ace-popup-menu-mode 1)
(ido-mode t)
(ido-everywhere 1)
(flx-ido-mode 1)
(icy-mode 1)
(yas-global-mode 1)
;; FLX IDO Setup
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
;; Alarms off
(setq ring-bell-function 'ignore)
;;(define-key haskell-mode-map "\C-ch" 'haskell-hoogle)
;;(define-key haskell-mode-map "\C-ci" 'haskell-navigate-imports)
;;(define-key haskell-mode-map "\C-c." 'haskell-align-imports)
;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
;; Trim trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-c C-p") 'yas-expand)
(define-key yas-minor-mode-map (kbd "C-c C-i") 'yas/insert-snippet)
;;(define-key sclang-mode-map (kbd "C-c C-s") 'sclang-start)
;;(define-key sclang-mode-map (kbd "C-c C-q") 'sclang-stop)
;;(define-key sclang-mode-map (kbd "C-c C-v") 'sclang-show-post-buffer)
(add-to-list 'auto-mode-alist '("\\.frag\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


(defun my-web-mode-hook ()
"BEGIN Hooks for Web mode.
Adjusts indentation.
END"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-auto-quote-style 2)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook 'my-web-mode-hook)

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tag\\'" . web-mode))


(let ((checkers (get 'javascript-eslint 'flycheck-next-checkers)))
  (put 'javascript-eslint 'flycheck-next-checkers
       (remove '(warning . javascript-jscs) checkers)))


;; No modifier on right alt (for compose)
(setq-default ns-right-alternate-modifier nil)
;; After Load
(eval-after-load 'css-mode
            '(define-key css-mode-map (kbd "C-c C-x c") 'css-comb))

(defun set-font-size-small ()
  "Set small font size"
  (interactive)
  (set-face-attribute 'default nil :height 120)
  )

(defun set-font-size-base ()
  "Set base font size"
  (interactive)
  (set-face-attribute 'default nil :height 240)
  )

(defun set-font-size-large ()
  "Set large font size"
  (interactive)
  (set-face-attribute 'default nil :height 420)
  )

(provide '.emacs)
;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight extra-light :height 223 :width normal :foundry "ADBO" :family "Source Code Pro")))))
;; Custom vars
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(haskell-mode-hook
   (quote
    (turn-on-haskell-indent turn-on-haskell-indentation)))
 '(haskell-program-name "/usr/local/bin/ghci")
 '(hindent-style "johan-tibell")
 '(package-selected-packages
   (quote
    (json-mode js2-mode hideshowvis rainbow-mode dockerfile-mode minimap terraform-mode rust-mode ## yasnippet yaml-mode web-mode solarized-theme scss-mode sass-mode rvm ruby-dev rinari rhtml-mode projectile multiple-cursors mc-jump markdown-mode icicles helm haskell-mode go-mode flycheck flx-ido emmet-mode company coffee-mode auto-complete angular-mode ace-window ace-popup-menu)))
 '(pulse-flag t)
 '(safe-local-variable-values
   (quote
    ((tidal-interpreter-arguments "repl" "--ghci-options=-XOverloadedStrings" "tidal" "tidal-midi")
     (tidal-interpreter-arguments "repl" "--ghci-options=-XOverloadedStrings" "--no-load")
     (tidal-interpreter-arguments "repl" "--ghci-options=-XOverloadedStrings")
     (tidal-interpreter-arguments "repl" "--ghci-options='-XOverloadedStrings'")
     (tidal-interpreter-arguments "repl" "--ghci-options" "'-XOverloadedStrings'")
     (tidal-interpreter-arguments "repl" "-XOverloadedStrings")
     (tidal-interpreter-arguments list "repl" "-XOverloadedStrings")
     (tidal-interpreter-arguments . "repl")
     (tidal-interpreter . "/usr/bin/stack")
     (tidal-interpreter . "/usr/bin/stack repl")
     (tidal-interpreter . "stack repl")
     (tidal-interpreter . "/home/l/.stack/programs/x86_64-linux/ghc-8.0.1/bin/ghci")
     (eval setq haskell-program-name "/home/l/.stack/programs/x86_64-linux/ghc-8.0.1/bin/ghci")
     (haskell-indent-spaces . 4)
     (haskell-process-use-ghci . t)
     (hamlet/basic-offset . 4)))))
