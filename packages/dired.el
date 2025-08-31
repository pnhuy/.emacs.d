(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
)

(use-package all-the-icons-dired
  :ensure t
  :config
  ;; add hook only in GUI
  (when (display-graphic-p)
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))
)

(use-package dired-hide-dotfiles
  :ensure t
  :hook (dired-mode . dired-hide-dotfiles-mode)
)