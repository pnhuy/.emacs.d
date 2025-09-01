(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style "file")
)

;; setup function
(defun setup-c-mode ()
  "Setup C/C++ mode."
  (setq c-default-style "bsd"
        c-basic-offset 4)
  ;; enable yas minor mode
  (yas-minor-mode)
  ;; run lsp
  (lsp)
  ;; electric mode
  (electric-pair-mode))

;; hook for both c and cpp mode
(add-hook 'c-mode-common-hook 'setup-c-mode)
(add-hook 'c-ts-base-mode-hook 'setup-c-mode)