;;; init-org.el --- Org mode settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t)
  (setq org-appear-autosubmarkers t)
  (setq org-appear-autoentities t)
  (setq org-appear-autokeywords t)
  (setq org-appear-inside-latex t)
  )

(use-package org-capture
  :ensure nil
  :bind ("C-c c" . (lambda () (interactive) (org-capture)))
  :hook ((org-capture-mode . (lambda ()
							   (setq-local org-complete-tags-always-offer-all-agenda-tags t)))
		 (org-capture-mode . delete-other-windows))
  :custom
  (org-capture-use-agenda-date nil)
  ;; define common template
  (org-capture-templates `(("t" "Tasks" entry (file+headline "tasks.org" "Reminders")
							"* TODO %i%?"
							:empty-lines-after 1
							:prepend t)
						   ("n" "Notes" entry (file+headline "capture.org" "Notes")
							"* %? %^g\n%i\n"
							:empty-lines-after 1)
						   ;; For EWW
						   ("b" "Bookmarks" entry (file+headline "capture.org" "Bookmarks")
							"* %:description\n\n%a%?"
							:empty-lines 1
							:immediate-finish t)
						   ("d" "Diary")
						   ("dt" "Today's TODO list" entry (file+olp+datetree "diary.org")
							"* Today's TODO list [/]\n%T\n\n** TODO %?"
							:empty-lines 1
							:jump-to-captured t)
						   ("do" "Other stuff" entry (file+olp+datetree "diary.org")
							"* %?\n%T\n\n%i"
							:empty-lines 1
							:jump-to-captured t)
						   ))
  )

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode-in-directories)
  :bind (("C-c d n" . denote)
		 ("C-c d d" . denote-date)
		 ("C-c d t" . denote-type)
		 ("C-c d s" . denote-subdirectory)
		 ("C-c d f" . denote-open-or-create)
		 ("C-c d r" . denote-dired-rename-file))
  :init
  (with-eval-after-load 'org-capture
	(setq denote-org-capture-specifiers "%l\n%i\n%?")
	(add-to-list 'org-capture-templates
				 '("N" "New note (with denote.el)" plain
				   (file denote-last-path)
				   #'denote-org-capture
				   :no-save t
				   :immediate-finish nil
				   :kill-buffer t
				   :jump-to-captured t)))
  :config
  (setq denote-directory (expand-file-name "~/org/denote/"))
  (setq denote-known-keywords '("emacs" "entertainment" "reading" "studying"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  ;; org is default, set others such as text, markdown-yaml, markdown-toml
  (setq denote-file-type nil)
  (setq denote-prompts '(title keywords))

  ;; We allow multi-word keywords by default.  The author's personal
  ;; preference is for single-word keywords for a more rigid workflow.
  (setq denote-allow-multi-word-keywords t)
  (setq denote-date-format nil)

  ;; If you use Markdown or plain text files (Org renders links as buttons
  ;; right away)
  (add-hook 'find-file-hook #'denote-link-buttonize-buffer)
  (setq denote-dired-rename-expert nil)

  ;; OR if only want it in `denote-dired-directories':
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)
  )

(use-package consult-notes
  :ensure t
  :commands (consult-notes
			 consult-notes-search-in-all-notes)
  :bind (("C-c n f" . consult-notes)
		 ("C-c n c" . consult-notes-search-in-all-notes))
  :config
  (setq consult-notes-file-dir-sources
		`(
		  ("work"    ?w ,(concat org-directory "/midea/"))
		  ("article" ?a ,(concat org-directory "/article/"))
		  ("org"     ?o ,(concat org-directory "/"))
		  ("hugo"    ?h ,(concat org-directory "/hugo/"))
		  ("books"   ?b ,(concat (getenv "HOME") "/Books/"))
		  ))

  ;; embark support
  (with-eval-after-load 'embark
	(defun consult-notes-open-dired (cand)
	  "Open notes directory dired with point on file CAND."
	  (interactive "fNote: ")
	  ;; dired-jump is in dired-x.el but is moved to dired in Emacs 28
	  (dired-jump nil cand))

	(defun consult-notes-marked (cand)
	  "Open a notes file CAND in Marked 2.
Marked 2 is a mac app that renders markdown."
	  (interactive "fNote: ")
	  (call-process-shell-command (format "open -a \"Marked 2\" \"%s\"" (expand-file-name cand))))

	(defun consult-notes-grep (cand)
	  "Run grep in directory of notes file CAND."
	  (interactive "fNote: ")
	  (consult-grep (file-name-directory cand)))

	(embark-define-keymap consult-notes-map
						  "Keymap for Embark notes actions."
						  :parent embark-file-map
						  ("d" consult-notes-dired)
						  ("g" consult-notes-grep)
						  ("m" consult-notes-marked))

	(add-to-list 'embark-keymap-alist `(,consult-notes-category . consult-notes-map))

	;; make embark-export use dired for notes
	(setf (alist-get consult-notes-category embark-exporters-alist) #'embark-export-dired)
	)
  )

(use-package ox
  :ensure nil
  :custom
  (org-export-with-toc t)
  (org-export-with-tags 'not-in-toc)
  (org-export-with-drawers nil)
  (org-export-with-priority t)
  (org-export-with-footnotes t)
  (org-export-with-smart-quotes t)
  (org-export-with-section-numbers t)
  (org-export-with-sub-superscripts '{})
  ;; `org-export-use-babel' set to nil will cause all source block header arguments to be ignored This means that code blocks with the argument :exports none or :exports results will end up in the export.
  ;; See:
  ;; https://stackoverflow.com/questions/29952543/how-do-i-prevent-org-mode-from-executing-all-of-the-babel-source-blocks
  (org-export-use-babel t)
  (org-export-headline-levels 9)
  (org-export-coding-system 'utf-8)
  (org-export-with-broken-links 'mark)
  (org-export-default-language "zh-CN") ; 默认是en
  ;; (org-ascii-text-width 72)
  )

(use-package ox-html
  :ensure nil
  :init
  ;; add support for video
  (defun org-video-link-export (path desc backend)
	(let ((ext (file-name-extension path)))
	  (cond
	   ((eq 'html backend)
		(format "<video width='800' preload='metadata' controls='controls'><source type='video/%s' src='%s' /></video>" ext path))
	   ;; fall-through case for everything else
	   (t
		path))))
  (org-link-set-parameters "video" :export 'org-video-link-export)
  :custom
  (org-html-doctype "html5")
  (org-html-html5-fancy t)
  (org-html-checkbox-type 'unicode)
  (org-html-validation-link nil))

(use-package htmlize
  :ensure t
  :custom
  (htmlize-pre-style t)
  (htmlize-output-type 'inline-css))

(use-package ox-latex
  :ensure nil
  :defer t
  :config
  (add-to-list 'org-latex-classes
			   '("cn-article"
				 "\\documentclass[UTF8,a4paper]{article}"
				 ("\\section{%s}" . "\\section*{%s}")
				 ("\\subsection{%s}" . "\\subsection*{%s}")
				 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
				 ("\\paragraph{%s}" . "\\paragraph*{%s}")
				 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
			   '("cn-report"
				 "\\documentclass[11pt,a4paper]{report}"
				 ("\\chapter{%s}" . "\\chapter*{%s}")
				 ("\\section{%s}" . "\\section*{%s}")
				 ("\\subsection{%s}" . "\\subsection*{%s}")
				 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (setq org-latex-default-class "cn-article")
  (setq org-latex-image-default-height "0.9\\textheight"
		org-latex-image-default-width "\\linewidth")
  (setq org-latex-pdf-process
		'("xelatex -interaction nonstopmode -output-directory %o %f"
		  "bibtex %b"
		  "xelatex -interaction nonstopmode -output-directory %o %f"
		  "xelatex -interaction nonstopmode -output-directory %o %f"
		  "rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
		  ))
  ;; 使用 Listings 宏包格式化源代码(只是把代码框用 listing 环境框起来，还需要额外的设置)
  (setq org-latex-listings t)
  ;; mapping jupyter-python to Python
  (add-to-list 'org-latex-listings-langs '(jupyter-python "Python"))
  ;; Options for \lset command（reference to listing Manual)
  (setq org-latex-listings-options
		'(
		  ("basicstyle" "\\small\\ttfamily")       ; 源代码字体样式
		  ("keywordstyle" "\\color{eminence}\\small")                 ; 关键词字体样式
		  ;; ("identifierstyle" "\\color{doc}\\small")
		  ("commentstyle" "\\color{commentgreen}\\small\\itshape")    ; 批注样式
		  ("stringstyle" "\\color{red}\\small")                       ; 字符串样式
		  ("showstringspaces" "false")                                ; 字符串空格显示
		  ("numbers" "left")                                          ; 行号显示
		  ("numberstyle" "\\color{preprocess}")                       ; 行号样式
		  ("stepnumber" "1")                                          ; 行号递增
		  ("xleftmargin" "2em")                                       ;
		  ;; ("backgroundcolor" "\\color{background}")                   ; 代码框背景色
		  ("tabsize" "4")                                             ; TAB 等效空格数
		  ("captionpos" "t")                                          ; 标题位置 top or buttom(t|b)
		  ("breaklines" "true")                                       ; 自动断行
		  ("breakatwhitespace" "true")                                ; 只在空格分行
		  ("showspaces" "false")                                      ; 显示空格
		  ("columns" "flexible")                                      ; 列样式
		  ("frame" "tb")                                              ; 代码框：single, or tb 上下线
		  ("frameleftmargin" "1.5em")                                 ; frame 向右偏移
		  ;; ("frameround" "tttt")                                       ; 代码框： 圆角
		  ;; ("framesep" "0pt")
		  ;; ("framerule" "1pt")                                         ; 框的线宽
		  ;; ("rulecolor" "\\color{background}")                         ; 框颜色
		  ;; ("fillcolor" "\\color{white}")
		  ;; ("rulesepcolor" "\\color{comdil}")
		  ("framexleftmargin" "5mm")                                  ; let line numer inside frame
		  ))
  )

(use-package ox-gfm
  :ensure t
  :after ox)

(unless (file-exists-p "~/org")
  (make-directory "~/org")) 

(use-package ox-publish
  :ensure nil
  :commands (org-publish org-publish-all)
  :config
  (setq org-export-global-macros
		'(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@")))

  ;; sitemap 生成函数
  (defun my/org-sitemap-date-entry-format (entry style project)
	"Format ENTRY in org-publish PROJECT Sitemap format ENTRY ENTRY STYLE format that includes date."
	(let ((filename (org-publish-find-title entry project)))
	  (if (= (length filename) 0)
		  (format "*%s*" entry)
		(format "{{{timestamp(%s)}}} [[file:%s][%s]]"
				(format-time-string "%Y-%m-%d"
									(org-publish-find-date entry project))
				entry
				filename))))

  ;; 设置 org-publish 的项目列表
  (setq org-publish-project-alist
		'(
		  ;; 笔记部分
		  ("org-notes"
		   :base-directory "~/org/"
		   :base-extension "org"
		   :exclude "\\(tasks\\|test\\|scratch\\|diary\\|capture\\|mail\\|habits\\|resume\\|meetings\\|personal\\|org-beamer-example\\)\\.org\\|test\\|article\\|roam\\|hugo"
		   :publishing-directory "~/public_html/"
		   :recursive t                 ; include subdirectories if t
		   :publishing-function org-html-publish-to-html
		   :headline-levels 6
		   :auto-preamble t
		   :auto-sitemap t
		   :sitemap-filename "sitemap.org"
		   :sitemap-title "Sitemap"
		   :sitemap-format-entry my/org-sitemap-date-entry-format)

		  ;; 静态资源部分
		  ("org-static"
		   :base-directory "~/org/"
		   :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|mov"
		   :publishing-directory "~/public_html/"
		   :recursive t
		   :publishing-function org-publish-attachment)

		  ;; 项目集合
		  ("org"
		   :components ("org-notes" "org-static"))
		  ))
  )

(use-package ox-hugo
  :ensure t
  :config    

  (setq org-hugo-base-dir "~/ox-hugo/")
  (with-eval-after-load 'org-capture
	(defun org-hugo-new-subtree-post-capture-template ()
	  "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
	  (let* ((title (read-from-minibuffer "Post Title: ")) ; Prompt to enter the post title
			 (fname (org-hugo-slug title)))
		(mapconcat #'identity
				   `(
					 ,(concat "* TODO " title)
					 ":PROPERTIES:"
					 ,(concat ":EXPORT_FILE_NAME: " fname)
					 ":END:"
					 "%?\n")          ; Place the cursor here finally
				   "\n")))

	(add-to-list 'org-capture-templates
				 '("h"                ; `org-capture' binding + h
				   "Hugo post"
				   entry
				   ;; It is assumed that below file is present in `org-directory'
				   ;; and that it has a "Blog Ideas" heading. It can even be a
				   ;; symlink pointing to the actual location of capture.org!
				   (file+olp "capture.org" "Notes")
				   (function org-hugo-new-subtree-post-capture-template))))
  )

(use-package toc-org
  :ensure t
  :hook (org-mode . toc-org-mode))

(use-package ol
  :ensure nil
  :defer t
  :custom
  (org-link-keep-stored-after-insertion t)
  (org-link-abbrev-alist '(("github"        . "https://github.com/")
						   ("gitlab"        . "https://gitlab.com/")
						   ("google"        . "https://google.com/search?q=")
						   ("baidu"         . "https://baidu.com/s?wd=")
						   ("rfc"           . "https://tools.ietf.org/html/")
						   ("wiki"          . "https://en.wikipedia.org/wiki/")
						   ("youtube"       . "https://youtube.com/watch?v=")
						   ("zhihu"         . "https://zhihu.com/question/"))))

(use-package emacs
  :ensure nil
  :after org
  :bind (:map org-mode-map
			  ("M-p" . my/org-insert-clipboard-image))
  :config
  (defun my/org-insert-clipboard-image (width)
	"create a time stamped unique-named file from the clipboard in the sub-directory
 (%filename.assets) as the org-buffer and insert a link to this file."
	(interactive (list
				  (read-string (format "Input image width, default is 800: ")
							   nil nil "800")))
	;; 设置图片存放的文件夹位置为 `当前Org文件同名.assets'
	(setq foldername (concat (file-name-base (buffer-file-name)) ".assets/"))
	(if (not (file-exists-p foldername))
		(mkdir foldername))
	;; 设置图片的文件名，格式为 `img_年月日_时分秒.png'
	(setq imgName (concat "img_" (format-time-string "%Y%m%d_%H%M%S") ".png"))
	;; 图片文件的相对路径
	(setq relativeFilename (concat (file-name-base (buffer-name)) ".assets/" imgName))
	;; 根据不同的操作系统设置不同的命令行工具
	(cond ((string-equal system-type "gnu/linux")
		   (shell-command (concat "xclip -selection clipboard -t image/png -o > " relativeFilename)))
		  ((string-equal system-type "darwin")
		   (shell-command (concat "pngpaste " relativeFilename))))
	;; 给粘贴好的图片链接加上宽度属性，方便导出
	(insert (concat "\n#+DOWNLOADED: screenshot @ "
					(format-time-string "%Y-%m-%d %a %H:%M:%S" (current-time))
					"\n#+CAPTION: \n#+ATTR_ORG: :width "
					width
					"\n#+ATTR_LATEX: :width "
					(if (>= (/ (string-to-number width) 800.0) 1.0)
						"1.0"
					  (number-to-string (/ (string-to-number width) 800.0)))
					"\\linewidth :float nil\n"
					"#+ATTR_HTML: :width "
					width
					"\n[[file:" relativeFilename "]]\n"))
	;; 重新显示一下图片
	(org-redisplay-inline-images)
	)
  )

(provide 'init-org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-org.el ends here
