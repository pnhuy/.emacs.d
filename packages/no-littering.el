(use-package no-littering
  :ensure t
  :config
  (setq no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory))
  (setq no-littering-var-directory (expand-file-name "var/" user-emacs-directory))
  (require 'no-littering)
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
)
