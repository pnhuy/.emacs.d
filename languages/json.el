(use-package json-mode
  :ensure t
  :mode "\\.json\\'"
  :hook
  (json-mode . lsp-deferred)
  (json-mode . prettier-js-mode)
  :config
  (setq js-indent-level 2))