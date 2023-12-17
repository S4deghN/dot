;; -----------------------------------------------
;; --- Options ---
;; -----------------------------------------------
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-fringe-mode 0)
(column-number-mode 1)
(scroll-bar-mode 1)

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
(setq read-file-name-completion-ignore-case t)

;; --- Face ---
(set-face-attribute 'default nil :family "jetbrains mono" :height 130)

;(set-face-attribute 'default nil :background "#cccccc")
;(set-face-attribute 'region nil :background "light blue")
;(set-face-attribute 'cursor nil :background "dodger blue")
;(set-face-attribute 'show-paren-match nil :background "light goldenrod")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'naysayer t)

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
  (setq evil-mode-line-format 'before)
  (setq evil-echo-state nil)
  ;; This is optional since it's already set to t by default.
  (setq evil-want-integration t)
  ;; Required by evil-collection
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; use default emacs undo-redo functionality when using <C-r> in evil mode
  ;; more info: `C-x v describe-variable' for evil-undo-system
  (evil-set-undo-system 'undo-redo)
  (setq evil-insert-state-cursor nil
        evil-visual-state-cursor nil
        evil-move-beyond-eol t
	evil-flash-delay 5
	;; why doesn't it work?!
	evil-bigword "^ \t\r\n()"))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package vterm
  :ensure t
  :config (add-hook 'vterm-mode-hook 'evil-collection-vterm-toggle-send-escape))

(use-package solaire-mode
  :config (solaire-global-mode t))

(use-package rainbow-mode
  :hook (emacs-lisp-mode text-mode lisp-mode c-mode))

;(use-package doom-modeline
;  :ensure t
;  :init (doom-modeline-mode 1)
;  :config
;  (setq doom-modeline-height 18))

(use-package disaster)

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq dumb-jump-force-searcher 'rg))

;; -----------------------------------------------
;; --- Semantic ---
;; -----------------------------------------------
(add-hook 'c-mode-hook #'(lambda()
			   (semantic-mode t)
			   (semantic-idle-summary-mode t)))
;; for project specific include path use this expresion
;; in `.dir-local.el' at the project root directory.
;; ((c-mode
;;     (eval . (semantic-add-system-include "~/path/to/inc"))
;;     (eval . (semantic-add-system-include "~/path/to/other/inc"))))

(defvar c-files-regex ".*\\.\\(c\\|cpp\\|h\\|hpp\\)"
  "A regular expression to match any c/c++ related files under a directory")
(defun my-semantic-parse-dir (root regex)
  "This function is an attempt of mine to force semantic to
   parse all source files under a root directory. Arguments:
   -- root: The full path to the root directory
   -- regex: A regular expression against which to match all files in the directory "

  ;; make sure that root has a trailing slash and is a dir
  (let ((root (file-name-as-directory root))
        (files (directory-files root t )))
    ;; remove current dir and parent dir from list
    (setq files (delete (format "%s." root) files))
    (setq files (delete (format "%s.." root) files))
    (while files (setq file (pop files))
      (if (not(file-accessible-directory-p file))
          ;; if it's a file that matches the regex we seek
          (progn (when (string-match-p regex file)
		   (save-excursion
                     (semanticdb-file-table-object file))))
        ;; else if it's a directory
        (my-semantic-parse-dir file regex)))))

(defun my-semantic-parse-current-dir (regex)
  "Parses all files under the current directory matching regex "
  (my-semantic-parse-dir (file-name-directory(buffer-file-name)) regex))

(defun lk-parse-curdir-c ()
  "Parses all the c/c++ related files under the current directory
   and inputs their data into semantic "
  (interactive)
  (my-semantic-parse-current-dir c-files-regex))

(defun lk-parse-dir-c (dir)
  "Prompts the user for a directory and parses all c/c++ related files
   under the directory "
  (interactive (list (read-directory-name "Provide the directory to search in:")))
  (my-semantic-parse-dir (expand-file-name dir) c-files-regex))

(provide 'lk-file-search)

;; -----------------------------------------------
;; --- Eglot ---
;; -----------------------------------------------
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       `(rust-mode . ("rustup" "run" "nightly" "rust-analyzer"))
	       `(c++-mode . ("clangd"
			     "--clang-tidy"
			     "--all-scopes-completion=true"
			     "--completion-style=detailed"
			     "--header-insertion=iwyu"
			     "--header-insertion-decorators"
			     "-j=2"
			     "--background-index"))))

;; -----------------------------------------------
;; --- Keybindings ---
;; -----------------------------------------------
(global-set-key (kbd "C-x C-r") 'eval-buffer)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(evil-global-set-key 'normal (kbd "C-e") 'end-of-line)

(evil-define-key 'normal 'global "L" (kbd "M-e"))
(evil-define-key 'normal 'global "H" (kbd "M-a"))

;; -----------------------------------------------
;; --- Custom ---
;; -----------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(doom-themes rust-mode disaster magit oblivion-theme))
 '(safe-local-variable-values
   '((eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Core/Include")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Core/Src")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/STM32F3xx_HAL_Driver/Inc")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/STM32F3xx_HAL_Driver")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Device/ST/STM32F3xx/Include")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Device/ST/STM32F3xx")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS/Include")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Drivers/CMSIS")
     (eval semantic-add-system-include "~/dev/embedded/keil1/Core/Inc"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
