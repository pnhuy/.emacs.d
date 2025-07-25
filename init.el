;; disable menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(select-frame-set-input-focus (selected-frame))

;; disable native comp warning
(setq native-comp-async-report-warnings-errors nil)

(setq warning-minimum-level :error)

;; set font
(cond
  ((find-font (font-spec :name "Iosevka Nerd Font Mono"))
   (set-face-attribute 'default nil
                       :family "Iosevka Nerd Font Mono"
                       :height 140
                       :weight 'normal)))

;; truncate lines in echo bar
(setq message-truncate-lines t)

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
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

;; config and load packages
;; check if package-selected-packages.el exists, if not create it
(unless (file-exists-p (expand-file-name "package-selected-packages.el" user-emacs-directory))
  (write-region "" nil (expand-file-name "package-selected-packages.el" user-emacs-directory)))
(setq custom-file (expand-file-name "package-selected-packages.el" user-emacs-directory))
(load custom-file)
(load (expand-file-name "init-packages.el" user-emacs-directory))

;; load theme
(use-package doom-themes 
  :ensure t
  :config
  (load-theme 'doom-one t))

(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-themes '((doom-one) (doom-one-light)))
  :config
  (if (display-graphic-p)
      (auto-dark-mode t)))

(if (display-graphic-p)
    (progn
    ;; if graphic
      (global-hl-line-mode 1))
    ;; else (optional)
    (progn
      (xterm-mouse-mode -1)))

;; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; get path from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; autocomplete paired brackets
(electric-pair-mode 1)

;; disable auto pair at the beginning of word
(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

;; show line numbers
(global-display-line-numbers-mode)

;; disable startup screen
(setq inhibit-startup-message t)

;; auto resolve symlinks
(setq find-file-visit-truename t)

;; Exclude remote files from recentf
(setq recentf-keep '(file-remote-p file-readable-p))
;; Exclude files having ".emacs.d" from recentf
(setq recentf-exclude '("emacs.d"))
(add-to-list 'recentf-exclude "org-roam")

;; Set waiting time for tramp
(setq tramp-connection-timeout 5)

;; dump-jump
(use-package dumb-jump
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
)

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
;; (load (expand-file-name "treemacs.el" user-emacs-directory))

;; load org mode config
(load (expand-file-name "packages/org.el" user-emacs-directory))

;; load dashboard config
(load (expand-file-name "dashboard.el" user-emacs-directory))

;; load ligature config
(load (expand-file-name "ligature.el" user-emacs-directory))

;; load treesitter config
(load (expand-file-name "packages/treesitter.el" user-emacs-directory))
(load (expand-file-name "packages/evil.el" user-emacs-directory))

;; load language config
(load (expand-file-name "languages/c.el" user-emacs-directory))
(load (expand-file-name "languages/python.el" user-emacs-directory))
(load (expand-file-name "languages/html.el" user-emacs-directory))
(load (expand-file-name "languages/json.el" user-emacs-directory))
(load (expand-file-name "languages/js.el" user-emacs-directory))
(load (expand-file-name "languages/web.el" user-emacs-directory))
(load (expand-file-name "languages/typescript.el" user-emacs-directory))
(load (expand-file-name "languages/prisma.el" user-emacs-directory))
(load (expand-file-name "languages/tex.el" user-emacs-directory))
(load (expand-file-name "languages/dart.el" user-emacs-directory))
(load (expand-file-name "languages/yaml.el" user-emacs-directory))
(load (expand-file-name "languages/docker.el" user-emacs-directory))
(load (expand-file-name "languages/lisp.el" user-emacs-directory))
(load (expand-file-name "languages/kotlin.el" user-emacs-directory))

;; load diminish config
(load (expand-file-name "packages/diminish.el" user-emacs-directory))

;; undo tree mode
(use-package undo-tree :ensure t)
(global-undo-tree-mode)
;; (setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; git-gutter
(use-package git-gutter
  :ensure t
  :hook
  (prog-mode . git-gutter-mode)
  (web-mode .git-gutter-mode)
  :config
  (custom-set-variables '(git-gutter:update-interval 0.5)))

(use-package projectile
  :ensure t
  :after helm
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

(use-package helm-projectile :ensure t)

;; custom find file function
(defun custom-find-file ()
  "Wrapper function for finding files."
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

;; emacs-ipython-notebook config
(use-package ein :ensure t)
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

(use-package surround
  :ensure t
  :bind-keymap ("M-'" . surround-keymap))

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

(use-package magit :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

(use-package goto-line-preview
  :ensure t
  :config
  (global-set-key [remap goto-line] 'goto-line-preview))

(use-package yasnippet
  :ensure t
  :config
  ;; enable for org and latex
  (add-hook 'org-mode-hook 'yas-minor-mode)
  (add-hook 'LaTeX-mode-hook 'yas-minor-mode)
)

(use-package yasnippet-snippets :ensure t)

(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

(use-package restart-emacs
  :ensure t)

;; key to copy current line to lower line
(defun copy-line-down ()
  "Copy the current line to the line below."
  (interactive)
  (save-excursion
    (let ((line (buffer-substring (line-beginning-position)
                                  (line-end-position))))
      (forward-line)
      (insert line)
      (insert "\n")
      )))
(global-set-key (kbd "C-c d") 'copy-line-down)

;; key to copy upper line to current line
(defun copy-line-up ()
  "Copy the line above the current line."
  (interactive)
  (move-beginning-of-line 1)
  (previous-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "C-c u") 'copy-line-up)

;; C-; to comment line or region
(global-set-key (kbd "C-;") 'comment-line)

;; autosaving for prog-mode
(add-hook 'prog-mode-hook 'auto-save-visited-mode)
;; interval for autosave
(setq auto-save-visited-interval 30) ;; 30 seconds
;; auto revert
(global-auto-revert-mode 1)

;; key for movement
(require 'viper-cmd)
(global-set-key (kbd "M-f") 'viper-forward-word)
(global-set-key (kbd "M-b") 'viper-backward-word)
(setq viper-inhibit-startup-message 't)
(setq viper-expert-level '3)

;; code folding
(add-hook 'prog-mode-hook
      (lambda ()
      (unless (derived-mode-p 'kotlin-ts-mode)
        (hs-minor-mode))))
(global-set-key (kbd "C-c h") 'hs-hide-block)

;; recentf stuff
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; tab
(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-icons t)
  :hook
  (lisp-interaction-mode . centaur-tabs-local-mode)
  (shell-mode . centaur-tabs-local-mode)
  (inferior-python-mode . centaur-tabs-local-mode)
  :bind
  ("s-[" . centaur-tabs-backward)
  ("s-]" . centaur-tabs-forward)
  ("s-w" . kill-this-buffer)
  ("s-t" . centaur-tabs--create-new-tab)
  )

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
  )

(use-package smart-hungry-delete
  :ensure t
  :bind (([remap backward-delete-char-untabify] . smart-hungry-delete-backward-char)
	       ([remap delete-backward-char] . smart-hungry-delete-backward-char)
	       ([remap delete-char] . smart-hungry-delete-forward-char))
  :init (smart-hungry-delete-add-default-hooks))

(use-package shell-pop
  :ensure t
  :defer t
  :bind
  ("C-`" . shell-pop)
  :config
  (setq shell-pop-universal-key "C-`")
  (setq shell-pop-cleanup-buffer-at-process-exit t)
  (setq shell-pop-autocd-to-working-dir t)
)
(add-hook 'shell-mode-hook (lambda () (display-line-numbers-mode -1)))

(use-package ultra-scroll
  :ensure t
  :straight (ultra-scroll :type git :host github :repo "jdtsmith/ultra-scroll")
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0) 
  :config
  (ultra-scroll-mode 1))

;; vlfi for viewing large files
(use-package vlf
  :ensure t
  :config
  (require 'vlf-setup))

;; Delete Selection Mode
(delete-selection-mode 1)

(use-package hardtime
  :init
  (unless (package-installed-p 'hardtime)
    (package-vc-install
     '(hardtime
       :vc-backend Git
       :url "https://github.com/ichernyshovvv/hardtime.el"
       :branch "master")))
  :hook (prog-mode . hardtime-mode))

;; disable enable-recursive-minibuffers
(setq enable-recursive-minibuffers nil)

;; darkroom mode
(use-package darkroom
  :ensure t
  :hook
  (darkroom-mode . centaur-tabs-local-mode)
  (darkroom-mode . visual-line-mode))

;; expand-region for selecting text
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; load custom settings
(load (expand-file-name "custom.el" user-emacs-directory))
