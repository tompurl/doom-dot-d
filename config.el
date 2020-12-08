(setq user-full-name "Tom Purl"
      user-mail-address "tom@tompurl.com")

(setq doom-theme 'doom-fairy-floss)
(setq org-directory "~/gtd/org")
(setq display-line-numbers-type t)

(setq doom-font (font-spec :family "Hack" :size 15)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 15))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key (kbd "<f4>") 'set-org-agenda-files)
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "<f5>") #'org-toggle-inline-images)
            (local-set-key (kbd "C-c n s") #'org-narrow-to-subtree)
            (local-set-key (kbd "C-c w") #'widen)))
(define-key global-map "\C-cc" 'org-capture)
(global-set-key (kbd "C-c h") 'open-org-html-file-in-browser)
(global-set-key (kbd "<f6>") (lambda() (interactive)(org-publish-current-file)))

(setq org-link-frame-setup (quote ((vm . vm-visit-folder-other-frame)
                                   (vm-imap . vm-visit-imap-folder-other-frame)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file)
                                   (wl . wl-other-frame))))

(fset 'tp/org/jump-to-logbook
      (lambda (&optional arg)
        "Keyboard macro."
        (interactive "p")
        (kmacro-exec-ring-item (quote ([19 108 111 103 98 return] 0 "%d")) arg)))
(global-set-key (kbd "\C-ck") 'tp/org/jump-to-logbook)

(defun tp/org/move-last-subbullet-to-top-of-sublist ()
  "Move the last sub-bullet to the top of the list of sub-bullets."
  (interactive)
  (org-forward-heading-same-level 1)
  (forward-line -1)
  (kill-visual-line 1)
  (org-backward-heading-same-level 1)
  (forward-line 1)
  (org-yank)
  (forward-line -1))

(defun set-org-agenda-files ()
  (interactive)
  (message "Saving all org buffers to keep agenda files list clean")
  (org-save-all-org-buffers)
  (setq org-agenda-files (list org-directory (concat org-directory "journal")))
  (message "Done setting org agenda files."))

(set-org-agenda-files)

(setq org-agenda-overriding-columns-format
      "%TODO %4PRIORITY(Pri.) %50ITEM(Task) %4POM_Estimate(Est.) %7POM_Pomodori(Poms) %12CLOCKSUM_T(Today's Time)")
(setq org-agenda-view-columns-initially t)
(setq org-agenda-custom-commands
      '(("p" "Pomodoro View"
         ((tags "+today")))
        ("c" "Daily Checklist"
         ((org-ql-block '(and (todo)
                              (tags "daily_checklist")
                              (scheduled :to today))
                        ((org-ql-block-header "Daily Checklist")))))
        ("A" "Remaining Agenda"
         ((org-ql-block '(and (todo "TODO")
                              (not (or (tags "today")
                                       (tags "daily_checklist")))
                              (or
                               (scheduled :to today)
                               (deadline auto)))
                        ((org-ql-block-header "Remaining Agenda")))))
        ))

(setq org-agenda-span 1)

(org-clock-sum)

(setq org-agenda-clockreport-parameter-plist
      '(:scope agenda-with-archives :formula % :maxlevel 10 :tags t :fileskip0 t :compact t :narrow 60 :score 0))

(setq org-clock-idle-time 15)
