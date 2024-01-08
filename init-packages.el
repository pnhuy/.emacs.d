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
    lsp-ui
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
    web-mode
    prettier-js
    tide
    ein
    ligature
    ))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
