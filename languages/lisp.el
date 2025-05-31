;; slime for lisp
(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl") ;; Set your preferred Lisp implementation
  (slime-setup '(slime-fancy)))

(add-hook 'lisp-mode-hook
  (lambda ()
  (set (make-local-variable 'compile-command)
          (concat "sbcl --script " buffer-file-name))))