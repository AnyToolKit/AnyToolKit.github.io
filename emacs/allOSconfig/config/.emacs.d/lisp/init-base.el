;;; init-base.el --- Basical settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :config
  ;; Allow commands in minibuffers, will affect `dired-do-dired-do-find-regexp-and-replace' command:
  (setq enable-recursive-minibuffers t)
  (setq history-length 1000)
  (setq savehist-additional-variables '(mark-ring
										global-mark-ring
										search-ring
										regexp-search-ring
										extended-command-history))
  (setq savehist-autosave-interval 300))

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package undo-tree
  :ensure t
  :hook (after-init . global-undo-tree-mode)
  :config
  ;; don't save undo history to local files
  (setq undo-tree-auto-save-history nil)
  )

(use-package super-save
  :ensure t
  :hook (after-init . super-save-mode)
  :config
  ;; Emacs空闲是否自动保存，这里不设置
  (setq super-save-auto-save-when-idle nil)
  ;; 切换窗口自动保存
  (add-to-list 'super-save-triggers 'other-window)
  ;; 查找文件时自动保存
  (add-to-list 'super-save-hook-triggers 'find-file-hook)
  ;; 远程文件编辑不自动保存
  (setq super-save-remote-files nil)
  ;; 特定后缀名的文件不自动保存
  (setq super-save-exclude '(".gpg"))
  ;; 自动保存时，保存所有缓冲区
  (defun super-save/save-all-buffers ()
	(save-excursion
	  (dolist (buf (buffer-list))
		(set-buffer buf)
		(when (and buffer-file-name
				   (buffer-modified-p (current-buffer))
				   (file-writable-p buffer-file-name)
				   (if (file-remote-p buffer-file-name) super-save-remote-files t))
		  (save-buffer)))))
  (advice-add 'super-save-command :override 'super-save/save-all-buffers)
  )

(provide 'init-base)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-base.el ends here
