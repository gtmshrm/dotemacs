(delayed-init
 (require-package 'yasnippet)

 (require 'yasnippet)

 (setq yas-fallback-behavior 'return-nil)
 (setq yas-also-auto-indent-first-line t)
 (setq yas-prompt-functions '(yas/ido-prompt yas/completing-prompt))

 ;; Enable for specific modes
 ;; (add-hook 'prog-mode-hook 'yas-minor-mode)
 ;; (add-hook 'org-mode-hook 'yas-minor-mode)
 ;; (add-hook 'html-mode-hook 'yas-minor-mode)

 ;; Enable globally
 (yas-global-mode 1)

 (yas-load-directory (concat user-emacs-directory "snippets")))

(provide 'init-yasnippet)
