;; -*- lexical-binding: t -*- 

;; package requirement
;; llvm
;; llvm-dev
;; libclang-dev
;; silversearcher-ag
;; mercurial
;; git
;; ddskk
;; cmake
;; python-virtualenv
;; rtags

(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "~/.emacs.d/use-package")
  (require 'use-package))

(use-package cl-lib)

;;# 行の表示
(use-package linum-relative
  :ensure t
  :config
  (setq linum-format "%5d")
  (linum-relative-on)
  (global-linum-mode 1))

(savehist-mode 1)
(setq initial-major-mode 'lisp-interaction-mode)
(setq inhibit-startup-screen t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode t)
(global-font-lock-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(line-number-mode t)
(column-number-mode t)
(setq vc-follow-symlinks t)
(setq auto-revert-check-vc-info t)
(setq gc-cons-threshold 40960000)
(setq frame-title-format
      '("emacs@" system-name ":"
        (:eval (or (buffer-file-name)
                   default-directory))
        ))
;;# ミニバッファを複数起動
(setq enable-recursive-minibuffers t)
;;# 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)
;;# クリップボード
(setq x-select-enable-primary t)
;;# display EOF
(setq-default indicate-empty-lines t)
;;# Edit
(show-paren-mode 1)
(which-function-mode 1)
(global-auto-revert-mode 1) 
;;# Scroll
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;for exec in shell
;;# Region
(setq transient-mark-mode t) ;highlight region
(setq highlight-nonselected-windows t)
;;# fold always
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)
(setq ring-bell-function 'ignore) ; No Beeps
;;# Don't ask
(add-hook 'find-file-not-found-hooks
		  '(lambda () (make-directory (file-name-directory buffer-file-name) t)))
;; 自動分割を抑制
(setq split-height-threshold nil)
(setq split-width-threshold nil)

;;# バックアップファイルを~/.bakに集める
(setq make-backup-files t)
(setq auto-save-default t)
(setq backup-directory-alist
	  (cons (cons ".*" (expand-file-name "~/.bak"))
        backup-directory-alist))
(setq auto-save-file-name-transforms
  `((".*", (expand-file-name "~/.bak") t)))
;;# tramp
(setq tramp-auto-save-directory "~/.bak/emacs")

;;# font
(set-face-attribute 'default nil
					:height 140)
(if (display-graphic-p)
	(set-fontset-font (frame-parameter nil 'font)
					  'japanese-jisx0208
					  '("ricty" . "unicode-bmp")))

(add-to-list 'default-frame-alist '(alpha . 95))

;;# undohist
(use-package undohist
  :ensure t
  :init
  (setq undohist-ignored-files
		'("/tmp/"))
  :config
  (undohist-initialize))

;;# key binding
(bind-key "C-x h" nil) ; delete help
(bind-keys :map isearch-mode-map
		   ("C-b" . isearch-delete-char)
		   ("C-m" . ret))
(bind-keys :map minibuffer-local-map
		   ("C-b" . backward-delete-char-untabify)
		   ("C-h" . next-line-or-history-element)
		   ("C-t" . previous-line-or-history-element))

;;# evil
(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq-default evil-shift-width 2)
  (evil-mode 1)
  :config
  (bind-keys :map evil-ex-search-keymap ("C-b" . backward-delete-char-untabify))
  (bind-keys :map evil-visual-state-map
			 ("h" . evil-next-visual-line)
			 ("t" . evil-previous-visual-line)
			 ("n" . evil-forward-char)
			 ("d" . evil-backward-char)
			 ("k" . evil-delete)
			 ("K" . evil-delete-line)
			 ("M" . evil-search-previous)
			 ("N" . evil-search-previous)
			 ("C-w" . comment-or-uncomment-region)
			 ("m" . evil-search-next))
  (bind-keys :map evil-motion-state-map
			 ("h" . evil-next-visual-line)
			 ("t" . evil-previous-visual-line)
			 ("n" . evil-forward-char)
			 ("d" . evil-backward-char)
			 ("k" . evil-delete)
			 ("K" . evil-delete-line)
			 ("M" . evil-search-previous)
			 ("N" . evil-search-previous)
			 ("C-w" . comment-or-uncomment-region)
			 ("m" . evil-search-next))
  (bind-keys :map evil-normal-state-map
			 ("h" . evil-next-visual-line)
			 ("t" . evil-previous-visual-line)
			 ("n" . evil-forward-char)
			 ("d" . evil-backward-char)
			 ("k" . evil-delete)
			 ("K" . evil-delete-line)
			 ("M" . evil-search-previous)
			 ("N" . evil-search-previous)
			 ("C-w" . comment-or-uncomment-region)
			 ("m" . evil-search-next))
  (bind-keys :map evil-insert-state-map
			 ("C-d" . backward-char)
			 ("C-n" . forward-char)
			 ("C-t" . previous-line)
			 ("C-b" . backward-delete-char-untabify)
			 ("C-h" . next-line))
  (use-package key-chord
    :ensure t
	:custom (key-chord-two-keys-delay 0.01)
	:config
	(key-chord-mode t)
	(key-chord-define evil-insert-state-map "hh" 'evil-normal-state))
  (use-package evil-numbers
    :ensure t
	:config
	(bind-key "+" 'evil-numbers/inc-at-pt evil-normal-state-map)
	(bind-key "-" 'evil-numbers/dec-at-pt evil-normal-state-map))
  (use-package evil-leader
    :ensure t
	:config
	(global-evil-leader-mode)
	(evil-leader/set-leader "<SPC>")
	(evil-leader/set-key
	  "q" 'kill-this-buffer
	  "w" 'save-buffer
	  "b" 'helm-mini)))

;;# helm
(use-package helm :ensure t)

(use-package helm-config
  :bind (("C-x C-b" . helm-mini)
		 ("M-x" . helm-M-x)
		 :map helm-buffer-map
		 ("C-t" . helm-previous-line)
		 ("C-h" . helm-next-line)
		 :map helm-moccur-map
		 ("C-h" . helm-next-line)
		 ("C-t" . helm-previous-line)
		 :map helm-command-map
		 ("C-t" . helm-previous-line)
		 ("C-h" . helm-next-line)
		 :map helm-map
		 ("C-t" . helm-previous-line)
		 ("C-h" . helm-next-line))
  :custom (helm-ff-auto-update-initial-value nil)
  :init
  (setq helm-idle-delay 0.3) 
  (setq helm-input-idle-delay 0.2) 
  (setq helm-candidate-number-limit 50)
  (setq helm-display-function (lambda (buf)
								(split-window-vertically)
								(switch-to-buffer buf)))
  :config
  (helm-descbinds-mode t)
  (helm-mode 1)
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
  (use-package helm-ag
    :ensure t
	:bind (("M-g ," . helm-ag-pop-stack)
		   ("C-M-s" . helm-ag-this-file)
		   ("C-M-f" . helm-ag))
	:init
	(setq helm-ag-base-command "ag --nocolor --nogrou")))

;;# yasnippet
(use-package yasnippet
  :ensure t
  :config
  ;; (setq yas/trigger-key (kbd "C-c m"))
  (yas/initialize)
  (yas/load-directory "~/.emacs.d/el-get/yasnippet/snippets")
  (yas/load-directory "~/.emacs.d/snippets"))

;;# auto-complete
(use-package auto-complete-config
  :commands (auto-complete-mode)
  :config
  (bind-keys :map ac-complete-mode-map
			 ("C-h" . ac-next)
			 ("C-t" . ac-previous))
  (global-auto-complete-mode -1))

;;# company
(use-package company
  :ensure t
  :init
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 4)
  (setq company-selection-wrap-around t)
  :config
  (bind-keys :map company-active-map
			 ("C-h" . company-select-next)
			 ("C-t" . company-select-previous))
  (global-company-mode))

;;# skk
(use-package ddskk)
(use-package skk
  :bind (("C-x C-j" . skk-mode))
  :init
  ;; (setq skk-kakutei-key "C-m")
  (setq skk-kakutei-when-unique-candidate t)
  (setq skk-egg-like-newline t)
  (setq skk-kuten-touten-alist
		'(
		  (jp . ("." . "," ))
		  (en . ("." . ","))
		  ))
  (setq-default skk-kutouten-type 'en)
  (setq skk-user-directory "~/skk"))

;;# git-gutter
(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode t))

;;# dired
(use-package dired
  :commands (dired-mode)
  :after (evil)
  :config
  (evil-make-overriding-map dired-mode-map 'normal)
  (defun keu-dired-down-directory ()
	"[Dired command] Go down to the directory."
	(interactive)
	(condition-case err
		(let ((path (dired-get-file-for-visit)))
		  (if (f-directory? path)
			  (dired-find-file)
			(message "This is not directory!")))
	  (error (message "%s" (cadr err)))))
  (evil-define-key 'normal dired-mode-map
	";" (lookup-key evil-motion-state-map ";")
	"t" 'dired-previous-line
	"h" 'dired-next-line
	"d" 'dired-up-directory
	"n" 'keu-dired-down-directory
	"m" (lookup-key evil-normal-state-map "m")
	"w" (lookup-key evil-normal-state-map "w")
	(kbd "SPC")   (lookup-key dired-mode-map "m")
	(kbd "S-SPC") (lookup-key dired-mode-map "d")))

;;# http://d.hatena.ne.jp/murase_syuka/20140815/1408061850
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (use-package color
	:config
	(cl-loop
	 for index from 1 to rainbow-delimiters-max-face-count
	 do
	 (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
	   (cl-callf color-saturate-name (face-foreground face) 30)))))

;;# Theme
(use-package slime-theme
  :ensure t)

;;# flycheck
(use-package flycheck
  :commands (flycheck-mode)
  :custom
  (flycheck-display-errors-function (lambda (errors)
									  (let ((messages
											 (mapcar
											  (function flycheck-error-message)
											  errors)))
										(popup-tip
										 (mapconcat
										  (quote identity)
										  messages " ")))))
  (flycheck-display-errors-delay 0.5)
  :bind (:map flycheck-mode-map
			  ("C-M-h" . flycheck-next-error)
			  ("C-M-t" . flycheck-previous-error))
  :hook ((c-mode-common-hook . flycheck-mode)
		 (c-mode-common-hook . (lambda () (progn (flycheck-select-checker 'c/c++-clang)
												 (setq flycheck-clang-include-path
													   (list "/usr/local/include/eigen3"))
												 (setq flycheck-clang-args
													   (list "-std=c++11"))))))
  :config
	(when (locate-library "flycheck-irony")
	  (flycheck-irony-setup)))

;;# start server
(use-package server
  :config
  (unless (server-running-p)
	(server-start)))

;;# irony
(use-package irony
  :commands (company-irony irony-mode-hook irony-cdb-autosetup-compile-options irony-mode)
  :custom (irony-additional-clang-options '("-std=c++11"))
  :after (company)
  :hook ((irony-mode-hook . irony-cdb-autosetup-compile-options)
		 (c-mode-common-hook . irony-mode))
  :config
  (add-to-list 'company-backends 'company-irony))

;;# gtags
(use-package helm-gtags
  :commands (helm-gtags-mode)
  :after (evil)
  :bind (:map evil-normal-state-local-map
			  ("<return>" . helm-gtags-find-tag)
			  ("RET" . helm-gtags-find-tag))
  :hook ((c-mode-common-hook . helm-gtags-mode)
		 (helm-gtags-mode-hook . (lambda ()
								   (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
								   (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
								   (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
								   (local-set-key (kbd "C-t") 'helm-gtags-pop-stack)))))

;;# markdown
(use-package markdown-mode
  :mode (("\\.md" . markdown-mode)
		 ("\\.md.erb\\'" . markdown-mode)
		 ("\\.howm\\'" . markdown-mode))
  :init
  (setq markdown-command "redcarpet")
  :hook ((markdown-mode . (lambda ()
							(setq imenu-create-index-function 'outline-imenu-create-index)
							(auto-fill-mode))))
  :config
  (defun outline-imenu-create-index ()
	(let (index)
	  (goto-char (point-min))
	  (while (re-search-forward "^\*\s*\\(.+\\)" (point-max) t)
		(push (cons (match-string 1) (match-beginning 1)) index))
	  (nreverse index))))

;;# c
(use-package cc-mode
  :commands (c-mode-common-hook)
  :mode (("\\.c\\'" . c++-mode)
		 ("\\.cpp\\'" . c++-mode)
		 ("\\.cc\\'" . c++-mode)
		 ("\\.h\\'" . c++-mode))
  :hook (c-mode-common-hook . (lambda ()
								(setq c-default-style "bsd")
								(setq indent-tabs-mode nil)
								(setq c-basic-offset 4)))
  :config
  (c-set-offset (quote cpp-macro) 0 nil))

;;# python
(use-package python
  :commands (python-mode-hook)
  :after (company)
  :config
  (use-package jedi-core
	:init
	(setq jedi:server-args
		  '("--sys-path" "/usr/local/lib/python3.4/dist-packages"
			"--sys-path" "/usr/local/lib/python2.7/dist-packages"))
	(setq jedi:complete-on-dot t)
	(setq jedi:use-shortcuts t)
	:config
	(add-hook 'python-mode-hook 'jedi:setup)
	(add-to-list 'company-backends 'company-jedi)))

;;# haskell
(use-package haskell-mode
  :mode "\\.hs\\'"
  :custom (haskell-mode-hook 'turn-on-haskell-indentation)
  :init
  (setq haskell-program-name "/bin/ghci"))

;;# others
(use-package yaml-mode)
(use-package rainbow-mode)

;;# eldoc
(use-package eldoc-extension
  :hook ((emacs-lisp-mode-hook lisp-interaction-mode-hook ielm-mode-hook) .turn-on-eldoc-mode)
  :after (company)
  :init
  (setq eldoc-idle-delay 0)
  (setq eldoc-echo-area-use-multiline-p t))

;;# YaTeX
(use-package yatex-mode
  :mode "\\.tex$"
  :commands (yatex-mode)
  :hook ((skk-mode-hook . (lambda ()
							(if (eq major-mode 'yatex-mode)
								(progn
								  (define-key skk-j-mode-map "\\" 'self-insert-command)
								  (define-key skk-j-mode-map "$" 'YaTeX-insert-dollar)
								  ))))
		 (yatex-mode-hook . (lambda ()
							  (auto-fill-mode -2)))
		 (yatex-mode-hook . (lambda ()
							  (reftex-mode 1)
							  (define-key reftex-mode-map (concat YaTeX-prefix ">") 'YaTeX-comment-region)
							  (define-key reftex-mode-map (concat YaTeX-prefix "<") 'YaTeX-uncomment-region))))
  :init
  (setq YaTeX-inhibit-prefix-letter t)
  (setq YaTeX-kanji-code 4))

;;# tuareg
(use-package tuareg
  :hook (tuareg-mode-hook . (lambda()
							  (local-unset-key (kbd "<ESC>"))))
  :init
  ;; -- opam and utop setup --------------------------------
  ;; Setup environment variables using opam
  (dolist
	  (var (car (read-from-string
				 (shell-command-to-string "opam config env --sexp"))))
	(setenv (car var) (cadr var)))
  ;; Update the emacs path
  (setq exec-path (split-string (getenv "PATH") path-separator))
  ;; Update the emacs load path
  (push (concat (getenv "OCAML_TOPLEVEL_PATH")
				"/../../share/emacs/site-lisp") load-path)
  (use-package utop
	:commands (utop utop-minor-mode)
	:hook (tuareg-mode-hook . utop-minor-mode)))

;;# CMake
(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
		 ("\\.cmake\\'" . cmake-mode)))

;;# Arduino
(use-package arduino-mode
  :config
  (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(ddskk evil-leader evil-numbers key-chord slime-theme rainbow-delimiters dired git-gutter skk company yasnippet helm-config helm evil undohist linum-relative tuareg shackle rainbow-mode edit-server async arduino-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
