;; -*- Mode: Emacs-Lisp -*-

;;; This is a sample .emacs file.
;;;
;;; The .emacs file, which should reside in your home directory, allows you to
;;; customize the behavior of Emacs.  In general, changes to your .emacs file
;;; will not take effect until the next time you start up Emacs.  You can load
;;; it explicitly with `M-x load-file RET ~/.emacs RET'.
;;;
;;; There is a great deal of documentation on customization in the Emacs
;;; manual.  You can read this manual with the online Info browser: type
;;; `C-h i' or select "Emacs Info" from the "Help" menu.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Basic Customization                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Are we on a mac?
(setq is-osx (equal system-type 'darwin))

;;;; shorter yes-no-dialogs
;;  (fset 'yes-or-no-p 'y-or-n-p)

;;;; Hide splash-screen and startup-message
;;  (setq inhibit-splash-screen nil)
;;  (setq inhibit-startup-message nil)

;;;; No menu bar
;;  (menu-bar-mode -1)
;;  (tool-bar-mode -1)

;;;; No scroll bars
;;  (scroll-bar-mode 0)

;;;; The blinking cursor is nothing, but an annoyance
;;  (blink-cursor-mode -1)

;;;; enable narrowing
;;;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Narrowing.html
;;  (put 'narrow-to-region 'disabled nil)

;;;; Enable linun
(global-linum-mode t)

;;;; Newline at end of file
(setq require-final-newline t)

;;;; delete the selection with a keypress
(delete-selection-mode t)

;;;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;;;; don't use tabs to indent
(setq-default indent-tabs-mode nil)

;;;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;;;; Setting Emacs 24 color theme from .emacs
;;;; http://stackoverflow.com/questions
;;;;   /9472254/setting-emacs-24-color-theme-from-emacs
(set-face-attribute 'default nil :height 100)

;;;; Reduce tabbing
(setq default-tab-width 2)

;;;; Linum readable
(setq linum-format "%4d \u2502 ")

;;;; Backups in .saves
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 5
  kept-old-versions 2
  version-control t)

;;;; Goto-line short-cut key
(global-set-key "\C-l" 'goto-line)

;;;; Highlight current line
;;;; http://www.emacswiki.org/emacs/HighlightCurrentLine
(global-hl-line-mode 1)

;;;; To customize the background color Emacs 22
;; (set-face-background 'hl-line "#330")

;;;; Enable the display of the current time
;;;; http://www.emacswiki.org/emacs/DisplayTime
(display-time-mode 1)

;;;; Enable or disable the display of the current line number
;;;; http://www.emacswiki.org/emacs/LineNumbers
;;;;  (line-number-modelinu 1)

;;;; Enable or disable the display of the current column number
(column-number-mode 1)

;;;; Enable or disable the current buffer size
;;;; http://www.gnu.org/software
;;;;   /emacs/manual/html_node/emacs/Optional-Mode-Line.html
;;  (size-indication-mode 1)

;;;; Enable or disable laptop battery information
;;;; http://www.emacswiki.org/emacs/DisplayBatteryMode
;;  (display-battery-mode 1)

;;;; http://www.emacswiki.org/emacs/ModeLineConfiguration
(column-number-mode 1)

;;;; Functions
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(defun strip-smart-quotes (rStart rEnd)
  "Replace smart quotes with plain quotes in text"
  (interactive "r")
  (save-restriction
    (narrow-to-region rStart rEnd)
    (goto-char (point-min))
    (while (re-search-forward "[“”]" nil t) (replace-match "\"" nil t))
      (goto-char (point-min))
      (while (re-search-forward "[‘’]" nil t) (replace-match "'" nil t))))

;;;; Set Frame title
(setq frame-title-format
  '((:eval (if (buffer-file-name)
    ;; (abbreviate-file-name (buffer-file-name))
    (buffer-file-name)
    "%b"))))

;;  (global-set-key (kbd "S-<f1>")
;;    (lambda ()
;;    (interactive)
;;    (dired "~/")))

;;  (defun switch-to-previous-buffer ()
;;    (interactive)
;;    (switch-to-buffer (other-buffer (current-buffer) 1)))

;;  (defun sudo-edit (&optional arg)
;;    "Edit currently visited file as root.
;;     With a prefix ARG prompt for a file to visit.
;;     Will also prompt for a file to visit if current
;;     buffer is not visiting a file."
;;    (interactive "P")
;;    (if (or arg (not buffer-file-name))
;;        (find-file (concat "/sudo:root@localhost:"
;;                           (ido-read-file-name "Find file(as root): ")))
;;      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;;;; the CamelCase issue
;;;; enable just in ruby-mode
;;  (add-hook 'ruby-mode-hook 'subword-mode)
;;;; enable for all programming modes
;;  (add-hook 'prog-mode-hook 'subword-mode)

;;;; BACKUP DIRS
;;;; http://www.emacswiki.org/emacs/BackupDirectory
;;  (setq backup-directory-alist
;;    `((".*" . ,temporary-file-directory)))
;;
;;  (setq auto-save-file-name-transforms
;;    `((".*" ,temporary-file-directory t)))

;;  (defun top-join-line ()
;;    "Join the current line with the line beneath it."
;;    (interactive)
;;    (delete-indentation 1))

;;  (global-set-key (kbd "M-^") 'top-join-line)

;;  (defun duplicate-line()
;;    (interactive)
;;    (move-beginning-of-line 1)
;;    (kill-line)
;;    (yank)
;;    (open-line 1)
;;    (next-line 1)
;;    (yank))

;;  (defun smart-open-line-above ()
;;    "
;;      Insert an empty line above the current line.
;;      Position the cursor at it's beginning, according to the current mode.
;;    "
;;    (interactive)
;;    (move-beginning-of-line nil)
;;    (newline-and-indent)
;;    (forward-line -1)
;;    (indent-according-to-mode))

;;  (global-set-key [(control shift return)] 'smart-open-line-above)
;;  (global-set-key (kbd "M-o") 'smart-open-line)
;;  (global-set-key (kbd "M-O") 'smart-open-line-above)

;;;; Package managers
;;;; List of all wanted packages
(setq
 wanted-packages
 '(
    ;;;; OSX specific
    exec-path-from-shell

    ;;;; Editor stuff
    ;;  popup
    ;;  auto-complete
    ;;  whitespace-cleanup-mode
    smartparens
    ;;  diff-hl
    ;;  anzu
    ido
    multiple-cursors
    neotree
    
    ;;;; Project and completion stuff
    projectile
    flx-ido    
    ;;  helm
    ;;  helm-ag
    ;;  helm-projectile
    ;;  ignoramus
    ;;  ag

    ;;;; Magit and diff
    ;;  magit
    ;;  magit-gh-pulls
    ;;  git-timemachine

    ;;;; graphical stuff
    ;;  ace-jump-mode
    ;;  switch-window
    ;;  highlight-indentation
    ;;  expand-region
    ;;  neotree
    smart-mode-line

    ;;;; syntax checking on-fly
    ;;  flycheck

    ;;;; yasnippet
    ;;  yasnippet

    ;; go
    go-mode
    golint
    ;;  go-projectile
    ;;  go-autocomplete

    ;;;; web mode
    ;;  web-mode
    ;;  web-beautify

    ;;;; javascript stuff
    ;;  js2-mode
    ;;  js2-refactor
    ;;  ac-js2
    ;;  react-snippets

    ;;;; typescript
    ;;  typescript
    ;;  tss

    ;;;; CSS, sass & scss
    ;;  css-mode
    ;;  scss-mode
    ;;  sass-mode

    ;;;; coffee-mode (hipster's not dead)
    ;;  coffee-mode

    ;;;; php stuff
    ;;  php-mode

    ;;;; toml stuff
    ;;  toml-mode

    ;;;; yaml stuff
    ;;  yaml-mode

    ;;;; ruby mode
    ;;  robe
    ;;  rubocop

    ;;;; markdown stuff
    markdown-mode

    ;;;; elixir stuff
    ;;  alchemist
    ;;  elixir-mode
    ;;  elixir-yasnippets

    ;;;; dockerfile-mode
    ;;  dockerfile-mode

    ;;;; feature-mode
    ;;  feature-mode

    ;;;; themes
    ;;  color-theme
    ;;  gotham-theme
    ;;  obsidian-theme
    ;;  solarized-theme
    ))

;;;; Package manager and packages handler
(defun install-wanted-packages ()
  "Install wanted packages according to a specific package manager."

  ;; package.el
  (require 'package)
  (add-to-list 'package-archives
    '("gnu" . "http://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives
    '("melpa" . "http://melpa.milkbox.net/packages/"))
  (add-to-list 'package-archives
    '("marmelade" . "http://marmalade-repo.org/packages/"))

  (package-initialize)
  (let ((need-refresh nil))
    (mapc (lambda (package-name)
      (unless (package-installed-p package-name)
      (set 'need-refresh t))) wanted-packages)
    (if need-refresh
        (package-refresh-contents)))

  (mapc (lambda (package-name)
    (unless (package-installed-p package-name)
      (package-install package-name))) wanted-packages))

;;;; Devel text modes mode
(defun devel-modes-hook ()
  "Activate minor modes for developing."

  ;;;; diff-hl
  (diff-hl-mode t)

  ;;;; line mode
  (hl-line-mode t)

  ;;;; line numbers
  (linum-mode t)

  ;;;; whitespace
  (whitespace-mode 1)
  (whitespace-cleanup-mode t))

;;;; Presentation modes
(defun presentation-modes-hook ()
  "Activate minor modes for presenting."

  ;;;; diff-hl
  (diff-hl-mode nil)

  ;;;; line mode
  (hl-line-mode t)

  ;;;; line numbers
  ;;  (linum-mode nil)

  ;;;; OSX presentation friendly font
  (when is-osx
    ;;  (when window-system
    ;;    (set-face-attribute 'default nil :font ~/presentation-font))
    ;;  (message "Minibuffer depth is %d."
    ;;    (minibuffer-depth))
    (message "Using OSX")))

;;;; Install wanted packages
(install-wanted-packages)

;;;; PACKAGES configurations

;;;; NEOTREE
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;;; DIRED
(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)

;;;; was dired-advertised-find-file
;;  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

;;;; was dired-up-directory
;;  (define-key dired-mode-map
;;    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))

;;;; allow dired to be able to delete or copy a whole dir.
;;  (setq dired-recursive-copies (quote always)) ; “always” means no asking
;;  (setq dired-recursive-deletes (quote top)) ; “top” means ask once

;;;; MULTIPLE CURSORS
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;;; IDO
(require 'ido)
(ido-mode t)

;;;; FLX-IDO
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;;;; RINARI
;; (add-to-list 'load-path "~/.emacs.d/scripts/rinari")
;; (require 'rinari)

;;;; DIRTREE
;; (require 'dirtree)

;;;; SMARTPARENS
;; smart pairing for all
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)
(show-smartparens-global-mode 1)

;;;; ANZU-MODE
;;;; enhances isearch & query-replace
;;;; by showing total matches and current match position
;;  (require 'anzu)
;;  (global-anzu-mode)
;;  (global-set-key (kbd "M-%") 'anzu-query-replace)
;;  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

;;;; WHITESPACE-MODE CONFIG
;;  (require 'whitespace)
;;  (setq whitespace-line-column 120) ;; limit line length
;;  (setq whitespace-style '(face tabs empty trailing lines-tail))

;;;; IGNORAMUS
;;  (ignoramus-setup)

;;;; PROJECTILE
;;  (projectile-global-mode)
;;  (setq projectile-completion-system 'helm)
;;;; ignore common temporary directories
;;  (setq projectile-globally-ignored-directories
;;    (append projectile-globally-ignored-directories
;;      '("node_modules" "bower_components" ".bower-cache"
;;        "public/assets" "tmp")))
;;  (helm-projectile-on)

;;;; YASNIPPET
;;;; should be loaded before auto complete so that they can work together
;;  (require 'yasnippet)
;;  (yas-global-mode 1)
;;;; auto complete mod
;;;; should be loaded after yasnippet so that they can work together
;;  (require 'auto-complete-config)
;;  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;;  (ac-config-default)
;;  (ac-linum-workaround)
;;  (ac-flyspell-workaround)
;;;; set the trigger key so that it can work together with yasnippet on tab key,
;;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;;; activate, otherwise, auto-complete will
;;  (ac-set-trigger-key "TAB")
;;  (ac-set-trigger-key "<tab>")

;;;; HELM
;;  (global-set-key (kbd "C-x b") 'helm-mini)
;;  (global-set-key (kbd "M-x") 'helm-M-x)
;;  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;;  (global-set-key (kbd "C-x C-f") 'helm-find-files)
;;  (global-set-key (kbd "C-x r") 'helm-recentf)
;;;; definitions
;;  (define-key helm-map (kbd "<tab>")
;;    'helm-execute-persistent-action) ; rebind tab to do persistent action
;;  (define-key helm-map (kbd "C-i")
;;    'helm-execute-persistent-action) ; make TAB works in terminal
;;  (define-key helm-map (kbd "C-z")
;;    'helm-select-action) ; list actions using C-z
;;;; fuzzy matching everywhere
;;  (setq helm-buffers-fuzzy-matching t
;;    helm-recentf-fuzzy-match t
;;    helm-M-x-fuzzy-match t)
;; widen buffer name length
;; (setq helm-buffer-max-length 40)
;; makes helm-ag use the platinum searcher
;;(setq helm-ag-base-command "pt --nocolor --nogroup")
;; (helm-autoresize-mode t)

;;;; GIT-TIMEMACHINE
;;  (global-set-key (kbd "C-x t") 'git-timemachine-toggle)

;;;; ACE-JUMP-MODE
;;  (require 'ace-jump-mode)
;;  (eval-when-compile
;;    (require 'cl))
;;  (global-set-key (kbd "C-x C-j") 'ace-jump-word-mode)
;;  (global-set-key (kbd "C-M-j") 'ace-jump-word-mode)
;;  (global-set-key (kbd "C-x j") 'ace-jump-char-mode)

;;;; MAGIT
;;  (global-set-key (kbd "C-x g") 'magit-status)
;;  (global-set-key (kbd "C-c l") 'magit-log)
;;  (global-set-key (kbd "C-c o") 'magit-checkout)
;;  (add-hook 'magit-mode-hook
;;    (lambda ()
;;      (turn-on-magit-gh-pulls)
;;      (setq magit-gh-pulls-collapse-commits t)))
;;  (setq magit-last-seen-setup-instructions "1.4.0")

;;;; SWITCH-WINDOW
;;  (require 'switch-window)
;;  (global-set-key (kbd "C-x C-o") 'switch-window)

;;;; EXPAND-REGION
;;  (require 'expand-region)
;;  (global-set-key (kbd "ESC <up>") 'er/expand-region)
;;  (global-set-key (kbd "ESC <down>") 'er/contract-region)

;;;; NEOTREE
;;  (require 'neotree)
;;  (global-set-key (kbd "C-c n") 'neotree-toggle)

;;;; FLYCHECK
;;  (add-hook 'after-init-hook #'global-flycheck-mode)

;;;; LISP mode
;;  (add-hook 'lisp-mode-hook 'devel-modes-hook)

;;;; GO mode
(require 'go-mode)

;;;; gofmt
(setq exec-path (cons "/usr/local/bin/go" exec-path))
(add-to-list 'exec-path "/Users/edoardo/Workspaces/go.sources/bin")
(add-hook 'before-save-hook 'gofmt-before-save)

;;;; go-autocomplete
;;  (require 'go-autocomplete)
;;  (add-hook 'go-mode-hook
;;    (lambda ()
;;      ;; Use goimports instead of go-fmt
;;      (setq gofmt-command "goimports")
;;
;;      ;; Call Gofmt before saving
;;      (add-hook 'before-save-hook 'gofmt-before-save)
;;
;;      ;; Customize compile command to run go build
;;      (if (not (string-match "go" compile-command))
;;        (set (make-local-variable 'compile-command)
;;          "go build -v && go test -v && go vet"))
;;
;;      ;; Godef jump key binding
;;      (local-set-key (kbd "M-.") 'godef-jump)
;;      (devel-modes-hook)))

;;;; WEB mode
;;  (setq web-mode-enable-current-element-highlight t
;;    web-mode-enable-current-column-highlight t)
;;  (require 'web-mode)
;;  (require 'react-snippets)
;;  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;;  ;; using web-mode with html also
;;  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;;  ;; using web-mode with handlebars also
;;  (add-to-list 'auto-mode-alist '("\\.handlebars$" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
;;  ;; web-mode for *.js, *.jsx and *.json
;;  (add-to-list 'auto-mode-alist '("\\.jsx?" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.json$" . web-mode))
;;  (add-hook 'web-mode-hook
;;    (lambda ()
;;      (setq
;;        web-mode-markup-indent-offset 2
;;        web-mode-css-indent-offset 2
;;        web-mode-code-indent-offset 2)
;;      (devel-modes-hook)))

;;  (setq flycheck-disabled-checkers '(javascript-jshint))
;;  (setq flycheck-checkers '(javascript-eslint))

;;;; TYPESCRIPT mode
;;  (require 'typescript)
;;  (add-to-list 'auto-mode-alist '("\\.tss\\'" . typescript-mode))
;;  (add-hook 'typescript-mode-hook
;;    (lambda ()
;;      (setq typescript-indent-level 2)
;;      (devel-modes-hook)))

;;;; TSS
;;  (require 'tss)
;;  (setq tss-popup-help-key "C-:")
;;  (setq tss-jump-to-definition-key "C->")
;;  (setq tss-implement-definition-key "C-c i")
;;;; Do setting recommended configuration
;;  (tss-config-default)

;;;; SCSS mode
;;  (add-hook 'css-mode-hook
;;    (lambda ()
;;      (setq
;;        indent-tabs-mode nil
;;        css-indent-offset 2)
;;      (devel-modes-hook)))
;;
;;  (add-hook 'scss-mode-hook
;;    (lambda ()
;;    (setq indent-tabs-mode nil
;;        css-indent-offset 2))
;;    (devel-modes-hook))

;;;; PHP mode
;;  (require 'php-mode)
;;  (add-hook 'php-mode-hook
;;    (lambda ()
;;      (php-enable-default-coding-style)
;;      (devel-modes-hook)))

;;;; RUBY mode
;;  (require 'rubocop)
;;  (add-to-list
;;    'auto-mode-alist
;;    '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" .
;;      ruby-mode))
;;
;;  (add-to-list
;;    'auto-mode-alist
;;    '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" .
;;    ruby-mode))
;;
;;  (add-hook 'ruby-mode-hook
;;    (lambda()
;;      (local-set-key "\r" 'newline-and-indent)
;;      (flymake-ruby-load)
;;      (devel-modes-hook)
;;      (robe-mode)
;;      (rubocop-mode)
;;      (devel-modes-hook)))

;;;; HAML mode
;;  (add-hook 'haml-mode-hook 'devel-modes-hook)

;;;; TOML mode
;;  (require 'toml-mode)
;;  (add-to-list 'auto-mode-alist '("\\.toml$\\'" . toml-mode))
;;  (add-hook 'toml-mode-hook 'devel-modes-hook)

;;;; YAML mode
;;  (require 'yaml-mode)
;;  (add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
;;  (add-hook 'yaml-mode-hook
;;    (lambda ()
;;      (define-key yaml-mode-map "\C-m" 'newline-and-indent)
;;      (devel-modes-hook)))

;;;; MARKDOWN mode
;;;; http://jblevins.org/projects/markdown-mode/
(require 'markdown-mode)
(add-to-list 'load-path "~/.emacs.d/scripts/")
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-hook 'markdown-mode-hook 'devel-modes-hook)

;;;; ELIXIR MODE
;;  (require 'elixir-mode)
;;  (add-hook 'elixir-mode-hook 'devel-modes-hook)

;;;; DOCKERFILE MODE
;;  (require 'dockerfile-mode)
;;  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;;; FEATURE MODE
;;  (require 'feature-mode)
;;  (add-hook 'feature-mode-hook 'devel-modes-hook)

;; OSX: exec-path-from-shell-initialize
;; Setup environment variables from the user's shell.
(when is-osx
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize)

  ;; change command to meta and ignore option
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq ns-function-modifier 'hyper)

  ;; mac friendly font
  ;;  (when window-system
  ;;    (setq ~/default-font "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
  ;;    (setq ~/presentation-font "-apple-Menlo-medium-normal-normal-*-18-*-*-*-m-0-iso10646-1")
  ;;    (set-face-attribute 'default nil :font ~/default-font))

  ;; Move to trash when deleting stuff
  (setq delete-by-moving-to-trash t
        trash-directory "~/.Trash/emacs")

  ;; Ignore .DS_Store files with ido mode
  (add-to-list 'ido-ignore-files "\\.DS_Store"))

;;;; THEMES color-theme.el/file
(add-to-list 'load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;;  (require 'color-theme)
;;  (eval-after-load "color-theme"
;;    '(progn
;;       (color-theme-initialize)
;;       (color-theme-hober)))
;;  (load-theme 'gotham t)
;;  (load-theme 'obsidian t)
;;  (load-theme 'solarized-dark t)

;;;; SMART-LINE-MODE
;;  (require 'smart-mode-line)
;;  (setq sml/mode-width 'full)
;;  (sml/setup)
;;  (sml/apply-theme 'automatic)

(provide '.emacs)
;;;; .emacs personal settings ends here

;; (show-paren-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(fci-rule-color "#eee8d5")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(magit-diff-use-overlays nil)
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c37300")
     (60 . "#b97d00")
     (80 . "#b58900")
     (100 . "#a18700")
     (120 . "#9b8700")
     (140 . "#948700")
     (160 . "#8d8700")
     (180 . "#859900")
     (200 . "#5a942c")
     (220 . "#439b43")
     (240 . "#2da159")
     (260 . "#16a870")
     (280 . "#2aa198")
     (300 . "#009fa7")
     (320 . "#0097b7")
     (340 . "#008fc7")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496")))
 '(xterm-color-names
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#073642"])
 '(xterm-color-names-bright
   ["#fdf6e3" "#cb4b16" "#93a1a1" "#839496" "#657b83" "#6c71c4" "#586e75" "#002b36"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
