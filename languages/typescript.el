(setq typescript-indent-level 2)
(setq typescript-ts-mode-indent-offset 2)
(setq treesit-font-lock-level 2)

;; if you use treesitter based typescript-ts-mode (emacs 29+)
;; (use-package js2-mode
;;   :ensure t
;;   :mode (("\\.tsx?\\'" . js2-mode))
;;   ;; :hook (js2-mode . lsp-deferred)
;;   :config
;;   (setq js2-basic-offset 2)
;;   (require 'lsp-mode)
;;   (lsp-deferred)
;; )

;; (use-package tide
;;   :ensure t
;;   :after (company flycheck)
;;   :hook ((typescript-ts-mode . tide-setup)
;;          (tsx-ts-mode . tide-setup)
;;          (typescript-ts-mode . tide-hl-identifier-mode)
;;          ;;(before-save . tide-format-before-save)
;;          )
;;          )

;; (use-package jtsx
;;   :ensure t
;;   :mode (("\\.jsx\\'" . jtsx-jsx-mode)
;;          ("\\.tsx\\'" . jtsx-tsx-mode)
;;          ("\\.ts\\'" . jtsx-typescript-mode))
;;   :commands jtsx-install-treesit-language
;;   :hook ((jtsx-jsx-mode . hs-minor-mode)
;;          (jtsx-tsx-mode . hs-minor-mode)
;;          (jtsx-typescript-mode . hs-minor-mode)
;;          (jtsx-jsx-mode . lsp-mode)
;;          (jtsx-tsx-mode . lsp-mode)
;;          (jtsx-typescript-mode . lsp-mode)
;;          )
;;   :custom
;;   ;; Optional customizations
;;   (js-indent-level 2)
;;   (typescript-ts-mode-indent-offset 2)
;;   (jtsx-switch-indent-offset 0)
;;   (jtsx-indent-statement-block-regarding-standalone-parent nil)
;;   ;; (jtsx-jsx-element-move-allow-step-out t)
;;   ;; (jtsx-enable-jsx-electric-closing-element t)
;;   ;; (jtsx-enable-electric-open-newline-between-jsx-element-tags t)
;;   ;; (jtsx-enable-jsx-element-tags-auto-sync nil)
;;   ;; (jtsx-enable-all-syntax-highlighting-features t)
;;   :config
;;   (require 'lsp-mode)
;;   (lsp-deferred)
;;   (defun jtsx-bind-keys-to-mode-map (mode-map)
;;     "Bind keys to MODE-MAP."
;;     (define-key mode-map (kbd "M-.") 'lsp-find-definition)
;;     (define-key mode-map (kbd "M-?") 'lsp-find-references)
;;     (define-key mode-map (kbd "C-c C-j") 'jtsx-jump-jsx-element-tag-dwim)
;;     (define-key mode-map (kbd "C-c j o") 'jtsx-jump-jsx-opening-tag)
;;     (define-key mode-map (kbd "C-c j c") 'jtsx-jump-jsx-closing-tag)
;;     (define-key mode-map (kbd "C-c j r") 'jtsx-rename-jsx-element)
;;     (define-key mode-map (kbd "C-c <down>") 'jtsx-move-jsx-element-tag-forward)
;;     (define-key mode-map (kbd "C-c <up>") 'jtsx-move-jsx-element-tag-backward)
;;     (define-key mode-map (kbd "C-c C-<down>") 'jtsx-move-jsx-element-forward)
;;     (define-key mode-map (kbd "C-c C-<up>") 'jtsx-move-jsx-element-backward)
;;     (define-key mode-map (kbd "C-c C-S-<down>") 'jtsx-move-jsx-element-step-in-forward)
;;     (define-key mode-map (kbd "C-c C-S-<up>") 'jtsx-move-jsx-element-step-in-backward)
;;     (define-key mode-map (kbd "C-c j w") 'jtsx-wrap-in-jsx-element)
;;     (define-key mode-map (kbd "C-c j u") 'jtsx-unwrap-jsx)
;;     (define-key mode-map (kbd "C-c j d") 'jtsx-delete-jsx-node))
    
;;   (defun jtsx-bind-keys-to-jtsx-jsx-mode-map ()
;;       (jtsx-bind-keys-to-mode-map jtsx-jsx-mode-map))

;;   (defun jtsx-bind-keys-to-jtsx-tsx-mode-map ()
;;       (jtsx-bind-keys-to-mode-map jtsx-tsx-mode-map))

;;   (add-hook 'jtsx-jsx-mode-hook 'jtsx-bind-keys-to-jtsx-jsx-mode-map)
;;   (add-hook 'jtsx-tsx-mode-hook 'jtsx-bind-keys-to-jtsx-tsx-mode-map))