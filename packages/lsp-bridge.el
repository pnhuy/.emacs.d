(defun my/lsp-format-buffer ()
  "Format the current buffer using dart formatter for dart-mode, prettier-js for HTML/JS/JSON modes, else lsp-bridge."
  (interactive)
  (message "Formatting code...")
  (message "Current major mode: %s" major-mode)
  (cond
   ((bound-and-true-p lsp-bridge-mode)
    (let ((mode-name (symbol-name major-mode)))
      (if (or (string-prefix-p "html" mode-name)
              (string-prefix-p "js" mode-name)
              (string-prefix-p "json" mode-name))
          (if (fboundp 'prettier-js)
              (prettier-js)
            (message "prettier-js is not available."))
        (lsp-bridge-code-format))))
   (t
    (message "LSP Bridge is not active.")))
  (message "Code formatting complete."))

(use-package lsp-bridge
  :ensure t
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
            :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
            :build (:not compile))
  :init
  (global-lsp-bridge-mode)
  :config
  ;; keybindings for lsp-bridge
  (define-key lsp-bridge-mode-map (kbd "M-.") 'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "M-?") 'lsp-bridge-find-references)
  (define-key lsp-bridge-mode-map (kbd "M-,") 'lsp-bridge-find-def-return)
  (define-key lsp-bridge-mode-map (kbd "C-c f") 'my/lsp-format-buffer)
  )