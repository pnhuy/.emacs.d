(defun my-neo-global--attach ()
  "Attach the global neotree buffer"
  (when neo-global--autorefresh-timer
    (cancel-timer neo-global--autorefresh-timer))
  ;; (when neo-autorefresh
  ;;   (setq neo-global--autorefresh-timer
  ;;         (run-with-idle-timer 0.01 t 'neo-global--do-autorefresh)))
  (setq neo-global--buffer (get-buffer neo-buffer-name))
  (setq neo-global--window (get-buffer-window
                            neo-global--buffer))
  (neo-global--with-buffer
    (neo-buffer--lock-width))
  (run-hook-with-args 'neo-after-create-hook '(window)))

(use-package neotree
  :ensure t
  :config
  ;; change file path to current file view
  (setq neo-smart-open t)
  ;; auto refresh
  (setq neo-autorefresh t)
  ;; time to auto refresh
  (setq neo-autorefresh-interval 1)
  ;; theme 
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  ;; highlight current file in tree
  (setq neo-show-updir-line nil)
  ;; use my-neo-global--attach instead of neo-global--attach
  (advice-add 'neo-global--attach :override #'my-neo-global--attach)
  ;; enable resize
  (setq neo-window-fixed-size nil)
  )

(use-package ranger
  :ensure t
  :config
  (global-set-key (kbd "C-x t r") 'ranger)
  )

(use-package treemacs
  :ensure t
  :config
  ;; show current project only
  (treemacs-project-follow-mode 1)
  (setq treemacs-display-current-project-exclusively t)
)
(use-package treemacs-icons-dired :ensure t)
(use-package lsp-treemacs :ensure t)
(global-set-key (kbd "C-x t s") 'lsp-treemacs-symbols)
(global-set-key (kbd "C-x t r") 'lsp-treemacs-references)

(defun open-file-manager ()
  "Open file manager"
  "If projectile is enabled, open current project root with treemacs, else open neotree"
  (interactive)
  (if (and (fboundp 'projectile-project-p)
           (projectile-project-p))
      (treemacs)
    (neotree-toggle))  
  )

(global-set-key (kbd "C-x t t") 'open-file-manager)
(global-set-key (kbd "s-b") 'open-file-manager)