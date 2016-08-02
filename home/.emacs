;;====================
;; General Settings
;;====================

(setq inhibit-startup-message t)  ;; No init message
(show-paren-mode 1)               ;; highlight parenthesis
(transient-mark-mode 1)           ;; coloring selection
(global-font-lock-mode t)         ;; coloring
(set-input-mode nil nil t)        ;; Alt as Meta key
(cond (window-system
       (tool-bar-mode 0)          ;; Tool bar
       (scroll-bar-mode 0)        ;; No Scroll bar
       ))
(setq ring-bell-function 'ignore) ;; No beep and flash
(setq-default indent-tabs-mode nil)
(setq initial-scratch-message "")

;; Do NOT show the message: "The local variables list in .emacs"
(add-to-list 'ignored-local-variables 'syntax)

;; Avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks t)

;; Use command key as meta key
(cond ((string-match "apple-darwin" system-configuration)
       (setq ns-command-modifier (quote meta))
       (setq ns-alternate-modifier (quote super))
       ))

;; Sync clibboard between Emacs and Gnome
(cond (window-system
       (setq x-select-enable-clipboard t)))

;; Open URL by Middle click
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program
      (if (file-exists-p "/usr/bin/open")
          "/usr/bin/open"))
(global-set-key [mouse-2] 'browse-url-at-mouse)

;; Scroll one line at a time (less "jumpy" than defaults)
;; http://www.emacswiki.org/emacs/SmoothScrolling

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-conservatively 1)

;; Half Scrolling
;; http://www.emacswiki.org/emacs/HalfScrolling

(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (window-half-height)))

(defun scroll-down-half ()         
  (interactive)                    
  (scroll-down (window-half-height)))

(global-set-key (kbd "C-v") 'scroll-up-half)
(global-set-key (kbd "M-v") 'scroll-down-half)

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
       (set-default-font "Menlo-14")
       (set-fontset-font (frame-parameter nil 'font)
                         'japanese-jisx0208
                         '("Hiragino Kaku Gothic Pro W3" . "unicode-bmp")
                         )))

;; Avoid recursive loading
(require 'tramp)

;; Hide "local varibales list" alert
(custom-set-variables
 '(safe-local-variable-values (quote ((clmemo-mode . t))))
 '(simplenote-notes-mode (quote markdown-mode)))

;; Increment Number 
;; http://www.emacswiki.org/emacs/IncrementNumber
;; Assign +1 to C-c a, -1 to C-c x

(defun my-change-number-at-point (change)
  (let ((number (number-at-point))
        (point (point)))
    (when number
      (progn
        (forward-word)
        (search-backward (number-to-string number))
        (replace-match (number-to-string (funcall change number)))
        (goto-char point)))))
(defun my-increment-number-at-point ()
  "Increment number at point like vim's C-a"
  (interactive)
  (my-change-number-at-point '1+))
(defun my-decrement-number-at-point ()
  "Decrement number at point like vim's C-x"
  (interactive)
  (my-change-number-at-point '1-))
(global-set-key (kbd "C-c a") 'my-increment-number-at-point)
(global-set-key (kbd "C-c x") 'my-decrement-number-at-point)

;; Comment Code
;; http://www.emacswiki.org/emacs/CommentingCode
;; M-;

(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key "\M-;" 'comment-dwim-line)

;;====================
;; site elisp
;;====================

;;--------------------
;; Add to load-path
;;--------------------

(add-to-list 'load-path "~/.elisp")

;;--------------------
;; elpa
;; http://elpa.gnu.org/
;; http://tromey.com/elpa/install.html
;; Installed in Emacs 24
;;--------------------

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;--------------------
;; el-get
;;--------------------

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync)

;;--------------------
;; auto-install
;; <http://www.emacswiki.org/AutoInstall>
;; $ wget -N -P ~/.elisp http://www.emacswiki.org/emacs/download/auto-install.el
;;--------------------

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
;(auto-install-update-emacswiki-package-name t) ;; 起動時に更新チェック．重ければコメントアウト．
(auto-install-compatibility-setup)
(add-to-list 'load-path "~/.emacs.d/auto-install")

;;--------------------
;; color-moccur
;; すべてのバッファを対象に occur を実施できる
;; <http://www.bookshelf.jp/soft/meadow_50.html#SEC746>
;; (auto-install-from-emacswiki "color-moccur.el")
;;--------------------

;(require 'color-moccur)

;;--------------------
;; moccur-edit
;; (auto-install-from-emacswiki "moccur-edit.el")
;;--------------------

(require 'moccur-edit)

;;--------------------
;; pos-tip (for auto-complete)
;; ツールチップ表示
;; <http://www.emacswiki.org/emacs-en/PosTip>
;; (auto-install-from-emacswiki "pos-tip.el")
;;--------------------

(require 'pos-tip)

;;--------------------
;; auto-complete
;; 自動補完をポップアップ表示
;; http://cx4a.org/software/auto-complete/
;; https://github.com/m2ym/auto-complete
;; http://www.emacswiki.org/emacs/AutoComplete
;;
;; Download:
;; http://cx4a.org/software/auto-complete/#Downloads
;;
;; Install:
;; $ make install DIR=$HOME/.emacs.d/
;;--------------------

;(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
(ac-config-default)

;;--------------------
;; auto-save-buffers
;; http://0xcc.net/misc/auto-save/
;; $ wget -N -P ~/.elisp http://0xcc.net/misc/auto-save/auto-save-buffers.el
;;--------------------

;(require 'auto-save-buffers)
;(run-with-idle-timer 1 t 'auto-save-buffers)

;;--------------------
;; auto-save-buffers-enhanced (ELPA)
;; https://github.com/kentaro/auto-save-buffers-enhanced
;;--------------------

(require 'auto-save-buffers-enhanced)
(auto-save-buffers-enhanced t)
(setq auto-save-buffers-enhanced-interval 1)

;;--------------------
;; color-theme (ELPA)
;; $ sudo apt-get install emacs-goodies-el
;;
;; http://www.nongnu.org/color-theme/#sec5
;;
;; tangotango color theme (ELPA)
;; http://blog.nozav.org/post/2010/07/12/Updated-tangotango-emacs-color-theme
;; (auto-install-from-url "https://raw.github.com/juba/color-theme-tangotango/master/color-theme-tangotango.el")
;;--------------------

;(add-to-list 'load-path "~/.elisp/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize) ; OR (setq color-theme-is-global t)

;(color-theme-charcoal-black)
;(color-theme-deep-blue)
;(color-theme-tangotango)
(require 'color-theme-tango)

;;--------------------
;; Helm
;; https://github.com/emacs-helm/helm
;; http://d.hatena.ne.jp/a_bicky/20140104/1388822688
;;--------------------

(helm-mode 1)
(global-set-key (kbd "C-c h") 'helm-mini)

(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c i")   'helm-imenu)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)

(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

(defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-exist activate)
  "Execute command only if CANDIDATE exists"
  (when (file-exists-p candidate)
    ad-do-it))

;;--------------------
;; dirtree
;; https://github.com/zk/emacs-dirtree
;;--------------------

(require 'dirtree)

;;--------------------
;; Magit
;; $ sudo apt-get install magit
;;--------------------

;(require 'magit)

;;--------------------
;; migemo
;; anything-migemoがあれば不要
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
;; speedbar
;;--------------------

(add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension
              '("howm" "js" "coffee" "rb" "html" "css" "php" "bib"))))

;;--------------------
;; sr-speedbar
;; <http://www.emacswiki.org/emacs/SrSpeedbar>
;; (auto-install-from-emacswiki "sr-speedbar.el")
;;--------------------

;; (require 'sr-speedbar)
;; (setq sr-speedbar-right-side nil)
;; (global-set-key (kbd "<f6>") 'sr-speedbar-toggle)
;; (global-set-key (kbd "<f4>") 'sr-speedbar-select-window)

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
              '("^\\*SPEEDBAR\\*")
              '("^\\*anything")
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
(add-to-list 'iswitchb-buffer-ignore "*howm")
(add-to-list 'iswitchb-buffer-ignore "*SPEEDBAR*")
(add-to-list 'iswitchb-buffer-ignore "*anything")

;;--------------------
;; shell-command completion
;; http://www.namazu.org/~tsuchiya/elisp/shell-command.el
;; M-x shell-command (M-!) のコマンド入力で補完が効くようにする
;; $ sudo apt-get install emacs-goodies-el
;;--------------------

;(require 'shell-command)
;(shell-command-completion-mode)

;;--------------------
;; clmemo
;; http://dl.dropbox.com/u/288817/clmemo.el/clmemo.el.html
;; http://dl.dropbox.com/u/288817/clmemo.el/clmemo-1.0rc3.tar.gz
;; http://dl.dropbox.com/u/288817/clmemo.el/blgrep-0.1rc1.tar.gz
;; それぞれ $ make & sudo make install
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
      (cons "/Users/kambara/work/var/chalow" exec-path))
(setenv "PATH"
        (concat "/Users/kambara/work/var/chalow:"
                (getenv "PATH")))

;;--------------------
;; markdown-mode
;; $ sudo apt-get install emacs-goodies-el
;; OR
;; (auto-install-from-url "http://jblevins.org/projects/markdown-mode/markdown-mode.el")
;;--------------------

(setq auto-mode-alist
      (append '(("\\.md$" . markdown-mode)
                ("\\.markdown$" . markdown-mode)
                ) auto-mode-alist))

(setq wiki-home "~/Dropbox/Private/wiki/data/home.md")
(global-set-key (kbd "C-c w h") (lambda ()
                                  (interactive)
                                  (find-file wiki-home)))

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

;;--------------------
;; howm
;; http://howm.sourceforge.jp/uu/
;;
;; Download:
;; http://howm.sourceforge.jp/index-j.html
;; Install:
;; $ ./configure --with-howmdir=$HOME/.emacs.d
;; $ ./configure --with-howmdir=$HOME/.emacs.d/lisp
;; $ make & sudo make install
;;--------------------

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/howm/")
;(add-hook 'org-mode-hook 'howm-mode) ;; org-modeで開く

;; 見出し
(setq howm-view-title-header "#") ;; howm のロードより前に書く
;(setq howm-view-title-regexp "^\t\\* .+$") ;; Changelogメモ見出し用
;(setq howm-view-title-regexp-grep "^\t\\* .+$") ;; Changelogメモ検索用
;(setq howm-view-title-regexp-grep "^[0-9-]+  .+$")

(add-to-list 'auto-mode-alist '("\\.howm$" . org-mode))
(add-to-list 'auto-mode-alist '("Dropbox/Private/Howm/.+\\.txt$" . org-mode))
(add-to-list 'auto-mode-alist '("Dropbox/Private/Howm/.+\\.md$" . markdown-mode))

(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
(autoload 'howm-menu "howm-mode" "Hitori Otegaru Wiki Modoki" t)
(setq howm-template (concat howm-view-title-header " %title%cursor\n\n"))
(setq howm-directory "~/Dropbox/Private/Howm")
(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.md")

;; UTF-8
(setq howm-process-coding-system '(utf-8-unix . utf-8-unix))
(add-hook 'howm-create-file-hook
          (lambda ()
            (set-buffer-file-coding-system 'utf-8)))
(setq howm-menu-lang 'ja)
(setq howm-view-use-grep t)
(setq howm-view-grep-command "/usr/local/bin/ggrep")

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
;; simplenote2
;; https://github.com/alpha22jp/simplenote2.el
;;--------------------

(require 'simplenote2)
(setq simplenote2-email "kambara@sappari.org")
(setq simplenote2-password "snhchzrqsi")
(simplenote2-setup)

(add-hook 'simplenote2-create-note-hook
      (lambda ()
        (simplenote2-set-markdown)))

(add-hook 'simplenote2-note-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-t") 'simplenote2-add-tag)
            (local-set-key (kbd "C-c C-c") 'simplenote2-push-buffer)
            (local-set-key (kbd "C-c C-d") 'simplenote2-pull-buffer)))

(global-set-key [f7] 'simplenote2-browse)

;;--------------------
;; Deft
;; http://jblevins.org/projects/deft/
;; (auto-install-from-url "http://jblevins.org/projects/deft/deft.el")
;;--------------------

(require 'deft)
(setq deft-default-extension "md")
(setq deft-extensions '("md" "txt"))
(setq deft-directory "~/Dropbox/Private/deft")
(setq deft-text-mode 'markdown-mode)
(setq deft-use-filename-as-title nil)
(setq deft-use-filter-string-for-filename t)
(setq deft-file-naming-rules '((noslash . "-")
                               (nospace . "-")
                               (case-fn . downcase)))
(global-set-key [f8] 'deft)

;;--------------------
;; XML mode (SGML, HTML, XML)
;;--------------------

(setq auto-mode-alist
      (append '(("\\.shtml$" . xml-mode)
                ("\\.xhtml$" . xml-mode)
                ("\\.rdf$" . xml-mode)
                ("\\.xul$" . xml-mode)
                ) auto-mode-alist))

;;--------------------
;; web-mode
;;--------------------

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;--------------------
;; css-mode
;;--------------------

(setq cssm-indent-level 2)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-mirror-mode t)

;;--------------------
;; less-css-mode
;;--------------------

(require 'less-css-mode)

;;--------------------
;; javascript-mode
;;--------------------

(setq js-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))

;;--------------------
;; js2-mode
;; $ sudo apt-get install js2-mode
;; or
;; Download from http://code.google.com/p/js2-mode/
;; or
;; (auto-install-from-url "https://js2-mode.googlecode.com/files/js2-mode.el")
;;--------------------

(autoload 'js2-mode "js2" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;--------------------
;; coffee-mode
;; <https://github.com/defunkt/coffee-mode>
;; (auto-install-from-url "https://raw.github.com/defunkt/coffee-mode/master/coffee-mode.el")
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
;; (auto-install-from-url "https://raw.github.com/nex3/haml-mode/master/haml-mode.el")
;;--------------------

(require 'haml-mode)
(setq auto-mode-alist
      (append '(("\\.hamlc$"  . haml-mode))
              auto-mode-alist))

;;--------------------
;; slim-mode
;; (auto-install-from-url "https://raw.github.com/slim-template/emacs-slim/master/slim-mode.el")
;;--------------------

(add-to-list 'load-path "~/emacs.d/vendor")
(require 'slim-mode)

;;--------------------
;; sass-mode
;; https://github.com/nex3/sass-mode/blob/master/sass-mode.el
;; (auto-install-from-url "https://raw.github.com/nex3/sass-mode/master/sass-mode.el")
;;--------------------

(require 'sass-mode)

;;--------------------
;; ruby-mode
;; $ sudo apt-get install ruby-elisp
;; Emacs23は標準で付属
;;--------------------

(setq ruby-deep-indent-paren-style nil)
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

(setq auto-mode-alist
      (append '(("\\.rb$"   . ruby-mode)
		("\\.ru$"   . ruby-mode)
                ("Gemfile"  . ruby-mode)
                ("Rakefile" . ruby-mode))
              auto-mode-alist))


;;--------------------
;; rcodetools and anything-rcodetools
;; $ sudo gem install rcodetools fastri
;; $ cp /var/lib/gems/1.8/gems/rcodetools-0.8.5.0/rcodetools.el ~/.elisp/
;; $ cp /var/lib/gems/1.8/gems/rcodetools-0.8.5.0/anything-rcodetools.el ~/.elisp/
;;--------------------

;; (require 'anything)
;; (require 'anything-rcodetools)
;; (setq rct-get-all-methods-command "PAGER=cat fri -l")
;; (define-key anything-map "\C-z" 'anything-execute-persistent-action)

;;--------------------
;; RSense
;; $ sudo apt-get install openjdk-6-jdk
;; http://cx4a.org/software/rsense/index.ja.html
;;
;; refm
;; http://www.ruby-lang.org/ja/man/archive/snapshot/
;;--------------------

;; (setq rsense-rurema-home "/Users/kambara/work/var/apps/ruby-refm-1.9.1")
;; (setq rsense-home "/Users/kambara/work/var/apps/rsense-0.3")
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

; (load-library "php-mode")
; (require 'php-mode)
; (add-hook 'php-mode-hook
;           '(lambda ()
;              (setq c-basic-offset 8)
;              (setq c-tab-width 8)
;              (setq c-indent-level 8)
;              (setq tab-width 8)
;              (setq indent-tabs-mode t)
;              (setq-default tab-width 8)))

;;--------------------
;; Python mode
;;--------------------

(add-hook 'python-mode-hook
          '(lambda()
             (setq indent-tabs-mode nil)
             (setq python-indent 4)
             ))

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
(global-set-key [f9] 'other-window)

;;====================
;; Coding system and Language Settings
;;====================

(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
