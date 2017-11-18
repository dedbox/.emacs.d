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
;; (require 'diminish)
(require 'bind-key)

;; Emacs
(use-package better-defaults :ensure t)
(use-package ido-hacks :ensure t)
(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config (smex-initialize))

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
   (_ "InputMono:size=14")))

(use-package material-theme :ensure t)

;; unbind C-Z in GUI
(when (display-graphic-p)
  (global-unset-key [(control z)])
  (global-unset-key [(control x) (control z)]))

;; Encryption
(use-package epa-file :config (epa-file-enable))

;; Text
(use-package flyspell
  :ensure t
  :config (add-hook 'text-mode-hook 'flyspell-mode))

;; Code
(use-package flycheck :ensure t)

;; Parentheses
(use-package paredit
  :config (mapc (lambda (hook) (add-hook hook #'enable-paredit-mode))
                '(eval-expression-minibuffer-setup-hook
                  emacs-lisp-mode-hook
                  scheme-mode-hook
                  geiser-repl-mode-hook)))

;; Templates
(use-package yasnippet
  :ensure t
  :config (progn
            (yas-reload-all)
            (add-hook 'snippet-mode-hook 'flyspell-mode-off)
            (mapc (lambda (hook) (add-hook hook #'yas-minor-mode))
                  '(prog-mode-hook
                    geiser-repl-mode-hook
                    LaTeX-mode-hook))))

;; Git
(use-package magit :ensure t)

;; Racket
(add-hook 'scheme-mode-hook 'flycheck-mode)
(add-hook 'geiser-repl-mode-hook 'bind-greek-keys)

(use-package scribble-mode :ensure t)

(use-package quack
  :ensure t
  :config (setq quack-remap-find-file-bindings-p nil))

(defun bind-greek-keys ()
  (mapc (lambda (x) (bind-key (car x) (cdr x)))
        '(("C-c a" . "α")
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
          ("C-c X" . "Ξ")
          ("C-c s" . "σ") ("C-c S" . "Σ")
          ("C-c F" . "Φ") ("C-c O" . "Ω")
          ("C-c E" . "∃") ("C-c A" . "∀")
          ("C-c ;" . "ℓ")
          ("C-k" . paredit-kill))))

(use-package geiser
  :ensure t
  :config (progn
            (bind-greek-keys)
            (add-hook 'geiser-repl-mode 'bind-greek-keys)

            (mapc (lambda (x)
                    (put (car x) 'scheme-indent-function (cdr x)))
                  '((choice-evt . 0)
                    (handle-evt . 1)
                    (let/cc . 1)
                    (replace-evt . 1)
                    (shift . 1)
                    (struct . 2)
                    ;; my functions
                    (-struct . 2)
                    (forever . 0)
                    (seq-evt . 1)
                    ;; axon
                    (define-process . 2)
                    (define-filter . 2)))

            (mapc (lambda (f)
                    (setq hippie-expand-try-functions-list
                          (remq f hippie-expand-try-functions-list)))
                  '(try-expand-line
                    try-expand-list))))

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
  :config (progn
            (setq reftex-plug-into-AUCTeX t)
            (add-hook 'LaTeX-mode-hook #'turn-on-reftex)))

(use-package bibtex
  :config (progn
            (setq bibtex-align-at-equal-sign t)
            (add-hook 'bibtex-mode-hook (lambda () (set-fill-column 120)))))

;; Python
(use-package elpy
  :ensure t
  :init (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  :config (progn
            (when (require 'flycheck nil t)
              (remove-hook 'elpy-modules 'elpy-module-flymake)
              (remove-hook 'elpy-modules 'elpy-module-yasnippet)
              (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
              (add-hook 'elpy-mode-hook 'flycheck-mode))
            (elpy-enable)
            (elpy-use-ipython)
            (setq elpy-rpc-backend "jedi")
            (setq elpy-rpc-timeout 1)))

(use-package py-autopep8 :ensure t)

;; YAML
(use-package yaml-mode
  :ensure t
  :config (progn
            (add-hook 'yaml-mode-hook 'flyspell-mode-off)
            (add-hook 'yaml-mode-hook 'flycheck-mode)))

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (scribble-mode yaml-mode raml-mode smex ido-hacks latex-preview-pane-mode auctex quack geiser racket-mode py-autopep8 rainbow-delimiters material-theme better-defaults magit use-package)))
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
