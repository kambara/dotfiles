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
(show-paren-mode 1)               ;; highlight parenthesis
(transient-mark-mode 1)           ;; coloring selection
(global-font-lock-mode t)         ;; coloring
(set-input-mode nil nil t)        ;; Alt as Meta key
(tool-bar-mode nil)               ;; Tool bar
(menu-bar-mode nil)               ;; Menu bar
(scroll-bar-mode nil)             ;; No Scroll bar
;(set-scroll-bar-mode 'right)     ;; Right Scroll bar
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
;(setq browse-url-browser-function 'browse-url-generic)
;(setq browse-url-browser-function 'browse-url-firefox)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")
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
       (set-default-font "DejaVu Sans Mono-13")
       (set-fontset-font (frame-parameter nil 'font)
                         'japanese-jisx0208
                         '("TakaoGothic" . "unicode-bmp")
                         )))

;;====================
;; site elisp
;;====================

;;--------------------
;; Add to load-path
;;--------------------

(add-to-list 'load-path "~/.elisp")

;;--------------------
;; auto-install
;; <http://www.emacswiki.org/AutoInstall>
;; $ wget -N -P ~/.elisp http://www.emacswiki.org/emacs/download/auto-install.el
;;--------------------

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t) ;; 起動時に更新チェック（重ければコメントアウト）
(auto-install-compatibility-setup)
(add-to-list 'load-path "~/.emacs.d/auto-install")

;;--------------------
;; anything.el
;; (auto-install-batch "anything")
;; anything-migemoインストール時に文字コードエラーが出たら euc-jp-unix を指定
;;--------------------

(defvar org-directory "") ;; org-directoryのwarningを回避
(require 'anything-startup)

;;--------------------
;; color-moccur
;; すべてのバッファを対象に occur を実施できる
;; <http://www.bookshelf.jp/soft/meadow_50.html#SEC746>
;; (auto-install-from-emacswiki "color-moccur.el")
;;--------------------

(require 'color-moccur)

;;--------------------
;; pos-tip for auto-complete
;; ツールチップ表示
;; <http://www.emacswiki.org/emacs-en/PosTip>
;; (auto-install-from-emacswiki "pos-tip.el")
;;--------------------

(require 'pos-tip)

;;--------------------
;; auto-complete
;; 自動補完をポップアップ表示
;; <http://www.emacswiki.org/emacs/AutoComplete>
;; (auto-install-batch "auto-complete development version")
;;--------------------

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;--------------------
;; auto-save-buffers
;; <http://0xcc.net/misc/auto-save/>
;; (auto-install-from-url "http://0xcc.net/misc/auto-save/auto-save-buffers.el")
;;--------------------

(require 'auto-save-buffers)
(run-with-idle-timer 1 t 'auto-save-buffers)

;;--------------------
;; color-theme
;; $ sudo apt-get install emacs-goodies-el
;;--------------------

(cond (window-system
       (require 'color-theme)
       (color-theme-initialize)
       ;(setq color-theme-is-global t)
       (color-theme-charcoal-black)
       ))

;;--------------------
;; migemo
;; $ sudo apt-get install migemo
;;--------------------

;(load "migemo")

;;--------------------
;; wdired
;; diredでファイルを一括リネーム
;; [r]キーで編集開始
;; Emacs22以降は標準で付属
;;--------------------

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;--------------------
;; clmemo
;; <http://dl.dropbox.com/u/288817/clmemo.el/clmemo.el.html>
;; <http://dl.dropbox.com/u/288817/clmemo.el/clmemo-1.0rc3.tar.gz>
;; <http://dl.dropbox.com/u/288817/clmemo.el/blgrep-0.1rc1.tar.gz>
;; それぞれ $ make して $ sudo make install する
;;--------------------

(setq user-full-name "Keisuke Kambara")
(setq user-mail-address "kambara@sappari.org")
(autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
(setq clmemo-file-name "~/work/var/memo/memo.changelog")
(global-set-key "\C-xM" 'clmemo)

;;--------------------
;; chalow
;; $ sudo apt-get install chalow
;;--------------------

(setq exec-path
      (cons "/home/kambara/work/var/chalow" exec-path))
(setenv "PATH"
        (concat "/home/kambara/work/var/chalow:"
                (getenv "PATH")))

;;--------------------
;; windata.el for imenu-tree
;; <http://www.emacswiki.org/cgi-bin/wiki/windata.el>
;; (auto-install-from-emacswiki "windata.el")
;;--------------------

;; (require 'windata)

;;--------------------
;; tree-mode.el for imenu-tree
;; <http://www.emacswiki.org/cgi-bin/wiki/tree-mode.el>
;; (auto-install-from-emacswiki "tree-mode.el")
;;--------------------

;; (require 'tree-mode)

;;--------------------
;; imenu-tree.el
;; <http://www.emacswiki.org/cgi-bin/wiki/imenu-tree.el>
;; (auto-install-from-emacswiki "imenu-tree.el")
;;--------------------

;; (require 'imenu-tree)

;;--------------------
;; org-mode
;;--------------------

(require 'org)
(setq org-startup-truncated nil)
(setq org-startup-folded nil)
;; org-modeのCtrl-tabを無効にする
(add-hook 'org-mode-hook
          '(lambda ()
             (define-key org-mode-map [(control tab)] nil)))

;; org-modeでimenu-treeを使用
;; (add-hook 'org-mode-hook
;;   (lambda()
;;     (require 'imenu-tree)))
;; (global-set-key (kbd "M-h") 'imenu-tree)

;;--------------------
;; howm
;; <http://howm.sourceforge.jp/uu/>
;; configure & make & sudo make install する
;;--------------------

(add-to-list 'load-path "/usr/share/emacs/site-lisp/howm/")
(add-hook 'org-mode-hook 'howm-mode)
(setq howm-view-title-header "*") ;; howm のロードより前に書く
;(setq howm-view-title-regexp "^\t\\* .+$") ;; Changelogメモ見出し用
;(setq howm-view-title-regexp-grep "^\t\\* .+$") ;; Changelogメモ検索用
;(setq howm-view-title-regexp-grep "^[0-9-]+  .+$")

(add-to-list 'auto-mode-alist '("\\.howm$" . org-mode))
(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
(autoload 'howm-menu "howm-mode" "Hitori Otegaru Wiki Modoki" t)
(setq howm-template (concat howm-view-title-header " %title%cursor\n\n"))
(setq howm-directory "~/Dropbox/Private/howm")
(setq howm-process-coding-system '(utf-8-unix . utf-8-unix))
(add-hook 'howm-create-file-hook
          (lambda ()
            (set-buffer-file-coding-system 'utf-8)))
(setq howm-menu-lang 'ja)
(setq howm-view-use-grep t)
;; howmのバッファを空にしたら削除
(if (not (memq 'delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
          (cons 'delete-file-if-no-contents after-save-hook)))
(defun delete-file-if-no-contents ()
  (when (and
         (buffer-file-name (current-buffer))
         (= (point-min) (point-max)))
    (when (y-or-n-p "Delete file and kill buffer?")
      (delete-file
       (buffer-file-name (current-buffer)))
      (kill-buffer (current-buffer)))))

;;--------------------
;; speedbar
;;--------------------

(add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension
              '("howm" "js" "rb" "html" "css" "php"))))

;;--------------------
;; sr-speedbar
;; <http://www.emacswiki.org/emacs/SrSpeedbar>
;; (auto-install-from-emacswiki "sr-speedbar.el")
;;--------------------

(require 'sr-speedbar)
(setq sr-speedbar-right-side nil)
(global-set-key (kbd "<f6>") 'sr-speedbar-toggle)
(global-set-key (kbd "<f4>") 'sr-speedbar-select-window)

;;--------------------
;; Easy Buffer Switch
;; [C-tab]でバッファを切り替える
;; <http://www.emacswiki.org/emacs/EasyBufferSwitch>
;; (auto-install-from-emacswiki "ebs.el")
;;--------------------

(require 'ebs)
(ebs-initialize)
(global-set-key [(control tab)] 'ebs-switch-buffer)
(setq ebs-exclude-buffer-regexps
      (append '("^\\*auto-install")
              '("^\\*howm")
              ebs-exclude-buffer-regexps))

;;--------------------
;; iswitchb
;; [C-x b]でバッファを一覧
;; <http://www.bookshelf.jp/soft/meadow_28.html#SEC370>
;; 標準で付属
;;--------------------

(iswitchb-mode 1)
(add-to-list 'iswitchb-buffer-ignore "*Messages*")
(add-to-list 'iswitchb-buffer-ignore "*Buffer")
(add-to-list 'iswitchb-buffer-ignore "*Completions")
(add-to-list 'iswitchb-buffer-ignore "*auto-install")
(add-to-list 'iswitchb-buffer-ignore "*SPEEDBAR*")
(add-to-list 'iswitchb-buffer-ignore "*anything")

;;--------------------
;; shell-command completion
;; <http://www.namazu.org/~tsuchiya/elisp/shell-command.el>
;; M-x shell-command（またはM-!）のコマンド入力で補完が効くようにする
;; $ sudo apt-get install emacs-goodies-el
;;--------------------

(require 'shell-command)
(shell-command-completion-mode)

;;--------------------
;; mozc.el
;; $ sudo apt-get install emacs-mozc
;;--------------------

;; (require 'mozc) or (load-file "path/to/mozc.el")
(load-file "/usr/share/emacs/site-lisp/emacs-mozc/mozc.el")
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
;; 変換キーでIME ON
(define-key global-map [henkan]
  (lambda ()
    (interactive)
    (if current-input-method (inactivate-input-method))
    (toggle-input-method)))
;; 無変換キーでIME OFF
(define-key global-map [muhenkan]
  (lambda ()
    (interactive)
    (inactivate-input-method)))

;;====================
;; Programming Mode
;;====================

;;--------------------
;; XML mode (SGML, HTML, XML)
;;--------------------

;; (setq auto-mode-alist
;;       (append '(("\\.html$" . xml-mode)
;;                 ("\\.shtml$" . xml-mode)
;;                 ("\\.xhtml$" . xml-mode)
;;                 ("\\.rdf$" . xml-mode)
;;                 ("\\.xul$" . xml-mode)
;;                 ) auto-mode-alist))

;;--------------------
;; nXhtml
;; <http://www.emacswiki.org/emacs/NxhtmlMode>
;; <http://ourcomments.org/Emacs/nXhtml/doc/nxhtml.html>
;; js2-modeに対応していない
;;--------------------

;; (load "~/.elisp/nxhtml/autostart.el")
;; (setq mumamo-background-colors nil)
;; (add-hook 'nxml-mode-hook
;;           (lambda ()
;;             (setq nxml-slash-auto-complete-flag t)
;;             (setq nxml-child-indent 2)
;;             (setq indent-tabs-mode nil)
;;             (setq tab-width 2)
;;             (setq nxml-bind-meta-tab-to-complete-flag t)
;;             (define-key nxml-mode-map "\r" 'newline-and-indent)))

;;--------------------
;; css-mode
;;--------------------

(setq cssm-indent-function #'cssm-c-style-indenter)

;;--------------------
;; javascript-mode (for nXhtml)
;; <http://www.emacswiki.org/emacs/JavaScriptMode>
;; <http://www.brgeight.se/emacs_modes.php>
;; (auto-install-from-url "http://www.brgeight.se/downloads/emacs/javascript.el")
;;--------------------

;(autoload 'javascript-mode "javascript" nil t)

;;--------------------
;; js2-mode
;; $ sudo apt-get install js2-mode
;; or
;; Download from http://code.google.com/p/js2-mode/
;;--------------------

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;--------------------
;; coffee-mode
;; <https://github.com/defunkt/coffee-mode>
;; (auto-install-from-url "https://github.com/defunkt/coffee-mode/raw/master/coffee-mode.el")
;;--------------------

(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2)
  (setq coffee-cleanup-whitespace nil))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;;--------------------
;; haml-mode
;; <https://github.com/nex3/haml-mode/blob/master/haml-mode.el>
;; (auto-install-from-url "https://github.com/nex3/haml-mode/raw/master/haml-mode.el")
;;--------------------

(require 'haml-mode)

;;--------------------
;; jade-mode
;; (auto-install-from-url "https://github.com/brianc/jade-mode/raw/master/jade-mode.el")
;;--------------------

(require 'jade-mode)

;;--------------------
;; ruby-mode
;; $ sudo apt-get install ruby-elisp
;; Emacs23は標準で付属
;;--------------------

(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)
		("\\.ru$" . ruby-mode))
              auto-mode-alist))

;;--------------------
;; RSense
;; <http://cx4a.org/software/rsense/index.ja.html>
;;--------------------

;; (setq rsense-home "/home/kambara/work/var/apps/rsense-0.3")
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (require 'rsense)
;; (add-hook 'ruby-mode-hook
;;           (lambda ()
;;             (add-to-list 'ac-sources 'ac-source-rsense-method)
;;             (add-to-list 'ac-sources 'ac-source-rsense-constant)))

;;--------------------
;; PHP mode
;; $ sudo apt-get install php-elisp
;;--------------------

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

;;--------------------
;; Python mode
;;--------------------

(add-hook 'python-mode-hook
          '(lambda()
             (setq indent-tabs-mode nil)
             (setq python-indent 4)
             ))

;;--------------------
;; YaTeX mode
;;--------------------

;; (add-hook 'yatex-mode-hook
;;           '(lambda ()
;;              (auto-fill-mode -1)))

;;--------------------
;; LaTeX mode
;;--------------------

(setq auto-mode-alist
      (append '(("\\.tex$" . latex-mode)
                ) auto-mode-alist))

;;====================
;; Key map
;;====================

(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\C-x\C-h" 'help-command)
(define-key global-map "\M-g" 'goto-line)
(define-key global-map "\M-o" 'moccur-grep)
(global-set-key [f8] 'other-frame)
(global-set-key [f9] 'other-window)

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
