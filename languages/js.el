(use-package js2-mode
  :ensure t
  :mode (("\\.jsx?\\'" . js2-mode))
  :hook (js2-mode . lsp-deferred)
  :config
  (setq js2-basic-offset 2)
)