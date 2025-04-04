(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (setq treesit-font-lock-level 4)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :diminish treesit-auto
  ;; disable because conflicts with lsp typescript
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
)

(use-package treesit-fold
  :straight (treesit-fold :type git :host github :repo "emacs-tree-sitter/treesit-fold")
  :bind 
  ("C-c C-f" . treesit-fold-toggle)
  :config
  (global-treesit-fold-indicators-mode 1)
  (setq treesit-fold-line-count-show t)
)
(use-package treesit-fold-indicators
  :straight (treesit-fold-indicators :type git :host github :repo "emacs-tree-sitter/treesit-fold"))
