(load (expand-file-name "init-packages.el" user-emacs-directory))
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq make-backup-files nil) ; stop creating ~ files
(setq create-lockfiles nil) ; stop creating # files

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
