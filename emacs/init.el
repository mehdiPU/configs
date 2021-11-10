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
  :init (load-theme 'doom-acario-dark t))


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
