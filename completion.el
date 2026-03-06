;; Set up savehist to persist minibuffer history
(use-package savehist
  :init
  (savehist-mode 1))

;; Set up a completion style that uses orderless
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles . (partial-completion)))))

;; Enable recursive minibuffers (helpful for running commands inside the minibuffer)
(setq enable-recursive-minibuffers t)

;; Vertico
(use-package vertico
  :init
  ;; Enable Vertico global minor mode
  (vertico-mode 1)
  
  :config
  ;; Tweak the display appearance/behavior
  (setq vertico-scroll-margin 0      ; Don't scroll until last candidate
        vertico-count 10             ; Max number of candidates to show
        vertico-resize t             ; Allow minibuffer to grow/shrink
        vertico-cycle t)             ; Enable cycling (next from last goes to first)
)

(use-package orderless
    :init
    ;; Configure orderless matching style
    (setq orderless-matching-styles '(orderless-literal
                                        orderless-prefixes
                                        orderless-initialism
                                        orderless-flex))
    )

(use-package marginalia
  :config
  (marginalia-mode)
  (setq marginalia-align 'right)
  
  :bind
  ;; Cycle between different annotation views
  ("M-A" . marginalia-cycle)
  )

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package embark
  :bind
  ;; Embark is typically bound to a key for "act"
  ("C-." . embark-act)              ; General key to act on the current thing
  ("C-;" . embark-dwim)             ; "Do What I Mean" (contextual action)

  ;; Keymap for Embark's "collect" buffer (a list of candidates)
  :bind (("C-c a" . embark-collect))
  )

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (global-corfu-mode 1)
  
  :config
  ;; Adjust pop-up behavior
  (setq corfu-count 10                 ; Max number of candidates
        corfu-auto t                   ; Enable automatic pop-up
        corfu-echo-delay 0.1)          ; Delay before showing echo message

  ;; Bind C-SPC to `corfu-insert-separator` if you want to use Orderless-style completion 
  ;; in the Corfu popup (e.g. searching 'fn' for 'file-name')
  (with-eval-after-load 'corfu
    (define-key corfu-map (kbd "C-SPC") #'corfu-insert-separator)
    (define-key corfu-map (kbd "<tab>") #'corfu-insert)
    (define-key corfu-map (kbd "<return>") nil)
    (define-key corfu-map (kbd "RET") nil)
    (define-key corfu-map (kbd "C-n") #'corfu-next)
    (define-key corfu-map (kbd "C-p") #'corfu-previous)
    (define-key corfu-map (kbd "C-SPC") #'corfu-insert-separator))

  ;; Disable Corfu in terminal mode and use terminal-friendly alternatives
  (unless (display-graphic-p)
    (setq corfu-auto nil) ;; Disable auto popup in terminal
    (global-corfu-mode -1)) ;; Disable Corfu in terminal
  )

(use-package cape
  :init
  ;; Add some basic completion backends to complement what is provided by LSP
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  )

;; Fallback to company-mode in terminal Emacs
;; Use company-mode as a terminal-friendly alternative
(use-package company
  :config
  (unless (display-graphic-p)
    (global-company-mode 1)
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.0)
    (with-eval-after-load 'company
      ;; TAB for accepting completions
      (define-key company-active-map (kbd "TAB") 'company-complete-selection)
      (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
      ;; Disable RET key to avoid conflicts with newline insertion
      (define-key company-active-map (kbd "RET") nil))))