(use-package tide :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (define-key web-mode-map (kbd "M-.") 'tide-jump-to-definition)
  (define-key web-mode-map (kbd "M-?") 'tide-references)
  (define-key web-mode-map (kbd "M-;") 'tide-rename-symbol)
)

(use-package web-mode
  :ensure t
  :init
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
        ;;  ("\\.jsx?\\'" . web-mode)
        ;;  ("\\.tsx?\\'" . web-mode))
  )
  :hook
  ;; (web-mode . prettier-js-mode)
  (web-mode . company-mode)
  (web-mode . flycheck-mode)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (js-indent-level 2)
  (web-mode-enable-auto-pairing nil)
  (web-mode-enable-auto-opening t)
  (web-mode-enable-auto-closing t)
  (web-mode-content-types-alist '(("jsx"  . "\\.js[x]?\\'")))
  :config
  (setq web-mode-engines-alist '(("django" . "\\.html\\'")))
  (require 'prettier-js)
  (require 'flycheck)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  ;; hot key for prettier-js
  (define-key web-mode-map (kbd "C-c l = =") 'prettier-js)
  ;; eval lsp after web-mode is loaded
  (eval-after-load 'web-mode
    '(progn
      ;;  (require 'lsp)
      ;;  (add-hook 'web-mode-hook #'lsp-deferred))
      ;; if tsx or ts file use tide
      (when (string-match-p "tsx?\\'" (buffer-file-name))
            (setup-tide-mode))))
)