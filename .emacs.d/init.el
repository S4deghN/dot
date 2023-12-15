;; -----------------------------------------------
;; --- Options ---
;; -----------------------------------------------
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-fringe-mode 0)
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
(setq backup-inhibited t)
(setq auto-save-default nil)

;; --- Face ---
(set-face-attribute 'default nil :family "Iosevka" :height 140 :weight 'normal :width 'normal)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'naysayer t)
;; (set-cursor-color "#8ec07c")

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
  (setq evil-mode-line-format 'after)
  (setq evil-echo-state nil)
  ;; This is optional since it's already set to t by default.
  (setq evil-want-integration t)
  ;; Required by evil-collection
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; use default emacs undo-redo functionality when using <C-r> in evil mode
  ;; more info: `C-x v describe-variable` for evil-undo-system
  (evil-set-undo-system 'undo-redo)
  (setq evil-insert-state-cursor nil
        evil-visual-state-cursor nil
        evil-move-beyond-eol nil
	evil-flash-delay 5
	;; why doesn't it work?!
	evil-bigword "^ \t\r\n\(\)"
	)
 )

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package vterm
  :ensure t
  :config (add-hook 'vterm-mode-hook 'evil-collection-vterm-toggle-send-escape))

;(use-package dumb-jump
;  :config
;  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
;  (setq dumb-jump-force-searcher 'rg))

;; CC-mode
(add-hook 'c-mode-common-hook #'(lambda()
				  (semantic-mode t)
				  (semantic-idle-summary-mode t)
				  (semantic-add-system-include "~/dev/embedded/keil1/Core/Inc" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Include" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Device/ST/STM32F3xx" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Device/ST/STM32F3xx/Include" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/STM32F3xx_HAL_Driver" 'c-mode)
                  (semantic-add-system-include "~/dev/embedded/keil1/Drivers/STM32F3xx_HAL_Driver/Inc" 'c-mode)
				  ))

;; -----------------------------------------------
;; --- Keybindings ---
;; -----------------------------------------------
(global-set-key (kbd "C-x C-S-e") 'eval-buffer)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; preserve useful emacs and ignore useless evil binding
(evil-global-set-key 'normal (kbd "C-e") 'end-of-line)
;; other custom bindings
(evil-global-set-key 'normal (kbd "L") 'end-of-line)
(evil-global-set-key 'normal (kbd "H") 'back-to-indentation)
(evil-global-set-key 'insert (kbd "C-S-v") (lambda() (interactive) (evil-paste-from-register 42))) ;; ascii 42 -> *

;; -----------------------------------------------
;; --- Custom ---
;; -----------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("64c6d120937fce35d16d1a65413a13b86beba8086dabcb4458771a11ab518456" "18cf5d20a45ea1dff2e2ffd6fbcd15082f9aa9705011a3929e77129a971d1cb3" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "d9717212622f16f6b9e0bccc99f98761cbeb14065c4d9fa7d88f6b4507a0dbf6" default))
 '(package-selected-packages
   '(magit which-key vterm oblivion-theme ivy gruber-darker-theme evil-collection dumb-jump)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(success ((t (:foreground "#44b340" :weight bold)))))
