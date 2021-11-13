;; General config
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https:/orgmode.org/elpa/")
			 ("elpa" . "https:/elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(require 'req-package)

(electric-pair-mode 1)
(show-paren-mode 1)


;;(global-display-line-numbers-mode 1)

;; UI customization
(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable visible scollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tool tips
(set-fringe-mode 10)  ; Give some breathing room

(menu-bar-mode -1)   ; Disable the menu bar

;; Setup the visible bell
(setq visible-bell t)

;; Set the fill column
(set-fill-column 75)

;; Font Configuration ----------------------------------------------------------

(set-face-attribute 'default nil :font "Fira Code Retina")

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina")

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :weight 'regular)

;;(use-package command-log-mode)

(use-package ivy
  :init
  (ivy-mode 1)
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-n" . ivy-next-line)
	 ("C-p" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-p" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-p" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill)))


;; The first time on a machine:
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))


(use-package general
  :config
  ;; Use the counsel switch buffer instead
  (general-define-key "C-x b" 'counsel-switch-buffer)

  ;; Make ESC quit prompts
  (general-define-key "<escape>" 'keyboard-escape-quit))

;; TODO Use evil and evil-collection to use vim key bindings
;; TODO Take a look at hydra as well

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; (use-package evil-magit :after magit)

;; Org Mode Configuration ------------------------------------------------------

(defun mehdi/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun mehdi/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . mehdi/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-genda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  
  (setq org-agenda-files
	'("~/hdd/configs/emacs/orgFiles/tasks.org"))
  
  (mehdi/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun mehdi/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . mehdi/org-mode-visual-fill))

;; Language Server Protocole mode ---------------------------

(defun mehdi/lsp-mode-setup ()
  (setq lsp-header-line-breadcrumb-segments '(path-up-to-project file symbol))
  (lsp-headerline-breadcrumb-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(use-package lsp-mode
  :commands (lsp lsp-deferred)
  
  :hook
  (lsp-mode . mehdi/lsp-mode-setup)
  
  :init
  (setq lsp-keymap-prefix "C-c l")
  
  :config
  (lsp-enable-which-key-integration t)
  
  :custom
  (lsp-diagnostics-provider flycheck))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
	("<tab>" . company-complete-selection))
  (:map lsp-mode-map ("<tab>" . company-indent-or-complete-common))

  :custom
  (company-minimum-prefix-length 1)
  (company-idle-dely 0.0))

;; Error
;; (use-package evil-nerd-commenter
;;   :bind ("M-/" . evil-comment-or-uncomment-lines))

;; Had a problem with it
;;(use-package company-box
  ;;:hook (company-mode .company-box-mode))

;; For Python
(use-package python-mode
  :hook (python-mode . lsp-deferred))


(use-package lsp-jedi
  :ensure t
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-disabled-clients 'pyls)
    (add-to-list 'lsp-enabled-clients 'jedi)))

(use-package cmake-mode
  :hook (cmake-mode . lsp-deferred)
  :config
  (add-to-list 'lsp-enabled-clients 'cmakels))

(use-package ccls
  :ensure t
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-enabled-clients 'ccls))
  (add-hook 'c-mode-hook 'lsp-deferred)
  (add-hook 'c++-mode-hook 'lsp-deferred))

(use-package yasnippet
  :ensure t)



(provide 'init)
;;; init.el ends here
