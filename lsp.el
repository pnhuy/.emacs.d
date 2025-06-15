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

(defun my/lsp-format-buffer ()
  (interactive)
  (save-buffer)
  (cond
   ((eq major-mode 'python-mode)
    (ruff-lint-format-dwim))
   ((eq major-mode 'python-ts-mode)
    (ruff-lint-format-dwim))
   ((eq major-mode 'prisma-mode)
    (when (fboundp 'prisma-fmt-buffer)
      (prisma-fmt-buffer)))
   ((or (string-prefix-p "html" (symbol-name major-mode))
        (string-prefix-p "json" (symbol-name major-mode))
        (string-prefix-p "jtsx" (symbol-name major-mode))
        (string-prefix-p "css" (symbol-name major-mode))
        (string-prefix-p "typescript" (symbol-name major-mode))
        (string-prefix-p "tsx" (symbol-name major-mode))
        (eq major-mode 'mhtml-mode)
        (eq major-mode 'web-mode)
        (eq major-mode 'js2-mode))
    (when (require 'prettier-js nil 'noerror)
      (when (fboundp 'prettier-js)
        (prettier-js))))
   (t
    (lsp-format-buffer))))

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;;(prog-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . yas-minor-mode)
         (lsp-mode . lsp-enable-which-key-integration))
  :bind (:map lsp-mode-map ("C-c l = =" . my/lsp-format-buffer))
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :ensure t :commands lsp-treemacs-errors-list)
(global-set-key (kbd "C-x t s") 'lsp-treemacs-symbols)
(global-set-key (kbd "C-x t r") 'lsp-treemacs-references)

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t
  ;; :hook
  ;; (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra)))
)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

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

;; function setup lsp mode
(defun set-up-lsp ()
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-peek-enable t)
(setq lsp-ui-doc-enable t)
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-ui-sideline-show-hover nil)
;; check if emacs no window mode
(if (not (display-graphic-p))
    (progn
      (setq lsp-ui-doc-show-with-cursor t)
      (setq lsp-ui-doc-enable nil)
      )
  )
(setq lsp-ui-doc-position 'at-point)
(setq lsp-ui-doc-show-with-mouse t)
;; web-mode
(if (eq major-mode 'web-mode)
    (setq lsp-enable-indentation nil))

;; hide signature documentation but keep the signature
(setq lsp-signature-render-documentation nil)
)

(add-hook 'lsp-mode-hook 'set-up-lsp)

;; Set up lsp-booster
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
  (message "Found emacs-lsp-booster at %s" (executable-find "emacs-lsp-booster"))
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)