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

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

(add-to-list 'load-path "~/.emacs.d/emmet-mode")
(require 'emmet-mode)

(autoload 'linum-mode "linum" "toggle line numbers on/off" t) 
(global-set-key (kbd "C-<f5>") 'linum-mode)  

(global-linum-mode t)

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

;(global-set-key (kbd "s-c") 'next-line)



(setq ns-command-modifier 'hyper)
(let ((cmd (cond ((eq ns-command-modifier 'hyper) "H-")
                 ((eq ns-command-modifier 'super) "s-"))))
  (global-set-key (kbd (concat cmd "<left>")) 'beginning-of-line)
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

;(setq-default indent-tabs-mode t)
(setq-default tab-width 2)
;(global-set-key (kbd "TAB") 'self-insert-command)

;(mouse-wheel-mode t)

;(global-set-key (kbd "<mouse-4>") 'down-slightly)
;(global-set-key (kbd "<mouse-5>") 'up-slightly)
;(setq scroll-step 1)
;(setq scroll-conservatively 1000)
;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;(setq mouse-wheel-progressive-speed nil)
;(setq mouse-wheel-follow-mouse t)
;(require 'mwheel)

;(mouse-wheel-mode 1)

(require 'mouse) ;; needed for iterm2 compatibility
(xterm-mouse-mode t)
(global-set-key [mouse-4] '(lambda ()
                           (interactive)
                           (scroll-down 1)))
(global-set-key [mouse-5] '(lambda ()
                           (interactive)
                           (scroll-up 1)))
(setq mouse-sel-mode t)
(defun track-mouse (e))

(ac-config-default)
(setq x-select-enable-clipboard t)

(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(package-install 'smartscan)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(custom-safe-themes
   (quote
    ("18aa799ae149ceed4e337310319ad612b4f2526f058f8fd8ee00b8d8d79ed678" default)))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(load-theme 'leuven t)

(setq linum-format "%d ")


;; from here: http://gertm.blogspot.com/2009/06/my-little-gnus-and-gmail-howto.html
;; its an email config..

;; got this line from one of the tutorials. Seemed interesting enough
(setq gnus-invalid-group-regexp "[:`'\"]\\|^$")

;; standard way of getting imap going
;; (setq gnus-select-method 
;;          '(nnimap "gmail"
;;           (nnimap-address "imap.gmail.com")
;;           (nnimap-server-port 993)
;;           (nnimap-stream ssl)))

(setq gnus-select-method 
         '(nnimap "openfin.co"
          (nnimap-address "imap.openfin.co")
          (nnimap-server-port 993)
          (nnimap-stream ssl)))

;; set up smtp so we can send from gmail too:
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.openfin.co" 587 "xavier@openfin.co" nil))
      smtpmail-default-smtp-server "smtp.openfin.co"
      smtpmail-smtp-server "smtp.openfin.co"
      smtpmail-smtp-service 587)

;;http://www.emacswiki.org/cgi-bin/wiki/GnusGmail                                                                                                              
;;http://linil.wordpress.com/2008/01/18/gnus-gmail/                                                                                                            

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Threads are nice!
(setq gnus-summary-thread-gathering-function
      'gnus-gather-threads-by-subject)

;; (setq gnus-posting-styles
;;        '((".*"
;;           (name "Gert M")
;;           ("X-URL" "http://gertm.blogspot.com/"))))

(setq user-full-name "xavier")
(setq user-mail-address "xavier@openfin.co")
(setq send-mail-function 'smtpmail-send-it)


