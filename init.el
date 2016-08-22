;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; ;; The packages you want installed. You can also install these
;; ;; manually with M-x package-install
;; ;; Add in your own as you wish:
(defvar my-packages
   '(;; makes handling lisp expressions much, much easier
;;     ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
;;     paredit

;;     ;; key bindings and code colorization for Clojure
;;     ;; https://github.com/clojure-emacs/clojure-mode
     clojure-mode

;;     ;; extra syntax highlighting for clojure
;;     clojure-mode-extra-font-locking

;;     ;; integration with a Clojure REPL
;;     ;; https://github.com/clojure-emacs/cider
     cider

;;     ;; allow ido usage in as many contexts as possible. see
;;     ;; customizations/navigation.el line 23 for a description
;;     ;; of ido
;;     ido-ubiquitous

;;     ;; Enhances M-x to allow easier execution of commands. Provides
;;     ;; a filterable list of possible commands in the minibuffer
;;     ;; http://www.emacswiki.org/emacs/Smex
;;     smex

;;     ;; project navigation
;;     projectile

;;     ;; colorful parenthesis matching
     rainbow-delimiters

;;     ;; edit html tags like sexps
;;     tagedit

;;     ;; git integration
     ;;magit
 ))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;;;;  environment variables from the user's shell.
;; ;; https://github.com/purcell/exec-path-from-shell
 (if (eq system-type 'darwin)
     (add-to-list 'my-packages 'exec-path-from-shell))

 (dolist (p my-packages)
   (when (not (package-installed-p p))
     (package-install p)))


;; ;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; ;; to load them.
;; ;;
;; ;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; ;; then you can add the following code to this file:
;; ;;
;; ;; (require 'yaml-mode)
;; ;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; ;; 
;; ;; Adding this code will make Emacs enter yaml mode whenever you open
;; ;; a .yml file
;; (add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; ;; Sets up exec-path-from-shell so that Emacs will use the correct
;; ;; environment variables
(load "shell-integration.el")

;; ;; These customizations make it easier for you to navigate files,
;; ;; switch buffers, and choose options from the minibuffer.
;; (load "navigation.el")

;; ;; These customizations change the way emacs looks and disable/enable
;; ;; some user interface elements
;; (load "ui.el")

;; ;; These customizations make editing a bit nicer.
;; (load "editing.el")

;; ;; Hard-to-categorize customizations
;; (load "misc.el")

;; ;; For editing lisps
;; (load "elisp-editing.el")

;; ;; Langauage-specific
;; (load "setup-clojure.el")
;; (load "setup-js.el")

(add-to-list 'load-path "~/.emacs.d/emmet-mode")
(require 'emmet-mode)

; (setq-default indent-tabs-mode t)
; (setq-default tab-width 2)
;(setq-default fill-colum 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)


;(add-to-list 'load-path "~/.emacs.d/config")
;(require 'editorconfig)
;(editorconfig-mode 1)

(autoload 'linum-mode "linum" "toggle line numbers on/off" t) 
(global-set-key (kbd "C-<f5>") 'linum-mode)  

(global-linum-mode -1)



; i just did this... 
;(setq tab-stop-list (number-sequence 4 200 4))
(add-hook 'lisp-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)))

(define-key global-map (kbd "RET") 'newline-and-indent)

;;
;; copy and paste stuff 
;;
(defun copy-from-osx ()
      (shell-command-to-string "pbpaste"))

  (defun paste-to-osx (text &optional push)
        (let ((process-connection-type nil))
                (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
                          (process-send-string proc text)
                                  (process-send-eof proc))))

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx)

(require 'multiple-cursors)
(global-set-key (kbd "H-m") 'mc/edit-lines)
(global-set-key (kbd "H-d") 'mc/mark-next-like-this)
;(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "H->") 'mc/mark-all-like-this)

(electric-pair-mode t)
(global-auto-complete-mode t)
(show-paren-mode t)
(scroll-bar-mode -1)


(global-set-key (kbd "C-.") 'forward-paragraph)
(global-set-key (kbd "C-,") 'backward-paragraph)


;; set nagivation near to the home row 
(global-set-key (kbd "H-;") 'forward-paragraph)
(global-set-key (kbd "H-j") 'backward-paragraph)
(global-set-key (kbd "H-k") 'previous-line)
(global-set-key (kbd "H-l") 'next-line)
(global-set-key (kbd "H-o") 'forward-word)
(global-set-key (kbd "H-i") 'backward-word)
(global-set-key (kbd "M-o") 'forward-char)
(global-set-key (kbd "M-i") 'backward-char)
(global-set-key (kbd "M-l") 'goto-line)
(global-set-key (kbd "H-[") 'delete-indentation)
(global-set-key (kbd "H-h") 'isearch-forward-symbol-at-point)
(global-set-key (kbd "H-y") 'neotree)
(global-set-key (kbd "H-Y") 'neotree-hide)
(global-set-key (kbd "H-b") 'switch-to-buffer)

; (global-set-key (kbd "H-p") 'list-buffers)
(global-set-key (kbd "H-/") 'indent-region)
(global-set-key (kbd "H-<left>") 'back-to-indentation)

(eval-after-load "flyspell"
    '(progn
       (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
       (define-key flyspell-mouse-map [mouse-3] #'undefined)))

(setq default-tab-width 2)
(load-theme 'misterioso t)

(setq ns-command-modifier 'hyper)
(let ((cmd (cond ((eq ns-command-modifier 'hyper) "H-")
                 ((eq ns-command-modifier 'super) "s-"))))

;  (global-set-key (kbd (concat cmd "<left>")) 'beginning-of-line)
(global-set-key (kbd (concat cmd "<right>")) 'end-of-line)
(global-set-key (kbd (concat cmd "<up>")) 'beginning-of-buffer)
(global-set-key (kbd (concat cmd "<down>")) 'end-of-buffer)
(global-set-key (kbd (concat cmd "o")) 'find-file-existing)
(global-set-key (kbd (concat cmd "n")) 'make-frame)
(global-set-key (kbd (concat cmd "s")) 'save-buffer)
(global-set-key (kbd (concat cmd "S")) 'write-file)
(global-set-key (kbd (concat cmd "a")) 'mark-whole-buffer)
(global-set-key (kbd (concat cmd "z")) 'undo)
(global-set-key (kbd (concat cmd "Z")) 'redo)
(global-set-key (kbd (concat cmd "l")) 'goto-line)
(global-set-key (kbd (concat cmd "x")) 'kill-region)
(global-set-key (kbd (concat cmd "c")) 'kill-ring-save)
(global-set-key (kbd (concat cmd "v")) 'yank)
(global-set-key (kbd (concat cmd "`")) 'other-frame)
(global-set-key (kbd (concat cmd "q")) 'save-buffers-kill-terminal)
(global-set-key (kbd (concat cmd "w")) 'delete-frame)
(global-set-key (kbd (concat cmd "f")) 'isearch-forward)
(global-set-key (kbd (concat cmd ".")) 'keyboard-quit)
(global-set-key (kbd (concat cmd "C-f")) 'toggle-frame-fullscreen)
(global-set-key (kbd (concat cmd "b")) 'list-buffers)
(global-set-key (kbd (concat cmd "1")) 'delete-other-windows)
(global-set-key (kbd (concat cmd "2")) 'split-window-below)
(global-set-key (kbd (concat cmd "3")) 'split-window-right)
(global-set-key (kbd (concat cmd "0")) 'delete-window)
(global-set-key (kbd (concat cmd "'")) 'other-window)
(global-set-key (kbd (concat cmd "=")) 'text-scale-increase)
(global-set-key (kbd (concat cmd "-")) 'text-scale-decrease)
(global-set-key (kbd (concat cmd "R")) 'reveal-in-finder)
(global-set-key (kbd (concat cmd "U")) '-revert-buffer-no-confirm))

;; set nagivation near to the home row 
(global-set-key (kbd "H-;") 'forward-paragraph)
(global-set-key (kbd "H-j") 'backward-paragraph)
(global-set-key (kbd "H-k") 'previous-line)
(global-set-key (kbd "H-l") 'next-line)
(global-set-key (kbd "H-o") 'forward-word)
(global-set-key (kbd "H-i") 'backward-word)
(global-set-key (kbd "M-o") 'forward-char)
(global-set-key (kbd "M-i") 'backward-char)
(global-set-key (kbd "M-l") 'goto-line)



(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(setq scroll-step 1) ;; keyboard scroll one line at a time

(package-install 'smartscan)

;; use web-mode for .jsx files
;;(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 (quote
		("18aa799ae149ceed4e337310319ad612b4f2526f058f8fd8ee00b8d8d79ed678" default)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; python stuff
(package-initialize)
(elpy-enable)

(add-to-list 'load-path "~/.emacs.d/repl")
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)


(defun javascript-custom-setup ()
	(moz-minor-mode 1))

(add-hook 'javascript-mode-hook 'javascript-custom-setup)

; turn on projectile mode all the time 
(projectile-global-mode)

(global-set-key (kbd "H-p") 'projectile-find-file)
;; (global-set-key (kbd "H-i") 'pop-global-mark) 


;; be able to edit text areas in emacs
;; http://wikemacs.org/wiki/Edit_with_Emacs
(add-to-list 'load-path "~/.emacs.d/edit-server")
(require 'edit-server)
(edit-server-start)

(setq lexical-let 1)

(defun backupgen ()
	(let ((last nil))
		(lambda ()
			(interactive)
			(if (eq nil last)
					(progn
						(setq last 1) ; local binding 
						(forward-paragraph))
				(progn
					(setq last nil) ; local binding 
					(backward-paragraph))))))

(setq backup (backupgen))

(defun scrl ()
	(interactive)
	(set-window-vscroll (selected-window) 20))

(global-set-key (kbd "H-8") 'scrl)


;; sample config
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            ;; company is an optional dependency. You have to
            ;; install it separately via package-install
            ;; (company-mode-on)
						))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

;; format options
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))
;; see https://github.com/Microsoft/TypeScript/blob/cc58e2d7eb144f0b2ff89e6a6685fb4deaa24fde/src/server/protocol.d.ts#L421-473 for the full list available options

;; Tide can be used along with web-mode to edit tsx files
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup)
              (flycheck-mode +1)
              (setq flycheck-check-syntax-automatically '(save mode-enabled))
              (eldoc-mode +1)
              (company-mode-on))))
