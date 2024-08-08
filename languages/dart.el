
(defun get-flutter-sdk-path ()
  (interactive)
  (let ((flutter-sdk-path (shell-command-to-string "echo -n $FLUTTER_SDK_PATH")))
    (if (string= flutter-sdk-path "")
        (flutter-sdk-path "/opt/homebrew/Caskroom/flutter/3.13.9/flutter")
      flutter-sdk-path)))

;; Assuming usage with dart-mode
(use-package dart-mode
  :ensure t
  :hook
  (dart-mode . yas-minor-mode)
  (dart-mode . (lambda ()
                 (add-hook 'after-save-hook 'my-lsp-format-buffer)))
  :config
  ;; auto kill lsp active process when exiting emacs
  (setq confirm-kill-processes nil)
  ;; tab width
  (setq lsp-dart-flutter-widget-guides t)
  (setq lsp-dart-line-length 120)
)

;; (use-package flutter
;;   :ensure t
;;   :after dart-mode
;;   :hook (dart-mode . (lambda ()
;;                       (add-hook 'after-save-hook #'flutter-run-or-hot-reload nil t)))
;;   :bind (:map dart-mode-map
;;               ("C-M-x" . #'flutter-run-or-hot-reload))
;;   :custom
;;   (flutter-sdk-path (get-flutter-sdk-path)))

(use-package lsp-dart
  :ensure t
  :hook (dart-mode . lsp-deferred)
)
  