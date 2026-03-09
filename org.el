(defvar my/org-roam-dir (file-truename "~/Dropbox/Documents/org-roam")
  "Root directory for org-roam notes.")

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

  ;; ;; Use dvisvgm to generate previews
  ;; ;; You don't need this, it's the default:
  ;; (setq org-latex-preview-process-default 'dvisvgm)
  
  ;; Turn on `org-latex-preview-mode', it's built into Org and much faster/more
  ;; featured than org-fragtog. (Remember to turn off/uninstall org-fragtog.)
  (add-hook 'org-mode-hook 'org-latex-preview-mode)

  ;; ;; Block C-n, C-p etc from opening up previews when using `org-latex-preview-mode'
  ;; (setq org-latex-preview-mode-ignored-commands
  ;;       '(next-line previous-line mwheel-scroll
  ;;         scroll-up-command scroll-down-command))

  ;; ;; Enable consistent equation numbering
  ;; (setq org-latex-preview-numbered t)

  ;; Bonus: Turn on live previews.  This shows you a live preview of a LaTeX
  ;; fragment and updates the preview in real-time as you edit it.
  ;; To preview only environments, set it to '(block edit-special) instead
  (setq org-latex-preview-mode-display-live t)

  ;; More immediate live-previews -- the default delay is 1 second
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
(setq org-agenda-files (file-expand-wildcards (concat my/org-roam-dir "/*backlog.org")))
;; C-c a to open agenda
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)")))

;; adjust line-spacing in org-mode
(defun my/org-mode-default-line-spacing ()
  (setq-local line-spacing 0.2))
(add-hook 'org-mode-hook #'my/org-mode-default-line-spacing)


(with-eval-after-load 'recentf
  (add-to-list 'recentf-exclude "/org-roam/")
  (add-to-list 'recentf-exclude "/.emacs.d/"))
