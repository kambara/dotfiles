;;====================
;; Coding system and Language Settings
;;====================
(when (equal emacs-major-version 21) (require 'un-define))
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)

;;====================
;; General Settings
;;====================
(setq inhibit-startup-message t)  ;; No init message
(show-paren-mode 1)               ;; highlight (~~)
(transient-mark-mode 1)           ;; coloring selection
(global-font-lock-mode t)         ;; coloring
(set-input-mode nil nil t)        ;; Alt as Meta key
(tool-bar-mode nil)               ;; Tool bar
(menu-bar-mode nil)               ;; Menu bar
(scroll-bar-mode nil)             ;; No Scroll bar
(set-scroll-bar-mode 'right)      ;; Right Scroll bar
(setq ring-bell-function 'ignore) ;; No beep and flash
(setq-default indent-tabs-mode nil)
(setq initial-scratch-message "")

;; Do NOT show the message: "The local variables list in .emacs"
(add-to-list 'ignored-local-variables 'syntax)

;; Avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks t)

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

;; Font for emacs23
(cond (window-system
       (set-default-font "DejaVu Sans Mono-15")
       ;(set-default-font "Bitstream Vera Sans Mono-11")
       (set-fontset-font (frame-parameter nil 'font)
                         'japanese-jisx0208
                         '("Takaoゴシック" . "unicode-bmp")
                         ;'("Meiryo" . "unicode-bmp")
                         )))

;;====================
;; site elisp
;;====================

;; Add to load-path
(add-to-list 'load-path "~/.elisp")

;; auto-install
;; <http://www.emacswiki.org/AutoInstall>

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t) ;; 更新チェック
(auto-install-compatibility-setup)
(add-to-list 'load-path "~/.emacs.d/auto-install")

;; color-moccur
;; すべてのバッファを対象に occur を実施できる
;; <http://www.bookshelf.jp/soft/meadow_50.html#SEC746>
;; (auto-install-from-emacswiki "coloe-moccur.el")

(require 'color-moccur)

;; pos-tip
;; ツールチップ表示
;; <http://www.emacswiki.org/emacs-en/PosTip>
;; (auto-install-from-emacswiki "pos-tip.el")

(require 'pos-tip)

;; auto-complete
;; 自動補完をポップアップ表示
;; <http://www.emacswiki.org/emacs/AutoComplete>
;; (auto-install-batch "auto-complete development version")

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; auto-save-buffers
;; <http://0xcc.net/misc/auto-save/>

(require 'auto-save-buffers)
(run-with-idle-timer 1 t 'auto-save-buffers)

;; color-theme
;; # apt-get install emacs-goodies-el

(cond (window-system
       (require 'color-theme)
       (color-theme-initialize)
       ;(setq color-theme-is-global t)
       (color-theme-charcoal-black)
       ))

;; migemo
;; # apt-get install migemo

(load "migemo")

;; wdired
;; diredでファイルを一括リネーム
;; [r]キーで編集開始
;; Emacs22以降は標準で付属

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; clmemo
;; <http://dl.dropbox.com/u/288817/clmemo.el/clmemo.el.html>
;; <http://dl.dropbox.com/u/288817/clmemo.el/clmemo-1.0rc3.tar.gz>
;; <http://dl.dropbox.com/u/288817/clmemo.el/blgrep-0.1rc1.tar.gz>
;; make install する

(setq user-full-name "Keisuke Kambara")
(setq user-mail-address "kambara@sappari.org")
(autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
(setq clmemo-file-name "~/work/var/memo/memo.changelog")
(global-set-key "\C-xM" 'clmemo)

;; chalow
;; # apt-get install chalow

(setq exec-path
      (cons "/home/kambara/work/var/chalow" exec-path))
(setenv "PATH"
        (concat "/home/kambara/work/var/chalow:"
                (getenv "PATH")))

;; Easy Buffer Switch
;; [C-tab]でバッファを切り替える
;; <http://www.emacswiki.org/emacs/EasyBufferSwitch>
;; (auto-install-from-emacswiki "ebs.el")

(require 'ebs)
(ebs-initialize)
(global-set-key [(control tab)] 'ebs-switch-buffer)
(setq ebs-exclude-buffer-regexps
      (append '("^\\*auto-install")
              ebs-exclude-buffer-regexps))

;; iswitchb
;; [C-x b]でバッファを一覧
;; <http://www.bookshelf.jp/soft/meadow_28.html#SEC370>
;; 標準で付属

(iswitchb-mode 1)
(add-to-list 'iswitchb-buffer-ignore "*Messages*")
(add-to-list 'iswitchb-buffer-ignore "*Buffer")
(add-to-list 'iswitchb-buffer-ignore "*Completions")
(add-to-list 'iswitchb-buffer-ignore "*auto-install")

;; shell-command completion
;; shell-command [M-!] のコマンド入力で補完が効くようにする
;; <http://www.namazu.org/~tsuchiya/elisp/shell-command.el>

(require 'shell-command)
(shell-command-completion-mode)

;; scim-bridge
;; # apt-get install scim-bridge-el

; (cond (window-system
;        (require 'scim-bridge)
;        (add-hook 'after-init-hook 'scim-mode-on)))

;; uim.el
;; # apt-get install uim-el

;(require 'uim)
;(global-set-key "\C-o" 'uim-mode)
;(setq uim-candidate-display-inline t)

;; mozc.el
;; # apt-get install emacs-mozc

; (require 'mozc) or
(load-file "/usr/share/emacs/site-lisp/emacs-mozc/mozc.el")
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
;; 変換でIME ON
(define-key global-map [henkan]
  (lambda ()
    (interactive)
    (if current-input-method (inactivate-input-method))
    (toggle-input-method)))
;; 無変換でIME OFF
(define-key global-map [muhenkan]
  (lambda ()
    (interactive)
    (inactivate-input-method)))

;;====================
;; Programming Mode
;;====================

;; ruby-mode
;; # apt-get install ruby-elisp
;; Emacs23は標準で付属
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)
		("\\.ru$" . ruby-mode))
              auto-mode-alist))

;; RSense
;; <http://cx4a.org/software/rsense/index.ja.html>
(setq rsense-home "/home/kambara/work/var/apps/rsense-0.3")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
(add-hook 'ruby-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)))

;; haml-mode
;; <https://github.com/nex3/haml-mode/blob/master/haml-mode.el>
;; (auto-install-from-url "https://github.com/nex3/haml-mode/raw/master/haml-mode.el")

(require 'haml-mode)

;; javascript-mode (for nXhtml)
;; <http://www.emacswiki.org/emacs/JavaScriptMode>

(autoload 'javascript-mode "javascript" nil t)

;; js2-mode
;; # apt-get install js2-mode

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; PSGML mode (SGML, HTML, XML)

;; (setq auto-mode-alist
;;       (append '(("\\.html$" . xml-mode)
;; 		("\\.shtml$" . xml-mode)
;;                 ("\\.xhtml$" . xml-mode)
;;                 ("\\.rdf$" . xml-mode)
;;                 ("\\.xul$" . xml-mode)
;;                 ("\\.erb$" . xml-mode)
;; 		) auto-mode-alist))

;; nXhtml
;; <http://www.emacswiki.org/emacs/NxhtmlMode>
;; <http://ourcomments.org/Emacs/nXhtml/doc/nxhtml.html>

(load "~/.elisp/nxhtml/autostart.el")
(setq mumamo-background-colors nil)
(add-hook 'nxml-mode-hook
          (lambda ()
            (setq nxml-slash-auto-complete-flag t)
            (setq nxml-child-indent 2)
            (setq indent-tabs-mode nil)
            (setq tab-width 2)
            (setq nxml-bind-meta-tab-to-complete-flag t)
            (define-key nxml-mode-map "\r" 'newline-and-indent)))

;; PHP mode
;; # apt-get install php-elisp

(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-hook
          '(lambda ()
             (setq c-basic-offset 8)
             (setq c-tab-width 8)
             (setq c-indent-level 8)
             (setq tab-width 8)
             (setq indent-tabs-mode t)
             (setq-default tab-width 8)))

;;====================
;; Key map
;;====================

(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\C-x\C-h" 'help-command)
(define-key global-map "\M-g" 'goto-line)
(define-key global-map "\M-o" 'moccur-grep)

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
