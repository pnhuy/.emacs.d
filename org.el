;; load phscroll
(add-to-list 'load-path (expand-file-name "packages/phscroll" user-emacs-directory))
(require 'phscroll)
;; uncomment the following line to enable phscroll in org-mode
;; (setq org-startup-truncated nil)
;; (with-eval-after-load "org"
;;   (require 'org-phscroll))

(setq org-adapt-indentation t)
(setq org-list-allow-alphabetical t)
