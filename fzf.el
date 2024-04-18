(use-package fzf
  :ensure t
  :bind
    ;; Don't forget to set keybinds!
  :config
  (setenv "FZF_DEFAULT_COMMAND" "rg --files --hidden --follow --glob '!.git/*'")
  (setq 
        ;; use rg for fzf
        ;; fzf/executable "rg"
        ;; fzf/args "--no-heading -nH"
        ;; fzf/args "--exclude=node_modules"
        ;; fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll "
        ;; fzf/executable "fzf"
        ;; fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        ;; fzf/grep-command "rg --no-heading -nH"
        ;; fzf/grep-command "grep -nrH"
        ;; fzf/grep-command "grep --color=always --exclude-dir={node_modules,.git,.svn,.hg,.bzr,.idea,.tox,.vscode} --exclude=tags"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        ;; fzf/window-height 15
        ))

;; run counsel-rg with project root
(defun counsel-rg-project-root ()
  (interactive)
  (counsel-rg nil (projectile-project-root)))

;; keymap for counsel-rg-project-root
(global-set-key (kbd "C-t") 'counsel-rg-project-root)