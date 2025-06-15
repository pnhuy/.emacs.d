;; Auto-install and configure prisma-mode
(let* ((prisma-dir (expand-file-name "~/.emacs.d/var/prisma-mode/"))
       (prisma-git-url "https://github.com/davidarenas/prisma-mode"))
  (unless (file-directory-p prisma-dir)
    (message "Cloning prisma-mode...")
    (make-directory (file-name-directory prisma-dir) t)
    (let ((default-directory (file-name-directory prisma-dir)))
      (shell-command (format "git clone %s %s" prisma-git-url prisma-dir)))
    (byte-recompile-directory prisma-dir 0))
  ;; Load prisma-mode
  (add-to-list 'load-path prisma-dir)
  (autoload 'prisma-mode "prisma-mode" "Major mode for editing Prisma schema files." t)
  (add-to-list 'auto-mode-alist '("\\.prisma\\'" . prisma-mode)))
;; if prisma-mode, set ctrl c l l to format buffer
(defun setup-prisma-mode ()
  (interactive)
  (when (fboundp 'prisma-fmt-buffer)
    (define-key prisma-mode-map (kbd "C-c l = =") 'prisma-fmt-buffer)))
(add-hook 'prisma-mode-hook #'setup-prisma-mode)