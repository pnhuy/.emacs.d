(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style "file")
)

;; hook for both c and cpp mode
(add-hook 'c-mode-common-hook
  (lambda ()
    ;; set c style
    (setq c-default-style "bsd"
          c-basic-offset 4)
    ;; enable yas minor mode
    (yas-minor-mode)
    ;; run lsp
    (lsp)
    ;; electric mode
    (electric-pair-mode)
  )
)