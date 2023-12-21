(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq package-selected-packages
  '(material-theme
    helm
    helm-lsp
    helm-projectile
    magit
    treemacs
    treemacs-projectile
    treemacs-icons-dired
    treemacs-magit
    lsp-mode
    lsp-treemacs 
    projectile 
    hydra flycheck company avy which-key helm-xref dap-mode
    exec-path-from-shell
    evil
    typescript-mode tree-sitter tree-sitter-langs
    fzf
    git-gutter
    org-bullets
    org-fragtog
    undo-tree
    ))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))
