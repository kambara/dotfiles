;; .emacs by kambara

;; Coding system and Language Settings
(when (equal emacs-major-version 21) (require 'un-define))
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)

;; Add to load-path
(setq load-path
      (append
       (list
	(expand-file-name "~/.elisp/"))
       load-path))

;; General Settings
(setq inhibit-startup-message t) ;; No init message
(show-paren-mode 1)              ;; highlight (~~)
(transient-mark-mode 1)          ;; coloring selection
(global-font-lock-mode t)        ;; coloring
(set-input-mode nil nil t)       ;; Alt as Meta key
(tool-bar-mode nil)              ;; Tool bar
(menu-bar-mode nil)              ;; Menu bar
(scroll-bar-mode nil)           ;; No Scroll bar
(set-scroll-bar-mode 'right)     ;; Right Scroll bar
(setq-default indent-tabs-mode nil)
(setq ring-bell-function 'ignore) ;; No beep and flash
(setq initial-scratch-message "")

;; Do NOT show the message: "The local variables list in .emacs"
(add-to-list 'ignored-local-variables 'syntax)

;; Sync clibboard between Emacs and Gnome
(cond (window-system
       (setq x-select-enable-clipboard t)))

;; Open URL by Middle click
(setq browse-url-browser-function 'browse-url-firefox)
(global-set-key [mouse-2] 'browse-url-at-mouse)

;; Backup
(setq make-backup-files t)
(setq vc-make-backup-files t) ;; Also save files under VCS (CVS, SVN)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.backup"))
            backup-directory-alist))
(setq version-control t)
(setq kept-new-versions 5)
(setq kept-old-versions 5)
(setq delete-old-versions t)

;; color-theme
(cond (window-system
       (require 'color-theme)
       ;(setq color-theme-is-global t)
       (color-theme-initialize)
       (color-theme-charcoal-black)
       ))

;; color-moccur:
;; - http://www.bookshelf.jp/soft/meadow_50.html#SEC733
;;   or
;; - $ apt-get install emacs-goodies package
(require 'color-moccur)

;; migemo
(load "migemo")

;; pos-tip.el
;; - http://www.emacswiki.org/emacs-en/PosTip
(require 'pos-tip)

;; auto save buffers:
;; - http://0xcc.net/misc/auto-save/
(require 'auto-save-buffers)
(run-with-idle-timer 2 t 'auto-save-buffers)

;; auto-complete:
;; - http://www.emacswiki.org/emacs/AutoComplete
;; - http://dev.ariel-networks.com/Members/matsuyama/auto-complete>
(add-to-list 'load-path "~/.elisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.elisp/auto-complete/ac-dict")
(ac-config-default)

;; RSense:
;; - http://cx4a.org/software/rsense/index.ja.html
(setq rsense-home "/home/kambara/work/var/apps/rsense-0.2")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
(add-hook 'ruby-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)))

;; ruby-mode
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)
		("\\.ru$" . ruby-mode))
              auto-mode-alist))

;; Haml-mode
(require 'haml-mode)

;; wdired
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; Changelog memo:
;; - require clmemo.el
;; - http://pop-club.hp.infoseek.co.jp/emacs/clmemo.html
(setq user-full-name "Keisuke Kambara")
(setq user-mail-address "kambara@sappari.org")
(autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
(setq clmemo-file-name "~/work/var/memo/memo.changelog")
(setq auto-mode-alist
      (cons '("\\.changelog$" . clmemo-mode)
            auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.changelog$" . change-log-mode)
            auto-mode-alist))
(global-set-key "\C-xM" 'clmemo)

;; challow
(setq exec-path
      (cons "/home/kambara/work/var/chalow" exec-path))
(setenv "PATH"
        (concat "/home/kambara/work/var/chalow:"
                (getenv "PATH")))

;; shell-command completion
(require 'shell-command)
(shell-command-completion-mode)

;; Switch buffer [C-tab]
;; - http://ftp2.de.freebsd.org/pub/emacs/emacs-lisp/incoming/pc-bufsw.el
(require 'pc-bufsw)
(pc-bufsw::bind-keys (quote [C-tab]) (quote [C-S-tab]))

;; javascript-mode
(autoload 'javascript-mode "javascript" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

;; PSGML mode (SGML and XML)
(setq auto-mode-alist
      (append '(("\\.html$" . xml-mode)
		("\\.shtml$" . xml-mode)
                ("\\.xhtml$" . xml-mode)
                ("\\.rdf$" . xml-mode)
                ("\\.xul$" . xml-mode)
                ("\\.erb$" . xml-mode)
		) auto-mode-alist))

;; PHP mode
(add-hook 'php-mode-user-hook
          '(lambda ()
             (setq c-basic-offset 8)
             (setq c-tab-width 8)
             (setq c-indent-level 8)
             (setq tab-width 8)
             (setq indent-tabs-mode t)
             (setq-default tab-width 8)))

;; Darkroom
(require 'darkroom)
(global-set-key [f11] 'darkroom-mode)

;; ATOK X3
(add-to-list 'load-path "~/.elisp/iiimecf/")
(setq iiimcf-server-control-hostlist (list (concat "/tmp/.iiim-" (user-login-name) "/:0.0")))
(when (and (= 0 (shell-command
                 (concat
                  "netstat --unix -l | grep -q "
                  (car iiimcf-server-control-hostlist))))
           (require 'iiimcf-sc nil t))
  (setq iiimcf-server-control-default-language "ja")
  (setq iiimcf-server-control-default-input-method "atokx3")
  (setq default-input-method 'iiim-server-control)
  (setq iiimcf-UI-input-method-title-format "<ATOK:%s>")
  (setq iiimcf-UI-preedit-use-face-p "window-system")
  (setq iiimcf-keycode-spec-alist
        (append
         '(
           (11 113 65535) ; C-k = F2(113)
           (12 114 65535) ; C-l = F3(114)
           (9  113 65535) ; C-i = F2(113)
           (15 114 65535) ; C-o = F3(114)
           (7  27  65535) ; C-g = Esc
           (16 38  65535) ; C-p = Up(38)
           (14 28  65535) ; C-n = Down(28)
           (2  37  65535) ; C-b = Left(37)
           (6  39  65535) ; C-f = Right(39)
           )
         iiimcf-keycode-spec-alist))
  (define-key global-map [henkan] (lambda ()
                                  (interactive)
                                  (if current-input-method (inactivate-input-method))
                                  (toggle-input-method)))
  (define-key global-map [muhenkan] (lambda ()
                                  (interactive)
                                  (inactivate-input-method)))
  )

;; Key map
(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\C-x\C-h" 'help-command)
(define-key global-map "\M-g" 'goto-line)
(define-key global-map "\M-o" 'moccur-grep)

;; Font for emacs23
(cond (window-system
;       (set-default-font "Bitstream Vera Sans Mono-11")
       (set-default-font "DejaVu Sans Mono-15")
;       (set-default-font "Takao明朝-16")
       (set-fontset-font (frame-parameter nil 'font)
                         'japanese-jisx0208
;                         '("Takao明朝" . "unicode-bmp")
;                         '("Meiryo" . "unicode-bmp")
                         '("Takaoゴシック" . "unicode-bmp")
                         )))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((clmemo-mode . t)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
