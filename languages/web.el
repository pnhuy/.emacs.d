(use-package tide :ensure t)

(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode)
  :custom
  (emmet-expand-jsx-className t)
  (emmet-indentation 2)
  :config
  (setq emmet-move-cursor-between-quotes t)
)

;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (eldoc-mode +1)
;;   (tide-hl-identifier-mode +1)
;;   (company-mode +1)
;;   (define-key web-mode-map (kbd "M-.") 'tide-jump-to-definition)
;;   (define-key web-mode-map (kbd "M-?") 'tide-references)
;;   (define-key web-mode-map (kbd "M-;") 'tide-rename-symbol)
;; )

(use-package web-mode
  :ensure t
  :init
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
        ;;  ("\\.tsx?\\'" . web-mode)
  )
  :hook
  ;; (web-mode . prettier-js-mode)
  (web-mode . prettier-js-mode)
  (web-mode . company-mode)
  (web-mode . flycheck-mode)
  (web-mode . lsp-deferred)
  (web-mode . yas-minor-mode)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (js-indent-level 2)
  (web-mode-enable-auto-pairing nil)
  (web-mode-enable-auto-opening t)
  (web-mode-enable-auto-closing t)
  (web-mode-enable-auto-indentation nil)
  (web-mode-enable-auto-quoting nil)
  :config
  (setq web-mode-engines-alist '(("django" . "\\.html\\'")))
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (require 'flycheck)
  (advice-add 'flycheck-eslint-config-exists-p :override (lambda() t))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode)
)