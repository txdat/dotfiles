;; Bootstrap straight and straight-use-package
(setq straight-use-package-by-default t)
(setq straight-vc-git-default-clone-depth 1)
(setq straight-recipes-gnu-elpa-use-mirror t)
;; (setq straight-check-for-modifications '(check-on-save find-when-checking))
(setq straight-check-for-modifications nil)
(setq use-package-always-defer t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
;; This is a variable that has been renamed but straight still refers when
;; doing :sraight (:no-native-compile t)
(setq comp-deferred-compilation-black-list nil)
;; Enable use-package statistics
(setq use-package-compute-statistics t)

;; Defaults
(setq blink-cursor-mode nil)

(use-package emacs
  :init
  (setq inhibit-startup-screen t
        initial-scratch-message nil
        sentence-end-double-space nil
        ring-bell-function 'ignore
        frame-resize-pixelwise t)

  (setq user-full-name "Dat Tran"
        user-mail-address "dattranx105@gmail.com")

  (setq read-process-output-max (* 1024 1024)) ;; 1mb

  ;; always allow 'y' instead of 'yes'.
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; default to utf-8 for all the things
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  ;; write over selected text on input... like all modern editors do
  (delete-selection-mode t)

  ;; enable recent files mode.
  (recentf-mode t)
  (setq recentf-exclude `(,(expand-file-name "straight/build/" user-emacs-directory)
                          ,(expand-file-name "eln-cache/" user-emacs-directory)
                          ,(expand-file-name "etc/" user-emacs-directory)
                          ,(expand-file-name "var/" user-emacs-directory)))

  ;; don't want ESC as a modifier
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ;; Don't persist a custom file, this bites me more than it helps
  (setq custom-file (make-temp-file "")) ; use a temp file as a placeholder
  (setq custom-safe-themes t)            ; mark all themes as safe, since we can't persist now
  (setq enable-local-variables :all)     ; fix =defvar= warnings

  ;; stop emacs from littering the file system with backup files
  (setq make-backup-files nil
        auto-save-default nil
        create-lockfiles nil)

  ;; follow symlinks
  (setq vc-follow-symlinks t)

  ;; don't show any extra window chrome
  (when (window-system)
    (tool-bar-mode -1)
    (toggle-scroll-bar -1))

  ;; enable winner mode globally for undo/redo window layout changes
  (winner-mode t)

  (show-paren-mode t)

  ;; less noise when compiling elisp
  (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq native-comp-async-report-warnings-errors nil)
  (setq load-prefer-newer t)

  ;; clean up the mode line
  (display-time-mode -1)
  (setq column-number-mode t)

  ;; use common convention for indentation by default
  (setq-default indent-tabs-mode t)
  (setq-default tab-width 2)

  ;; Enable indentation+completion using the TAB key.
  ;; Completion is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  )

;; Custom variables
(use-package emacs
  :init
  (defcustom lc/default-font-family "JetbrainsMono Nerd Font"
    "Default font family"
    :type 'string
    :group 'lc)

  (defcustom lc/variable-pitch-font-family "JetbrainsMono Nerd Font"
    "Variable pitch font family"
    :type 'string
    :group 'lc)

  (defcustom lc/font-size 120 ;; gui only
    "Font size"
    :type 'int
    :group 'lc)
  )

;; Font
(use-package emacs
  :hook (after-init . lc/set-font-size)
  :init
  (defun lc/set-font-size ()
    (interactive)
    ;; Main typeface
    (set-face-attribute 'default nil :family lc/default-font-family :height lc/font-size)
    ;; Set the fixed pitch face (monospace)
    (set-face-attribute 'fixed-pitch nil :family lc/default-font-family)
    ;; Set the variable pitch face
    (set-face-attribute 'variable-pitch nil :family lc/variable-pitch-font-family)
    ;; modeline
    (set-face-attribute 'mode-line nil :family lc/default-font-family :height lc/font-size)
    (set-face-attribute 'mode-line-inactive nil :family lc/default-font-family :height lc/font-size)
    )
  )

;; Zoom
(use-package emacs
  :init
  (global-set-key (kbd "C-=") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  )

;; Garbage collector
(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))

;; Helpful
(use-package helpful
  :after evil
  :init
  (setq evil-lookup-func #'helpful-at-point)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; Eldoc
(use-package eldoc
  :hook (emacs-lisp-mode cider-mode))

;; Exec path from shell
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :hook (emacs-startup . (lambda ()
                           (setq exec-path-from-shell-arguments '("-l")) ; removed the -i for faster startup
                           (exec-path-from-shell-initialize)))
  ;; :config
  ;; (exec-path-from-shell-copy-envs
  ;;  '())
  )

;; no littering
(use-package no-littering
  :demand
  :config
  (with-eval-after-load 'recentf
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory))
  )

;; server mode
(use-package emacs
  :init
  (unless (and (fboundp 'server-running-p) (server-running-p))
  (server-start)))

;; Auto-pair
(use-package emacs
  :hook
  ((org-jupyter-mode . (lambda () (lc/add-local-electric-pairs '())))
   (org-mode . (lambda () (lc/add-local-electric-pairs '(;(?= . ?=)
														 (?~ . ?~))))))
  :init
  ;; auto-close parentheses
  (setq electric-pair-pairs '((?\{ . ?\})
                               ))
  (electric-pair-mode +1)
  (setq electric-pair-preserve-balance nil)
  ;; don't skip newline when auto-pairing parenthesis
  (setq electric-pair-skip-whitespace-chars '(9 32))
  ;; mode-specific local-electric pairs
  (defconst lc/default-electric-pairs electric-pair-pairs)
  (defun lc/add-local-electric-pairs (pairs)
    "Example usage:
    (add-hook 'jupyter-org-interaction-mode '(lambda () (set-local-electric-pairs '())))
    "
    (setq-local electric-pair-pairs (append lc/default-electric-pairs pairs))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  ;; disable auto pairing for <  >
  (add-function :before-until electric-pair-inhibit-predicate
                (lambda (c) (eq c ?<   ;; >
							 )))
  )

;; Rename file
(use-package emacs
  :init
  (defun lc/rename-current-file ()
    "Rename the current visiting file and switch buffer focus to it."
    (interactive)
    (let ((new-filename (lc/expand-filename-prompt
                         (format "Rename %s to: " (file-name-nondirectory (buffer-file-name))))))
      (if (null (file-writable-p new-filename))
          (user-error "New file not writable: %s" new-filename))
      (rename-file (buffer-file-name) new-filename 1)
      (find-alternate-file new-filename)
      (message "Renamed to and now visiting: %s" (abbreviate-file-name new-filename))))
  (defun lc/expand-filename-prompt (prompt)
    "Return expanded filename prompt."
    (expand-file-name (read-file-name prompt)))
  )

;; Xref
(use-package xref
  :straight (:type built-in)
  :init
  (setq xref-prompt-for-identifier nil) ;; always find references of symbol at point
  ;; configured in consult
  ;; (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  ;; (setq xref-show-xrefs-function #'xref-show-definitions-buffer) ; for grep and the like
  ;; (setq xref-file-name-display 'project-relative)
  ;; (setq xref-search-program 'grep)
  )

;; Don't close windows on escape
(use-package emacs
  :init
  (defadvice keyboard-escape-quit
      (around keyboard-escape-quit-dont-close-windows activate)
    (let ((buffer-quit-function (lambda () ())))
      ad-do-it))
  )

;; Keybindings

(provide 'core)
;;; core.el ends here
