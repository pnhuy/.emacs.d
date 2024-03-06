(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package treesit-auto
  :ensure t
  :diminish treesit-auto
  :config
  (global-treesit-auto-mode))

