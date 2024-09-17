(setenv "LSP_USE_PLISTS" "true")
;; Speed up startup
;; Don’t compact font caches during GC for doom-modeline
(setq inhibit-compacting-font-caches t)
;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)
;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))
;; END Speed up startup