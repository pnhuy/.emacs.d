;; disable menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; set font
(cond
 ((find-font (font-spec :name "JetBrainsMono Nerd Font Mono"))
  (set-frame-font "JetBrainsMono Nerd Font Mono-12")))

;; make scroll more smooth, pixel scroll
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; Maximize window on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(load (expand-file-name "packages/no-littering.el" user-emacs-directory))

;; Disable backup files.
(setf make-backup-files nil)
;; Prompt to delete autosaves when killing buffers.
(setf kill-buffer-delete-auto-save-files t)
(setq create-lockfiles nil) ; stop creating # files
(setq backup-directory-alist '(("." . (concat user-emacs-directory "backups"))))

;; config and load packages
;; check if package-selected-packages.el exists, if not create it
(unless (file-exists-p (expand-file-name "package-selected-packages.el" user-emacs-directory))
  (write-region "" nil (expand-file-name "package-selected-packages.el" user-emacs-directory)))
(setq custom-file (expand-file-name "package-selected-packages.el" user-emacs-directory))
(load custom-file)
(load (expand-file-name "init-packages.el" user-emacs-directory))

;; load theme
(if (display-graphic-p)
    (progn
    ;; if graphic
      (load-theme 'material-light t)
      (global-hl-line-mode 1))
    ;; else (optional)
    (progn
      (xterm-mouse-mode -1)
      (load-theme 'wombat t)))

;; Speed up startup
;; Don’t compact font caches during GC for doom-modeline
(setq inhibit-compacting-font-caches t)
;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)
;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))
;; END Speed up startup

;; get path from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; autocomplete paired brackets
(electric-pair-mode 1)

;; show line numbers
(global-display-line-numbers-mode)

;; disable startup screen
(setq inhibit-startup-message t)

;; auto resolve symlinks
(setq find-file-visit-truename t)

;; Exclude remote files from recentf
(setq recentf-keep '(file-remote-p file-readable-p))

;; Set waiting time for tramp
(setq tramp-connection-timeout 5)

;; load dired config
(load (expand-file-name "packages/dired.el" user-emacs-directory))
(load (expand-file-name "packages/neotree.el" user-emacs-directory))
(load (expand-file-name "packages/org-roam.el" user-emacs-directory))

;; load doom modeline
(load (expand-file-name "packages/doom-modeline.el" user-emacs-directory))

;; load ivy config
(load (expand-file-name "packages/ivy.el" user-emacs-directory))

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

;; load ligature config
(load (expand-file-name "ligature.el" user-emacs-directory))

;; load treesitter config
(load (expand-file-name "packages/treesitter.el" user-emacs-directory))

;; load language config
(load (expand-file-name "languages/c.el" user-emacs-directory))
(load (expand-file-name "languages/python.el" user-emacs-directory))
(load (expand-file-name "languages/html.el" user-emacs-directory))
(load (expand-file-name "languages/json.el" user-emacs-directory))
(load (expand-file-name "languages/typescript.el" user-emacs-directory))
(load (expand-file-name "languages/web.el" user-emacs-directory))
(load (expand-file-name "languages/tex.el" user-emacs-directory))

;; load diminish config
(load (expand-file-name "packages/diminish.el" user-emacs-directory))

;; undo tree mode
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; git-gutter
(add-hook 'prog-mode-hook 'git-gutter-mode)
(custom-set-variables '(git-gutter:update-interval 0.5))

(use-package projectile
  :ensure t
  :after helm
  :custom
  (require 'helm)
  (projectile-indexing-method 'alien)
  (projectile-completion-system 'helm)
  :bind (:map projectile-mode-map
              ;; ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (projectile-mode +1)
  ;; check if projectile is enabled, change working dir to root of project
  (add-hook 'projectile-after-switch-project-hook
            (lambda ()
              (setq default-directory (projectile-project-root))))
  )

;; custom find file function
(defun custom-find-file ()
  "Wrapper function for finding files."
  (require 'helm-projectile)
  (interactive)
  (if (and (fboundp 'projectile-project-p)
           (projectile-project-p))
      (call-interactively 'helm-projectile-find-file)
    (call-interactively 'helm-find-files)))

;; Bind the keymap
(global-set-key (kbd "C-x C-f") 'custom-find-file)
;; (global-set-key (kbd "C-x b") 'helm-buffers-list)

;; Projectile
(setq projectile-switch-project-action #'custom-find-file)

;; Latex Preview folder
(setq org-preview-latex-image-directory 
      (concat temporary-file-directory "ltximg/"))
;; Config latex preview process list
(setq org-preview-latex-default-process 'dvisvgm)

;; emacs-ipython-notebook config
(setq ein:output-area-inlined-images (display-graphic-p))
(setq mailcap-user-mime-data '(((viewer . "open -a Preview.app %s") (type . "image/.*"))))

;; doc view setting
;; ppi
(setq doc-view-resolution 300)
(setq doc-view-continuous t)
;; disable line number
(add-hook 'doc-view-mode-hook (lambda ()
                                (display-line-numbers-mode -1)))

;; disable ls-dired on mac
(when (string= system-type "darwin")       
  (setq dired-use-ls-dired nil))

(use-package emacs-surround
  :straight '(emacs-surround
              :type git
              :host github
              :repo "ganmacs/emacs-surround")
  :config
  (global-set-key (kbd "C-q") 'emacs-surround))

(use-package move-lines
  :straight '(move-lines
              :type git
              :host github
              :repo "targzeta/move-lines")
  :config
  (move-lines-binding)
  ;; After this, you can move the line(s) up by M-p or M-<up>
  ;; or down by M-n or M-<down>.
)

(global-set-key (kbd "C-x g") 'magit-status)

(use-package goto-line-preview
  :ensure t
  :config
  (global-set-key [remap goto-line] 'goto-line-preview))

(use-package yasnippet
  :ensure t
  :config
  (add-to-list 'yas-snippet-dirs (expand-file-name "snippets" user-emacs-directory) t)
  ;; enable for org and latex
  (add-hook 'org-mode-hook 'yas-minor-mode)
  (add-hook 'LaTeX-mode-hook 'yas-minor-mode)
)

(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

(use-package restart-emacs
  :ensure t)
