;; load phscroll
(add-to-list 'load-path (expand-file-name "packages/phscroll" user-emacs-directory))
(require 'phscroll)
;; uncomment the following line to enable phscroll in org-mode
;; (setq org-startup-truncated nil)
;; (with-eval-after-load "org"
;;   (require 'org-phscroll))

(setq org-adapt-indentation t)
(setq org-list-allow-alphabetical t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(defun org-table-collapse-cell ()
  (interactive)
  (save-excursion ;; Save point
    (org-table-blank-field) ;; Blank the cell
    (while (progn ;; Swap blank cell with a cell under it until the blank is at the bottom.
         (org-table--move-cell 'down)
         (org-table-align)
         (org-table-check-inside-data-field))))
  (org-table-next-field))

;; latex fragment preview dpi
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
(setq org-latex-create-formula-image-program 'dvisvgm)
(add-hook 'org-mode-hook 'org-fragtog-mode)

