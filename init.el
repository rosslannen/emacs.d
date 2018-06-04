;;; .emacs --- Global Settings

;;; Commentary:

;;; Code:


;; User info
(setq user-full-name "Ross Lannen")
(setq user-mail-address "ross.lannen@gmail.com")

(package-initialize)

;; init-use-package.el
;; Update package-archive lists
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

;; Install 'use-package' if necessary
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use package
(eval-when-compile
 (require 'use-package))

(setq use-package-always-ensure t)
;; init-use-package.el ends here

;; Auto updating
(use-package auto-package-update
  :custom
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe))

;; Basic defaults
;; Set encoding to UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(use-package better-defaults
  :config
  (global-linum-mode t)
  :custom
  (inhibit-splash-screen t)
  (initial-scratch-message nil))

(setq inhibit-splash-screen t
      initial-scratch-message nil)

;; TRAMP settings for remote hosts
(setq tramp-default-method "ssh")

;; Aggressive Indentation
(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1))


;; Evil mode
(use-package evil
  :config
  (progn
    (evil-mode 1))
  (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line))


;; Org mode
(use-package org)
;; (use-package evil-org)


;; Helm incremental narrowing search framework
(use-package helm)


;; Company
(use-package company
  :hook (after-init . global-company-mode))

(use-package company-quickhelp
  :config
  (company-quickhelp-mode 1))


;; Flycheck
(use-package flycheck
  :init
  (global-flycheck-mode))


;; YASnippet
;;(use-package yasnippet
;;  :config
;;  (yas-global-mode 1))


;; Multi-Term
;; adds support for multiple terminals
(use-package multi-term
  :config
  (evil-define-key 'normal term-raw-map
    "p" 'term-paste)
  (evil-define-key 'normal term-raw-map
    "P" 'term-paste))


;; Git
(use-package magit)

(use-package gitignore-mode)


;; Elm
(use-package elm-mode
  :after (company)
  :custom
  (elm-format-on-save t)
  (elm-sort-imports-on-save t)
  :config
  (add-to-list 'company-backends 'company-elm))

(use-package flycheck-elm
  :after (flycheck)
  :hook (flycheck-mode . flycheck-elm-setup))


;; Python
(use-package anaconda-mode
  :hook ((python-mode . anaconda-mode)
         (python-mode . anaconda-eldoc-mode)))

(setq python-shell-interpreter "python3")

(defvaralias 'flycheck-python-flake8-executable 'python-shell-interpreter)

(use-package company-anaconda
  :after (company)
  :config
  (add-to-list 'company-backends 'company-anaconda))

(use-package py-autopep8
  :hook (python-mode . py-autopep8-enable-on-save))


;; c, c++, Obj-c
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(use-package irony
  :hook ((c++-mode . irony-mode)
         (c-mode-hook . irony-mode)
         (objc-mode . irony-mode)
         (irony-mode . irony-cdb-autosetup-compile-options)))

(use-package company-irony
  :after (company)
  :hook (irony-mode . company-irony-setup-begin-commands)
  :config
  (setq company-backends (delete 'company-semantic company-backends)))

(use-package company-irony-c-headers
  :after (company)
  :config
  (add-to-list
   'company-backends '(company-irony-c-headers company-irony)))

(use-package flycheck-irony
  :after (flycheck)
  :hook ((flycheck-mode . flycheck-irony-setup)
         (c++-mode . (lambda () (setq flycheck-gcc-language-standard "gnu++11")))
         (c++-mode . (lambda () (setq flycheck-clang-language-standard "gnu++11")))))

(use-package clang-format
  :custom
  (clang-format-style-option "google")
  (clang-format-on-save t))


;; Dockerfiles
(use-package dockerfile-mode)


;; .NET
(use-package omnisharp
  :after (company)
  :hook ((csharp-mode . omnisharp-mode)
         (fsharp-mode . omnisharp-mode))
  :config
  (add-to-list 'company-backends 'company-omnishap))

(use-package csharp-mode)

(use-package fsharp-mode)


;; Web Mode
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.cshtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-script-padding 2))


;; Clojure
(use-package clojure-mode
  :config
  (define-clojure-indent
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (OPTIONS 2)
    (PATCH 2)
    (rfn 2)
    (let-routes 1)
    (context 2)))

(use-package cider)


;; Powershell
(use-package powershell)


;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; Assembly
(setq asm-comment-char ?\#)


;; Haskell
(use-package haskell-mode)

(use-package company-ghci
  :after (company)
  :config
  (add-to-list 'company-backends 'company-ghci))


;; Latex
(require 'ox-latex)

(setq org-latex-listings 'minted)

(add-to-list 'org-latex-packages-alist '("" "minted"))

(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -shell-escape -output-directory %o %f"
        "xelatex -interaction nonstopmode -shell-escape -output-directory %o %f"
        "xelatex -interaction nonstopmode -shell-escape -output-directory %o %f"))


;; Elixir
(use-package elixir-mode)

(use-package alchemist)


;; Rust
(use-package rust-mode
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package racer
  :hook ((rust-mode . racer-mode)
         (racer-mode . eldoc-mode)))

(use-package flycheck-rust
  :after (rust-mode)
  :hook (flycheck-mode . flycheck-rust-setup))


;; Javascript
(defun my/use-eslint-from-node-modules ()
  "Use local eslint file for flycheck if it exists."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js" root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(use-package js2-mode
  :after flycheck
  :mode "\\.js\\'"
  :hook (js2-mode . js2-imenu-extras-mode)
  :config
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (setq-default flycheck-temp-prefix ".flycheck")
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq js-indent-level 2))

(use-package xref-js2
  :after js2-mode
  :config
  (define-key js-mode-map (kbd "M-.") nil)
  (add-hook 'js2-mode-hook
            (lambda ()
              (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))

(use-package company-tern
  :after company
  :config
  (add-to-list 'company-backends 'company-tern)
  (add-hook 'js2-mode-hook (lambda ()
                             (tern-mode)
                             (company-mode)))
  (define-key tern-mode-keymap (kbd "M-.") nil)
  (define-key tern-mode-keymap (kbd "M-,") nil))

(use-package web-beautify
  :config
  (eval-after-load 'js2-mode
    '(add-hook 'js2-mode-hook
               (lambda ()
                 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  (eval-after-load 'json-mode
    '(add-hook 'json-mode-hook
               (lambda ()
                 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  (eval-after-load 'web-mode
    '(add-hook 'web-mode-hook
               (lambda ()
                 (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))
  (eval-after-load 'css-mode
    '(add-hook 'css-mode-hook
               (lambda ()
                 (add-hook 'before-save-hook 'web-beautify-css-buffer t t)))))

(use-package json-mode)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(auto-package-update-delete-old-versions t)
 '(auto-package-update-hide-results t)
 '(blink-cursor-mode nil)
 '(clang-format-on-save t t)
 '(clang-format-style-option "google" t)
 '(custom-enabled-themes (quote (sanityinc-tomorrow-bright)))
 '(custom-safe-themes
   (quote
    ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "98cc377af705c0f2133bb6d340bf0becd08944a588804ee655809da5d8140de6" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" default)))
 '(elm-format-on-save t)
 '(elm-sort-imports-on-save t)
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(inhibit-splash-screen t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (flycheck-rust alchemist elixir-mode color-theme-sanityinc-tomorrow color-theme-tomorrow clang-format aggressive-indent csharp-mode markdown-mode powershell cider fsharp-mode rainbow-delimiters company company-mode flycheck-elm flycheck use-package solarized-theme org evil)))
 '(safe-local-variable-values
   (quote
    ((flycheck-cppcheck-language-standard . "c++11")
     (flycheck-disabled-checkers quote
                                 (c/c++-clang)))))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Asthetics Below Here

;; Mode line
(use-package telephone-line
  :config
  (setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-major-mode-segment))
          (nil    . (telephone-line-buffer-segment
                     telephone-line-minor-mode-segment))))
  (setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-process-segment))
          (evil   . (telephone-line-airline-position-segment))))
  (setq telephone-line-subseparator-faces '())
  (setq telephone-line-primary-left-separator 'telephone-line-gradient
        telephone-line-secondary-left-separator 'telephone-line-flat
        telephone-line-primary-right-separator 'telephone-line-gradient
        telephone-line-secondary-right-separator 'telephone-line-gradient)
  (setq telephone-line-height 18)
  (telephone-line-mode t))

;; Material theme
(use-package material-theme
  :config
  (load-theme 'material))

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (latex-mode . rainbow-delimiters-mode)))


(provide '.emacs)
;;; .emacs end here
