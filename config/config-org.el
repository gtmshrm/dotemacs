(after 'org
  (setq org-directory "~/Dropbox/org")

  (defgroup dotemacs-org nil
    "Configuration options for org-mode."
    :group 'dotemacs
    :prefix 'dotemacs-org)

  (defcustom dotemacs-org/journal-file (concat org-directory "/journal.org")
    "The path to the file where you want to make journal entries."
    :type 'file
    :group 'dotemacs-org)

  (defcustom dotemacs-org/inbox-file (concat org-directory "/inbox.org")
    "The path to the file where to capture notes."
    :type 'file
    :group 'dotemacs-org)

  (unless (file-exists-p org-directory)
    (make-directory org-directory))

  (defun org-file-path (filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory org-directory) filename))
  (setq org-archive-location
	(concat (org-file-path "archive.org") "::* From %s"))

  (setq org-default-notes-file (expand-file-name dotemacs-org/inbox-file))
  (setq org-default-journal-file (expand-file-name dotemacs-org/journal-file))
  (setq org-log-done t)
  (setq org-log-into-drawer t)

  (setq org-startup-indented t)
  (setq org-indent-indentation-per-level 2)
  (setq org-src-fontify-natively t)

  (setq org-agenda-files `(,org-directory))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline org-default-notes-file "INBOX")
           "* TODO %?\n%U\n%a\n")
          ("n" "Note" entry (file+headline org-default-notes-file "NOTES")
           "* %? :NOTE:\n%U\n%a\n")
          ("m" "Meeting" entry (file org-default-notes-file)
           "* MEETING %? :MEETING:\n%U")
          ("j" "Journal" entry (file+datetree org-default-journal-file)
           "* %U\n** %?")))

  (setq org-use-fast-todo-selection t)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n@)" "|" "DONE(d@)")
          (sequence "WAITING(w@/!)" "|" "CANCELLED(c@/!)")))

  (setq org-todo-state-tags-triggers
        ' (("CANCELLED" ("CANCELLED" . t))
           ("WAITING" ("WAITING" . t))
           ("TODO" ("WAITING") ("CANCELLED"))
           ("NEXT" ("WAITING") ("CANCELLED"))
           ("DONE" ("WAITING") ("CANCELLED"))))

  (defun hrs/mark-done-and-archive ()
    "Mark the state of an org-mode item as DONE and archive it."
    (interactive)
    (org-todo 'done)
    (org-archive-subtree))

  (define-key org-mode-map (kbd "C-c C-x C-s") 'hrs/mark-done-and-archive)

  (setq org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-completion-use-ido t)


  ;; Require ob package of languages for src block
  (require-package 'ob-ipython)

  ;; Languages to be loaded for execution of src block
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ipython . t)  ;; ob-ipython has async mode
     (sh . t)))

  ;; Don't ask for confirmation before execution of src block
  (setq org-confirm-babel-evaluate nil)

  (add-hook 'org-babel-after-execute-hook #'org-redisplay-inline-images)


  (defun /org/org-mode-hook ()
    (toggle-truncate-lines t)
    (setq show-trailing-whitespace t))
  (add-hook 'org-mode-hook #'/org/org-mode-hook)

  ;; Async feature for src block
  ;; Usage: just add `:async` in front of src block
  ;; Eg: #+BEGIN_SRC elisp :async
  ;; WARNING: Ipython has in-built async feature and this doesn't goes well with
  ;;          that. So use this only when other languages src blocks need to be executed asynchronously.
  ;;          While using ipython src block in async mode, keep this part commented!
  ;;          Uncomment it only when any language other that ipython needs to be executed asynchronously.
  ;; (require-package 'ob-async)
  ;; (require 'ob-async)

  (require-package 'org-pomodoro)
  (require 'org-pomodoro)

  (require-package 'org-bullets)
  (setq org-bullets-bullet-list '("●" "○" "◆" "◇" "▸"))
  (add-hook 'org-mode-hook #'org-bullets-mode))

(provide 'config-org)
