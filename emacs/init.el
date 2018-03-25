;; -*- lexical-binding: t -*- 

;; package requirement
;; silversearcher-ag
;; opam

;; コンパイル時にパッケージをインストールする.
(eval-when-compile
  (package-initialize)
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")))
  (unless package-archive-contents (package-refresh-contents))
  (when (not (package-installed-p 'use-package))
    (package-install 'use-package))
  (package-install-selected-packages))

(setq gc-cons-threshold 100000000)

(package-initialize)

(require 'use-package)

(setq initial-major-mode 'lisp-interaction-mode)
(setq inhibit-startup-screen t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(line-number-mode t)
(column-number-mode t)
(setq frame-title-format
      '("emacs@" system-name ":"
        (:eval (or (buffer-file-name)
                   default-directory))))
;;# ミニバッファを複数起動
(setq enable-recursive-minibuffers t)
;;# 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)
;;# クリップボード
(setq select-enable-primary t)
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
;;# fold always
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)
(setq ring-bell-function 'ignore) ; No Beeps
;; like "mkdir -p"
(add-hook 'find-file-not-found-hooks
          '(lambda () (make-directory (file-name-directory buffer-file-name) t)))
;; 自動分割を抑制
(setq split-height-threshold nil)
(setq split-width-threshold nil)
(custom-set-variables
 ;; collecting backups
 '(make-backup-files t)
 '(auto-save-default t)
 '(backup-directory-alist '(("." . "~/.bak/emacs")))
 '(auto-save-file-name-transforms '(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" ,(expand-file-name "~/.bak/emacs/autosave") t)))
 '(vc-follow-symlinks t)
 '(auto-revert-check-vc-info t))

;;# font
(set-face-attribute 'default nil :family "Source Han Code JP N" :height 122)
(set-frame-font "Source Han Code JP N" nil t)

(use-package diminish :ensure t)

(use-package recentf
  :init
  (setq recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
  (setq recentf-auto-save-timer (run-with-idle-timer 60 t 'recentf-save-list))
  (recentf-mode 1)
  :config
  ;; recentf の メッセージをエコーエリア(ミニバッファ)に表示しない
  (defun recentf-save-list-inhibit-message:around (orig-func &rest args)
    (setq inhibit-message t)
    (apply orig-func args)
    (setq inhibit-message nil)
    'around)
  (advice-add 'recentf-cleanup   :around 'recentf-save-list-inhibit-message:around)
  (advice-add 'recentf-save-list :around 'recentf-save-list-inhibit-message:around)
  :custom
  (recentf-max-saved-items 2000)
  (recentf-exclude '("recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/elpa"))
  (recentf-save-file (expand-file-name "~/.bak/emacs/recentf")))

(use-package recentf-ext :ensure t)

(use-package savehist
  :custom
  (savehist-file (expand-file-name "~/.bak/emacs/history"))
  :config
  (savehist-mode 1))

(use-package undohist :ensure t
  :custom
  (undohist-ignored-files '("/tmp" "/EDITMSG" "/elpa"))
  (undohist-directory (expand-file-name "~/.bak/emacs/undohist"))
  :config
  (undohist-initialize))

(use-package tramp
  :config
  (setq tramp-auto-save-directory (expand-file-name "~/.bak/emacs/tramp")))

(use-package undo-tree :diminish ""
  :bind (:map undo-tree-visualizer-mode-map
              ("C-t" . undo-tree-visualize-undo)
              ("C-h" . undo-tree-visualize-redo)))

;;# key binding
(bind-keys* :map global-map
            ("C-x h" . nil) ; delete help
            ("<C-tab>" . other-window)
            ("<C-iso-lefttab>" . (lambda () (interactive) (other-window -1)))
            :map isearch-mode-map
            ("C-b" . isearch-delete-char)
            ("C-m" . ret)
            :map minibuffer-local-map
            ("C-b" . backward-delete-char-untabify)
            ("C-h" . next-line-or-history-element)
            ("C-t" . previous-line-or-history-element)
            :filter window-system ;; for tiling window manager
            :map global-map
            ("C-x 3" . make-frame-command)
            ("C-x 2" . make-frame-command))

;;# evil
(use-package evil :ensure t
  :init
  (evil-mode 1)
  :custom
  (evil-ex-substitute-case 'smart)
  (evil-search-module 'evil-search)
  (evil-shift-width 2)
  :bind (:map evil-ex-search-keymap
              ("C-b" . backward-delete-char-untabify)
              :map evil-visual-state-map
              ("h" . evil-next-visual-line)
              ("t" . evil-previous-visual-line)
              ("n" . evil-forward-char)
              ("d" . evil-backward-char)
              ("k" . evil-delete)
              ("K" . evil-delete-line)
              ("M" . evil-ex-search-previous)
              ("N" . evil-ex-search-previous)
              ("m" . evil-ex-search-next)
              ("C-w" . comment-or-uncomment-region)
              ("C-c C-l" . xref-find-definitions)
              :map evil-motion-state-map
              ("h" . evil-next-visual-line)
              ("t" . evil-previous-visual-line)
              ("n" . evil-forward-char)
              ("d" . evil-backward-char)
              ("k" . evil-delete)
              ("K" . evil-delete-line)
              ("M" . evil-ex-search-previous)
              ("N" . evil-ex-search-previous)
              ("m" . evil-ex-search-next)
              ("C-w" . comment-or-uncomment-region)
              ("C-c C-l" . xref-find-definitions)
              :map evil-normal-state-map
              ("h" . evil-next-visual-line)
              ("t" . evil-previous-visual-line)
              ("n" . evil-forward-char)
              ("d" . evil-backward-char)
              ("k" . evil-delete)
              ("K" . evil-delete-line)
              ("M" . evil-ex-search-previous)
              ("N" . evil-ex-search-previous)
              ("m" . evil-ex-search-next)
              ("C-w" . comment-or-uncomment-region)
              ("C-c C-l" . xref-find-definitions)
              :map evil-insert-state-map
              ("C-d" . backward-char)
              ("C-n" . forward-char)
              ("C-t" . previous-line)
              ("C-b" . backward-delete-char-untabify)
              ("C-h" . next-line)))

(use-package key-chord :ensure t
  :after (evil)
  :custom (key-chord-two-keys-delay 0.05)
  :config
  (key-chord-mode t)
  (key-chord-define evil-insert-state-map "hh" 'evil-normal-state))

(use-package evil-numbers :ensure t
  :after (evil)
  :config
  (bind-key "+" 'evil-numbers/inc-at-pt evil-normal-state-map)
  (bind-key "-" 'evil-numbers/dec-at-pt evil-normal-state-map))

;;# 行の表示
;; TODO : 26.0.5 < emacs version
(use-package linum-relative :ensure t :diminish ""
  :config
  (linum-relative-global-mode 1)
  (global-linum-mode 1))

(use-package git-gutter :ensure t :diminish ""
  :after (linum-relative)
  :config
  (global-git-gutter-mode t)
  (git-gutter:linum-setup))

;;# helm
(use-package helm :ensure t)
(use-package helm-config 
  :bind (("M-x" . helm-M-x)
         :map helm-buffer-map
         ("C-t" . helm-previous-line)
         ("C-h" . helm-next-line)
         :map helm-moccur-map
         ("C-h" . helm-next-line)
         ("C-t" . helm-previous-line)
         :map helm-map
         ("C-t" . helm-previous-line)
         ("C-h" . helm-next-line))
  :custom
  (helm-ff-auto-update-initial-value nil)
  (helm-input-idle-delay 0.2) 
  (helm-candidate-number-limit 50)
  :config
  ;; (require 'helm-lib)
  ;; (require 'linum-relative)
  ;; (helm-linum-relative-mode 1)
  (helm-mode 1)
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil)))

(use-package evil-leader :ensure t
  :after (evil helm)
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "q" 'kill-this-buffer
    "w" 'save-buffer
    "<SPC>" 'helm-mini))

(use-package helm-ag :ensure t
  :after (helm)
  :bind (("C-M-f" . helm-ag))
  :init
  (setq helm-ag-base-command "ag --nocolor --nogrou"))

(use-package yasnippet :ensure t :diminish yas-minor-mode
  :config
  (yas-global-mode 1)
  (yas-load-directory "~/.emacs.d/snippets"))

(use-package auto-complete
  :commands (auto-complete-mode)
  :config
  (bind-keys :map ac-complete-mode-map
             ("C-h" . ac-next)
             ("C-t" . ac-previous))
  (global-auto-complete-mode -1))

(use-package company :ensure t :diminish ""
  :bind
  (:map company-active-map
        ("C-h" . company-select-next)
        ("C-t" . company-select-previous))
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 4)
  (company-selection-wrap-around t)
  :init
  (global-company-mode))

(use-package ddskk
  :bind (("C-x C-j" . skk-mode))
  :init
  (setq skk-kakutei-when-unique-candidate t)
  (setq skk-egg-like-newline t)
  (setq skk-kuten-touten-alist
        '((jp . ("." . "," ))
          (en . ("." . ","))))
  (setq-default skk-kutouten-type 'en)
  (setq skk-user-directory "~/skk"))

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
    "w" (lookup-key evil-normal-state-map "w")
    (kbd "SPC")   (lookup-key dired-mode-map "m")
    (kbd "S-SPC") (lookup-key dired-mode-map "d")))

;; http://d.hatena.ne.jp/murase_syuka/20140815/1408061850
(use-package rainbow-delimiters :ensure t
  :config
  (use-package color
    :config
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
    (use-package cl-lib)
    (cl-loop
     for index from 1 to rainbow-delimiters-max-face-count
     do
     (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
       (cl-callf color-saturate-name (face-foreground face) 30)))))

(use-package magit :ensure t
  :commands (magit-status)
  :after (evil)
  :bind (("C-c C-g" . magit-status)
         :map magit-mode-map
         ("t" . magit-section-backward)
         ("h" . magit-section-forward)
         ("T" . magit-section-backward-sibling)
         ("H" . magit-section-forward-sibling))
  :config
  (add-hook 'with-editor-mode-hook 'evil-insert-state)
  (evil-make-overriding-map dired-mode-map 'normal))

;;# Theme
(use-package madhat2r-theme :ensure t
  :config
  (load-theme 'madhat2r t))
(add-to-list 'default-frame-alist '(alpha . 95))

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

(use-package markdown-mode
  :commands (markdown-mode)
  :mode (("\\.md" . markdown-mode)
         ("\\.md.erb\\'" . markdown-mode)
         ("\\.howm\\'" . markdown-mode))
  :init
  (setq markdown-command "redcarpet")
  :config
  (defun outline-imenu-create-index ()
    (let (index)
      (goto-char (point-min))
      (while (re-search-forward "^\*\s*\\(.+\\)" (point-max) t)
        (push (cons (match-string 1) (match-beginning 1)) index))
      (nreverse index)))
  (add-hook 'markdown-mode '(lambda ()
                              (setq imenu-create-index-function 'outline-imenu-create-index)
                              (auto-fill-mode))))

(use-package cc-mode
  :commands (c++-mode)
  :mode (("\\.c\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.cc\\'" . c++-mode)
         ("\\.h\\'" . c++-mode))
  :hook (c-mode-common-hook . (lambda ()
                                (setq c-default-style "bsd")
                                (setq indent-tabs-mode nil)
                                (setq c-basic-offset 4)))
  :config
  (c-set-offset 'cpp-macro 0 nil))

(use-package yatex
  :commands (yatex-mode)
  :mode ("\\.tex\\'" . yatex-mode)
  :hook ((skk-mode-hook . (lambda ()
                            (if (eq major-mode 'yatex-mode)
                                (progn
                                  (define-key skk-j-mode-map "\\" 'self-insert-command)
                                  (define-key skk-j-mode-map "$" 'YaTeX-insert-dollar)))))
         (yatex-mode-hook . (lambda ()
                              (reftex-mode 1)
                              (auto-fill-mode -2)
                              (define-key reftex-mode-map (concat YaTeX-prefix ">") 'YaTeX-comment-region)
                              (define-key reftex-mode-map (concat YaTeX-prefix "<") 'YaTeX-uncomment-region))))
  :init
  (setq YaTeX-inhibit-prefix-letter t)
  (setq YaTeX-kanji-code 4))

;;# OCaml
(use-package tuareg
  :commands (tuareg-mode)
  :mode (("\\.ml\\'" . tuareg-mode)
         ("\\.mli\\'" . tuareg-mode))
  :config
  ;; work around
  (defun tuareg-abbrev-hook () nil))

;; opam init
;; opam install merlin utop core
;; -- opam and utop setup --------------------------------
;; Setup environment variables using opam
(when (executable-find "opam")
  (dolist
      (var (car (read-from-string
                 (shell-command-to-string "opam config env --sexp"))))
    (setenv (car var) (cadr var)))
  ;; Update the emacs path
  (setq exec-path (split-string (getenv "PATH") path-separator))
  ;; Update the emacs load path
  (add-to-list 'load-path (concat (getenv "OCAML_TOPLEVEL_PATH")
                                  "/../../share/emacs/site-lisp")))

(use-package merlin
  :after (tuareg company)
  :commands (merlin-mode)
  :init 
  (add-hook 'tuareg-mode-hook 'merlin-mode t)
  :config
  (evil-make-overriding-map merlin-mode-map 'normal)
  (add-to-list 'company-backends 'merlin-company-backend)
  (setq merlin-command 'opam))

(use-package utop
  :after (tuareg)
  :commands (utop-minor-mode)
  :init 
  (add-hook 'tuareg-mode-hook 'utop-minor-mode t))

(use-package fsharp-mode)

(use-package haskell-mode :ensure t)

(use-package ediff
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally))

;; killing custom
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
