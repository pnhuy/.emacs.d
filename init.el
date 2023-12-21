;; config and load packages
(setq custom-file (expand-file-name "package-selected-packages.el" user-emacs-directory))
(load custom-file)
(load (expand-file-name "init-packages.el" user-emacs-directory))

;; speed up startup

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))

;; end speed up startup

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq make-backup-files nil) ; stop creating ~ files
(setq create-lockfiles nil) ; stop creating # files
(setq backup-directory-alist '(("." . (concat user-emacs-directory "backups"))))

;; disable menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq c-default-style "bsd"
      c-basic-offset 4)


;; load theme
(load-theme 'material-light t)

;; autocomplete paired brackets
(electric-pair-mode 1)

;; show line numbers
(global-display-line-numbers-mode)

;; hightlight current line
(global-hl-line-mode 1)

;; disable startup screen
(setq inhibit-startup-message t)

;; auto resolve symlinks
(setq find-file-visit-truename t)

;; load lsp-mode
(load (expand-file-name "lsp.el" user-emacs-directory))


;; load treemacs
(load (expand-file-name "treemacs.el" user-emacs-directory))

;; load org mode config
(load (expand-file-name "org.el" user-emacs-directory))

;; load dashboard config
(load (expand-file-name "dashboard.el" user-emacs-directory))

;; load fzf config
(load (expand-file-name "fzf.el" user-emacs-directory))

(global-set-key (kbd "M-i") 'imenu)

;; undo tree mode
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; git-gutter
(add-hook 'prog-mode-hook 'git-gutter-mode)
(custom-set-variables '(git-gutter:update-interval 0.5))

;; custom find file function
(require 'helm-projectile)
(defun custom-find-file ()
  "Wrapper function for finding files."
  (interactive)
  (if (and (fboundp 'projectile-project-p)
           (projectile-project-p))
      (call-interactively 'helm-projectile-find-file)
    (call-interactively 'helm-find-files)))

;; Bind the keymap
(global-set-key (kbd "C-x C-f") 'custom-find-file)

;; Projectile
(setq projectile-switch-project-action #'custom-find-file)

;; Latex Preview folder
(setq org-preview-latex-image-directory 
      (concat temporary-file-directory "ltximg/"))
;; Config latex preview process list
(setq org-preview-latex-default-process 'dvisvgm)
