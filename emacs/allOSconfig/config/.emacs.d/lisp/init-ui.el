;;; init-ui.el --- UI settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package spacemacs-theme
  :ensure t
  :config
  (load-theme 'spacemacs-dark t)  ; Dark theme
  ;; 或者
  ;; (load-theme 'spacemacs-light t) ; Light theme
  )

;; 禁用一些GUI特性
(setq use-dialog-box nil)               ; 鼠标操作不使用对话框
(setq inhibit-default-init t)           ; 不加载 `default' 库
(setq inhibit-startup-screen t)         ; 不加载启动画面
(setq inhibit-startup-message t)        ; 不加载启动消息
(setq inhibit-startup-buffer-menu t)    ; 不显示缓冲区列表

;; ;; 草稿缓冲区默认文字设置
;; (setq initial-scratch-message (concat ";; Happy hacking, "
;;                                       (capitalize user-login-name) " - Emacs ♥ you!\n\n"))

;; 设置缓冲区的文字方向为从左到右
(setq bidi-paragraph-direction 'left-to-right)
;; 禁止使用双向括号算法
;; (setq bidi-inhibit-bpa t)

;; 设置自动折行宽度为80个字符，默认值为70
(setq-default fill-column 80)

;; 设置大文件阈值为100MB，默认10MB
(setq large-file-warning-threshold 100000000)

;; ;; 以16进制显示字节数
;; (setq display-raw-bytes-as-hex t)
;; 有输入时禁止 `fontification' 相关的函数钩子，能让滚动更顺滑
(setq redisplay-skip-fontification-on-input t)

;; 禁止响铃
(setq ring-bell-function 'ignore)

;; 禁止闪烁光标
(blink-cursor-mode -1)

;; 在光标处而非鼠标所在位置粘贴
(setq mouse-yank-at-point t)

;; 拷贝粘贴设置
(setq select-enable-primary nil)        ; 选择文字时不拷贝
(setq select-enable-clipboard t)        ; 拷贝时使用剪贴板

;; 鼠标滚动设置
(setq scroll-step 2)
(setq scroll-margin 0)
(setq hscroll-step 2)
(setq hscroll-margin 2)
(setq scroll-conservatively 101)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq scroll-preserve-screen-position 'always)

;; 对于高的行禁止自动垂直滚动
(setq auto-window-vscroll nil)

;; 设置新分屏打开的位置的阈值
(setq split-width-threshold (assoc-default 'width default-frame-alist))
(setq split-height-threshold nil)

;; TAB键设置，在Emacs里不使用TAB键，所有的TAB默认为4个空格
;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 4)
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq c-default-style "linux")
(setq c-basic-offset 4)

;; yes或no提示设置，通过下面这个函数设置当缓冲区名字匹配到预设的字符串时自动回答yes
(setq original-y-or-n-p 'y-or-n-p)
(defalias 'original-y-or-n-p (symbol-function 'y-or-n-p))
(defun default-yes-sometimes (prompt)
  "automatically say y when buffer name match following string"
  (if (or
	   (string-match "has a running process" prompt)
	   (string-match "does not exist; create" prompt)
	   (string-match "modified; kill anyway" prompt)
	   (string-match "Delete buffer using" prompt)
	   (string-match "Kill buffer of" prompt)
	   (string-match "still connected.  Kill it?" prompt)
	   (string-match "Shutdown the client's kernel" prompt)
	   (string-match "kill them and exit anyway" prompt)
	   (string-match "Revert buffer from file" prompt)
	   (string-match "Kill Dired buffer of" prompt)
	   (string-match "delete buffer using" prompt)
	   (string-match "Kill all pass entry" prompt)
	   (string-match "for all cursors" prompt)
	   (string-match "Do you want edit the entry" prompt))
	  t
	(original-y-or-n-p prompt)))
(defalias 'yes-or-no-p 'default-yes-sometimes)
(defalias 'y-or-n-p 'default-yes-sometimes)

;; 设置剪贴板历史长度300，默认为60
(setq kill-ring-max 200)

;; 在剪贴板里不存储重复内容
(setq kill-do-not-save-duplicates t)

;; 设置位置记录长度为6，默认为16
;; 可以使用 `counsel-mark-ring' or `consult-mark' (C-x j) 来访问光标位置记录
;; 使用 C-x C-SPC 执行 `pop-global-mark' 直接跳转到上一个全局位置处
;; 使用 C-u C-SPC 跳转到本地位置处
(setq mark-ring-max 6)
(setq global-mark-ring-max 6)

;; 设置 emacs-lisp 的限制
(setq max-lisp-eval-depth 10000)        ; 默认值为 800
(setq max-specpdl-size 10000)           ; 默认值为 1600

;; 启用 `list-timers', `list-threads' 这两个命令
(put 'list-timers 'disabled nil)
(put 'list-threads 'disabled nil)

;; 在命令行里支持鼠标
(xterm-mouse-mode 1)

;; 退出Emacs时进行确认
(setq confirm-kill-emacs 'y-or-n-p)

;; 在模式栏上显示当前光标的列号
(column-number-mode t)

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil))) ;自动换行(折行)

;; 显示行号
(if (>= emacs-major-version 29)
	(global-display-line-numbers-mode)
  (global-linum-mode t))

(defun reload-emacs-config ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c C-SPC") 'reload-emacs-config)

(defun close-current-window ()
  (interactive)
  (delete-window)
  )
(global-set-key (kbd "C-c z") 'close-current-window)

;; 配置编码
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)

(use-package keycast
  :ensure t
  :hook (after-init . keycast-mode)
  ;; :custom-face
  ;; (keycast-key ((t (:background "#0030b4" :weight bold))))
  ;; (keycast-command ((t (:foreground "#0030b4" :weight bold))))
  :config
  ;; set for doom-modeline support
  ;; With the latest change 72d9add, mode-line-keycast needs to be modified to keycast-mode-line.
  (define-minor-mode keycast-mode
	"Show current command and its key binding in the mode line (fix for use with doom-mode-line)."
	:global t
	(if keycast-mode
		(progn
		  (add-hook 'pre-command-hook 'keycast--update t)
		  (add-to-list 'global-mode-string '("" keycast-mode-line "  ")))
	  (remove-hook 'pre-command-hook 'keycast--update)
	  (setq global-mode-string (delete '("" keycast-mode-line "  ") global-mode-string))
	  ))

  (dolist (input '(self-insert-command
				   org-self-insert-command))
	(add-to-list 'keycast-substitute-alist `(,input "." "Typing…")))

  (dolist (event '(mouse-event-p
				   mouse-movement-p
				   mwheel-scroll))
	(add-to-list 'keycast-substitute-alist `(,event nil)))

  (setq keycast-log-format "%-20K%C\n")
  (setq keycast-log-frame-alist
		'((minibuffer . nil)))
  (setq keycast-log-newest-first t)
  )

(use-package shackle
  :ensure t
  :hook (after-init . shackle-mode)
  :init
  (setq shackle-lighter "")
  (setq shackle-select-reused-windows nil) ; default nil
  (setq shackle-default-alignment 'below)  ; default below
  (setq shackle-default-size 0.4)          ; default 0.5
  (setq shackle-rules
		;; CONDITION(:regexp)            :select     :inhibit-window-quit   :size+:align|:other     :same|:popup
		'((compilation-mode              :ignore t)
		  ("\\*Async Shell.*\\*" :regexp t :ignore t)
		  ("\\*corfu.*\\*"       :regexp t :ignore t)
		  ("*eshell*"                    :select t                          :size 0.4  :align t     :popup t)
		  (helpful-mode                  :select t                          :size 0.6  :align right :popup t)
		  ("*Messages*"                  :select t                          :size 0.4  :align t     :popup t)
		  ("*Calendar*"                  :select t                          :size 0.3  :align t     :popup t)
		  ("*info*"                      :select t                                                  :same t)
		  (magit-status-mode             :select t   :inhibit-window-quit t                         :same t)
		  (magit-log-mode                :select t   :inhibit-window-quit t                         :same t)
		  ))
  )

(use-package popper
  :ensure t
  :bind (("M-`"     . popper-toggle-latest)
		 ("M-<tab>" . popper-cycle)
		 ("M-\\"    . popper-toggle-type)
		 )
  :init
  (setq popper-reference-buffers
		'("\\*Messages\\*"
		  "\\*Async Shell Command\\*"
		  help-mode
		  helpful-mode
		  occur-mode
		  pass-view-mode
		  "^\\*eshell.*\\*$" eshell-mode ;; eshell as a popup
		  "^\\*shell.*\\*$"  shell-mode  ;; shell as a popup
		  ("\\*corfu\\*" . hide)
		  (compilation-mode . hide)
		  ;; derived from `fundamental-mode' and fewer than 10 lines will be considered a popup
		  (lambda (buf) (with-current-buffer buf
						  (and (derived-mode-p 'fundamental-mode)
							   (< (count-lines (point-min) (point-max))
								  10))))
		  )
		)
  (popper-mode +1)
  (popper-echo-mode +1)
  :config
  ;; group by project.el, projectile, directory or perspective
  (setq popper-group-function nil)

  ;; pop in child frame or not
  (setq popper-display-function #'display-buffer-in-child-frame)

  ;; use `shackle.el' to control popup
  (setq popper-display-control nil)
  )

(use-package winner
  :ensure nil
  :hook (after-init . winner-mode)
  :commands (winner-undo winner-redo)
  :config
  (setq winner-boring-buffers
		'("*Completions*"
		  "*Compile-Log*"
		  "*inferior-lisp*"
		  "*Fuzzy Completions*"
		  "*Apropos*"
		  "*Help*"
		  "*cvs*"
		  "*Buffer List*"
		  "*Ibuffer*"
		  "*esh command on file*"))
  )

(provide 'init-ui)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-ui.el ends here
