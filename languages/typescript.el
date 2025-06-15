(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (prettier-js-mode +1)
  (company-mode +1)
  ;; config prettier-js-show-errors to echo
  (setq prettier-js-show-errors 'echo)
  ;; ctrl c l l to format buffer
  (define-key tide-mode-map (kbd "C-c l = =") 'prettier-js)
  ;; config emmet-mode for tsx and jsx
  (emmet-mode +1)
  (add-to-list 'emmet-jsx-major-modes 'typescript-mode)
  (add-to-list 'emmet-jsx-major-modes 'typescript-ts-mode)
  (add-to-list 'emmet-jsx-major-modes 'tsx-ts-mode)
  )

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'typescript-ts-mode-hook #'setup-tide-mode)
(add-hook 'tsx-ts-mode-hook #'setup-tide-mode)