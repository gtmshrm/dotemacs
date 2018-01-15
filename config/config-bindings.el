(defmacro bind (&rest commands)
  "Convenience macro which creates a lambda interactive command."
  `(lambda (arg)
     (interactive "P")
     ,@commands))

(require-package 'which-key)
(setq which-key-idle-delay 0.2)
(setq which-key-min-display-lines 3)
(which-key-mode)

(defmacro -define-key (keymap sequence binding &optional description)
  (declare (indent defun))
  `(progn
     (define-key ,keymap (kbd ,sequence) ,binding)
     (when ,description
       (which-key-add-key-based-replacements ,sequence ,description))))

(defmacro -define-keys (keymap &rest body)
  (declare (indent defun))
  `(progn
     ,@(cl-loop for binding in body
                collect `(let ((seq ,(car binding))
                               (func ,(cadr binding))
                               (desc ,(caddr binding)))
                           (-define-key ,keymap seq func desc)))))

(defun /bindings/custom-major-mode-hydra ()
  (interactive)
  (let ((func (intern (concat "/hydras/modes/" (symbol-name major-mode) "/body"))))
    (if (fboundp func)
        (call-interactively func)
      (message "No custom major-mode bindings defined."))))



(after 'evil
  (after "multiple-cursors-autoloads"
    (define-key evil-normal-state-map (kbd "g r") 'mc/mark-all-like-this-dwim))

  (-define-keys evil-normal-state-map
    ("g d" #'dumb-jump-go))

  (require-package 'key-chord)
  ;; (setq key-chord-two-keys-delay 0.4)
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)

  (-define-key evil-normal-state-map (kbd "RET") #'/bindings/custom-major-mode-hydra)
  (-define-key evil-visual-state-map (kbd "RET") #'/bindings/custom-major-mode-hydra)

  (-define-keys evil-normal-state-map
    (", e" #'eval-last-sexp)
    (", , e" #'eval-defun)
    (", E" #'eval-defun)
    (", f" ctl-x-5-map "frames")
    (", v" (kbd "C-w v C-w l") "vsplit")
    (", s" (kbd "C-w s C-w j") "split")
    (", c" #'/eshell/new-split "eshell")
    (", C" #'customize-group)
    (", P" #'package-list-packages "packages")
    (", h" help-map "help"))

  (-define-keys evil-visual-state-map
    (", e" #'eval-region))

  (after "paradox-autoloads"
    (-define-key evil-normal-state-map ", P" #'paradox-list-packages))

  (-define-key evil-visual-state-map "SPC SPC" #'execute-extended-command "M-x")
  (-define-keys evil-normal-state-map
    ("SPC SPC" #'execute-extended-command "M-x")
    ("SPC t" #'/hydras/toggles/body "toggle...")
    ("SPC q" #'/hydras/quit/body "quit...")
    ("SPC e" #'/hydras/errors/body "errors...")
    ("SPC b" #'/hydras/buffers/body "buffers...")
    ("SPC j" #'/hydras/jumps/body "jump...")
    ("SPC f" #'/hydras/files/body "files...")
    ("SPC s" #'/hydras/search/body "search...")
    ("SPC l" #'/hydras/jumps/lambda-l-and-exit "lines(current)")
    ("SPC L" #'/hydras/jumps/lambda-L-and-exit "lines(all)")
    ("SPC o" #'/hydras/jumps/lambda-i-and-exit "outline")
    ("SPC '" #'/eshell/new-split "shell")
    ("SPC y" (bind
              (cond ((eq dotemacs-switch-engine 'ivy)
                     (call-interactively #'counsel-yank-pop))
                    ((eq dotemacs-switch-engine 'helm)
                     (call-interactively #'helm-show-kill-ring)))) "kill-ring"))

  (after "magit-autoloads"
    (-define-key evil-normal-state-map "SPC g" #'/hydras/git/body "git..."))

  (after "counsel-autoloads"
    (-define-key evil-normal-state-map "SPC i" #'/hydras/ivy/body "ivy..."))

  (after "helm-autoloads"
    (-define-key evil-normal-state-map "SPC h" #'/hydras/helm/body "helm..."))

  (after "helm-dash-autoloads"
    (-define-key evil-normal-state-map "SPC d" #'helm-dash "dash"))

  (after "fzf-autoloads"
    (define-key evil-normal-state-map (kbd "SPC F") 'fzf))

  (after "evil-numbers-autoloads"
    (-define-key evil-normal-state-map "C-a" #'evil-numbers/inc-at-pt)
    (-define-key evil-normal-state-map "C-S-a" #'evil-numbers/dec-at-pt))

  (after "git-gutter+-autoloads"
    (-define-keys evil-normal-state-map
      ("[ h" #'git-gutter+-previous-hunk)
      ("] h" #'git-gutter+-next-hunk))
    (-define-keys evil-visual-state-map
      ("SPC g a" #'git-gutter+-stage-hunks)
      ("SPC g r" #'git-gutter+-revert-hunks))
    (evil-ex-define-cmd "Gw" (bind (git-gutter+-stage-whole-buffer))))

  (-define-keys evil-normal-state-map
    ("g p" "`[v`]")
    ("g b" #'/hydras/buffers/lambda-b-and-exit))

  (-define-keys evil-normal-state-map
    ("C-b" #'evil-scroll-up)
    ("C-f" #'evil-scroll-down))

  (-define-keys evil-normal-state-map
    ("[ SPC" (bind (evil-insert-newline-above) (forward-line)))
    ("] SPC" (bind (evil-insert-newline-below) (forward-line -1)))
    ("[ e" "ddkP")
    ("] e" "ddp")
    ("[ b" 'previous-buffer)
    ("] b" 'next-buffer)
    ("[ q" 'previous-error)
    ("] q" 'next-error))

  (global-set-key (kbd "C-w") 'evil-window-map)
  (after 'evil-evilified-state
    (-define-keys evil-evilified-state-map
      ("C-h" #'evil-window-left)
      ("C-j" #'evil-window-down)
      ("C-k" #'evil-window-up)
      ("C-l" #'evil-window-right)))
  (-define-keys evil-normal-state-map
    ("C-h" #'evil-window-left)
    ("C-j" #'evil-window-down)
    ("C-k" #'evil-window-up)
    ("C-l" #'evil-window-right)
    ("SPC w d" #'evil-window-delete)
    ("SPC w h" #'evil-window-left)
    ("SPC w j" #'evil-window-down)
    ("SPC w k" #'evil-window-up)
    ("SPC w l" #'evil-window-right))

  (-define-keys evil-normal-state-map
    ("p" #'/hydras/paste/evil-paste-after)
    ("P" #'/hydras/paste/evil-paste-before)
    ("Q" #'/utils/window-killer)
    ("Y" "y$"))

  ;; emacs lisp
  (evil-define-key 'normal emacs-lisp-mode-map "K" (bind (help-xref-interned (symbol-at-point))))
  (after "elisp-slime-nav-autoloads"
    (evil-define-key 'normal emacs-lisp-mode-map (kbd "g d") 'elisp-slime-nav-find-elisp-thing-at-point))

  (after 'python
    (evil-define-key 'normal python-mode-map (kbd "C-c C-p") 'run-python)
    (evil-define-key 'normal python-mode-map (kbd "C-c C-c") 'python-shell-send-buffer)
    (evil-define-key 'normal python-mode-map (kbd ", ,") 'python-shell-send-string)
    (evil-define-key 'visual python-mode-map (kbd ", ,") 'python-shell-send-region)
    (evil-define-key 'normal python-mode-map (kbd ", f") 'python-shell-send-defun))

  (after 'coffee-mode
    (evil-define-key 'visual coffee-mode-map (kbd ", p") 'coffee-compile-region)
    (evil-define-key 'normal coffee-mode-map (kbd ", p") 'coffee-compile-buffer))

  (after 'stylus-mode
    (define-key stylus-mode-map [remap eval-last-sexp] '/stylus/compile-and-eval-buffer)
    (evil-define-key 'visual stylus-mode-map (kbd ", p") '/stylus/compile-and-show-region)
    (evil-define-key 'normal stylus-mode-map (kbd ", p") '/stylus/compile-and-show-buffer))

  (after 'tide
    (evil-define-key 'normal tide-mode-map (kbd "g d") #'tide-jump-to-definition)
    (evil-define-key 'normal tide-mode-map (kbd "g r") #'tide-rename-symbol))

  (after 'cider
    (evil-define-key 'normal clojure-mode-map (kbd ", e") #'cider-eval-last-sexp)
    (evil-define-key 'visual clojure-mode-map (kbd ", e") #'cider-eval-region)
    (evil-define-key 'normal clojure-mode-map (kbd ", E") #'cider-eval-defun-at-point)

    (evilify cider-docview-mode cider-docview-mode-map
      (kbd "q") #'cider-popup-buffer-quit)

    (evilify cider-inspector-mode cider-inspector-mode-map
      (kbd "L") #'cider-inspector-pop
      (kbd "n") #'cider-inspector-next-page
      (kbd "N") #'cider-inspector-previous-page
      (kbd "r") #'cider-inspector-refresh)

    (evilify cider-test-report-mode cider-test-report-mode-map
      (kbd "C-j") #'cider-test-next-result
      (kbd "C-k") #'cider-test-previous-result
      (kbd "RET") #'cider-test-jump
      (kbd "d")   #'cider-test-ediff
      (kbd "e")   #'cider-test-stacktrace
      (kbd "q")   #'cider-popup-buffer-quit
      (kbd "r")   #'cider-test-rerun-tests
      (kbd "t")   #'cider-test-run-test
      (kbd "T")   #'cider-test-run-ns-tests)

    (evilify cider-stacktrace-mode cider-stacktrace-mode-map
      (kbd "C-j") #'cider-stacktrace-next-cause
      (kbd "C-k") #'cider-stacktrace-previous-cause
      (kbd "TAB") #'cider-stacktrace-cycle-current-cause
      (kbd "0")   #'cider-stacktrace-cycle-all-causes
      (kbd "1")   #'cider-stacktrace-cycle-cause-1
      (kbd "2")   #'cider-stacktrace-cycle-cause-2
      (kbd "3")   #'cider-stacktrace-cycle-cause-3
      (kbd "4")   #'cider-stacktrace-cycle-cause-4
      (kbd "5")   #'cider-stacktrace-cycle-cause-5
      (kbd "a")   #'cider-stacktrace-toggle-all
      (kbd "c")   #'cider-stacktrace-toggle-clj
      (kbd "d")   #'cider-stacktrace-toggle-duplicates
      (kbd "J")   #'cider-stacktrace-toggle-java
      (kbd "r")   #'cider-stacktrace-toggle-repl
      (kbd "T")   #'cider-stacktrace-toggle-tooling))

  (after "projectile-autoloads"
    (-define-keys evil-normal-state-map
      ("SPC p" #'projectile-command-map "projectile...")
      ("SPC /"
       (bind
        (if current-prefix-arg
            (cond
             ((executable-find "ag")  (call-interactively #'projectile-ag))
             ((executable-find "pt")  (call-interactively #'projectile-pt))
             ((executable-find "ack") (call-interactively #'projectile-ack))
             (t                       (call-interactively #'projectile-grep)))
          (cond
           ((eq dotemacs-switch-engine 'ivy)
            (cond
             ((executable-find "ag") (counsel-ag))
             ((executable-find "pt") (counsel-pt))))
           ((eq dotemacs-switch-engine 'helm)
            (helm-do-ag (projectile-project-root))))))
       "search..."))
    (-define-keys evil-normal-state-map
      ("C-p" (bind
              (cond ((eq dotemacs-switch-engine 'helm)
                     (call-interactively #'helm-projectile))
                    ((eq dotemacs-switch-engine 'ivy)
                     (if (projectile-project-p)
                         (call-interactively #'counsel-projectile-find-file)
                       (call-interactively #'counsel-projectile)))
                    (t
                     (call-interactively #'projectile-find-file-dwim)))))))

  (after 'js2-mode
    (evil-define-key 'normal js2-mode-map (kbd "g r") #'js2r-rename-var))

					; (after "avy-autoloads"
					;   (define-key evil-operator-state-map (kbd "z") 'avy-goto-char-2)
					;   (define-key evil-normal-state-map (kbd "s") 'avy-goto-char-2)
					;   (define-key evil-motion-state-map (kbd "S-SPC") 'avy-goto-line))

  (add-hook 'eshell-mode-hook
            (lambda ()
              (local-set-key (kbd "C-h") #'evil-window-left)
              (local-set-key (kbd "C-j") #'evil-window-down)
              (local-set-key (kbd "C-k") #'evil-window-up)
              (local-set-key (kbd "C-l") #'evil-window-right))))

;; escape minibuffer
(define-key minibuffer-local-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] '/utils/minibuffer-keyboard-quit)

(define-key minibuffer-local-map (kbd "C-w") 'backward-kill-word)


(after 'ivy
  (define-key ivy-mode-map [escape] (kbd "C-g")))


(after "magit-autoloads"
  (global-set-key (kbd "C-x g") #'/hydras/git/body))


(after "treemacs-autoloads"
  (global-set-key [f3] #'treemacs-find-file)
  (global-set-key [f2] #'treemacs-toggle)
  (after "projectile-autoloads"
    (global-set-key [f2] #'treemacs-projectile-toggle)))


(after "multiple-cursors-autoloads"
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click))


(after 'comint
  (define-key comint-mode-map [up] 'comint-previous-input)
  (define-key comint-mode-map [down] 'comint-next-input))


(after 'auto-complete
  (define-key ac-completing-map (kbd "C-n") 'ac-next)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous))


(after 'company
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "<tab>") '/company/tab)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous))


(after "expand-region-autoloads"
  (global-set-key (kbd "C-=") 'er/expand-region))


;; mouse scrolling in terminal
(unless (display-graphic-p)
  (global-set-key [mouse-4] (bind (scroll-down 1)))
  (global-set-key [mouse-5] (bind (scroll-up 1))))


(after 'compile
  (define-key compilation-mode-map (kbd "j") 'compilation-next-error)
  (define-key compilation-mode-map (kbd "k") 'compilation-previous-error))


(after "helm-autoloads"
  (-define-key (current-global-map) "C-c h" #'/hydras/helm/body "helm..."))


(after "counsel-autoloads"
  (-define-key (current-global-map) "C-c i" #'/hydras/ivy/body "ivy..."))


(global-set-key [prior] 'previous-buffer)
(global-set-key [next] 'next-buffer)

(-define-keys (current-global-map)
  ("C-c c" #'org-capture)
  ("C-c a" #'org-agenda)
  ("C-c l" #'org-store-link)
  ("C-c s" #'/utils/goto-scratch-buffer)
  ("C-c e" #'/utils/eval-and-replace)
  ("C-c t" #'/eshell/new-split))

(-define-keys (current-global-map)
  ("C-x c" #'calculator)
  ("C-x C" #'calendar)
  ("C-x C-b" #'ibuffer)
  ("C-x C-k" #'kill-this-buffer)
  ("C-x n" #'/hydras/narrow/body)
  ("C-x p" #'proced))

(after "vkill-autoloads"
  (autoload 'vkill "vkill" nil t)
  (global-set-key (kbd "C-x p") 'vkill))

(-define-keys (current-global-map)
  ("C-s"   #'isearch-forward-regexp)
  ("C-M-s" #'isearch-forward)
  ("C-r"   #'isearch-backward-regexp)
  ("C-M-r" #'isearch-backward))


(global-set-key (kbd "<f5>") (bind (profiler-start 'cpu+mem)))
(global-set-key (kbd "<f6>") (bind (profiler-report) (profiler-stop)))


;; have no use for these default bindings
(global-unset-key (kbd "C-x m"))


(global-set-key (kbd "C-x C-c") (bind (message "Thou shall not quit!")))
(after 'evil
  (defadvice evil-quit (around dotemacs activate)
    (message "Thou shall not quit!"))
  (defadvice evil-quit-all (around dotemacs activate)
    (message "Thou shall not quit!")))


(provide 'config-bindings)
