;; Dependencies: pip3 install jedi flake8 importmagic autopep8 ipython

(setq ansi-color-for-comint-mode t)

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

(add-hook 'python-mode-hook
	  (lambda ()
	    (setq tab-width 4)))

(require-package 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)

;; (require-package 'elpy)
;; (elpy-enable)
