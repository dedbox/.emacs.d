(add-to-list 'load-path "~/.emacs.d/lisp")

;; package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(setq package-enable-at-startup nil)

;; use-package
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)
(require 'bind-key)

;; defaults
(use-package better-defaults :ensure t)
(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq initial-scratch-message nil)
(setq sentence-end-double-space nil)
(setq recenter-positions '(.29 .71 top bottom))
(setq ring-bell-function 'ignore)
(setq-default x-stretch-cursor t)
(setq-default fill-column 78)
(setq browse-url-browser-function 'browse-url-chromium)
(setq split-height-threshold nil)
(setq split-width-threshold 160)

;; unbind C-Z in GUI
(when (display-graphic-p)
  (global-unset-key [(control z)])
  (global-unset-key [(control x) (control z)]))

;; fonts
(set-frame-font
 (pcase system-name
   ;; ("walden" "Roboto Mono 9")
   ("walden" "Roboto Mono 11")
   ("wubbzy" "Roboto Mono 12")
   ("zim" "Roboto Mono 10")
   (_ "InputMono:size=14"))
 nil t)

;; theme
(use-package material-theme :ensure t)

;; buffer names
(use-package uniquify
  :config (setq uniquify-buffer-name-style 'post-forward))

;; ido
;; (use-package ido :ensure t :config (ido-mode t))
;; (use-package ido-hacks :ensure t)

;; smex
(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command))
  :config (smex-initialize))

;; folding
(use-package origami
  :ensure t
  :bind (("C-z C-z" . origami-toggle-node)
         ("C-z C-a" . origami-toggle-all-nodes)))

;; flycheck
;; (use-package flycheck
;;   :ensure t
;;   :config (global-flycheck-mode))

;; company
;; (use-package company
;;   :ensure t
;;   :config (global-company-mode))

;; org-mode
(use-package visual-fill-column :ensure t)
(use-package htmlize :ensure t)
(use-package org
  :ensure t
  :config (progn
            (add-hook 'org-mode-hook 'visual-line-mode)
            (add-hook 'org-mode-hook 'visual-fill-column-mode)
            (setq org-log-done 'time)
            (setq fill-column 70)))

;; Enable Racket in Org-mode Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((racket . t)))

;; racket
(use-package racket-mode
  :ensure t
  :config (progn
            (mapc
             (lambda (x) (bind-key (car x) (cdr x)))
             '(("C-c a" . "α")
               ("C-c b" . "β")
               ("C-c g" . "γ") ("C-c G" . "Γ")
               ("C-c d" . "δ") ("C-c D" . "Δ")
               ("C-c e" . "ε")
               ("C-c z" . "ζ")
               ("C-c y" . "θ")
               ("C-c l" . "λ") ("C-c L" . "Λ")
               ("C-c m" . "μ")
               ("C-c x" . "ξ")
               ("C-c p" . "π") ("C-c P" . "Π")
               ("C-c r" . "ρ")
               ("C-c t" . "τ")
               ("C-c f" . "φ") ("C-c F" . "Φ")
               ("C-c X" . "Ξ") ("C-c Y" . "Θ")
               ("C-c s" . "σ") ("C-c S" . "Σ")
               ("C-c F" . "Φ") ("C-c O" . "Ω")
               ("C-c E" . "∃") ("C-c A" . "∀")
               ("C-c ;" . "ℓ") ("C-c :" . "◊")
               ("C-k" . paredit-kill)))
            (put 'set! 'racket-indent-function 'defun)
            (put 'set-field! 'racket-indent-function 2)
            (put 'for/foldr 'racket-indent-function 'racket--indent-for/fold)
            (put 'struct-copy 'racket-indent-function 2)
            (put 'place 'racket-indent-function 1)
            (put 'syntax/loc/props 'racket-indent-function 1)
            (put 'property 'racket-indent-function 1)
            (put 'data 'racket-indent-function 0)
            (put 'do 'racket-indent-function 0)
            (put 'do~ 'racket-indent-function 0)
            (put 'φ 'racket-indent-function 1)
            (put 'phi 'racket-indent-function 1)
            (put 'function 'racket-indent-function 0)
            (put 'φ* 'racket-indent-function 1)
            (put 'phi* 'racket-indent-function 1)
            (put 'function* 'racket-indent-function 0)
            (put 'μ 'racket-indent-function 1)
            (put 'mu 'racket-indent-function 1)
            (put 'macro 'racket-indent-function 0)
            (put 'μ* 'racket-indent-function 1)
            (put 'mu* 'racket-indent-function 1)
            (put 'macro* 'racket-indent-function 0)
            (put 'let-data 'racket-indent-function 1)
            (put 'instance 'racket-indent-function 2)
            (put 'with-instance 'racket-indent-function 1)
            (put 'with-instances 'racket-indent-function 1)
            (put 'splicing-with-instance 'racket-indent-function 1)
            (put 'splicing-with-instances 'racket-indent-function 1)
            (put 'case-λ 'racket-indent-function 1)
            (put 'case-values 'racket-indent-function 1)
            (put 'algebraic-λ 'racket-indent-function 1)
            (put 'algebraic-lambda 'racket-indent-function 1)
            (put 'algebraic-case-λ 'racket-indent-function 0)
            (put 'algebraic-case-lambda 'racket-indent-function 0)
            (put 'algebraic-let 'racket-indent-function 'racket--indent-maybe-named-let)
            (put 'algebraic-let* 'racket-indent-function 1)
            (put 'algebraic-letrec 'racket-indent-function 1)
            (put 'algebraic-let-values 'racket-indent-function 1)
            (put 'algebraic-let*-values 'racket-indent-function 1)
            (put 'algebraic-letrec-values 'racket-indent-function 1)
            (put 'algebraic-case 'racket-indent-function 1)
            (put 'algebraic-case-values 'racket-indent-function 1)
            (put 'algebraic-define 'racket-indent-function 'defun)
            (put 'lazy-do 'racket-indent-function 0)
            (put 'truthy-do 'racket-indent-function 0)
            (put (intern "#%rewrite") 'racket-indent-function 1)
            (put 'newtype 'racket-indent-function 1)
            (put 'let-instance 'racket-indent-function 2)
            (put 'GL> 'racket-indent-function 0)
            (put 'GL>> 'racket-indent-function 0)
            (put 'maybe-parameterize 'racket-indent-function 1)))

;; scribble
(use-package scribble-mode :ensure t)

;; paredit
(use-package paredit
  :config (progn
            (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
            (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
            (add-hook 'racket-mode-hook #'enable-paredit-mode)))

;; haskell
(use-package haskell-mode :ensure t)

;; templates
(use-package yasnippet
  :ensure t
  :config (progn
            (yas-reload-all)
            (add-hook 'snippet-mode-hook 'flyspell-mode-off)
            (add-hook 'prog-mode-hook #'yas-minor-mode)
            (add-hook 'racket-mode-hook #'yas-minor-mode)))

;; git
(use-package magit :ensure t)

(use-package forge :ensure t :after magit)

;; ;; Encryption
;; (use-package epa-file :config (epa-file-enable))

;; ;; Pollen
;; (use-package pollen-mode :ensure t)

;; Latex
(use-package auctex
  :defer t
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :init (progn
            (setq TeX-view-program-list '(("Zathura" "/usr/bin/zathura %o")))
            (setq TeX-view-program-selection '((output-pdf "Zathura"))))
  :config (progn
            (setq TeX-auto-save t)
            (setq TeX-parse-self t)
            (setq-default TeX-master "master")))

(use-package reftex
  :ensure t
  :bind ("C-c C-g" . reftex-goto-label)
  :config (progn
            (setq reftex-plug-into-AUCTeX t)
            (add-hook 'LaTeX-mode-hook #'turn-on-reftex)))

(use-package bibtex
  :config (progn
            (setq bibtex-align-at-equal-sign t)
            (add-hook 'bibtex-mode-hook (lambda () (set-fill-column 120)))))

;; C++
(use-package modern-cpp-font-lock
  :ensure t
  :config (add-hook 'c++-mode-hook 'origami-mode))

;; ;; Python
;; (use-package elpy
;;   :ensure t
;;   :init (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;;   :config (progn
;;             (when (require 'flycheck nil t)
;;               (remove-hook 'elpy-modules 'elpy-module-flymake)
;;               (remove-hook 'elpy-modules 'elpy-module-yasnippet)
;;               (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
;;               (add-hook 'elpy-mode-hook 'flycheck-mode))
;;             (elpy-enable)
;;             ;; (elpy-use-ipython)
;;             (setq elpy-rpc-backend "jedi")
;;             (setq elpy-rpc-timeout 1)))

;; (use-package py-autopep8 :ensure t)

;; ;; YAML
;; (use-package yaml-mode
;;   :ensure t
;;   :config (progn
;;             (add-hook 'yaml-mode-hook 'flyspell-mode-off)
;;             (add-hook 'yaml-mode-hook 'flycheck-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" default)))
 '(package-selected-packages
   (quote
    (origami modern-cpp-font-lock edit-indirect forge htmlize visual-fill-column haskell-mode org id yaml-mode use-package smex scribble-mode racket-mode py-autopep8 pollen-mode material-theme magit ido-hacks geiser elpy better-defaults auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
