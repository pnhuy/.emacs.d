(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style "file")
)

;; hook for both c and cpp mode
(defun setup-c-mode ()
  ;; set c style
  (setq c-default-style "bsd"
        c-basic-offset 4)
  ;; enable yas minor mode
  (yas-minor-mode)
  ;; run lsp
  ;; (lsp)
  ;; electric mode
  (electric-pair-mode)
  ;; setup indent for c-ts-mode
  (setq c-ts-mode-indent-style 'bsd
        c-ts-mode-indent-offset 4)
)

(add-hook 'c-mode-common-hook #'setup-c-mode)
(add-hook 'c-ts-mode-hook #'setup-c-mode)