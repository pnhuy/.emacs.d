(defvar my/org-roam-dir (file-truename "~/Dropbox/Documents/org-roam")
  "Root directory for org-roam notes.")

(defvar my/org-download-dir (concat my/org-roam-dir "/images/")
  "Directory for org-download images inside org-roam directory.")

(use-package org
  :defer
  :straight `(org
              :fork (:host nil
                     :repo "https://git.tecosaur.net/tec/org-mode.git"
                     :branch "dev"
                     :remote "tecosaur")
              :files (:defaults "etc")
              :build t
              :pre-build
              (with-temp-file "org-version.el"
               (require 'lisp-mnt)
               (let ((version
                      (with-temp-buffer
                        (insert-file-contents "lisp/org.el")
                        (lm-header "version")))
                     (git-version
                      (string-trim
                       (with-temp-buffer
                         (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
                         (buffer-string)))))
                (insert
                 (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
                 (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
                 "(provide 'org-version)\n")))
              :pin nil)
  :config
  (require 'org-tempo)
  (add-hook 'org-mode-hook 'visual-line-mode)
  (setq org-preview-latex-image-directory
        (concat temporary-file-directory "ltximg/"))
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; Org Babel configuration for Python
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (lisp . t)
     (emacs-lisp . t)))
  ;; Don't ask for confirmation before executing code blocks
  (setq org-confirm-babel-evaluate nil)
  ;; Use python3 by default
  (setq org-babel-python-command "python3")
  ;; config org-babel for lisp
  (setq org-babel-lisp-eval-fn #'sly-eval)
)

(use-package org-latex-preview
  :ensure nil
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)
  (add-hook 'org-mode-hook 'org-latex-preview-mode)
  (setq org-latex-preview-mode-display-live t)
  (setq org-latex-preview-mode-update-delay 0.5))

;; use org-superstar instead of org-bullets
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :init
  (setq org-superstar-prettify-item-bullets t
        org-superstar-headline-bullets-list
        '("◉" "○" "✸" "✿" "◆" "▶" "▷")

        org-superstar-leading-bullet ?\s
        org-hide-leading-stars t

        org-superstar-item-bullet-alist
        '((?+ . ?➤)
          (?- . ?•)))
  )

(use-package org-modern
  :config
  (add-hook 'org-mode-hook 'org-modern-mode)
  (setq org-modern-star nil)
  (setq org-modern-keyword nil)
)

(use-package org-roam
  :init
  (org-roam-db-autosync-mode)
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture))
  :custom
  (org-roam-directory my/org-roam-dir))

(use-package consult-org-roam
  :after (consult org-roam))

(defun my/org-latex-preview-increase-scale ()
  "Increase the scale of LaTeX previews in Org mode."
  (interactive)
  (when (eq major-mode 'org-mode)
    (let* ((current-scale (plist-get org-format-latex-options :scale))
           (new-scale (* current-scale 1.2))) ; Increase by 20%
      (plist-put org-format-latex-options :scale new-scale)
      (message "Increased LaTeX preview scale to %s" new-scale)
      (org-latex-preview 16)))) ; Regenerate all previews

(defun my/org-latex-preview-decrease-scale ()
  "Increase the scale of LaTeX previews in Org mode."
  (interactive)
  (when (eq major-mode 'org-mode)
    (let* ((current-scale (plist-get org-format-latex-options :scale))
           (new-scale (/ current-scale 1.2))) ; Decrease by 20%
      (plist-put org-format-latex-options :scale new-scale)
      (message "Decreased LaTeX preview scale to %s" new-scale)
      (org-latex-preview 16)))) ; Regenerate all previews

;; set agenda to wildcard *backlog.org files under org-roam directory
(setq org-agenda-files
      (file-expand-wildcards
       (concat my/org-roam-dir "/*backlog.org")))

(setq org-agenda-inhibit-startup t)

;; auto close org-agenda files after opening dashboard
(defun my/org-agenda-close-buffers ()
  (dolist (file org-agenda-files)
    (let ((buf (get-file-buffer file)))
      (when buf
        (kill-buffer buf)))))

(add-hook 'dashboard-after-initialize-hook #'my/org-agenda-close-buffers)

;; C-c a to open agenda
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)")))

;; adjust line-spacing in org-mode
(defun my/org-mode-default-line-spacing ()
  (setq-local line-spacing 0.2))
(add-hook 'org-mode-hook #'my/org-mode-default-line-spacing)

;; org-download configuration
(use-package org-download
  :after org
  :config
  ;; (message "Configuring org-download...")
  ;; (message "Org-roam directory: %s" my/org-roam-dir)
  (setq-default org-download-image-dir my/org-download-dir)
  ;; (setq org-download-image-org-width 800)
  (setq org-download-image-prompt t)
  (add-hook 'org-mode-hook 'org-download-enable))
(defun my/org-roam-cleanup-images (&optional dry-run)
  "Find broken image links in org-roam files and optionally orphaned images on disk.
   With prefix argument (or DRY-RUN non-nil), skip the delete prompt."
  (interactive "P")
  (let* ((org-files (directory-files-recursively my/org-roam-dir "\\.org$"))
         (image-dir (file-truename my/org-download-dir))
         (image-files (when (file-directory-p image-dir)
                        (directory-files image-dir t
                                         "\\.\\(png\\|jpg\\|jpeg\\|gif\\|svg\\|webp\\|bmp\\|tiff?\\)$")))
         (linked-images (my/org-roam--collect-linked-images org-files image-dir))
         (orphans (seq-filter (lambda (f)
                                (not (member (file-truename f) linked-images)))
                              image-files))
         (broken-links (my/org-roam--find-broken-links org-files))
         (buf (get-buffer-create "*org-roam-image-cleanup*")))

    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (insert "Org-Roam Image Cleanup\n")
      (insert "======================\n")
      (insert (format "Scanned : %d org files\n" (length org-files)))
      (insert (format "Images  : %d on disk\n" (length image-files)))
      (insert (format "Orphans : %d on disk (not linked)\n" (length orphans)))
      (insert (format "Broken  : %d links pointing to missing files\n\n" (length broken-links)))

      ;; --- Broken links section ---
      (insert "Broken Links\n")
      (insert "------------\n")
      (if (null broken-links)
          (insert "No broken links found.\n\n")
        (cl-loop for (org-file line-num img-path) in broken-links do
          (insert "  ")
          (let ((file org-file)
                (line line-num))
            (insert-text-button
            (format "%s:%d" (file-relative-name file my/org-roam-dir) line)
            'action `(lambda (_)
                        (find-file-other-window ,file)
                        (goto-char (point-min))
                        (forward-line (1- ,line)))
            'follow-link t
            'help-echo (format "Jump to %s line %d" file line)))
          (insert (format "\n     missing: %s\n" img-path)))
        (insert "\n"))

      ;; --- Orphaned files section ---
      (insert "Orphaned Files on Disk\n")
      (insert "----------------------\n")
      (if (null orphans)
          (insert "No orphaned images found.\n")
        (dolist (f orphans)
          (insert (format "  - %s\n" (file-relative-name f image-dir)))))

      (read-only-mode 1)
      (local-set-key (kbd "q") #'quit-window)
      (goto-char (point-min)))

    (display-buffer buf
                    '((display-buffer-below-selected)
                      (window-height . 0.35)))

    ;; Prompt to delete orphans
    (when (and orphans (not dry-run))
      (if (yes-or-no-p (format "Delete %d orphaned image(s) from disk? " (length orphans)))
          (progn
            (dolist (f orphans)
              (delete-file f))
            (with-current-buffer buf
              (read-only-mode -1)
              (goto-char (point-max))
              (insert (format "\n\nDeleted %d orphaned file(s)." (length orphans)))
              (read-only-mode 1))
            (message "Done. Deleted %d orphaned image(s)." (length orphans)))
        (with-current-buffer buf
          (read-only-mode -1)
          (goto-char (point-max))
          (insert "\n\nAborted. No files were deleted.")
          (read-only-mode 1))
        (message "Aborted. No files deleted.")))))

(defun my/org-roam--find-broken-links (org-files)
  "Scan ORG-FILES for image links whose target file does not exist.
   Returns a list of (org-file line-number image-path)."
  (let ((results '()))
    (dolist (org-file org-files)
      (with-temp-buffer
        (insert-file-contents org-file)
        (goto-char (point-min))
        (let ((line-num 1))
          (while (not (eobp))
            (let ((line (thing-at-point 'line t)))
              (let ((pos 0))
                (while (string-match
                        "\\[\\[file:\\([^]]+\\.\\(?:png\\|jpg\\|jpeg\\|gif\\|svg\\|webp\\|bmp\\|tiff?\\)\\)\\]"
                        line pos)
                  (let* ((raw  (match-string 1 line))
                         (abs  (expand-file-name raw (file-name-directory org-file))))
                    (unless (file-exists-p abs)
                      (push (list org-file line-num abs) results)))
                  (setq pos (match-end 0)))))
            (forward-line 1)
            (setq line-num (1+ line-num))))))
    (nreverse results)))

(defun my/org-roam--collect-linked-images (org-files image-dir)
  "Return a list of absolute truename paths of images linked from ORG-FILES
   that reside under IMAGE-DIR."
  (let ((linked '()))
    (dolist (org-file org-files)
      (with-temp-buffer
        (insert-file-contents org-file)
        (goto-char (point-min))
        (while (re-search-forward
                "\\[\\[file:\\([^]]+\\.\\(?:png\\|jpg\\|jpeg\\|gif\\|svg\\|webp\\|bmp\\|tiff?\\)\\)\\]"
                nil t)
          (let* ((raw  (match-string 1))
                 (abs  (expand-file-name raw (file-name-directory org-file)))
                 (true (file-truename abs)))
            (when (string-prefix-p image-dir true)
              (push true linked))))))
    (delete-dups linked)))