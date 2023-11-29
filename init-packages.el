(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq package-selected-packages
  '(material-theme
    magit
    treemacs treemacs-projectile treemacs-icons-dired treemacs-magit
    lsp-mode lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode
    exec-path-from-shell
    ))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))
