;; hook for both c and cpp mode
(add-hook 'c-mode-common-hook
  (lambda ()
    (setq c-default-style "bsd"
          c-basic-offset 4))
)