;; load file dap.el
(load (expand-file-name "packages/dap.el" user-emacs-directory))

;; function to find python virtualenv path like .venv .env env venv
(defun find-venv ()
  
  (setq venv (if (file-exists-p ".venv")
            ".venv"
          (if (file-exists-p ".env")
              ".env"
            (if (file-exists-p "env")
                "env"
              (if (file-exists-p "venv")
                  "venv"
                nil
  )))))
  (if (and (not (eq venv nil)) (file-exists-p (concat (file-truename venv) "/bin/python")))
      (concat (file-truename venv) "/bin/python")
    (shell-command-to-string "which python3")
    )
)

;; Run python setup if python mode is enabled
(add-hook 'python-mode-hook
          (lambda ()
            (dap-setup)
            (require 'dap-python)
            (setq dap-python-debugger 'debugpy)
            (setq dap-python-executable (find-venv))
          )
)