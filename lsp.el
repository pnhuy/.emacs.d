(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ((c-mode c++-mode python-mode web-mode) . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; python mode
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))  ; or lsp

;; json mode
(use-package json-mode
  :ensure t
  :mode "\\.json\\'"
  :config
  (setq js-indent-level 2)
  ;; chang hot key for json-pretty-print-buffer
  (define-key json-mode-map (kbd "C-c l = =") 'json-pretty-print-buffer)
  )

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t
  ;; :hook
  ;; (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra)))
)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :ensure t
    :config
    (which-key-mode))

(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-peek-enable t)
(setq lsp-ui-doc-enable t)
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-ui-sideline-show-hover nil)

;; check if emacs no window mode
(if (not (display-graphic-p))
    (progn
      (setq lsp-ui-doc-show-with-cursor t)
      (setq lsp-ui-doc-enable nil)
      (setq lsp-headerline-breadcrumb-enable nil)
      )
  )
(setq lsp-ui-doc-position 'at-point)
(setq lsp-ui-doc-show-with-mouse t)

;; remap xref-find-definitions(M-.) and xref-find-references(M-?) to lsp-ui-peek
(define-key lsp-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

;; change hot key from enter to tab for company-complete-selection
(use-package company
  :ensure t
  :bind (:map company-active-map
              ("RET" . nil)
              ("<return>" . nil)
              ("TAB" . company-complete-selection)
              ("<tab>" . company-complete-selection)))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

;; Copilot
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :config
  (copilot-mode -1)
  (add-hook 'prog-mode-hook 'copilot-mode)
  ;; key binding for accept
  (define-key copilot-mode-map (kbd "C-c C-a") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "C-c C-n") 'copilot-accept-completion-by-line)
  )
