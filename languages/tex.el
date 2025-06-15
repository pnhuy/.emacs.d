;; (use-package lsp-latex
;;   :ensure t)

;; (with-eval-after-load "tex-mode"
;;   (add-hook 'tex-mode-hook 'lsp-deferred)
;;   (add-hook 'latex-mode-hook 'lsp-deferred)
;;   (setq lsp-latex-latex-formatter "latexindent")
;;   (setq lsp-latex-latexindent-local	"latexindent.yaml")
;;   (setq lsp-latex-build-executable	"latexmk")
;;   (setq lsp-latex-build-args		'("-pdf" "-pvc" "-interaction=nonstopmode"))
;;  )

;; ;; For YaTeX
;; (with-eval-after-load "yatex"
;;  (add-hook 'yatex-mode-hook 'lsp-deferred))

;; ;; For bibtex
;; (with-eval-after-load "bibtex"
;;  (add-hook 'bibtex-mode-hook 'lsp-deferred))