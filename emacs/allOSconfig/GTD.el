(setq org-todo-keywords
      '((sequence "REPORT(@/!)" "BUG(@/!)" "KNOWNCAUSE(@/!)" "|" "FIXED(!)")
	(sequence "TODO(t!)" "|" "DONE(!)" "CANCELED(@/!)")
	))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
