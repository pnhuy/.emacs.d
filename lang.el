(use-package magit
  :bind
  ("C-x g" . magit-status))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package dumb-jump
  :config
  (dumb-jump-mode)
  (setq dumb-jump-force-searcher 'rg)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  )

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  ;; Enable caching for better performance
  (setq projectile-enable-caching t)
  ;; Index files in .projectile
  (setq projectile-indexing-method 'hybrid)
  ;; Ignore certain directories
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories ".git")
  (add-to-list 'projectile-globally-ignored-directories "target")
  (add-to-list 'projectile-globally-ignored-directories "build")
  )

;; Flycheck
(use-package flycheck
  :init (global-flycheck-mode))

(use-package eglot
  :ensure nil
  :config
  (add-hook 'prog-mode-hook 'eglot-ensure)
  ;; disable inlay hints
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
  (setq eglot-extend-to-xref t)
  )


(use-package markdown-mode
  :ensure t)