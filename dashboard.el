;; use-package with package.el:
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                        ;; (bookmarks . 5)
                        (projects . 5)
                        ;; (agenda . 5)
                        (registers . 5)))
  )