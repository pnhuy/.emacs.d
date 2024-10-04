;; load phscroll
(use-package phscroll
  :straight '(phscroll
              :type git
              :host github
              :repo "misohena/phscroll"))
;; (require 'phscroll)
;; uncomment the following line to enable phscroll in org-mode
;; (setq org-startup-truncated nil)
;; (with-eval-after-load "org"
;;   (require 'org-phscroll))

(use-package org-bullets 
  :ensure t
  :hook (org-mode . org-bullets-mode)
)

(defun org-table-collapse-cell ()
  (interactive)
  (save-excursion ;; Save point
    (org-table-blank-field) ;; Blank the cell
    (while (progn ;; Swap blank cell with a cell under it until the blank is at the bottom.
         (org-table--move-cell 'down)
         (org-table-align)
         (org-table-check-inside-data-field))))
  (org-table-next-field))

;; turn on auto-save for org-mode
(defun org-save-all-org-buffers-quietly ()
  (save-some-buffers t (lambda () (derived-mode-p 'org-mode)))
  (when (featurep 'org-id) (org-id-locations-save)))

;; function setup org-mode
(defun set-up-org-mode ()
  (require 'org-phscroll)
  (setq org-adapt-indentation nil)
  (setq org-list-allow-alphabetical t)

  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;; active Babel languages
  (org-babel-do-load-languages
  'org-babel-load-languages
  '((R . t)
    (python . t)
    (dot . t)))

  ;; latex fragment preview dpi
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (setq org-latex-create-formula-image-program 'dvisvgm)
  
  ;; Latex Preview folder
  (setq org-preview-latex-image-directory 
        (concat temporary-file-directory "ltximg/"))
  
  ;; Config latex preview process list
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; auto adjust scale after font size change
  (add-hook 'text-scale-mode-hook
    (lambda ()
      (plist-put org-format-latex-options :scale 
        (expt text-scale-mode-step text-scale-mode-amount))))
  
  ;; set path for python
  (setq org-babel-python-command "python3")
  
  ;; auto save
  (require 'org-tempo)                            
  (auto-save-mode 1)
  (setq auto-save-interval 50)
  (add-hook 'auto-save-hook 'org-save-all-org-buffers-quietly)
  
  ;; turn auto-revert-mode on for org
  (auto-revert-mode 1)
  (setq auto-revert-verbose nil)
  (setq auto-revert-use-notify nil)
  
  ;; enable org-tempo in org-mode
  (add-to-list 'org-modules 'org-tempo t)
  
  ;; disable electric-pair-mode in org-mode
  (electric-pair-mode -1)
  
  ;; yasnippet for latex in org-mode
  (yas-activate-extra-mode 'latex-mode)
  
  ;; enable prettify-symbols-mode in org-mode
  (prettify-symbols-mode 1)
  
  ;; start startup folded
  (setq org-startup-folded t)
)

(add-hook 'org-mode-hook 'set-up-org-mode)
