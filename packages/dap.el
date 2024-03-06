;; dap setup function
(defun dap-setup ()
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (dap-ui-controls-mode 1)
  (dap-auto-configure-mode 1)
  (setq dap-auto-configure-features '(sessions locals breakpoints expressions controls tooltip repl))
  (unless (display-graphic-p)
    (custom-set-faces
    ;; set marker color to text color
     '(dap-ui-pending-breakpoint-face ((t (:underline "dim gray"))))
     '(dap-ui-verified-breakpoint-face ((t (:underline "green")))))
    )
  )