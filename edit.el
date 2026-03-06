(delete-selection-mode 1)

(use-package surround
  :ensure t
  :bind-keymap ("M-'" . surround-keymap))

(use-package drag-stuff
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines) ; C-S-c C-S-c for line editing
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Better undo/redo
(use-package undo-fu
  :bind
  (("C-/" . undo-fu-only-undo)
   ("C-?" . undo-fu-only-redo)))

;; yasnippet
(use-package yasnippet
  :config
  (yas-reload-all)
  (add-hook 'org-mode-hook
            (lambda ()
              (yas-minor-mode)
              (yas-activate-extra-mode 'latex-mode)))
)

;; yasnippet-snippets
(use-package yasnippet-snippets
  :after yasnippet)