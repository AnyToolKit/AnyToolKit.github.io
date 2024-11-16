;;; init.el --- The main init entry for Emacs -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;;; early-init.el --- Emacs pre-initialization config -*- lexical-binding: t -*-
   ;;; Commentary:

   ;;; Code:

;; 设置垃圾回收参数
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)

;; 启动早期不加载`package.el'包管理器
(setq package-enable-at-startup nil)
;; 不从包缓存中加载
(setq package-quickstart nil)

;; 禁止展示菜单栏、工具栏和纵向滚动条
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; 禁止自动缩放窗口先
(setq frame-inhibit-implied-resize t)

;; 禁止Echo Area显示For information about GNU Emacs and the GNU system,type C-h C-a
(fset 'display-startup-echo-area-message 'ignore)

;; 禁止菜单栏、工具栏、滚动条模式，禁止启动屏幕和文件对话框
(menu-bar-mode -1)  
(if(functionp 'scroll-bar-mode)
	(scroll-bar-mode -1))
(if(functionp 'toogle-menu-bar)
	(toogle-menu-bar -1)
  )
(if(functionp 'tool-bar-mode)
	(tool-bar-mode -1)
  )

(setq inhibit-splash-screen t)
(setq use-file-dialog nil)

;; 在这个阶段不编译
(setq comp-deferred-compilation nil)

(setq frame-title-format "emacs@%b")
;;在标题栏显示buffer的名字，而不是 emacs@wangyin.com 这样没用的提示。

(require 'package)
(setq package-archives
	   '(("melpa-cn" . "http://elpa.zilongshanren.com/melpa/")
		("org-cn"   . "http://elpa.zilongshanren.com/org/")
		("gnu-cn"   . "http://elpa.zilongshanren.com/gnu/")))
	  ;; '(
	  ;; 	("melpa-cn" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
	  ;; 	("nongnu-cn"   . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
	  ;; 	("gnu-cn"   . "https://mirrors.ustc.edu.cn/elpa/gnu/")
	  ;; 	;; ("melpa"  . "https://melpa.org/packages/")
	  ;; 	;; ("gnu"    . "https://elpa.gnu.org/packages/")
	  ;; 	;; ("nongnu" . "https://elpa.nongnu.org/nongnu/")
	  ;; 	))

(package-initialize)

(provide 'init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
