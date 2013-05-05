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

;; Hide splash-screen and startup-message
;; (setq inhibit-splash-screen nil)
;; (setq inhibit-startup-message nil)

(set-face-attribute 'default nil :height 100)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(display-battery-mode t)
 '(fancy-splash-image "nil")
 '(show-paren-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 75 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

(setq fancy-splash-image (expand-file-name "~/Pictures/emacs_splash_image.xpm"))

(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
		  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(require 'linum)
(global-linum-mode 1)
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; Goto-line short-cut key
(global-set-key "\C-l" 'goto-line)

(global-hl-line-mode +1)
(column-number-mode 1)

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

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                  ;; (abbreviate-file-name (buffer-file-name))
                 (buffer-file-name)
                 "%b"))))

;; (add-to-list 'load-path "/path/to/color-theme.el/file")
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))

(add-to-list 'load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(global-set-key (kbd "S-<f1>")
  (lambda ()
    (interactive)
    (dired "~/")))

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.
   With a prefix ARG prompt for a file to visit.
   Will also prompt for a file to visit if current
   buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; the CamelCase issue
;; enable just in ruby-mode
(add-hook 'ruby-mode-hook 'subword-mode)

;; enable for all programming modes
(add-hook 'prog-mode-hook 'subword-mode)

;; http://www.emacswiki.org/emacs/BackupDirectory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;
