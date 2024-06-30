(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(defun ruff-lint-format-dwim ()
  "Run ruff lint and format."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if (and file-name (string-match-p "\\.py\\'" file-name))
      (let ((ruff-lint-output (shell-command-to-string (format "ruff check --select I --fix %s" file-name))))
        (message "Ruff lint output: %s" ruff-lint-output)
        (let ((ruff-format-output (shell-command-to-string (format "ruff format %s" file-name))))
          (message "Ruff format output: %s" ruff-format-output)
          (when (or (string-match-p "fixed" ruff-lint-output)
                    (string-match-p "reformatted" ruff-format-output))
            (progn
              (revert-buffer t t t)
              (message "Changes made.")))))
      (message "Not a Python file."))))

(defun my-lsp-format-buffer ()
  (interactive)
  (if (eq major-mode 'python-mode)
      (ruff-lint-format-dwim)
    (if (or (string-prefix-p "html" (symbol-name major-mode))
          (string-prefix-p "json" (symbol-name major-mode))
          (string-prefix-p "jtsx" (symbol-name major-mode))
          (string-prefix-p "css" (symbol-name major-mode))
          (string-prefix-p "typescript" (symbol-name major-mode))
          (eq major-mode 'mhtml-mode)
          (eq major-mode 'js2-mode))
        (prettier-js)
        (lsp-format-buffer))))

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;;(prog-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :bind (:map lsp-mode-map ("C-c l = =" . my-lsp-format-buffer))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm :ensure t)
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

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.venv\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]venv\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.env\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]env\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]node_modules\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]__pycache__\\'")
)

;; remap xref-find-definitions(M-.) and xref-find-references(M-?) to lsp-ui-peek
(define-key lsp-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

;; change hot key from enter to tab for company-complete-selection
(use-package company
  :ensure t
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
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
  ;; :hook (prog-mode . copilot-mode)
  :ensure t
  :config
  (copilot-mode -1)
  ;; disable warning
  (setq copilot-indent-offset-warning-disable t)
  ;; key binding for accept
  (define-key copilot-mode-map (kbd "C-c C-a") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "C-c C-n") 'copilot-accept-completion-by-line)
  )


;; function setup lsp mode
(defun set-up-lsp ()
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
)

(add-hook 'lsp-mode-hook 'set-up-lsp)