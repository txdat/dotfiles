;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq-default
 ad-redefinition-action 'accept         ; Silence warnings for redefinition
 auto-save-list-file-prefix nil         ; Prevent tracking for auto-saves
 create-lockfiles nil                   ; Locks are more nuisance than blessing
 cursor-in-non-selected-windows nil     ; Hide the cursor in inactive windows
 cursor-type 'box                       ; Block-shaped cursor
 custom-unlispify-menu-entries nil      ; Prefer kebab-case for titles
 custom-unlispify-tag-names nil         ; Prefer kebab-case for symbols
 delete-by-moving-to-trash t            ; Delete files to trash
 fill-column 80                         ; Set width for automatic line breaks
 gc-cons-threshold (* 100 1024 1024)    ; We're not using Game Boys anymore
 help-window-select t                   ; Focus new help windows when opened
 indent-tabs-mode nil                   ; Stop using tabs to indent
 inhibit-startup-screen t               ; Disable start-up screen
 initial-scratch-message ""             ; Empty the initial *scratch* buffer
 initial-major-mode #'org-mode          ; Prefer `org-mode' for *scratch*
 mouse-yank-at-point t                  ; Yank at point rather than pointer
 native-comp-async-report-warnings-errors 'silent ; Skip error buffers
 read-process-output-max (* 1024 1024)  ; Increase read size for data chunks
 recenter-positions '(5 bottom)         ; Set re-centering positions
 scroll-conservatively 101              ; Avoid recentering when scrolling far
 scroll-margin 1                        ; Add a margin when scrolling vertically
 select-enable-clipboard t              ; Merge system's and Emacs' clipboard
 sentence-end-double-space nil          ; Use a single space after dots
 show-help-function nil                 ; Disable help text everywhere
 tab-always-indent 'complete            ; Indent first then try completions
 tab-width 4                            ; Smaller width for tab characters
 uniquify-buffer-name-style 'forward    ; Uniquify buffer names
 use-short-answers t                    ; Replace yes/no prompts with y/n
 window-combination-resize t            ; Resize windows proportionally
 x-stretch-cursor t                     ; Stretch cursor to the glyph width
 visible-cursor nil)                    ; Disable cursor blinking
(blink-cursor-mode 0)                   ; Prefer a still cursor
(delete-selection-mode 1)               ; Replace region when inserting text
(global-subword-mode 1)                 ; Iterate through CamelCase words
(mouse-avoidance-mode 'exile)           ; Avoid collision of mouse with point
(put 'downcase-region 'disabled nil)    ; Enable `downcase-region'
(put 'scroll-left 'disabled nil)        ; Enable `scroll-left'
(put 'upcase-region 'disabled nil)      ; Enable `upcase-region'
(set-default-coding-systems 'utf-8)     ; Default to utf-8 encoding

(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Dat Tran"
      user-mail-address "dattranx105@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;

(setq font-family "Maple Mono NF CN"
      font-size 22)
;; (if (equal (display-pixel-width) 3072)
;;  (setq font-size 22) ; hidpi
;;  (setq font-size 12)
;;  )

(setq doom-font (font-spec :family font-family :size font-size)
      doom-variable-pitch-font (font-spec :family font-family :size font-size)
      doom-big-font (font-spec :family font-family :size font-size)
      doom-unicode-font (font-spec :family font-family :size font-size)
      doom-serif-font (font-spec :family font-family :size font-size))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'modus-operandi)
(setq doom-theme 'modus-vivendi)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/projects/notes/org")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; evil cursor's shapes
(setq evil-emacs-state-cursor 'box
      evil-normal-state-cursor 'box
      evil-visual-state-cursor 'box
      evil-insert-state-cursor 'box
      evil-replace-state-cursor 'box
      evil-operator-state-cursor 'box)

;; Which-key
(setq which-key-idle-delay 0.5
      which-key-idle-secondary-delay 0.05
      which-key-allow-multiple-replacements t)

;; File templates
(set-file-template! "\\.tex$" :trigger "__" :mode 'latex-mode)
(set-file-template! "\\.org$" :trigger "__" :mode 'org-mode)

;; Project errors on modeline
(with-eval-after-load 'lsp-mode
  ;; :global/:workspace/:file
  (setq ))

;; Breadcrumb on headerline
(setq )

;; org-mode src highlighting
(setq org-src-fontify-natively t)

;; Lsp
(after! lsp-mode
  (setq lsp-idle-delay 1.0
        lsp-log-io nil
        gc-cons-threshold (* 100 1024 1024)))

(after! lsp-mode
  (setq lsp-enable-symbol-highlighting t
        lsp-ui-doc-enable t
        lsp-lens-enable t
        lsp-headerline-breadcrumb-enable t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil
        lsp-diagnostics-provider :flycheck
        lsp-eldoc-enable-hover nil
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-completion-provider :company-mode
        lsp-completion-show-detail t
        lsp-completion-show-kind t))

;; Lsp ~ Treemacs
;; (lsp-treemacs-sync-mode 1)

;; YASnippet
(setq yas-triggers-in-field t)
