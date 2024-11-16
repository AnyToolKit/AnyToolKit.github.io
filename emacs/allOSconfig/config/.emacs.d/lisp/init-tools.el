;;; init-tools.el --- Tools settings -*- lexical-binding: t -*-
;;; Commentary: Useful tools to make Emacs efficient!

;;; Code:

(use-package helpful
  :ensure t
  :commands (helpful-callable helpful-variable helpful-command helpful-key helpful-mode)
  :bind (([remap describe-command] . helpful-command)
		 ("C-h f" . helpful-callable)
		 ("C-h v" . helpful-variable)
		 ("C-h s" . helpful-symbol)
		 ("C-h S" . describe-syntax)
		 ("C-h m" . describe-mode)
		 ("C-h F" . describe-face)
		 ([remap describe-key] . helpful-key))
  )

(use-package pass
  :ensure t
  :commands (pass)
  )

(use-package cnfonts
  :ensure t
  :defer 3
  :init (cnfonts-mode t)
  :config
  (define-key cnfonts-mode-map (kbd "C--") #'cnfonts-decrease-fontsize)
  (define-key cnfonts-mode-map (kbd "C-=") #'cnfonts-increase-fontsize)
  )

(provide 'init-tools)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-tools.el ends here
