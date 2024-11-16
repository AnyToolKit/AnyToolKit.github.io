;;; init-edit.el --- Editing settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(setq make-backup-files nil)                                  ; 不自动备份
(setq auto-save-default nil)                                  ; 不使用Emacs自带的自动保存

;; 解除不常用的快捷键定义
(global-set-key (kbd "s-q") nil)
(global-set-key (kbd "M-z") nil)
(global-set-key (kbd "M-m") nil)
(global-set-key (kbd "C-x C-z") nil)
(global-set-key [mouse-2] nil)

;; Directly modify when selecting text
(use-package delsel
  :ensure t
  :hook (after-init . delete-selection-mode))

(use-package autorevert
  :ensure t
  :hook (after-init . global-auto-revert-mode)
  ;; :bind ("s-u" . revert-buffer)
  :custom
  (auto-revert-interval 10)
  (auto-revert-avoid-polling t)
  (auto-revert-verbose nil)
  (auto-revert-remote-files t)
  (auto-revert-check-vc-info t)
  (global-auto-revert-non-file-buffers t))

(use-package avy
  :ensure t
  :bind
  (("M-j" . avy-goto-char-timer)))

(use-package amx
  :ensure t
  :init (amx-mode))

(use-package window-numbering
  :ensure t
  ;; :defer 3
  :init (window-numbering-mode t)
  )

(use-package mwim
  :ensure t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(use-package dashboard
  :ensure t
  :config
  ;; (setq dashboard-banner-logo-title "Welcome to Emacs!") ;; 个性签名，随读者喜好设置
  ;; (setq dashboard-projects-backend 'projectile) ;; 读者可以暂时注释掉这一行，等安装了 projectile 后再使用
  (setq dashboard-startup-banner 'official) ;; 也可以自定义图片
  (setq dashboard-items '((recents  . 10)   ;; 显示多少个最近文件
						  (bookmarks . 10)  ;; 显示多少个最近书签
						  (projects . 10))) ;; 显示多少个最近项目
  (dashboard-setup-startup-hook))

(use-package projectile
  :ensure t)

(use-package marginalia
  :ensure t
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map
			  ("M-A" . marginalia-cycle)))

(use-package which-key
  :ensure t
  :init (which-key-mode))

(use-package hydra
  :ensure t)

(use-package use-package-hydra
  :ensure t
  :after hydra)

(use-package multiple-cursors
  :ensure t
  :after hydra
  :bind
  (("C-x M-h m" . hydra-multiple-cursors/body)
   ("C-M-<mouse-1>" . mc/toggle-cursor-on-click))
  :hydra (hydra-multiple-cursors
		  (:hint nil)
		  "
Up^^             Down^^           Miscellaneous           % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
------------------------------------------------------------------
 [_p_]   Prev     [_n_]   Next     [_l_] Edit lines  [_0_] Insert numbers
 [_P_]   Skip     [_N_]   Skip     [_a_] Mark all    [_A_] Insert letters
 [_M-p_] Unmark   [_M-n_] Unmark   [_s_] Search      [_q_] Quit
 [_|_] Align with input CHAR       [Click] Cursor at point"
		  ("l" mc/edit-lines :exit t)
		  ("a" mc/mark-all-like-this :exit t)
		  ("n" mc/mark-next-like-this)
		  ("N" mc/skip-to-next-like-this)
		  ("M-n" mc/unmark-next-like-this)
		  ("p" mc/mark-previous-like-this)
		  ("P" mc/skip-to-previous-like-this)
		  ("M-p" mc/unmark-previous-like-this)
		  ("|" mc/vertical-align)
		  ("s" mc/mark-all-in-region-regexp :exit t)
		  ("0" mc/insert-numbers :exit t)
		  ("A" mc/insert-letters :exit t)
		  ("<mouse-1>" mc/add-cursor-on-click)
		  ;; Help with click recognition in this hydra
		  ("<down-mouse-1>" ignore)
		  ("<drag-mouse-1>" ignore)
		  ("q" nil)))

(use-package highlight-symbol
  :ensure t
  :init (highlight-symbol-mode)
  :bind (
		 ("<f10>" . highlight-symbol)	; 按下 F10 键就可高亮当前符号
		 ("<f9>" . highlight-symbol-remove-all) ; 取消 Emacs 中所有当前高亮的符号
		 )
  )

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package evil
  :ensure t
  ;; :init (evil-mode)
  :bind
  (("C-x C-z" . evil-mode)))

(defun add-code-block ()
  "在当前位置添加一个代码块，并以时间作为块名进行命名"
  (interactive)
  (let* ((time (format-time-string "%Y-%m-%d"))  ; 获取当前日期
		 (week (format-time-string "%A"))  ; 获取当前星期名称
		 (clean-time (replace-regexp-in-string "[-:]" "" time))  ; 去除时间中的破折号和冒号
		 (block-name-with-week (concat clean-time " " week))  ; 构建带星期的代码块名
		 (block-name (concat clean-time))  ; 构建不带星期的代码块名
		 (code-block (format
					  "*** %s\n
#+BEGIN_SRC emacs-lisp :tangle %s.txt
  %s: name\n  1、
#+END_SRC\n\n"
					  block-name-with-week block-name block-name)))
	(insert code-block)))  ; 在当前位置插入代码块

;; 设置快捷键 C-c b 绑定到 add-code-block 函数
(global-set-key (kbd "C-c SPC r") 'add-code-block)

(defun g-org-insert-note-header () ;;; 定义一个名为g-org-insert-note-header ()的函数
  (interactive) ;;; 函数的一个特殊声明，表示函数可以被用户调用
  (insert
   "#+TITLE: \n#+AUTHOR: yenao\n#+OPTIONS: toc:t num:10 H:10 ^:nil \\n:t broken-links:nil pri:t\n#+STARTUP: overview\n#+HTML_HEAD: \<link rel=\"stylesheet\" type=\"text\/css\" href=\"http:\/\/gongzhitaao.org\/orgcss\/org.css\"\/\>\n"
   )) ;;; insert函数用于在当前 光标位置插入指定的文本内容，当你调用这个函数时，它会在当前光标位置插入文本#+OPTIONS: ^:nil、#+TITLE:  和#+AUTHOR: yenao
;; #+LANGUAGE: zh-CN ;; zh-CN或者en

(defun g-org-emacs-lisp-code-block ()
  (interactive)
  (insert "#+begin_src emacs-lisp\n\n#+end_src")
  )

(defun g-org-c-code-block ()
  (interactive)
  (insert "#+begin_src c\n\n#+end_src")
  )

(defun g-org-bash-code-block ()
  (interactive)
  (insert "#+begin_src bash\n\n#+end_src")
  )

(defun g-org-html-code-block ()
 (interactive)
 (insert "#+begin_src html\n\n#+end_src")
)

(defun g-org-javascript-code-block ()
 (interactive)
 (insert "#+begin_src javascript\n\n#+end_src")
)

(defun insert-space-between-english-and-chinese ()
  "在英文字符与中文字符之间插入空格"
  (interactive)
  (save-excursion
	(while (re-search-forward "\\([[:ascii:]]\\)\\(\\cc\\)" nil t)
	  (replace-match "\\1 \\2"))))

(defun delete-space-between-english-and-chinese ()
  "删除英文字符与中文字符之间的空格"
  (interactive)
  (save-excursion
	(while (re-search-forward "\\([[:ascii:]]\\) \\(\\cc\\)" nil t)
	  (replace-match "\\1\\2"))))

(use-package markdown-mode
  :ensure t
  :defer t
  :config
  ;;markdown设置
  (autoload 'markdown-mode "markdown-mode"
	"Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  )

;; (message "init-base configuration: %.2fs"
;;          (float-time (time-subtract (current-time) my/init-base-start-time)))

(provide 'init-edit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-edit.el ends here
