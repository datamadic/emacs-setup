;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start))

  ; s- is command, M- is option, C- is control
  (global-set-key (kbd "s-m") 'mark-sexp) ;; s is command
  (global-set-key (kbd "s-/") 'comment-or-uncomment-region)
  (global-set-key (kbd "s-?") 'uncomment-region)
  (global-set-key (kbd "s-I") 'indent-region)
  (global-set-key (kbd "s-<up>") 'backward-sexp)
  (global-set-key (kbd "s-<down>") 'forward-sexp)
  (global-set-key (kbd "s-p") 'projectile-find-file)
  (global-set-key (kbd "s-e") 'eval-last-sexp)
  (global-set-key (kbd "s-T") 'ns-popup-font-panel) ;; menlo default
  (global-set-key (kbd "s-t") 'neotree-toggle)
  (global-set-key (kbd "s-<left>") 'beginning-of-line-text)
  (global-set-key (kbd "s-<right>") 'end-of-line)
  (global-set-key (kbd "s-\"") 'sp-slurp-hybrid-sexp)
  (global-set-key (kbd "s-b") 'sp-unwrap-sexp)
  (global-set-key (kbd "s-E") 'eval-last-sexp)
  (global-set-key (kbd "s-e") 'cider-eval-last-sexp)
  (global-set-key (kbd "s-b") 'helm-buffers-list)
  (global-set-key (kbd "M-t") 'mode-line-other-buffer)
 ;;  (global-set-key (kbd "s-[") 'mode-line-other-buffer)
  (global-set-key (kbd "s-r") 'cider-format-region)
  (global-set-key (kbd "s-w") 'er/expand-region)
  (global-set-key (kbd "s-0") 'evil-goto-definition)
  (global-set-key (kbd "s-R") 'previous-buffer)
  (global-set-key (kbd "s-[") 'previous-buffer)
  (global-set-key (kbd "s-]") 'next-buffer)
  (global-set-key (kbd "s-}") 'forward-paragraph)
  (global-set-key (kbd "s-{") 'backward-paragraph)
  (global-set-key (kbd "s-b") 'helm-buffers-list)
  (global-set-key (kbd "s-B") 'sp-unwrap-sexp)
  (global-set-key (kbd "M-<up>") 'move-text-up)
  (global-set-key (kbd "M-<down>") 'move-text-down)
  (global-set-key (kbd "M-SPC") 'set-rectangular-region-anchor)
  (global-set-key (kbd "s-D") 'mc/mark-all-like-this)
  (global-set-key (kbd "s-d") 'mc/mark-next-like-this)
  (global-set-key (kbd "M-S") 'org-agenda-list)
  (global-set-key (kbd "<C-S-right>") 'sp-end-of-sexp)
  (global-set-key (kbd "<C-S-left>") 'sp-beginning-of-sexp)
  

  (setq org-agenda-files (quote ("~/todo.org")))
  (setq org-todo-keywords
        '((sequence "TODO" "PROG" "BLOC"  "|" "DONE")))

  ;; control+space 2x to set mark, control+u control+space to pop to mark 
  ;; (global-set-key (kbd "s-b") 'sp-unwrap-sexp)

  ;; setting (or overriding) just for a mode
  (with-eval-after-load 'clojure-mode-map
    (define-key clojure-mode-map (kbd "s-e") 'cider-eval-last-sexp))
  (with-eval-after-load 'org-mode-map
    (global-set-key (kbd "M->") 'org-table-move-cell-right)
    (global-set-key (kbd "M-<") 'org-table-move-cell-left))


  (defun js-src-block ()
    "wrap the region in a src block"
    (interactive)
    (let (;; (string (buffer-substring (region-beginning) (region-end)))
          (s2 (delete-and-extract-region (region-beginning) (region-end))))
      ;; (erase-buffer)
      (when t
        (insert "#+BEGIN_SRC js\n"
                s2
                "\n#+END_SRC")
        (previous-line)
        )))

  (global-set-key (kbd "s-J") 'js-src-block)

  (defun send-to-ansi ()
    "send the highlighted text to ansi"
    (interactive)
    (comint-send-string
     "*ansi-term*"
     (buffer-substring-no-properties (region-beginning) (region-end)))
    (comint-send-string
     "*ansi-term*" "\n"))

;;   (region-beginning)
;;   (region)
  ;;   (buffer-substring-no-properties (region-beginning) (region-end))

;;  (define-derived-mode k-mode fundamental-mode "custom k mode")
;;  (define-key 'k-mode-map (kbd "s-e") #'send-to-ansi)
  ;; (define-key (kbd "s-e") 'send-to-ansi)

  );; end if in emacs


;; Use C-h m, C-h k, and C-h b wherever you want to make the change. That will help you figure out the keymap in which you need to make the change. If Dan's suggestion didn't help then clearly that keymap is not the global map.

;; Setting the key binding to nil is indeed the way to unbind it. You just need to do that in the right map.

;; Using C-h M-k (describe-keymap), from library help-fns+.el will give you a human-readable list of the bindings in a given keymap (bound to a keymap variable, such as global-map.
