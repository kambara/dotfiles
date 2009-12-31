;;
;; Kahua client interface for Emacs
;;
;;  Copyright (c) 2003-2007 Scheme Arts, L.L.C., All rights reserved.
;;  Copyright (c) 2003-2007 Time Intermedia Corporation, All rights reserved.
;;
;; $Id: kahua.el.in,v 1.6.2.5 2007/05/29 07:59:20 bizenn Exp $
;;

(require 'comint)
(require 'cmuscheme)

;; Custom Variables:
(defgroup kahua nil
  "*Support for editing and running remote kahua server application."
  :group 'scheme
  :prefix "kahua-"
  :link '(url-link "http://www.kahua.org/"))

(defcustom kahua-ssh-mode t
  "*If non nil, run kahua-shell via ssh."
  :type 'boolean
  :group 'kahua)

(defcustom kahua-admin-command "/usr/local/kahua/bin/kahua-admin"
  "*Kahua-admin command file(full path or base name)."
  :type 'string
  :group 'kahua)

(defcustom kahua-shell-command "/usr/local/kahua/bin/kahua-shell"
  "*Kahua-shell command file(full path or base name)."
  :type 'string
  :group 'kahua)

(defcustom kahua-ssh-opts '("-t")
  "*Options for ssh which run kahua-shell."
  :type '(repeat string)
  :group 'kahua)

(defcustom kahua-default-server ""
  "*Default kahua server."
  :type 'string
  :group 'kahua)

(defcustom kahua-default-user (or (getenv "USER")
				  (getenv "LOGNAME")
				  (user-login-name))
  "*Default username for running kahua server."
  :type 'string
  :group 'kahua)

(defcustom kahua-site-bundle nil
  "Site Bundle for kahua-shell and kahua-admin."
  :type 'string
  :group 'kahua)

(defcustom kahua-admin-coding-system 'utf-8
  "*Kahua-admin coding system."
  :type 'symbol
  :group 'kahua)
(defun get-kahua-admin-coding-system (p) nil kahua-admin-coding-system)

(defcustom kahua-shell-coding-system 'utf-8
  "*Kahua-shell coding system."
  :type 'symbol
  :group 'kahua)
(defun get-kahua-shell-coding-system (p) nil kahua-shell-coding-system)

(setq process-coding-system-alist
      (append '(("kahua-admin" . get-kahua-admin-coding-system)
		("kahua-shell" . get-kahua-shell-coding-system))
	      process-coding-system-alist))

(defvar kahua-worker-prompt-regex "^select wno> "
  "Regexp to recognise select woker prompt")

(define-derived-mode kahua-mode scheme-mode "Kahua mode"
  "Major mode for editing kahua code.
Editing commands are similar to those of 'scheme-mode'."
  (make-local-variable 'scheme-buffer)
  (setq scheme-buffer "*kahua-shell*"))

(put 'entry-lambda 'scheme-indent-function 1)
(font-lock-add-keywords
 'kahua-mode
 '(("\\<define-entry\\>" . font-lock-keyword-face)
   ("\\<entry-lambda\\>" . font-lock-keyword-face)
   ("\\<reset/pc\\>" . font-lock-keyword-face)
   ("\\<call/pc\\>" . font-lock-keyword-face)
   ("\\<let/pc\\>" . font-lock-keyword-face)))

(defun kahua-select-worker-prompt (string)
  "Prompt in the minibuffer for selecting worker"
  (if (string-match kahua-worker-prompt-regex string)
      (comint-simple-send "*kahua-shell*" (read-string "select worker: " nil))))

;; for compatibility with Emacs 21
(unless (functionp 'read-directory-name)
  (defalias 'read-directory-name 'read-file-name))

(defun kahua-read-server ()
  (if kahua-ssh-mode
      (read-string "hostname: " kahua-default-server)
    ""))
(defun kahua-read-user (host)
  (if (and kahua-ssh-mode (not (string= host "")))
      (read-string "username: " kahua-default-user)
    ""))
(defun kahua-read-site ()
  (let ((insert-default-directory nil))
    (let ((site (read-directory-name "site bundle: " nil nil nil kahua-site-bundle)))
      (if (string= site "")
	  nil
	site))))

(defun kahua-command-buffer-setup (bufname comname command host user site)
  (if (not (comint-check-proc bufname))
      (let* ((use-ssh          (and kahua-ssh-mode (not (string= host ""))))
             (program          (if use-ssh "ssh" command))
             (kahua-shell-args (if (or (not site) (string= site ""))
                                   '() (list "-S" (expand-file-name site))))
             (args             (if use-ssh
                                   `(,@kahua-ssh-opts
                                     ,(if (string= user "")
                                          host (concat user "@" host))
                                     ,command
                                     ,@kahua-shell-args)
                                 kahua-shell-args)))
        (set-buffer (apply 'make-comint comname program nil args))
        (inferior-scheme-mode)))
  (pop-to-buffer bufname)
  (make-local-variable 'scheme-program-name)
  (setq scheme-program-name comname)
  (setq kahua-default-server host)
  (setq kahua-default-user user)
  (setq kahua-site-bundle site)
  (make-local-variable 'scheme-buffer)
  (setq scheme-buffer bufname))

(defun run-kahua-shell (host user site)
  (interactive
   (let* ((host (kahua-read-server))
          (user (kahua-read-user host))
	  (site (kahua-read-site)))
     (list host user site)))
  (unless (get-buffer "*kahua-shell*")
    (let ((add-password-hook?
           (not (memq 'comint-watch-for-password-prompt
                      comint-output-filter-functions))))
      (set-buffer (get-buffer-create "*kahua-shell*"))
      (make-local-hook 'comint-output-filter-functions)
      (add-hook 'comint-output-filter-functions
                'kahua-select-worker-prompt nil t)
      (when add-password-hook?
        (add-hook 'comint-output-filter-functions
                  'comint-watch-for-password-prompt nil t))))
  (kahua-command-buffer-setup "*kahua-shell*" "kahua-shell"
			      kahua-shell-command host user site))

(defun run-kahua (host user site)
  (interactive
   (let* ((host (kahua-read-server))
	  (user (kahua-read-user host))
	  (site (kahua-read-site)))
     (list host user site)))
  (unless (get-buffer "*kahua-admin*")
    (set-buffer (get-buffer-create "*kahua-admin*")))
  (kahua-command-buffer-setup "*kahua-admin*" "kahua-admin"
			      kahua-admin-command host user site))

(provide 'kahua)

;; Local variables:
;; mode: emacs-lisp
;; end:



