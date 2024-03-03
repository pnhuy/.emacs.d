;; use-package with package.el:
(use-package dashboard
  :if (< (length command-line-args) 2)
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  ;; dashboard project backend to projectile
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                        ;; (bookmarks . 5)
                        (projects . 5)
                        ;; (agenda . 5)
                        (registers . 5)))
  )