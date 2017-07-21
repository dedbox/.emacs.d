(add-to-list 'load-path "~/.emacs.d/lisp")

;; package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'diminish)
(require 'bind-key)

;; Emacs
(use-package better-defaults :ensure t)
(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq initial-scratch-message nil)
(setq sentence-end-double-space nil)
(setq recenter-positions '(.29 .71 top bottom))
(setq ring-bell-function 'ignore)
(setq-default x-stretch-cursor t)
(setq-default fill-column 78)

(set-frame-font
 (pcase system-name
   ("walden" "Inconsolata LGC 8")
   (_ "Inconsolata LGC 11")))

(use-package material-theme :ensure t)

;; unbind C-Z in GUI
(when (display-graphic-p)
  (global-unset-key [(control z)])
  (global-unset-key [(control x) (control z)]))

;; Text
(use-package flyspell :ensure t)

;; Code
(use-package flycheck :ensure t)

;; Parentheses
(use-package paredit
  :diminish ""
  :config
  (progn
    (add-hook 'emacs-lisp-mode-hook                  #'enable-paredit-mode)
    (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
    (add-hook 'ielm-mode-hook                        #'enable-paredit-mode)
    (add-hook 'lisp-mode-hook                        #'enable-paredit-mode)
    (add-hook 'lisp-interaction-mode-hook            #'enable-paredit-mode)))

;; Git
(use-package magit :ensure t :defer 2)

;; Racket
(use-package quack :ensure t)

(use-package geiser
  :ensure t
  :bind (("C-c a" . "α")
         ("C-c b" . "β")
         ("C-c g" . "γ") ("C-c Y" . "Θ")
         ("C-c d" . "δ") ("C-c D" . "Δ")
         ("C-c e" . "ε")
         ("C-c z" . "ζ")
         ("C-c y" . "θ")
         ("C-c l" . "λ") ("C-c L" . "Λ")
         ("C-c m" . "μ")
         ("C-c x" . "ξ")
         ("C-c p" . "π") ("C-c P" . "Π")
         ("C-c r" . "ρ")
         ("C-c f" . "φ") ("C-c F" . "Φ")
         ("C-c X" . "Ξ") ("C-c S" . "Σ")
         ("C-c F" . "Φ") ("C-c O" . "Ω")
         ("C-c E" . "∃") ("C-c A" . "∀")
         :map geiser-repl-mode-map
         ("C-c a" . "α")
         ("C-c b" . "β")
         ("C-c g" . "γ") ("C-c Y" . "Θ")
         ("C-c d" . "δ") ("C-c D" . "Δ")
         ("C-c e" . "ε")
         ("C-c z" . "ζ")
         ("C-c y" . "θ")
         ("C-c l" . "λ") ("C-c L" . "Λ")
         ("C-c m" . "μ")
         ("C-c x" . "ξ")
         ("C-c p" . "π") ("C-c P" . "Π")
         ("C-c r" . "ρ")
         ("C-c f" . "φ") ("C-c F" . "Φ")
         ("C-c X" . "Ξ") ("C-c S" . "Σ")
         ("C-c F" . "Φ") ("C-c O" . "Ω")
         ("C-c E" . "∃") ("C-c A" . "∀"))
  :config (progn (add-hook 'scheme-mode-hook      #'enable-paredit-mode)
                 (add-hook 'geiser-repl-mode-hook #'enable-paredit-mode)
                 (mapc (lambda (x)
                         (put (car x) 'scheme-indent-function (cdr x)))
                       '((forever . 0)))))

;; Latex
(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :config (progn (add-hook 'LaTeX-mode-hook #'turn-on-reftex)
                 (setq TeX-auto-save t)
                 (setq TeX-parse-self t)
                 (add-to-list 'TeX-view-program-list
                              '(preview-pane-mode latex-preview-pane-mode))
                 (setq-default TeX-master "master")))

(use-package reftex
  :ensure t
  :config (progn (setq reftex-plug-into-AUCTeX t)))

(use-package bibtex
  :config (progn (setq bibtex-align-at-equal-sign t)
                 (add-hook 'bibtex-mode-hook (lambda () (set-fill-column 120)))))

(use-package latex-preview-pane :ensure t)

;; Python
(use-package elpy
  :ensure t
  :defer 2
  :init (progn (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))
  :config (progn (when (require 'flycheck nil t)
                   (remove-hook 'elpy-modules 'elpy-module-flymake)
                   (remove-hook 'elpy-modules 'elpy-module-yasnippet)
                   (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
                   (add-hook 'elpy-mode-hook 'flycheck-mode))
                 (elpy-enable)
                 (setq elpy-rpc-backend "jedi")))

(use-package py-autopep8 :ensure t)

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (latex-preview-pane-mode auctex quack geiser racket-mode py-autopep8 rainbow-delimiters material-theme better-defaults magit use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
