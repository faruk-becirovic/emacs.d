;;; Comentary:

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'use-package)

(global-display-line-numbers-mode)
;; (setq default-directory "/path/to/documents/directory/")

;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'whiteboard-custom t)

;; Set highlight colur for the minimap in dark themes.
;;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;;'(minimap-active-region-background ((((background dark)) (:background "#5F345F")) (t (:background "#F19BF1"))) nil :group))

;; Company mode
(use-package company
  :after lsp-mode
  :ensure t
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-backends '((company-capf company-dabbrev-code)))
(setq global-display-line-numbers-mode t)
(setq global-flycheck-mode t)

;; Flycheck mode
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Apheleia mode
(use-package apheleia
  :ensure t
  :init (apheleia-global-mode))

;; Projectile
(use-package projectile
  :ensure t)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-project-search-path '("~/Projects/" ))

;; Minimap mode
(use-package minimap
  :ensure t)
(minimap-mode 1)
(add-to-list 'minimap-major-modes 'html-mode)
(add-to-list 'minimap-major-modes 'org-mode)

;; Aggresive indent
(use-package aggressive-indent
  :ensure t)
(global-aggressive-indent-mode 1)

;; Bracket closing behaviour
(electric-pair-mode t)
(add-hook 'c-mode-common-hook '(lambda ()
				 (local-set-key (kbd "RET") 'newline-and-indent)))

;; Ido setup
(require 'ido)
(ido-mode t)

;; org markdown support
(eval-after-load "org"
  '(require 'ox-md nil t))

(setq org-log-done 'time)
(setq org-log-done 'note)

;; ORG-EXPORT TIMESTAMPS
;; custom format to 'euro' timestamp
(setq org-time-stamp-custom-formats '("<%d.%m.%Y>" . "<%d.%m.%Y %a %H:%M>"))
;; function with hook on export
(defun my-org-export-ensure-custom-times (backend)
  (setq-local org-display-custom-times t))
(add-hook 'org-export-before-processing-hook 'my-org-export-ensure-custom-times)
;; remove brackets on export
(defun org-export-filter-timestamp-remove-brackets (timestamp backend info)
  "Remove relevant brackets from a (TIMESTAMP)."
  (cond
   ((org-export-derived-backend-p backend 'latex)
    (replace-regexp-in-string "[<>]\\|[][]" "" timestamp))
   ((org-export-derived-backend-p backend 'html)
    (replace-regexp-in-string "&[lg]t;\\|[][]" "" timestamp))))
(eval-after-load 'ox '(add-to-list
                       'org-export-filter-timestamp-functions
                       'org-export-filter-timestamp-remove-brackets))

;; Helm mode
(use-package helm
  :ensure t
  :init
  (setq helm-mode 1))

;; Emacs Speaks Statistics
(use-package ess
  :mode (
    	 ("\\.jl..'" . ess-mode)
    	 ("\\.R..'"  . ess-mode)
    	 ("\\.r..'"  . ess-mode)
    	 )
  )
(add-hook 'julia-mode-hook #'ess-julia-mode)

;; LSP Mode
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
	 ;; (julia-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;;(use-package lsp-julia
;;  :config
;;  (setq lsp-julia-default-environment "~/.julia/environments/v1.10"))

(add-hook 'ess-julia-mode-hook #'lsp-mode)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package dap-mode
  :ensure t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
(use-package dap-python)


;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp))))  ; or lsp-deferred

;; M-x lsp-install-server RET jsts-ls RET.
;; npm i -g javascript-typescript-langserver

;; M-x lsp-install-server RET json-ls RET.
;; Automatic or manual by npm i -g vscode-langservers-extracted

;; M-x lsp-install-server RET dockerfile-ls RET.
;; npm install -g dockerfile-language-server-nodejs

;; END LSP MODE

;; org-roam
;;((setq org-roam-directory (file-truename "~/Notes"))
;; (setq find-file-visit-truename t)
;; (org-roam-db-autosync-mode))

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; Org babel setup
(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (shell . t)
   (css . t)
   (latex . t)
   (js . t)
   (python . t)
   (sql . t)))

;; TODO pyvenv
;;(use-package pyvenv
;;  :ensure t
;;  :init
;;  (setq venv-initialize-interactive-shells t) ;; if you want interactive shell support
;;  (setq venv-initialize-eshell t) ;; if you want eshell support
;;  (setq venv-location "/home/faruk/.venv/"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-frame-alist '((fullscreen . maximized)))
 '(org-agenda-files
   '("~/Notes/Projects/CSEC-Hackathon/meetings.org" "/home/faruk/Notes/2024.org"))
 '(org-confirm-babel-evaluate nil)
 '(org-safe-remote-resources '("\\`https://fniessen\\.github\\.io\\(?:/\\|\\'\\)"))
 '(package-selected-packages
   '(solarized-theme flycheck-julia lsp-julia julia-mode ess yaml-mode ein pandoc timu-macos-theme org-roam tide company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
