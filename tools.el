;; Enable recentf
(use-package recentf
  :init (recentf-mode 1)
  :config
    (add-to-list 'recentf-exclude "/org-roam/")
    (add-to-list 'recentf-exclude "/.emacs.d/"))

(use-package eat)