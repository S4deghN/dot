;; -----------------------------------------------
;; --- Options ---
;; -----------------------------------------------
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-fringe-mode 5)
(column-number-mode 1)

(setq show-paren-delay 0)
(show-paren-mode 1)

(setq inhibit-startup-screen t)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(setq scroll-margin 8)
(setq scroll-step 0)
(setq scroll-conservatively 101)           
(setq frame-resize-pixelwise t)

;; --- Face ---
(set-face-attribute 'default nil :family "Iosevka" :height 140 :weight 'normal :width 'normal)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")                
(load-theme 'oblivion t)
;;(set-cursor-color "#8ec07c")

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

(use-package vterm
  :ensure t
  :config (add-hook 'vterm-mode-hook 'evil-collection-vterm-toggle-send-escape))

;; -----------------------------------------------
;; --- Keybindings ---
;; -----------------------------------------------
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(oblivion-theme which-key vterm sublime-themes solarized-theme popup leuven-theme ivy gruvbox-theme gruber-darker-theme evil-collection color-theme-sanityinc-solarized adwaita-dark-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
