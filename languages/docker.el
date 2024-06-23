;; dockerfile mode
(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" . dockerfile-mode)
  :config
  (add-hook 'dockerfile-mode-hook
            (lambda ()
              (setq dockerfile-mode-command "docker")
              (setq-local tab-width 4)
              (setq-local indent-tabs-mode t)
              (setq-local comment-start "# ")
              (setq-local comment-end "")
              ;; disable tree-sitter
              (tree-sitter-mode -1)
              ))

)