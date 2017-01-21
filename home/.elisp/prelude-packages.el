;; -*- coding: utf-8 -*-
;; https://github.com/masa21kik/dotfiles/blob/master/emacs.d/prelude-packages.el
;; http://batsov.com/articles/2012/02/19/package-management-in-emacs-the-good-the-bad-and-the-ugly/

;; Usage:
;;
;;   $ emacs --batch -l ~/.elisp/prelude-packages.el
;;
;; Package Search:
;;
;;   M-x list-packages

(defvar prelude-packages
  '(arduino-mode
    auto-complete
    auto-install
    auto-save-buffers-enhanced
    coffee-mode
    color-theme
    deft
    dirtree
    fuzzy
    haml-mode
    helm
    helm-ag
    helm-descbinds
    js2-mode
    less-css-mode
    markdown-mode
    php-mode
    popup
    pos-tip
    rhtml-mode
    sass-mode
    slim-mode
    sr-speedbar
    tree-mode
    color-theme-tango 
    web-mode
    yaml-mode
    simplenote
    )
  "A list of packages to ensure are installed at launch.")

(setq el-get-sources
      '(
        (:name moccur-edit
               :type http
               :description "moccur-edit"
               :url "http://www.emacswiki.org/emacs/download/moccur-edit.el")
        (:name ebs
               :type http
               :description "ebs"
               :url "http://www.emacswiki.org/emacs/download/ebs.el")
        ))

(defvar my/el-get-packages
  '(moccur-edit
    ebs
    )
  "A list of packages to install from el-get at launch.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (prelude-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p prelude-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'prelude-packages)
;;; prelude-packages.el ends here



;;; el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(el-get 'sync my/el-get-packages)

