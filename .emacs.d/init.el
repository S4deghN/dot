;; -----------------------------------------------
;; --- Options ---
;; -----------------------------------------------
(menu-bar-mode 1)
(tool-bar-mode 0)
(set-fringe-mode 0)
(column-number-mode 1)
(scroll-bar-mode 0)

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
(set-face-attribute 'default nil :family "Source Code Pro" :height 120)

;(set-face-attribute 'default nil :background "#cccccc")
;(set-face-attribute 'region nil :background "light blue")
;(set-face-attribute 'cursor nil :background "dodger blue")
;(set-face-attribute 'show-paren-match nil :background "light goldenrod")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'naysayer t)

(set-face-attribute 'mode-line nil :background "dark slate gray" :foreground "#d1b897" :box nil)
(set-face-attribute 'success   nil :foreground "#44b340" :weight 'bold)

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
  (setq evil-mode-line-format 'before)
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

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 18)
  )

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
			   (semantic-idle-summary-mode t)
			   ))
;; for project specific include path use this expresion
;; in `.dir-local.el' at the project root directory.
;; ((c-mode
;;     (eval . (semantic-add-system-include "~/path/to/inc"))
;;     (eval . (semantic-add-system-include "~/path/to/other/inc"))))

(defvar c-files-regex ".*\\.\\(c\\|cpp\\|h\\|hpp\\)"
  "A regular expression to match any c/c++ related files under a directory")
(defun my-semantic-parse-dir (root regex)
  "
   This function is an attempt of mine to force semantic to
   parse all source files under a root directory. Arguments:
   -- root: The full path to the root directory
   -- regex: A regular expression against which to match all files in the directory
  "
  (let (
        ;;make sure that root has a trailing slash and is a dir
        (root (file-name-as-directory root))
        (files (directory-files root t ))
	)
    ;; remove current dir and parent dir from list
    (setq files (delete (format "%s." root) files))
    (setq files (delete (format "%s.." root) files))
    (while files
      (setq file (pop files))
      (if (not(file-accessible-directory-p file))
          ;;if it's a file that matches the regex we seek
          (progn (when (string-match-p regex file)
		   (save-excursion
                     (semanticdb-file-table-object file))
		   ))
        ;;else if it's a directory
        (my-semantic-parse-dir file regex)
	)
      )
    )
  )

(defun my-semantic-parse-current-dir (regex)
  "
   Parses all files under the current directory matching regex
  "
  (my-semantic-parse-dir (file-name-directory(buffer-file-name)) regex)
  )

(defun lk-parse-curdir-c ()
  "
   Parses all the c/c++ related files under the current directory
   and inputs their data into semantic
  "
  (interactive)
  (my-semantic-parse-current-dir c-files-regex)
  )

(defun lk-parse-dir-c (dir)
  "Prompts the user for a directory and parses all c/c++ related files
   under the directory
  "
  (interactive (list (read-directory-name "Provide the directory to search in:")))
  (my-semantic-parse-dir (expand-file-name dir) c-files-regex)
  )

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
			     "--background-index"))
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
   '("ffafb0e9f63935183713b204c11d22225008559fa62133a69848835f4f4a758c" "1f292969fc19ba45fbc6542ed54e58ab5ad3dbe41b70d8cb2d1f85c22d07e518" "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7" "e9a1226ffed627ec58294d77c62aa9561ec5f42309a1f7a2423c6227e34e3581" "6c79c891ffc3120b4dfcb8440e808f12d7593a71cbe933c6ecb70290712c5156" "ea5a840bd2f9616a36890c27fd5e97528cb9fcfafa0e6739315bb12786d6c4ee" "38c0c668d8ac3841cb9608522ca116067177c92feeabc6f002a27249976d7434" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "ee0785c299c1d228ed30cf278aab82cf1fa05a2dc122e425044e758203f097d2" "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "6e33d3dd48bc8ed38fd501e84067d3c74dfabbfc6d345a92e24f39473096da3f" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "f4d1b183465f2d29b7a2e9dbe87ccc20598e79738e5d29fc52ec8fb8c576fcfd" "7964b513f8a2bb14803e717e0ac0123f100fb92160dcf4a467f530868ebaae3e" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "13e3d7ed639865561ae8b5ecd7c94c6517cdbf99d1f90abfa8d68c72dce9fd85" "64c6d120937fce35d16d1a65413a13b86beba8086dabcb4458771a11ab518456" "18cf5d20a45ea1dff2e2ffd6fbcd15082f9aa9705011a3929e77129a971d1cb3" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "d9717212622f16f6b9e0bccc99f98761cbeb14065c4d9fa7d88f6b4507a0dbf6" default))
 '(ede-project-directories '("/home/s4/dev/embedded/keil1"))
 '(package-selected-packages
   '(doom-modeline ggtags tango-2-theme adwaita-dark-theme doom-themes rainbow-mode rust-mode disaster magit which-key vterm oblivion-theme ivy gruber-darker-theme evil-collection dumb-jump))
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
