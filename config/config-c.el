;; Add this to config-bindings.el
(defun execute-c-program ()
  (interactive)
  (defvar foo)
  ;; (setq foo (concat "gcc " (buffer-name) " && ./a.out"))
  (setq foo (concat "python build.py"))
  (shell-command foo))

(evil-define-key 'normal c-mode-map (kbd "C-c C-c") 'execute-c-program)
