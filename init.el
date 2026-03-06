(setq native-comp-async-report-warnings-errors nil)
(setq warning-minimum-level :error)
(add-hook
 'window-setup-hook
 (lambda ()
   (select-frame-set-input-focus (selected-frame))))

;; Disable backup files.
(setf make-backup-files nil)
;; Prompt to delete autosaves when killing buffers.
(setf kill-buffer-delete-auto-save-files t)
(setq create-lockfiles nil) ; stop creating # files
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

(load-theme 'tango-dark t)

(setq find-file-visit-truename t)

;; set super in macos to be meta
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super))

;; autosaving for prog-mode
(add-hook 'prog-mode-hook 'auto-save-visited-mode)
;; interval for autosave
(setq auto-save-visited-interval 30) ;; 30 seconds
;; auto revert
(global-auto-revert-mode 1)

;; Disable text-mode-ispell-word-completion entirely
(setq text-mode-ispell-word-completion nil)

;; config and load packages
(load (expand-file-name "init-packages.el" user-emacs-directory))
(load (expand-file-name "org.el" user-emacs-directory))
(load (expand-file-name "ui.el" user-emacs-directory))
(load (expand-file-name "completion.el" user-emacs-directory))
(load (expand-file-name "lang.el" user-emacs-directory))
(load (expand-file-name "edit.el" user-emacs-directory))
(load (expand-file-name "tools.el" user-emacs-directory))
(load (expand-file-name "keymap.el" user-emacs-directory))

;; if exists, load custom.el for user customizations
(let ((custom-file (expand-file-name "custom.el" user-emacs-directory)))
  (when (file-exists-p custom-file)
    (load custom-file)))