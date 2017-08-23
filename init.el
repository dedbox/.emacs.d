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
   (_ "Inconsolata LGC 11")))

(use-package material-theme :ensure t)

;; unbind C-Z in GUI
(when (display-graphic-p)
  (global-unset-key [(control z)])
  (global-unset-key [(control x) (control z)]))

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
                  scheme-mode-hook
                  geiser-repl-mode-hook)))

;; Templates
(use-package yasnippet
  :ensure t
  :config
  (progn
    (yas-reload-all)
    (add-hook 'prog-mode-hook 'yas-minor-mode)
    (add-hook 'geiser-repl-mode-hook 'yas-minor-mode)
    (add-hook 'snippet-mode-hook 'flyspell-mode-off)))

;; Git
(use-package magit :ensure t)

;; Racket
(add-hook 'scheme-mode-hook 'flycheck-mode)
(add-hook 'geiser-repl-mode-hook 'bind-greek-keys)

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
                    (define-process . 1)
                    (define-filter . 2)
                    (filter . 1)
                    (repeat . 1)
                    (trigger . 1)
                    (serve . 1)
                    (async . 1)
                    (pipe . 0)
                    (sink . 1)
                    (source . 1)))

            (mapc (lambda (f)
                    (setq hippie-expand-try-functions-list
                          (remq f hippie-expand-try-functions-list)))
                  '(try-expand-line
                    try-expand-list))))

;; Latex
(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :config (progn
            (add-hook 'LaTeX-mode-hook #'turn-on-reftex)
            (setq TeX-auto-save t)
            (setq TeX-parse-self t)
            (add-to-list 'TeX-view-program-list
                         '(preview-pane-mode latex-preview-pane-mode))
            (setq-default TeX-master "master")))

(use-package reftex
  :ensure t
  :config (setq reftex-plug-into-AUCTeX t))

(use-package bibtex
  :config (progn
            (setq bibtex-align-at-equal-sign t)
            (add-hook 'bibtex-mode-hook (lambda () (set-fill-column 120)))))

(use-package latex-preview-pane :ensure t)

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
    (yaml-mode raml-mode smex ido-hacks latex-preview-pane-mode auctex quack geiser racket-mode py-autopep8 rainbow-delimiters material-theme better-defaults magit use-package)))
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#1f292e")))))
