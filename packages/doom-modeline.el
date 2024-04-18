;; only load all-the-icons if in gui
(use-package all-the-icons
  :if (display-graphic-p)
  :ensure t
  :config
  ;; check if all-the-icons font is installed and gui, if not run install it
  (if (display-graphic-p)
    (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t)))
  )

(use-package nerd-icons
  :if (display-graphic-p)
  :ensure t
  :config
  ;; check if nerd font is installed and gui, if not run install it
  (if (display-graphic-p)
    (unless (member "Symbols Nerd Font Mono" (font-family-list))
    (nerd-icons-install-fonts t)))
  )

(use-package doom-modeline
  :if (display-graphic-p)
  :ensure t
  :custom
  (doom-modeline-enable-word-count nil)
  (inhibit-compacting-font-caches t)
  :init (doom-modeline-mode 1))