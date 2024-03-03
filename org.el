;; load phscroll
(use-package phscroll
  :straight '(phscroll
              :type git
              :host github
              :repo "misohena/phscroll"))
(require 'phscroll)
;; uncomment the following line to enable phscroll in org-mode
;; (setq org-startup-truncated nil)
;; (with-eval-after-load "org"
;;   (require 'org-phscroll))

(setq org-adapt-indentation nil)
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

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)))

;; set path for python
(setq org-babel-python-command "python3")

;; turn on auto-save for org-mode
(add-hook 'org-mode-hook (lambda ()
                            (require 'org-tempo)                            
                            (auto-save-mode 1)
                            (setq auto-save-interval 50)
                            (add-hook 'auto-save-hook 'org-save-all-org-buffers)))

;; turn auto-revert-mode on for org
(add-hook 'org-mode-hook 'auto-revert-mode)
(setq auto-revert-verbose nil)
(setq auto-revert-use-notify nil)

;; enable org-tempo in org-mode
(add-to-list 'org-modules 'org-tempo t)

;; disable electric-pair-mode in org-mode
(add-hook 'org-mode-hook (lambda () (electric-pair-mode -1)))

