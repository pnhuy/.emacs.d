;; key for duplicate-dwim
(global-set-key (kbd "C-c d") 'duplicate-dwim)

;; C-+ and C-_- to increase/decrease global text scale
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Meta Shift up/down to move org subtree up/down in org mode
(define-key org-mode-map (kbd "M-S-<up>") 'org-move-subtree-up)
(define-key org-mode-map (kbd "M-S-<down>") 'org-move-subtree-down)
(define-key org-mode-map (kbd "C-S-w") 'org-cut-subtree)