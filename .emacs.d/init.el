;; -----------------------------------------------
;; --- Options ---
;; -----------------------------------------------
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-fringe-mode 5)
(column-number-mode 1)
(setq inhibit-startup-screen t)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(setq show-paren-delay 0)

(set-face-attribute 'default nil :family "Iosevka" :height 140 :weight 'normal :width 'normal)
(load-theme 'wombat t)

;; -----------------------------------------------
;; --- Packages ---
;; -----------------------------------------------
;; Configure melpa package repository usage
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil
  :ensure t
  :init
  ;; This is optional since it's already set to t by default.
  (setq evil-want-integration t)
  ;; Required by evil-collection
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; use default emacs undo-redo functionality when using <C-r> in evil mode
  ;; more info: `C-x v describe-variable` for evil-undo-system
  (evil-set-undo-system 'undo-redo)
  (setq evil-insert-state-cursor nil)
  (setq evil-visual-state-cursor nil))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package ivy
  :config
  (ivy-mode 0))


;; -----------------------------------------------
;; --- Keybindings ---
;; -----------------------------------------------
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;; -----------------------------------------------
;; --- Custom ---
;; -----------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wombat))
 '(custom-safe-themes
   '("7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98" "046a2b81d13afddae309930ef85d458c4f5d278a69448e5a5261a5c78598e012" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(evil-collection ivy evil-mode which-key solarized-theme color-theme-sanityinc-solarized gruber-darker-theme gruvbox-theme adwaita-dark-theme evil))
 '(show-paren-delay 0))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#8ec07c")))))
