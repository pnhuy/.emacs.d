;; ;; if you use treesitter based typescript-ts-mode (emacs 29+)
;; (use-package rjsx-mode
;;   :ensure t
;;   :mode
;;   ("\\.jsx?\\'" . rjsx-mode)
;;   :hook
;;   (rjsx-mode . prettier-js-mode)
;;   :bind
;;   (:map rjsx-mode-map
;;         ("C-c l = =" . prettier-js))
;;   :config
;;   (setq js-basic-offset 2)
;;   (setq js-indent-level 2)
;;   (require 'lsp-mode)
;;   (lsp-deferred)
;; )
