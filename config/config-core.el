(setq server-auth-dir (concat dotemacs-cache-directory "server"))
(require 'server)
(unless (server-running-p)
  (server-start))


;; move cursor to the last position upon open
(require 'saveplace)
(setq save-place-file (concat dotemacs-cache-directory "places"))
(setq-default save-place t)


;; savehist
(setq savehist-file (concat dotemacs-cache-directory "savehist")
      savehist-additional-variables '(search ring regexp-search-ring)
      savehist-autosave-interval 60
      history-length 1000)
(savehist-mode)


;; recent files
(require 'recentf)
(setq recentf-save-file (concat dotemacs-cache-directory "recentf"))
(setq recentf-max-saved-items 1000)
(setq recentf-max-menu-items 500)
(setq recentf-auto-cleanup 300)
(add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
(add-to-list 'recentf-exclude ".*elpa.*autoloads\.el$")
(recentf-mode t)
(run-with-idle-timer 600 t #'recentf-save-list)


;; gc
(defun /core/minibuffer-setup-hook () (setq gc-cons-threshold most-positive-fixnum))
(defun /core/minibuffer-exit-hook () (setq gc-cons-threshold (* 64 1024 1024)))
(add-hook 'minibuffer-setup-hook #'/core/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'/core/minibuffer-exit-hook)


;; pcomplete
(setq pcomplete-ignore-case t)


;; imenu
(setq-default imenu-auto-rescan t)


;; narrowing
(put 'narrow-to-region 'disabled nil)


;; dired
(after 'dired
  (require 'dired-x))


;; url
(setq url-configuration-directory (concat dotemacs-cache-directory "url/"))


;; tramp
(setq tramp-persistency-file-name (concat dotemacs-cache-directory "tramp"))


;; comint
(after 'comint
  (defun /core/toggle-comint-scroll-to-bottom-on-output ()
    (interactive)
    (if comint-scroll-to-bottom-on-output
        (setq comint-scroll-to-bottom-on-output nil)
      (setq comint-scroll-to-bottom-on-output t))))


;; compile
(setq compilation-always-kill t)
(setq compilation-ask-about-save nil)
(add-hook 'compilation-filter-hook
          (lambda ()
            (when (eq major-mode 'compilation-mode)
              (require 'ansi-color)
              (let ((inhibit-read-only t))
                (ansi-color-apply-on-region (point-min) (point-max))))))


;; bookmarks
(setq bookmark-default-file (concat dotemacs-cache-directory "bookmarks"))
(setq bookmark-save-flag 1) ;; save after every change


;; fringe
(when (display-graphic-p)
  (fringe-mode 16))


;; ediff
(setq ediff-split-window-function 'split-window-horizontally) ;; side-by-side diffs
(setq ediff-window-setup-function 'ediff-setup-windows-plain) ;; no extra frames


;; re-builder
(setq reb-re-syntax 'string) ;; fix backslash madness


;; clean up old buffers periodically
(midnight-mode)
(midnight-delay-set 'midnight-delay 0)


;; ibuffer
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook #'ibuffer-auto-mode)


;; move auto-save to the cache
(let ((dir (expand-file-name (concat dotemacs-cache-directory "auto-save/"))))
  (setq auto-save-list-file-prefix (concat dir "saves-"))
  (setq auto-save-file-name-transforms `((".*" ,(concat dir "save-") t))))


;; multiple-backups
(setq backup-directory-alist `((".*" . ,(expand-file-name (concat dotemacs-cache-directory "backups/")))))
(setq backup-by-copying t)
(setq version-control t)
(setq kept-old-versions 0)
(setq kept-new-versions 20)
(setq delete-old-versions t)


;; better scrolling
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t
      scroll-margin 3)


;; better buffer names for duplicates
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      uniquify-separator "/"
      uniquify-ignore-buffers-re "^\\*" ; leave special buffers alone
      uniquify-after-kill-buffer-p t)


(defun /core/do-not-kill-scratch-buffer ()
  (if (member (buffer-name (current-buffer))
              '("*scratch*" "*Messages*" "*Require Times*"))
      (progn
        (bury-buffer)
        nil)
    t))
(add-hook 'kill-buffer-query-functions '/core/do-not-kill-scratch-buffer)


(defalias 'yes-or-no-p 'y-or-n-p)


(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq sentence-end-double-space nil)
(setq delete-by-moving-to-trash t)
(setq ring-bell-function 'ignore)
(setq mark-ring-max 64)
(setq global-mark-ring-max 128)
(setq save-interprogram-paste-before-kill t)
(setq create-lockfiles nil)
(setq echo-keystrokes 0.01)
(setq initial-major-mode 'emacs-lisp-mode)
(setq eval-expression-print-level nil)
;(setq-default indent-tabs-mode nil)

(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)

;; font
(set-frame-font "DejaVu Sans Mono:pixelsize=12")
;; (set-face-attribute 'default nil
;;                     :family "menlo"
;;                     :weight 'normal
;;                     :width 'normal
;;                     :height 100)

(global-visual-line-mode)
(xterm-mouse-mode t)
(which-function-mode t)
(blink-cursor-mode -1)
(global-auto-revert-mode t)
(electric-indent-mode t)
(transient-mark-mode t)
(delete-selection-mode t)
(random t) ;; seed


(when (eq dotemacs-pair-engine 'emacs)
  (electric-pair-mode t)
  (add-hook 'minibuffer-setup-hook (lambda () (electric-pair-mode -1)))
  (add-hook 'minibuffer-exit-hook (lambda () (electric-pair-mode t))))


(defun /core/find-file-hook ()
  (when (string-match "\\.min\\." (buffer-file-name))
    (fundamental-mode)))
(add-hook 'find-file-hook #'/core/find-file-hook)


(evilify profiler-report-mode profiler-report-mode-map)
(evilify Custom-mode Custom-mode-map)
(evilify help-mode help-mode-map)
(evilify ibuffer-mode ibuffer-mode-map)
(evilify package-menu-mode package-menu-mode-map)
(evilify calendar-mode calendar-mode-map
  "j" #'calendar-forward-week
  "k" #'calendar-backward-week
  "l" #'calendar-forward-day
  "h" #'calendar-backward-day)


(provide 'config-core)
