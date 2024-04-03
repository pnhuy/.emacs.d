(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :diminish treesit-auto
  ;; disable because conflicts with lsp typescript
  ;; :config
  ;; (treesit-auto-add-to-auto-mode-alist 'all)
)

