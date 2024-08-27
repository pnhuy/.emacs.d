(use-package ivy
  :ensure t
  :init (ivy-mode 1)
  :diminish ivy-mode
  :config
  (setq ivy-use-virtual-buffers nil
        enable-recursive-minibuffers t
	      ivy-re-builders-alist '((ivy-switch-buffer . ivy--regex-plus)
                                (t . ivy--regex-fuzzy))
        ;;ivy-initial-inputs-alist nil
  ))

(use-package swiper
  :ensure t
  :after ivy
  :bind (("C-s" . 'swiper-isearch)
	 ("C-r" . 'swiper-backward)))

(use-package counsel
  :ensure t
  :after ivy
  :diminish counsel-mode
  :init (counsel-mode 1)
  :bind (("M-x" . 'counsel-M-x)
	 ("C-x C-f" . 'counsel-find-file)
   ("C-x C-r" . 'counsel-recentf)
	 ("C-x b" . 'counsel-switch-buffer))
  :config
  (add-to-list 'ivy-sort-functions-alist
             '(counsel-recentf . file-newer-than-file-p))
  )

(use-package ivy-prescient
  :ensure t
  :after ivy
  :config
  (ivy-prescient-mode 1)
  (prescient-persist-mode 1)
  (setq prescient-filter-method '(literal regexp initialism fuzzy))
  )

(use-package ivy-rich
  :ensure t
  :after ivy
  :config
  (ivy-rich-mode 1)
  )

(use-package all-the-icons-ivy-rich
  :ensure t
  :after ivy-rich
  :config
  (all-the-icons-ivy-rich-mode 1)
  )

