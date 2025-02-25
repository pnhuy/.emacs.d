;; define org-roam directory
(setq org-roam-directory (file-truename  "~/.config/org-roam"))

(use-package org-roam
  :ensure t
  :custom
  (org-return-follows-link t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; open link in same window
	(setq org-link-frame-setup '((file . find-file)))
  )

(defun org-roam-ag ()
  "Search org-roam files with counsel-ag."
  (interactive)
  (counsel-ag "" org-roam-directory nil "Search org-roam: "))